//
//  SideMenuItemViewModel.swift
//  EMSlideMenu
//
//  Created by Eduard Moya on 5/23/18.
//  Copyright © 2018 Eduard Moya. All rights reserved.
//

import UIKit

//MARK:- ViewModel
struct SideMenuItemViewModel {
    var menuItem: SideMenuItem!

    init(title: String, image: UIImage?, target: Any, action: Selector) {
        self.menuItem = SideMenuItem(title: title, image: image, target: target, action: action)
    }
}

//MARK:- Protocol-Oriented ViewModel
extension SideMenuItemViewModel: SideMenuItemViewModelDataSource {
    var icon: UIImage? {
        return menuItem.icon
    }
    var title: String {
        return menuItem.title
    }
    var action: Selector {
        return menuItem.action
    }
}
