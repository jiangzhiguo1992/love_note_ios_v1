//
//  MoreMatchWifeVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/5/8.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import XLPagerTabStrip

class MoreMatchWifeVC: BaseVC {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    
    // view
    private var pagerVC: MoreMatchWifePagerVC?
    
    public static func pushVC() {
        if UserHelper.isCoupleBreak(couple: UDHelper.getCouple()) {
            CouplePairVC.pushVC()
            return
        }
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(MoreMatchWifeVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "nav_wife")
        let barHelp = UIBarButtonItem(image: UIImage(named: "ic_help_outline_white_24dp"), style: .plain, target: self, action: #selector(targetGoHelp))
        self.navigationItem.rightBarButtonItems = [barHelp]
        hideNavigationBarShadow()
        
        // pager
        pagerVC = MoreMatchWifePagerVC.get(height: self.view.frame.size.height)
        
        if pagerVC != nil {
            pagerVC!.view.frame.size = CGSize(width: screenWidth, height: self.view.frame.size.height)
            pagerVC!.view.frame.origin.x = 0
            pagerVC!.view.frame.origin.y = 0
            self.addChild(pagerVC!)
            self.view.addSubview(pagerVC!.view)
        }
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_MORE_MATCH)
    }
    
}

class MoreMatchWifePagerVC: ButtonBarPagerTabStripViewController {
    
    // const
    lazy var barHeight = ScreenUtils.heightFit(50)
    
    // var
    private var subVCList = [BaseVC]()
    
    public static func get(height: CGFloat) -> MoreMatchWifePagerVC? {
        let vc = MoreMatchWifePagerVC(nibName: nil, bundle: nil)
        // list
        let periodVC = MoreMatchPeriodListVC.get(height: height - vc.barHeight, kind: MatchPeriod.MATCH_KIND_WIFE_PICTURE)
        let ourVC = MoreMatchWifeOurVC.get(height: height - vc.barHeight)
        vc.subVCList = [periodVC, ourVC]
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
        self.settings.style.buttonBarItemsShouldFillAvailiableWidth = true
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
