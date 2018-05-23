//
//  SideMenuViewModel.swift
//  EMSlideMenu
//
//  Created by Eduard Moya on 5/23/18.
//  Copyright © 2018 Eduard Moya. All rights reserved.
//

import UIKit

class SideMenuViewModel {
    //Properties
    var menuItems = [SideMenuItemViewModel]()

    //Completion closures
    typealias SetupCompletion = () -> Void

    func setUpMenuOptions(target: Any, completion: SetupCompletion) -> Void {
        menuItems = [SideMenuItemViewModel(title: "Option 1", image: nil, target: target, action: #selector(SideMenuViewController.someOptionWasTapped)),
                     SideMenuItemViewModel(title: "Option 2", image: nil, target: target, action: #selector(SideMenuViewController.someOptionWasTapped)),
                     SideMenuItemViewModel(title: "Option 3", image: nil, target: target, action: #selector(SideMenuViewController.someOptionWasTapped)),
                     SideMenuItemViewModel(title: "Option 4", image: nil, target: target, action: #selector(SideMenuViewController.someOptionWasTapped))]
    }

    func getCount() -> Int {
        return menuItems.count
    }

    func getItemViewModel(atRow row: Int) -> SideMenuItemViewModel {
        let itemsCount = getCount()
        guard itemsCount > 0, 0...(itemsCount - 1) ~= row else { fatalError() }
        return menuItems[row]
    }

    func performAction(atRow row: Int) -> Void {
        let itemViewModel = getItemViewModel(atRow: row)
        guard let viewController = itemViewModel.menuItem?.target as? UIViewController, let action = itemViewModel.menuItem?.action else { return }
        viewController.perform(action, with: itemViewModel.getTitle())
    }
}
