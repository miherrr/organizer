//
//  TimelineViewModel.swift
//  Organizer
//
//  Created by mac on 18.08.2018.
//  Copyright © 2018 Mikhail Babushkin. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class TimelineModel: Object {
    @objc dynamic var id: String? = nil
    @objc dynamic var title: String = ""
    @objc dynamic var start: Date = Date()
    @objc dynamic var end: Date = Date()
    @objc dynamic var desc: String = ""
    @objc dynamic private var _type: Int = 0
    var type: EventType {
        get {
            return EventType(rawValue: _type)!
        }
        set {
            _type = newValue.rawValue
        }
    }
    
    init(id: String?, title: String, start: Date, end: Date, type: EventType, description: String) {
        self.id = id
        self.title = title
        self.start = start
        self.end = end
        super.init()
        self.type = type
        self.desc = description
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        fatalError("init(realm:schema:) has not been implemented")
    }
    
    required init(value: Any, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
}
