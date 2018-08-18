//
//  TimelineViewModel.swift
//  Organizer
//
//  Created by mac on 18.08.2018.
//  Copyright © 2018 Mikhail Babushkin. All rights reserved.
//

import Foundation

class TimelineViewModel {
    var id: Int
    var title: String
    var start: Date
    var end: Date
    
    init(id: Int, title: String, start: Date, end: Date) {
        self.id = id
        self.title = title
        self.start = start
        self.end = end
    }
}
