//
//  Notification.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 11.10.2021.
//

import UIKit

class NotificationService {
    
    class func setBadgeValue(on vc: UIViewController) {
        if let favCount: Int = RealmManager().fetch()?.count, favCount != 0 {
            vc.tabBarController?.viewControllers?[1].tabBarItem.badgeValue = String(favCount)
        } else {
            vc.tabBarController?.viewControllers?[1].tabBarItem.badgeValue = "0"
        }
    }
    
    class func postNotification(name: String, object: Any?) {
        NotificationCenter.default.post(name: Notification.Name(name), object: object)
    }
}
