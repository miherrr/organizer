//
//  ViewController.swift
//  Organizer
//
//  Created by mac on 18.08.2018.
//  Copyright © 2018 Mikhail Babushkin. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {

    @IBOutlet private weak var timelineScrollView: UIScrollView!
    @IBOutlet private  weak var timelineView: TimelineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineScrollView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        timelineView.data = [
            TimelineModel(id: 0, title: "Первое событие", start: Date(), end: Date().addingTimeInterval(10_000), type: EventType.important),
            TimelineModel(id: 1, title: "Второе событие", start: Date(), end: Date().addingTimeInterval(20_000), type: EventType.notImportant),
            TimelineModel(id: 2, title: "Долгое", start: Date(), end: Date().addingTimeInterval(60_000), type: EventType.routine),
            TimelineModel(id: 3, title: "Короткое событие с удивительно длинным названием", start: Date(), end: Date().addingTimeInterval(3_600), type: EventType.important)
        ]
//        timelineView.data = []
    }
}

