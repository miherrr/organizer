//
//  ParentViewController.swift
//  Organizer
//
//  Created by mac on 20.08.2018.
//  Copyright © 2018 Mikhail Babushkin. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {
    func showMessage(message: String) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
