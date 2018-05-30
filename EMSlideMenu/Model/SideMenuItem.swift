//
//  SideMenuItem.swift
//  EMSlideMenu
//
//  Created by Eduard Moya on 5/23/18.
//  Copyright © 2018 Eduard Moya. All rights reserved.
//

import UIKit

struct SideMenuItem {
    var icon: UIImage?
    var title: String!
    var action: Selector!
    var target: Any!

    init(title: String, image: UIImage?, target: Any, action: Selector) {
        self.title = title
        self.icon = image
        self.target = target
        self.action = action
    }
}
