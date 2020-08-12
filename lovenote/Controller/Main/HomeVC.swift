//
//  HomeVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2018/11/30.
//  Copyright © 2018年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class HomeVC: BaseVC {
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().newRoot([HomeVC(nibName: nil, bundle: nil)])
        }
    }
    
    private var tabBarVC: UITabBarController!
    
    override func initView() {
        // navigationBar 隐藏掉
        initNavBar(title: "")
        
        // couple
        let coupleVC = CoupleVC.get()
        coupleVC.tabBarItem = UITabBarItem(title: StringUtils.getString("nav_couple"), image: UIImage(named: "ic_nav_couple_black_24dp"), selectedImage: nil)
        coupleVC.tabBarItem.imageInsets = UIEdgeInsets(top: ScreenUtils.heightFit(-2), left: 0, bottom: ScreenUtils.heightFit(2), right: 0);
        coupleVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -ScreenUtils.heightFit(3))
        coupleVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_SMALL)], for: .normal)
        let coupleNaviVC = BaseNaviVC.get(root: coupleVC)
        coupleNaviVC.setNavigationBarHidden(true, animated: false)
        
        // note
        let noteVC = NoteVC.get()
        noteVC.tabBarItem = UITabBarItem(title: StringUtils.getString("nav_note"), image: UIImage(named: "ic_nav_note_black_24dp"), selectedImage: nil)
        noteVC.tabBarItem.imageInsets = UIEdgeInsets(top: ScreenUtils.heightFit(-2), left: 0, bottom: ScreenUtils.heightFit(2), right: 0);
        noteVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -ScreenUtils.heightFit(3))
        noteVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_SMALL)], for: .normal)
        let noteNaviVC = BaseNaviVC.get(root: noteVC)
        noteNaviVC.setNavigationBarHidden(false, animated: false)
        
        // topic
        let topicVC = TopicVC.get()
        topicVC.tabBarItem = UITabBarItem(title: StringUtils.getString("nav_topic"), image: UIImage(named: "ic_nav_topic_black_24dp"), selectedImage: nil)
        topicVC.tabBarItem.imageInsets = UIEdgeInsets(top: ScreenUtils.heightFit(-2), left: 0, bottom: ScreenUtils.heightFit(2), right: 0);
        topicVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -ScreenUtils.heightFit(3))
        topicVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_SMALL)], for: .normal)
        let topicNaviVC = BaseNaviVC.get(root: topicVC)
        topicNaviVC.setNavigationBarHidden(false, animated: false)
        
        // more
        let moreVC = MoreVC.get()
        moreVC.tabBarItem = UITabBarItem(title: StringUtils.getString("nav_more"), image: UIImage(named: "ic_nav_more_black_24dp"), selectedImage: nil)
        moreVC.tabBarItem.imageInsets = UIEdgeInsets(top: ScreenUtils.heightFit(-2), left: 0, bottom: ScreenUtils.heightFit(2), right: 0);
        moreVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -ScreenUtils.heightFit(3))
        moreVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_SMALL)], for: .normal)
        let moreNaviVC = BaseNaviVC.get(root: moreVC)
        topicNaviVC.setNavigationBarHidden(false, animated: false)
        
        // tabbar
        tabBarVC = BaseTabBarVC.getHomeTabVC()
        let modelShow = UDHelper.getModelShow()
        if modelShow.couple {
            tabBarVC.addChild(coupleNaviVC)
        }
        if modelShow.note {
            tabBarVC.addChild(noteNaviVC)
        }
        if modelShow.topic {
            tabBarVC.addChild(topicNaviVC)
        }
        if modelShow.more {
            tabBarVC.addChild(moreNaviVC)
        }
        
        // view
        self.addChild(tabBarVC)
        self.view.addSubview(tabBarVC.view)
    }
    
    override func initData() {
    }
    
    override func onThemeUpdate(theme: Int?) {
        tabBarVC.tabBar.tintColor = ThemeHelper.getColorPrimary()
    }
    
}
