//
//  TimelineViewmodel.swift
//  Organizer
//
//  Created by mac on 20.08.2018.
//  Copyright © 2018 Mikhail Babushkin. All rights reserved.
//

import Foundation

class TimelineViewmodel: TimelineViewmodelProtocol {
    private var _data: [TimelineModel] = []
    var data: [TimelineModel] {
        return _data.sorted(by: { (item1, item2) -> Bool in
            item1.start < item2.start
        })
    }
    
    func loadData(onCompleted: (() -> Void)?) {
        fatalError("not implemented")
    }
    
    func delete(with id: String, onCompleted: (() -> Void)?) {
        fatalError("not implemented")
    }
    
    func addOrUpdate(event: TimelineModel, onCompleted: (() -> Void)?, onTimeBusy: (() -> Void)?) {
        fatalError("not implemented")
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
    
    private func index(for id: String) -> Array<Any>.Index? {
        return _data.index(where: { item -> Bool in item.id == id })
    }
    
    private func getNextId() -> String {
        return String(Date().timeIntervalSince1970)
    }
    
    private func update(event: TimelineModel, onCompleted: (() -> Void)?, onTimeBusy: (() -> Void)?) {
        guard let index = index(for: event.id!) else {
            return
        }
        if isTimeRangeAvailable(start: event.start, end: event.end) {
            _data[index] = event
            onCompleted?()
        } else {
            onTimeBusy?()
        }
    }
    
    private func add(event: TimelineModel, onCompleted: (() -> Void)?, onTimeBusy: (() -> Void)?) {
        if isTimeRangeAvailable(start: event.start, end: event.end) {
            _data.append(event)
            onCompleted?()
        } else {
            onTimeBusy?()
        }
    }
}
