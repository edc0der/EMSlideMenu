//
//  SideMenuViewModel.swift
//  EMSlideMenu
//
//  Created by Eduard Moya on 5/23/18.
//  Copyright © 2018 Eduard Moya. All rights reserved.
//

import UIKit

//MARK:- ViewModel
struct SideMenuViewModel {
    //Properties
    var menuItems = [SideMenuItemViewModel]()
}

//MARK:- Protocol-Oriented ViewModel
extension SideMenuViewModel: SideMenuViewModelDataSource {
    var count: Int {
        return menuItems.count
    }
}

extension SideMenuViewModel: SideMenuViewModelDelegate {
    mutating func fetchItems(target: Any, completion: () -> Void) {
        self.menuItems = [SideMenuItemViewModel(title: "Option 1", image: nil, target: target, action: #selector(SideMenuViewController.someOptionWasTapped)),
                          SideMenuItemViewModel(title: "Option 2", image: nil, target: target, action: #selector(SideMenuViewController.someOptionWasTapped)),
                          SideMenuItemViewModel(title: "Option 3", image: nil, target: target, action: #selector(SideMenuViewController.someOptionWasTapped)),
                          SideMenuItemViewModel(title: "Option 4", image: nil, target: target, action: #selector(SideMenuViewController.someOptionWasTapped))]
    }

    func getViewModel(atRow row: Int) -> SideMenuItemViewModel {
        guard count > 0, 0...(count - 1) ~= row else { fatalError() }
        return menuItems[row]
    }

    func performAction(atRow row: Int) {
        let itemViewModel = getViewModel(atRow: row)
        guard let viewController = itemViewModel.menuItem?.target as? UIViewController, let action = itemViewModel.menuItem?.action else { return }
        viewController.perform(action, with: itemViewModel.title)
    }


}
