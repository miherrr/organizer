//
//  TimelineViewmodelStub.swift
//  Organizer
//
//  Created by mac on 19.08.2018.
//  Copyright © 2018 Mikhail Babushkin. All rights reserved.
//

import Foundation

class TimelineviewmodelStub: TimelineViewmodelProtocol {
    private var _data: [TimelineModel] = []
    var data: [TimelineModel] {
        return _data.sorted(by: { (item1, item2) -> Bool in
            item1.start < item2.start
        })
    }
    
    func loadData(onCompleted: (() -> Void)?) {
        _data = [
            TimelineModel(
                id: 0,
                title: "Первое событие",
                start: Date().addingTimeInterval(-3_600),
                end: Date().addingTimeInterval(10_000),
                type: EventType.important,
                description: "test"),
            TimelineModel(
                id: 1,
                title: "Второе событие",
                start: Date().addingTimeInterval(-2_000),
                end: Date().addingTimeInterval(20_000),
                type: EventType.notImportant,
                description: "test2"),
            TimelineModel(
                id: 2,
                title: "Долгое",
                start: Date().addingTimeInterval(1_000),
                end: Date().addingTimeInterval(120_000),
                type: EventType.routine,
                description: "test3"),
            TimelineModel(
                id: 3,
                title: "Короткое событие с удивительно длинным названием",
                start: Date().addingTimeInterval(-5_000),
                end: Date().addingTimeInterval(3_600),
                type: EventType.important,
                description: "test4")
        ]
        onCompleted?()
    }
    
    func delete(with id: Int, onCompleted: (() -> Void)?) {
        _data.remove(at: _data.index(where: { item -> Bool in
            item.id == id
        })!)
        onCompleted?()
    }
    func update(event: TimelineModel, onCompleted: (() -> Void)?) {
        _data[_data.index(where: { item -> Bool in
            item.id == event.id
        })!] = event
        onCompleted?()
    }
    
    func add(event: TimelineModel, onCompleted: (() -> Void)?) {
        _data.append(event)
        onCompleted?()
    }
}
