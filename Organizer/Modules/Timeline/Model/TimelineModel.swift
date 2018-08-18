//
//  TimelineViewModel.swift
//  Organizer
//
//  Created by mac on 18.08.2018.
//  Copyright © 2018 Mikhail Babushkin. All rights reserved.
//

import Foundation

class TimelineModel {
    var id: Int
    var title: String
    var start: Date
    var end: Date
    var type: EventType
    
    init(id: Int, title: String, start: Date, end: Date, type: EventType) {
        self.id = id
        self.title = title
        self.start = start
        self.end = end
        self.type = type
    }
}
