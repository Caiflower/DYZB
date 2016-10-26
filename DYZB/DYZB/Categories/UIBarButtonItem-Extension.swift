//
//  UIBarButtonItem-Extension.swift
//  DYZB
//
//  Created by 花菜ChrisCai on 2016/10/2.
//  Copyright © 2016年 花菜ChrisCai. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    /*
    class func creatItem(imageName : String, selectedImageName : String = "", size : CGSize = CGSize.zero, target : AnyObject?,action : Selector) -> UIBarButtonItem{
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        if selectedImageName != "" {
            btn.setImage(UIImage(named: selectedImageName), for: .selected)
        }
        if size == CGSize(width: 0, height: 0) {
            btn.sizeToFit()
        }else {
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        if (target != nil) {
            btn.addTarget(target, action: action, for: .touchUpInside)
        }
        return UIBarButtonItem(customView: btn)
    }
 */
     // 便利构造函数: 1> convenience开头 2> 在构造函数中必须明确调用一个设计的构造函数(self)
    convenience init(imageName : String, selectedImageName : String = "", size : CGSize = CGSize.zero, target : AnyObject, action : Selector) {
        // 1. 创建按钮
        let btn = UIButton()
        // 2. 设置图片
        btn.setImage(UIImage(named: imageName), for: .normal)
        if selectedImageName != "" {
            btn.setImage(UIImage(named: selectedImageName), for: .selected)
        }
        // 3. 设置尺寸
        if size == CGSize.zero {
            btn.sizeToFit()
        }else {
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        // 4. 添加事件
        btn.addTarget(target, action: action, for: .touchUpInside)
        // 5. 创建UIBarButtonItem
        self.init(customView : btn)
    }
}
