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
    }
}

