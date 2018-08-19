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
    private var selectedId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = try! Containers.container.resolve()
        
        viewModel.loadData {
            self.timelineView.data = self.viewModel.data
            if let currentSelection = self.selectedId {
                self.timelineView.select(eventId: currentSelection)
            } else if !self.viewModel.data.isEmpty {
                self.selectedId = self.viewModel.data[0].id
                self.timelineView.select(eventId: self.viewModel.data[0].id)
            }
        }
    
        timelineView.onSelectEvent = { [unowned self] event in
            self.navigationItem.title = event.title
            self.titleLabel.text = "Заголовок: \(event.title)"
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy HH:mm"
            self.startLabel.text = "Время начала: \(formatter.string(from: event.start))"
            self.endLabel.text = "Время окончания: \(formatter.string(from: event.end))"
            self.descriptionLabel.text = "Время описания: \(event.description)"
            self.typeLabel.text = "Тип: \(event.type.desctiption)"
        }
        timelineScrollView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.timelineView.data = self.viewModel.data
        if let currentSelection = self.selectedId {
            self.timelineView.select(eventId: currentSelection)
        } else if !self.viewModel.data.isEmpty {
            self.selectedId = self.viewModel.data[0].id
            self.timelineView.select(eventId: self.viewModel.data[0].id)
        }
    }
}

