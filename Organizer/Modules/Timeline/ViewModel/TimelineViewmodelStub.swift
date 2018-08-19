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
    
    // MARK: - Private methods
    private func isTimeRangeAvailable(start: Date, end: Date) -> Bool {
        for item in data {
            /*
             если желаемое начало или конец события находятся в границах одно из существующих событий,
             то такое событие нельзя создать, потому что мы заняты в это время
            */
            if start > item.start && start < item.end
                || end > item.start && end < item.end {
                return false
            }
        }
        return true
    }
    
    private func index(for id: Int) -> Array<Any>.Index? {
        return _data.index(where: { item -> Bool in item.id == id })
    }
    
    // MARK: - Public methods
    func delete(with id: Int, onCompleted: (() -> Void)?) {
        guard let index = index(for: id) else {
            return
        }
        _data.remove(at: index)
        onCompleted?()
    }
    
    func update(event: TimelineModel, onCompleted: (() -> Void)?, onTimeBusy: (() -> Void)?) {
        guard let index = index(for: event.id) else {
            return
        }
        if isTimeRangeAvailable(start: event.start, end: event.end) {
            _data[index] = event
            onCompleted?()
        } else {
            onTimeBusy?()
        }
    }
    
    func add(event: TimelineModel, onCompleted: (() -> Void)?, onTimeBusy: (() -> Void)?) {
        if isTimeRangeAvailable(start: event.start, end: event.end) {
            _data.append(event)
            onCompleted?()
        } else {
            onTimeBusy?()
        }
    }
}
