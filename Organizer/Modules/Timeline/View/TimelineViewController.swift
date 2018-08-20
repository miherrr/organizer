//
//  ViewController.swift
//  Organizer
//
//  Created by mac on 18.08.2018.
//  Copyright © 2018 Mikhail Babushkin. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    
    private var viewModel: TimelineViewmodelProtocol!

    @IBOutlet private weak var timelineScrollView: UIScrollView!
    @IBOutlet private  weak var timelineView: TimelineView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    private var selectedId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = try! Containers.container.resolve()
        
        viewModel.loadData {
            self.timelineView.data = self.viewModel.data
            if let currentSelection = self.selectedId {
                self.timelineView.select(eventId: currentSelection)
            } else if !self.viewModel.data.isEmpty {
                self.selectedId = self.viewModel.data[0].id
                self.timelineView.select(eventId: self.viewModel.data[0].id!)
            }
        }
    
        timelineView.onSelectEvent = { [unowned self] event in
            self.selectedId = event.id
            self.navigationItem.title = event.title
            self.titleLabel.text = "Заголовок: \(event.title)"
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy HH:mm"
            self.startLabel.text = "Время начала: \(formatter.string(from: event.start))"
            self.endLabel.text = "Время окончания: \(formatter.string(from: event.end))"
            self.descriptionLabel.text = "Описание: \(event.desc)"
            self.typeLabel.text = "Тип: \(event.type.desctiption)"
        }
        timelineScrollView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit" {
            guard let destination = segue.destination as? EventEditorViewController else {
                return
            }
            destination.currentEvent = viewModel.data.first(where: { model -> Bool in
                model.id == self.selectedId
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.timelineView.data = self.viewModel.data
        if let currentSelection = self.selectedId {
            self.timelineView.select(eventId: currentSelection)
        } else if !self.viewModel.data.isEmpty {
            self.selectedId = self.viewModel.data[0].id
            self.timelineView.select(eventId: self.viewModel.data[0].id!)
        }
    }
}

