//
//  AlertHelper.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 7.10.2021.
//

import UIKit

struct AlertHelper {
    
    typealias completionHandler = (_ action: UIAlertAction) -> Void
    static func showNotificationAlertWithAction(presentingScreen: UIViewController,
                                                title: String,
                                                message: String,
                                                actionTitle: String,
                                                completion: @escaping completionHandler) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel, handler: completion))
        presentingScreen.present(alert, animated: true, completion: nil)
    }
}
