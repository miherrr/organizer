//
//  Container.swift
//  Organizer
//
//  Created by mac on 19.08.2018.
//  Copyright © 2018 Mikhail Babushkin. All rights reserved.
//

import Foundation
import Dip

enum Containers {
    static let container: DependencyContainer = {
        Dip.logLevel = .Errors
        
        let container = DependencyContainer()
        container.register(.weakSingleton) { TimelineviewmodelStub() as TimelineViewmodelProtocol }
        
        return container
    }()
}
