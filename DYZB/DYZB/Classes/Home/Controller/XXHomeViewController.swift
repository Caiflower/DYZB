//
//  CFHomeViewController.swift
//  DYZB
//
//  Created by 花菜ChrisCai on 2016/10/2.
//  Copyright © 2016年 花菜ChrisCai. All rights reserved.
//

import UIKit
private let kTitleViewHeight : CGFloat = 40
class XXHomeViewController: UIViewController {
    fileprivate lazy var titleView : XXPageTitleView = { [weak self] in
        let titleFrame = CGRect(x: 0, y: kStatusBarHeight + kNavigationBarHeight, width: kScreenWidth, height: kTitleViewHeight)
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        let titleView = XXPageTitleView(frame: titleFrame, titles: titles)
        titleView.deleage = self
        return titleView
    }()
    fileprivate lazy var contentView : XXPageContentView = {[weak self] in
        let contentFrame = CGRect(x: 0, y: (self?.titleView.frame.maxY)!, width: kScreenWidth, height: kScreenHeight - (self?.titleView.frame.maxY)!)
        let viewControllers = [UIViewController(), UIViewController(), UIViewController(),UIViewController()]
        let contentView = XXPageContentView(frame: contentFrame, viewControllers: viewControllers, parentViewController: self!)
        contentView.delegate = self
        return contentView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
    }


}

// MARK: - 初始化UI界面
extension XXHomeViewController {
    // MARK: - 设置所有的UI界面
    fileprivate func setupUI() {
        
        automaticallyAdjustsScrollViewInsets = false
        // 初始化导航栏
        setupNavigationBar()
        // 添加标题栏
        view.addSubview(titleView)
        // 添加内容视图
        view.addSubview(contentView)
    }
    // MARK: - 初始化导航栏
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo", target: self, action: #selector(XXHomeViewController.leftItemClick))
        let size = CGSize(width: 40, height: 40)
        let historyItem = UIBarButtonItem(imageName: "image_my_history", selectedImageName: "Image_my_history_click", size: size, target: self, action: #selector(XXHomeViewController.historyItemClick))
        let searchItem = UIBarButtonItem(imageName: "btn_search", selectedImageName: "btn_search_clicked", size: size, target: self, action: #selector(XXHomeViewController.searchItemClick))
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", selectedImageName: "Image_scan_click", size: size, target: self, action: #selector(XXHomeViewController.qrcodeItemClick))
        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcodeItem]
    }
    
    private func setupContentView() {
        
    }
}

// MARK: - 导航栏点击事件
extension XXHomeViewController {
    // MARK: - 左边按钮点击事件
   @objc fileprivate func leftItemClick() -> Void{
        print("左边导航栏按钮点击事件")
    }
    // MARK: - 历史记录按钮点击事件
   @objc fileprivate func historyItemClick() -> Void {
        print("历史记录按钮点击事件")
    }
    // MARK: - 搜索按钮点击事件
   @objc fileprivate func searchItemClick() -> Void {
        print("搜索按钮点击事件")
    }
    // MARK: - 二维码按钮点击事件
   @objc fileprivate func qrcodeItemClick() -> Void {
       print("二维码按钮点击事件")
    }
}

extension XXHomeViewController : XXPageTitleViewDelegate {
    func pageTitleView(titleView: XXPageTitleView, selectedIndex: Int) {
        contentView.setCurrentIndex(currentIndex: selectedIndex)
    }
}

extension XXHomeViewController : FCPageContentViewDelegate {
    func pageContentView(contentView: XXPageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        titleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

