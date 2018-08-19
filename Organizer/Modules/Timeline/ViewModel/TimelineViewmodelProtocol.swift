//
//  TimelineViewmodelProtocol.swift
//  Organizer
//
//  Created by mac on 19.08.2018.
//  Copyright © 2018 Mikhail Babushkin. All rights reserved.
//

import Foundation

protocol TimelineViewmodelProtocol {
    var data: [TimelineModel] { get }
    func loadData(onCompleted: (() -> Void)?)
    func delete(with id: Int, onCompleted: (() -> Void)?)
    func update(event: TimelineModel, onCompleted: (() -> Void)?)
    func add(event: TimelineModel, onCompleted: (() -> Void)?)
}
