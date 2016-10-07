//
//  XXPageContentView.swift
//  DYZB
//
//  Created by 花菜ChrisCai on 2016/10/7.
//  Copyright © 2016年 花菜ChrisCai. All rights reserved.
//

import UIKit

private let ContentCellID = "ContentCellID"

protocol FCPageContentViewDelegate : class {
    func pageContentView(contentView : XXPageContentView, progress : CGFloat, sourceIndex : Int, targetIndex : Int)
}

class XXPageContentView: UIView {
    fileprivate var viewControllers : [UIViewController]
    weak var parentViewController : UIViewController?
    fileprivate var startOffsetX : CGFloat = 0
    fileprivate var isForbidScrollDelegate : Bool = false
    weak var delegate : FCPageContentViewDelegate?
    fileprivate lazy var contentView : UICollectionView = { [weak self] in
        // 0.创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        // 1.创建contentView
        let contentView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        // 2.设置属性
        contentView.isPagingEnabled = true
        contentView.bounces = false
        contentView.dataSource = self
        contentView.scrollsToTop = false
        contentView.delegate = self
        // 3.注册cell
        contentView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        // 4.返回contentView
        return contentView
    }()
    init(frame : CGRect, viewControllers : [UIViewController], parentViewController : UIViewController) {
        self.viewControllers = viewControllers
        self.parentViewController = parentViewController
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - 设置UI界面
extension XXPageContentView {
    fileprivate func setupUI() {
       
        // 添加所有的子控制器
        for viewController in viewControllers {
            parentViewController?.addChildViewController(viewController)
        }
        // 添加容器控件
        addSubview(contentView)
        contentView.frame = bounds
    }
}

// MARK: - 代理方法
extension XXPageContentView : UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 判断是否是点击事件
        if isForbidScrollDelegate {
            return
        }
        // 定义需要获取的变量
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        // 判断是左划还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let width = scrollView.bounds.width
        if currentOffsetX > startOffsetX {
            // 左划
            progress = currentOffsetX / width - floor(currentOffsetX / width)
            sourceIndex = Int(currentOffsetX / width)
            targetIndex = sourceIndex + 1
            if targetIndex >= viewControllers.count {
                targetIndex = viewControllers.count - 1
            }
            if currentOffsetX - startOffsetX == width {
                progress = 1
                targetIndex = sourceIndex
            }
        }else {
            // 右滑
            progress = 1 - (currentOffsetX / width - floor(currentOffsetX / width))
            targetIndex = Int(currentOffsetX / width)
            sourceIndex = targetIndex + 1
            if sourceIndex >= viewControllers.count {
                sourceIndex = viewControllers.count - 1
            }
        }
        delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
        
    }
}
// MARK: - 数据原方法
extension XXPageContentView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return viewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        // 防止循环利用
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        let viewController = viewControllers[indexPath.row]
        viewController.view.backgroundColor = UIColor.randomColor()
        viewController.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(viewController.view)
        return cell
    }
}

// MARK:- 对外暴露的方法
extension XXPageContentView {
    func setCurrentIndex(currentIndex : Int) {
        
        // 1.记录需要进制执行代理方法
        isForbidScrollDelegate = true
        
        // 2.滚动正确的位置
        let offsetX = CGFloat(currentIndex) * contentView.frame.width
           contentView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
