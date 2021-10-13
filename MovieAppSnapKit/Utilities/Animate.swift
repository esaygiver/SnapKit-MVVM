//
//  Animate.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 8.10.2021.
//

import UIKit

class Animate {
    
    class func addAnimation(on view: UIView, and vc: UIViewController) {
        UIView.animate(withDuration: 0.1, animations: {
            view.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            view.center = vc.view.center
        }) { _ in
            UIView.animate(withDuration: 1, animations: {
                view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
                view.center = vc.view.center
            }) { _ in
                view.removeFromSuperview()
            }
        }
    }
}
