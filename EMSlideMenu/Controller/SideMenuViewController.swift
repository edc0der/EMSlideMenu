//
//  SideMenuViewController.swift
//  EMSlideMenu
//
//  Created by Eduard Moya on 5/12/18.
//  Copyright © 2018 Eduard Moya. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    //views
    @IBOutlet private weak var tblSideMenuOptions: UITableView!
    @IBOutlet private weak var imgAvatar: UIImageView!
    //data source
    private var viewModel = SideMenuViewModel()
    //delegate
    public var delegate: SideMenuViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        //prepare view
        imgAvatar.image = #imageLiteral(resourceName: "IconAvatarPlaceholder")
        imgAvatar.clipsToBounds = true
        imgAvatar.layer.cornerRadius = imgAvatar.frame.width / 2
        //set table delegates
        tblSideMenuOptions.delegate = self
        tblSideMenuOptions.dataSource = self
        //fetch menu options
        viewModel.setUpMenuOptions(target: self) {
            self.tblSideMenuOptions.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //clear selection/highlight
        if let indexPath = tblSideMenuOptions.indexPathForSelectedRow {
            tblSideMenuOptions.deselectRow(at: indexPath, animated: true)
        }
    }
}

//MARK:- Table datasource delegate actions
extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.getItemViewModel(atRow: indexPath.row).getTitle()
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

//MARK:- Table delegate actions
extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.performAction(atRow: indexPath.row)
    }
}

//MARK:- Item actions
extension SideMenuViewController {
    @objc func someOptionWasTapped(_ senderTitle: String) -> Void {
        delegate?.didSelectSideMenuOption()
    }
}
