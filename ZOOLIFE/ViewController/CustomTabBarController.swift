//
//  CustomTabBarController.swift
//  ZOOLIFE
//
//  Created by The Mac Store on 04/05/2021.
//  Copyright © 2021 Hafiz Anser. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//            let rootView = self.viewControllers
//            [self.selectedIndex] as! UINavigationController
//            rootView.popToRootView // here the editor says that it does not work/exist //
        print("clicked1233")
        print("clicked \(item.title ?? "clicked")")
        if let title = item.title
        {
            if title.compare("Home").rawValue == 0 || title.compare("الرئيسية").rawValue == 0
            {
                
                if let home = AppDelegate.homeVC
                {
                    print("clicked called")
                    home.ClearAndCallGetAllMethod()
                }
                
//                print("clicked \(self.viewControllers?.count)")
//                if let controllers = self.viewControllers
//                {
//                    for con in controllers
//                    {
//                        if let home = con as? HomeViewController
//                        {
//                            home.viewDidLoad()
//                        }
//                    }
//                }
//                if let home = self.ta
//                {
//                    home.viewDidLoad()
//                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
