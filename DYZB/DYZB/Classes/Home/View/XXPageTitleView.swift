//
//  XXPageTitleView.swift
//  DYZB
//
//  Created by 花菜ChrisCai on 2016/10/7.
//  Copyright © 2016年 花菜ChrisCai. All rights reserved.
//

import UIKit
protocol XXPageTitleViewDelegate: class {
    func titleView(titleView: XXPageTitleView , selectedIndex : Int)
}

class XXPageTitleView: UIView {
    // MARK: - 定义属性
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.scrollsToTop = false
        view.bounces = false
        return view
    }()
    fileprivate lazy var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    fileprivate var currentIndex : Int = 0
    fileprivate var titles : [String]
    weak var deleage : XXPageTitleViewDelegate?
    
    // MARK: - 自定义构造函数
    init(frame : CGRect , titles : [String]) {
        self.titles = titles
        super.init(frame: frame)
        // 设置UI界面
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 定义常量
private let kScrollLineH : CGFloat = 2
private let kNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

extension XXPageTitleView {
    fileprivate func setupUI() {
        scrollView.frame = bounds
        addSubview(scrollView)
        setupTitlteLabels()
        setupBottomLineAndScrollLine()
    }
    private func setupTitlteLabels() {
        // 0.确定label的一些frame的值
        let labelW : CGFloat = frame.width / CGFloat(titles.count)
        let labelH : CGFloat = frame.height - kScrollLineH
        let labelY : CGFloat = 0
        for (index,title) in titles.enumerated() {
            // 1.创建UILabel
            let label = UILabel()
            // 2.设置属性
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16)
            label.textAlignment = .center
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.text = title
            let labelX : CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            // 3.添加父控件
            scrollView.addSubview(label)
            titleLabels.append(label)
            // 4.添加手势
            label.setTapAction { [weak self] in
                // 1.防止重复点击
                if label.tag == self?.currentIndex { return }
                // 2.获取上一次的label
                 let oldLabel = self?.titleLabels[(self?.currentIndex)!]
                // 3.切换文字的颜色
                label.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
                oldLabel?.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
                // 4.保存最新Label的下标值
                self?.currentIndex = label.tag
                
                // 5.滚动条位置发生改变
                let scrollLineX = CGFloat((self?.currentIndex)!) * (self?.scrollLine.frame.width)!
                UIView.animate(withDuration: 0.15) {
                    self?.scrollLine.frame.origin.x = scrollLineX
                }
                // 6.通知代理
                self?.deleage?.titleView(titleView: self!, selectedIndex: (self?.currentIndex)!)
            }
        }
    }
    private func setupBottomLineAndScrollLine() {
        // 1.添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        // 2.添加scrollLine
        // 2.1.获取第一个Label
        guard let firstLabel = titleLabels.first else { return }
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        // 2.2.设置scrollLine的属性
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
    }
}

// MARK: - 公开的方法
extension XXPageTitleView {
    func setTitleWithProgress(progress : CGFloat , sourceIndex : Int , targetIndex : Int) {
        // 1.取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 2.处理滑块的逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        // 3.颜色的渐变(复杂)
        // 3.1.取出变化的范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        
        // 3.2.变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        
        // 3.2.变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        
        // 4.记录最新的index
        currentIndex = targetIndex

    }
}
