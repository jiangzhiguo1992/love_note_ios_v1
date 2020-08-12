//
//  CommonPageVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2018/12/28.
//  Copyright © 2018年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class BasePageVC: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    public static func getSplashVC(dateSource: [UIViewController]?) -> BasePageVC {
        return BasePageVC(dateSource: dateSource)
    }
    
    private var pageSubControllers: [UIViewController]!
    private lazy var currentPage: Int = 0
    
    // 页面数量改变时的回调
    var pageViewControllerUpdatePageCount: ((BasePageVC, NSInteger) -> Void)!
    // 页面改变时的回调
    var pageViewControllerUpdatePageIndex: ((BasePageVC, NSInteger) -> Void)!
    
    internal init(transitionStyle style: UIPageViewController.TransitionStyle = .pageCurl,
                  navigationOrientation: UIPageViewController.NavigationOrientation = .horizontal,
                  options: [UIPageViewController.OptionsKey: Any]? = nil,
                  dateSource: [UIViewController]? = nil,
                  pageCount: ((BasePageVC, NSInteger) -> Void)? = nil,
                  pageIndex: ((BasePageVC, NSInteger) -> Void)? = nil) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
        pageSubControllers = dateSource ?? [UIViewController]()
        if pageCount != nil {
            self.pageViewControllerUpdatePageCount = pageCount
        }
        if pageIndex != nil {
            self.pageViewControllerUpdatePageIndex = pageIndex
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view
        self.view.backgroundColor = ColorHelper.getBackground()
        self.view.autoresizesSubviews = true
        self.view.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleHeight.rawValue
            | UIView.AutoresizingMask.flexibleWidth.rawValue
            | UIView.AutoresizingMask.flexibleLeftMargin.rawValue
            | UIView.AutoresizingMask.flexibleRightMargin.rawValue
            | UIView.AutoresizingMask.flexibleTopMargin.rawValue
            | UIView.AutoresizingMask.flexibleBottomMargin.rawValue)
        
        delegate = self
        dataSource = self
        
        // 设置首页
        if let firstViewController = pageSubControllers.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)
        }
        
        // 页面数量改变时
        self.pageViewControllerUpdatePageCount?(self, pageSubControllers.count)
    }
    
    // 销毁
    deinit {
        // notify
        NotifyHelper.removeObserver(self)
    }
    
    // 获取前一个页面
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pageSubControllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard pageSubControllers.count > previousIndex else {
            return nil
        }
        return pageSubControllers[previousIndex]
    }
    
    // 获取后一个页面
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pageSubControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = currentIndex + 1
        guard nextIndex >= 0 else {
            return nil
        }
        guard pageSubControllers.count > nextIndex else {
            return nil
        }
        return pageSubControllers[nextIndex]
    }
    
    // 页面切换完毕
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let firstViewController = pageSubControllers.first, let index = pageSubControllers.firstIndex(of: firstViewController) {
            self.pageViewControllerUpdatePageIndex?(self, index)
        }
    }
    
    // 更新页面索引
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let controller = pendingViewControllers[0]
        self.currentPage = pageSubControllers.firstIndex(of: controller)!
    }
    
}
