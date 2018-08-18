//
//  ViewController.swift
//  Organizer
//
//  Created by mac on 18.08.2018.
//  Copyright © 2018 Mikhail Babushkin. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {

    @IBOutlet private  weak var timelineView: TimelineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timelineView.data = [
            TimelineViewModel(id: 0, title: "Первое событие", start: Date(), end: Date().addingTimeInterval(10_000)),
            TimelineViewModel(id: 1, title: "Второе событие", start: Date(), end: Date().addingTimeInterval(20_000)),
            TimelineViewModel(id: 2, title: "Долгое", start: Date(), end: Date().addingTimeInterval(60_000)),
            TimelineViewModel(id: 3, title: "Короткое событие с удивительно длинным названием", start: Date(), end: Date().addingTimeInterval(3_600))
        ]
    }
}

