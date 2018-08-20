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
    func delete(with id: String, onCompleted: (() -> Void)?)
    func addOrUpdate(event: TimelineModel, onCompleted: (() -> Void)?, onTimeBusy: (() -> Void)?)
}
