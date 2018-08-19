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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = try! Containers.container.resolve()
        
        viewModel.loadData {
            self.timelineView.data = self.viewModel.data
        }
        
        timelineScrollView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
}

