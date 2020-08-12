//
//  TopicMessageVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/5/2.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import XLPagerTabStrip

class TopicMessageVC: BaseVC {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    
    // view
    private var pagerVC: TopicMessagePagerVC?
    
    public static func pushVC() {
        if UserHelper.isCoupleBreak(couple: UDHelper.getCouple()) {
            CouplePairVC.pushVC()
            return
        }
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(TopicMessageVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "my_message")
        hideNavigationBarShadow()
        
        // pager
        pagerVC = TopicMessagePagerVC.get(height: self.view.frame.size.height)
        
        if pagerVC != nil {
            pagerVC!.view.frame.size = CGSize(width: screenWidth, height: self.view.frame.size.height)
            pagerVC!.view.frame.origin.x = 0
            pagerVC!.view.frame.origin.y = 0
            self.addChild(pagerVC!)
            self.view.addSubview(pagerVC!.view)
        }
    }
    
    override func initData() {
        // count
        let commonCount = UDHelper.getCommonCount()
        commonCount.topicMsgNewCount = 0
        UDHelper.setCommonCount(commonCount)
    }
    
}

class TopicMessagePagerVC: ButtonBarPagerTabStripViewController {
    
    // const
    lazy var barHeight = ScreenUtils.heightFit(50)
    
    // var
    private var subVCList = [TopicMessageListVC]()
    
    public static func get(height: CGFloat) -> TopicMessagePagerVC? {
        let vc = TopicMessagePagerVC(nibName: nil, bundle: nil)
        // list
        let allVC = TopicMessageListVC.get(height: height - vc.barHeight, kind: TopicMessage.KIND_ALL)
        let jabPostVC = TopicMessageListVC.get(height: height - vc.barHeight, kind: TopicMessage.KIND_JAB_IN_POST)
        let jabCommentVC = TopicMessageListVC.get(height: height - vc.barHeight, kind: TopicMessage.KIND_JAB_IN_COMMENT)
        let postCommentVC = TopicMessageListVC.get(height: height - vc.barHeight, kind: TopicMessage.KIND_POST_BE_COMMENT)
        let commentReplyVC = TopicMessageListVC.get(height: height - vc.barHeight, kind: TopicMessage.KIND_COMMENT_BE_REPLY)
        vc.subVCList = [allVC, jabPostVC, jabCommentVC, postCommentVC, commentReplyVC]
        return vc
    }
    
    override func viewDidLoad() {
        // 顶部buttonBar背景颜色
        self.settings.style.buttonBarBackgroundColor = ColorHelper.getWhite()
        self.settings.style.buttonBarMinimumInteritemSpacing = 0
        self.settings.style.buttonBarHeight = barHeight
        // self.settings.style.buttonBarMinimumLineSpacing: CGFloat?
        // self.settings.style.buttonBarLeftContentInset: CGFloat?
        // self.settings.style.buttonBarRightContentInset: CGFloat?
        // 标签
        self.settings.style.buttonBarItemsShouldFillAvailiableWidth = false
        self.settings.style.buttonBarItemBackgroundColor = ColorHelper.getWhite()
        // 下标
        self.settings.style.selectedBarHeight = ScreenUtils.heightFit(2)
        self.settings.style.selectedBarBackgroundColor = ThemeHelper.getColorPrimary()
        // 字体
        self.settings.style.buttonBarItemFont = ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)
        self.settings.style.buttonBarItemLeftRightMargin = ScreenUtils.widthFit(20)
        self.settings.style.buttonBarItemTitleColor = ThemeHelper.getColorPrimary()
        
        super.viewDidLoad()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return subVCList
    }
    
}
