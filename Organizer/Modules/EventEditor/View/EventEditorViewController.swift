//
//  EventEditorViewController.swift
//  Organizer
//
//  Created by mac on 19.08.2018.
//  Copyright © 2018 Mikhail Babushkin. All rights reserved.
//

import UIKit

class EventEditorViewController: ParentViewController {
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter
    }
    @IBOutlet private weak var titleTF: UITextField!
    @IBOutlet private weak var descriptionTF: UITextField!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var startTF: UITextField!
    @IBOutlet private weak var endTF: UITextField!
    @IBOutlet private weak var typeTF: UITextField!
    @IBOutlet private weak var startPickerView: UIDatePicker!
    @IBOutlet private weak var endPickerView: UIDatePicker!
    @IBOutlet private weak var typePickerView: UIPickerView!
    @IBOutlet private weak var deleteButton: UIBarButtonItem!
    
    var currentEvent: TimelineModel?
    var onSaved: (() -> Void)?
    
    private var pickedType: EventType?
    private var pickedStartDate: Date?
    private var pickedEndDate: Date?
    
    private var viewModel: TimelineViewmodelProtocol!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let event = currentEvent else {
            deleteButton.isEnabled = false
            return
        }
        deleteButton.isEnabled = true
        
        titleTF.text = event.title
        descriptionTF.text = event.desc
        startTF.text = dateFormatter.string(from: event.start)
        startPickerView.date = event.start
        endTF.text = dateFormatter.string(from: event.end)
        endPickerView.date = event.end
        typeTF.text = event.type.desctiption
        typePickerView.selectRow(EventType.allCases.index(of: event.type)!, inComponent: 0, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = try! Containers.container.resolve()
        
        let typePickerGesture = UITapGestureRecognizer(target: self, action: #selector(togglePicker(_:)))
        typeTF.addGestureRecognizer(typePickerGesture)
        stackView.arrangedSubviews[12].isHidden = true
        
        let startDateGesture = UITapGestureRecognizer(target: self, action: #selector(togglePicker(_:)))
        startTF.addGestureRecognizer(startDateGesture)
        stackView.arrangedSubviews[6].isHidden = true
        startPickerView.addTarget(self, action: #selector(pickDate(_:)), for: .valueChanged)
        
        let endDateGesture = UITapGestureRecognizer(target: self, action: #selector(togglePicker(_:)))
        endTF.addGestureRecognizer(endDateGesture)
        stackView.arrangedSubviews[9].isHidden = true
        endPickerView.addTarget(self, action: #selector(pickDate(_:)), for: .valueChanged)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func save(_ sender: Any) {
        var eventToSave: TimelineModel!
        // редактирование
        if currentEvent != nil {
            eventToSave = TimelineModel(
                id: currentEvent!.id,
                title: titleTF.text ?? currentEvent!.title,
                start: pickedStartDate ?? currentEvent!.start,
                end: pickedEndDate ?? currentEvent!.end,
                type: pickedType ?? currentEvent!.type,
                description: descriptionTF.text ?? currentEvent!.desc)
        } else {
            guard let start = pickedStartDate,
                let end = pickedEndDate,
                let type = pickedType else {
                    showMessage(message: "Не все поля заполнены")
                    return
            }
            eventToSave = TimelineModel(
                id: nil,
                title: titleTF.text ?? "",
                start: start,
                end: end,
                type: type,
                description: descriptionTF.text ?? "")
        }
        viewModel.addOrUpdate(event: eventToSave, onCompleted: {
            self.dismiss(animated: true, completion: nil)
        }) {
            self.showMessage(message: "На выбранное время уже назначено событие")
        }
    }
    @IBAction func deleteEvent(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "Выберите вариант", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            self.viewModel.delete(with: self.currentEvent!.id!, onCompleted: {
                self.dismiss(animated: true, completion: nil)
            })
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        optionMenu.addAction(deleteAction)
        
        present(optionMenu, animated: true, completion: nil)
    }
    
    @objc private func pickDate(_ source: UIDatePicker) {
        if source == startPickerView {
            pickedStartDate = source.date
            startTF.text = dateFormatter.string(from: pickedStartDate!)
        } else if source == endPickerView {
            pickedEndDate = source.date
            endTF.text = dateFormatter.string(from: pickedEndDate!)
        }
    }
    
    @objc private func togglePicker(_ source: UITapGestureRecognizer) {
        switch source.view! {
        case startTF:
            startPickerView.isHidden = !startPickerView.isHidden
            if startTF.text == nil || startTF.text!.isEmpty {
                pickDate(startPickerView)
            }
            endPickerView.isHidden = true
            typePickerView.isHidden = true
        case endTF:
            endPickerView.isHidden = !endPickerView.isHidden
            if endTF.text == nil || endTF.text!.isEmpty {
                pickDate(endPickerView)
            }
            startPickerView.isHidden = true
            typePickerView.isHidden = true
        case typeTF:
            typePickerView.isHidden = !typePickerView.isHidden
            if typeTF.text == nil || typeTF.text!.isEmpty{
                pickerView(typePickerView, didSelectRow: 0, inComponent: 0)
            }
            startPickerView.isHidden = true
            endPickerView.isHidden = true
        default:
            fatalError("not implemented")
        }
    }
}

extension EventEditorViewController: UITextFieldDelegate {
    
}

extension EventEditorViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return EventType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return EventType.allCases[row].desctiption
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeTF.text = EventType.allCases[row].desctiption
        pickedType = EventType.allCases[row]
    }
}
