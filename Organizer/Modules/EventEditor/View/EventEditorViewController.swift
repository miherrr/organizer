//
//  EventEditorViewController.swift
//  Organizer
//
//  Created by mac on 19.08.2018.
//  Copyright © 2018 Mikhail Babushkin. All rights reserved.
//

import UIKit

class EventEditorViewController: UIViewController {
    @IBOutlet private weak var titleTF: UITextField!
    @IBOutlet private weak var descriptionTF: UITextField!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var startTF: UITextField!
    @IBOutlet private weak var endTF: UITextField!
    @IBOutlet private weak var typeTF: UITextField!
    @IBOutlet weak var startPickerView: UIDatePicker!
    @IBOutlet weak var endPickerView: UIDatePicker!
    @IBOutlet weak var typePickerView: UIPickerView!
    
    var currentEvent: TimelineModel?
    var onSaved: (() -> Void)?
    
    private var viewModel: TimelineViewmodelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = try! Containers.container.resolve()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func save(_ sender: Any) {
        
    }
}

extension EventEditorViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        <#code#>
    }
}
