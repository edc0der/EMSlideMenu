//
//  UIViewController+Instance.swift
//  EMSlideMenu
//
//  Created by Eduard Moya on 5/21/18.
//  Copyright © 2018 Eduard Moya. All rights reserved.
//

import UIKit

extension UIViewController {
    static var nibName: String {
        return String(describing: self)
    }

    class func loadFromNib<T: UIViewController>() -> T {
        return T(nibName: nibName, bundle: nil)
    }
}
