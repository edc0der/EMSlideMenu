//
//  SideMenuItemViewModel.swift
//  EMSlideMenu
//
//  Created by Eduard Moya on 5/23/18.
//  Copyright © 2018 Eduard Moya. All rights reserved.
//

import UIKit

class SideMenuItemViewModel {
    var menuItem: SideMenuItem!

    init(title: String, image: UIImage?, target: Any, action: Selector) {
        self.menuItem = SideMenuItem(title: title, image: image, target: target, action: action)
    }

    func getIcon() -> UIImage? {
        return menuItem.icon
    }

    func getTitle() -> String {
        return menuItem.title
    }

    func getAction() -> Selector {
        return menuItem.action
    }
}
