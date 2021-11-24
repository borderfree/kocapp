//
//  TabViewController.swift
//  KocYKS
//
//  Created by Fetih Tunay Yetişir on 3.05.2021.
//

import UIKit
import AnimatedTabBar
class TabViewController: AnimatedTabBarController, AnimatedTabBarDelegate {
    var numberOfItems: Int {
        return d.count
    }

    func tabBar(_ tabBar: AnimatedTabBar, itemFor index: Int) -> AnimatedTabBarItem {
        d[index]
    }

    func initialIndex(_ tabBar: AnimatedTabBar) -> Int? {
        1
    }
    var d = [iitemev,iitemsahne,iitemtakvim,iitemprofil]

}
