//
//  SideMenuItemViewModelDataSource.swift
//  EMSlideMenu
//
//  Created by Eduard Moya on 5/30/18.
//  Copyright © 2018 Eduard Moya. All rights reserved.
//

import UIKit

protocol SideMenuItemViewModelDataSource {
    var icon: UIImage? { get }
    var title: String { get }
    var action: Selector { get }
}
