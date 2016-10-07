//
//  CFTabBarController.swift
//  DYZB
//
//  Created by 花菜ChrisCai on 2016/10/2.
//  Copyright © 2016年 花菜ChrisCai. All rights reserved.
//

import UIKit

class XXTabBarController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        addViewController(storyName: "Home")
        addViewController(storyName: "Live")
        addViewController(storyName: "Follow")
        addViewController(storyName: "Porfile")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addViewController(storyName: String) {
        let vc = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        addChildViewController(vc)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
