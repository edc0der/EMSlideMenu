//
//  SideMenuViewModelDelegate.swift
//  EMSlideMenu
//
//  Created by Eduard Moya on 5/30/18.
//  Copyright © 2018 Eduard Moya. All rights reserved.
//

import UIKit

protocol SideMenuViewModelDelegate {
    mutating func fetchItems(target: Any, completion: () -> Void) -> Void
    func getViewModel(atRow row: Int) -> SideMenuItemViewModel
    func performAction(atRow row: Int) -> Void
}
