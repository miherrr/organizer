//
//  TimelineViewmodel.swift
//  Organizer
//
//  Created by mac on 20.08.2018.
//  Copyright © 2018 Mikhail Babushkin. All rights reserved.
//

import Foundation
import RealmSwift

class TimelineViewmodel: TimelineViewmodelProtocol {
    var realm: Realm!
    init() {
        realm = try! Realm()
    }
    
    private var _data: [TimelineModel] = []
    var data: [TimelineModel] {
        return _data.sorted(by: { (item1, item2) -> Bool in
            item1.start < item2.start
        })
    }
    
    func loadData(onCompleted: (() -> Void)?) {
        let result = realm.objects(TimelineModel.self)
        _data = Array(result)
    }
    
    func delete(with id: String, onCompleted: (() -> Void)?) {
        guard let index = index(for: id) else {
            return
        }
        try! realm.write {
            realm.delete(_data[index])
            _data.remove(at: index)
        }
        onCompleted?()
    }
    
    func addOrUpdate(event: TimelineModel, onCompleted: (() -> Void)?, onTimeBusy: (() -> Void)?) {
        if event.id != nil {
            update(event: event, onCompleted: onCompleted, onTimeBusy: onTimeBusy)
        } else {
            event.id = getNextId()
            add(event: event, onCompleted: onCompleted, onTimeBusy: onTimeBusy)
        }
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
            try! realm.write {
                _data[index].desc = event.desc
                _data[index].title = event.title
                _data[index].start = event.start
                _data[index].end = event.end
                _data[index].type = event.type
            }
            onCompleted?()
        } else {
            onTimeBusy?()
        }
    }
    
    private func add(event: TimelineModel, onCompleted: (() -> Void)?, onTimeBusy: (() -> Void)?) {
        if isTimeRangeAvailable(start: event.start, end: event.end) {
            try! realm.write {
                realm.add(event)
            }
            _data.append(event)
            onCompleted?()
        } else {
            onTimeBusy?()
        }
    }
}
