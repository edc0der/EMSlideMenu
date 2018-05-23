//
//  CenterViewController.swift
//  EMSlideMenu
//
//  Created by Eduard Moya on 5/12/18.
//  Copyright © 2018 Eduard Moya. All rights reserved.
//

import UIKit

class CenterViewController: UIViewController {
    //views
    @IBOutlet private weak var imgBanner: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        imgBanner.image = #imageLiteral(resourceName: "IconBannerSlide")
    }
}
