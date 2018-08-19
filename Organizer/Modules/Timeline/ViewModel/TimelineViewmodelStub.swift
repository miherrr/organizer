//
//  TimelineViewmodelStub.swift
//  Organizer
//
//  Created by mac on 19.08.2018.
//  Copyright © 2018 Mikhail Babushkin. All rights reserved.
//

import Foundation

class TimelineviewmodelStub: TimelineViewmodelProtocol {
    var data: [TimelineModel] = []
    
    func loadData(onCompleted: (() -> Void)?) {
        data = [
            TimelineModel(id: 0, title: "Первое событие", start: Date(), end: Date().addingTimeInterval(10_000), type: EventType.important, description: "test"),
            TimelineModel(id: 1, title: "Второе событие", start: Date(), end: Date().addingTimeInterval(20_000), type: EventType.notImportant, description: "test2"),
            TimelineModel(id: 2, title: "Долгое", start: Date(), end: Date().addingTimeInterval(120_000), type: EventType.routine, description: "test3"),
            TimelineModel(id: 3, title: "Короткое событие с удивительно длинным названием", start: Date(), end: Date().addingTimeInterval(3_600), type: EventType.important, description: "test4")
        ]
        onCompleted?()
    }
    
    func delete(with id: Int, onCompleted: (() -> Void)?) {
        data.remove(at: data.index(where: { item -> Bool in
            item.id == id
        })!)
        onCompleted?()
    }
    func update(event: TimelineModel, onCompleted: (() -> Void)?) {
        data[data.index(where: { item -> Bool in
            item.id == event.id
        })!] = event
        onCompleted?()
    }
    
    func add(event: TimelineModel, onCompleted: (() -> Void)?) {
        data.append(event)
        onCompleted?()
    }
}
