//
//  UIView-Extension.swift
//  DYZB
//
//  Created by 花菜ChrisCai on 2016/10/3.
//  Copyright © 2016年 花菜ChrisCai. All rights reserved.
//

import UIKit
fileprivate var kActionHandlerTapBlockKey = "kActionHandlerTapBlockKey"
public typealias TapOperation = () -> ()

public class Operation : NSObject {
    public var block:TapOperation?
}

extension UIView {
    func setTapAction(tapCallBack :@escaping TapOperation) {
        // 开启用户交互
        isUserInteractionEnabled = true
        // 创建手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(gesture:)))
        // 添加手势
        addGestureRecognizer(tap)
        // 包装闭包
        let op = Operation()
        op.block = tapCallBack
        // 保存属性
        objc_setAssociatedObject(self, &kActionHandlerTapBlockKey, op, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func tapAction(gesture : UITapGestureRecognizer) {
        // 判断
        if gesture.state == .recognized {
            // 取出属性
            guard let op = objc_getAssociatedObject(self, &kActionHandlerTapBlockKey) as? Operation else {
                return
            }
            // 执行闭包
            guard let block = op.block else { return }
                block()
        }
    }
}
