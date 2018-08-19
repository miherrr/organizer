//
//  EventType.swift
//  Organizer
//
//  Created by mac on 18.08.2018.
//  Copyright © 2018 Mikhail Babushkin. All rights reserved.
//

import Foundation
import UIKit

enum EventType: CaseIterable {
    case important
    case notImportant
    case routine
    
    var desctiption: String {
        switch self {
        case .important:
            return "Важно"
        case .notImportant:
            return "Не очень важно"
        case .routine:
            return "Рутина"
        }
    }
    
    var color: UIColor {
        switch self {
        case .important:
            return UIColor.red
        case .notImportant:
            return UIColor.blue
        case .routine:
            return UIColor.green
        }
    }
}
