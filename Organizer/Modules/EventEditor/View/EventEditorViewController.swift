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
    @IBOutlet weak var startPickerView: UIDatePicker!
    @IBOutlet weak var endPickerView: UIDatePicker!
    @IBOutlet weak var typePickerView: UIPickerView!
    
    var currentEvent: TimelineModel? {
        didSet {
            titleTF.text = currentEvent?.title
            descriptionTF.text = currentEvent?.description
            startTF.text = dateFormatter.string(from: currentEvent!.start)
            endTF.text = dateFormatter.string(from: currentEvent!.end)
            typeTF.text = currentEvent?.type.desctiption
        }
    }
    var onSaved: (() -> Void)?
    
    private var pickedType: EventType?
    private var pickedStartDate: Date?
    private var pickedEndDate: Date?
    
    private var viewModel: TimelineViewmodelProtocol!

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
            currentEvent?.title = titleTF.text ?? currentEvent!.title
            currentEvent?.description = descriptionTF.text ?? currentEvent!.description
            currentEvent?.type = pickedType ?? currentEvent!.type
            currentEvent?.start = pickedStartDate ?? currentEvent!.start
            currentEvent?.end = pickedEndDate ?? currentEvent!.end
            eventToSave = currentEvent
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
