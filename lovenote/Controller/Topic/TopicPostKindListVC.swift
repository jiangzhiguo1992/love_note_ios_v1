//
//  TopicPostKindListVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/28.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import XLPagerTabStrip

class TopicPostKindListVC: BaseVC {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    
    // view
    private var lSearch: UILabel!
    private var pagerVC: TopicPostKindVC?
    
    // var
    private var kindInfo: PostKindInfo!
    private var searchIndex = 0
    
    public static func pushVC(kindInfo: PostKindInfo?) {
        if kindInfo == nil {
            return
        }
        AppDelegate.runOnMainAsync {
            let vc = TopicPostKindListVC(nibName: nil, bundle: nil)
            vc.kindInfo = kindInfo
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: kindInfo.name)
        hideNavigationBarShadow()
        
        // search
        lSearch = ViewHelper.getLabelGreyNormal(text: ApiHelper.LIST_TOPIC_TYPE_SHOW[searchIndex], lines: 1, align: .center, mode: .byTruncatingTail)
        let ivSearch = ViewHelper.getImageView(img: UIImage(named: "ic_search_grey_18dp"), width: lSearch.frame.size.height, height: lSearch.frame.size.height, mode: .scaleAspectFit)
        let vSearch = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth / 2, height: lSearch.frame.size.height + margin * 2))
        
        ivSearch.frame.origin = CGPoint(x: (vSearch.frame.size.width - ivSearch.frame.size.width - margin - lSearch.frame.size.width) / 2, y: margin)
        lSearch.frame.origin = CGPoint(x: ivSearch.frame.origin.x + ivSearch.frame.size.width + margin, y: margin)
        vSearch.addSubview(ivSearch)
        vSearch.addSubview(lSearch)
        
        // add
        let lAdd = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("publish"), lines: 1, align: .center, mode: .byTruncatingTail)
        let ivAdd = ViewHelper.getImageView(img: UIImage(named: "ic_add_circle_outline_grey_18dp"), width: lAdd.frame.size.height, height: lAdd.frame.size.height, mode: .scaleAspectFit)
        let vAdd = UIView(frame: CGRect(x: screenWidth / 2, y: 0, width: screenWidth / 2, height: lAdd.frame.size.height + margin * 2))
        
        ivAdd.frame.origin = CGPoint(x: (vAdd.frame.size.width - ivAdd.frame.size.width - margin - lAdd.frame.size.width) / 2, y: margin)
        lAdd.frame.origin = CGPoint(x: ivAdd.frame.origin.x + ivAdd.frame.size.width + margin, y: margin)
        vAdd.addSubview(ivAdd)
        vAdd.addSubview(lAdd)
        
        // line
        let vLineTop = ViewHelper.getViewLine(width: screenWidth)
        vLineTop.frame.origin = CGPoint(x: 0, y: 0)
        let vLineCenter = ViewHelper.getViewLine(height: vSearch.frame.size.height)
        vLineCenter.center.x = screenWidth / 2
        vLineCenter.frame.origin.y = 0
        
        // bottomBar
        let vBottomBar = UIView()
        vBottomBar.frame.size = CGSize(width: screenWidth, height: vSearch.frame.size.height + ScreenUtils.getBottomNavHeight())
        vBottomBar.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height - RootVC.get().getTopBarHeight() - vBottomBar.frame.size.height)
        vBottomBar.backgroundColor = ColorHelper.getWhite()
        
        vBottomBar.addSubview(vSearch)
        vBottomBar.addSubview(vAdd)
        vBottomBar.addSubview(vLineTop)
        vBottomBar.addSubview(vLineCenter)
        
        // year
        let kindHeight = self.view.frame.size.height - vBottomBar.frame.size.height
        pagerVC = TopicPostKindVC.get(height: kindHeight, kindInfo: kindInfo, updateIndicator:  { index in
            self.searchIndex = index
            self.lSearch.text = ApiHelper.LIST_TOPIC_TYPE_SHOW[self.searchIndex]
        })
        if pagerVC != nil {
            pagerVC!.view.frame.size = CGSize(width: screenWidth, height: kindHeight)
            pagerVC!.view.frame.origin.x = 0
            pagerVC!.view.frame.origin.y = 0
            self.addChild(pagerVC!)
            self.view.addSubview(pagerVC!.view)
        }
        self.view.addSubview(vBottomBar)
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vSearch, action: #selector(showSearchAlert))
        ViewUtils.addViewTapTarget(target: self, view: vAdd, action: #selector(goAdd))
    }
    
    @objc func showSearchAlert() {
        // search
        _ = AlertHelper.showAlert(title: StringUtils.getString("select_search_type"),
                                  confirms: ApiHelper.LIST_TOPIC_TYPE_SHOW,
                                  cancel: StringUtils.getString("cancel"),
                                  canCancel: true,
                                  actionHandler: { (_, index, _) in
                                    self.searchIndex = Int(index)
                                    self.lSearch.text = ApiHelper.LIST_TOPIC_TYPE_SHOW[self.searchIndex]
                                    if self.pagerVC != nil {
                                        let currentIndex = self.pagerVC!.currentIndex
                                        switch ApiHelper.LIST_TOPIC_TYPE_TYPE[self.searchIndex] {
                                        case ApiHelper.LIST_TOPIC_TYPE_OFFICIAL: // 官方
                                            NotifyHelper.post(NotifyHelper.TAG_POST_SEARCH_OFFICIAL, obj: currentIndex)
                                            break
                                        case ApiHelper.LIST_TOPIC_TYPE_WELL: // 精华
                                            NotifyHelper.post(NotifyHelper.TAG_POST_SEARCH_WELL, obj: currentIndex)
                                            break
                                        default:
                                            NotifyHelper.post(NotifyHelper.TAG_POST_SEARCH_ALL, obj: currentIndex)
                                            break
                                        }
                                    }
        }, cancelHandler: nil)
    }
    
    @objc func goAdd() {
        let currentIndex = pagerVC?.currentIndex ?? 0
        let subKindInfoList = kindInfo.postSubKindInfoList
        if currentIndex >= 0 && subKindInfoList.count > 0 && currentIndex < subKindInfoList.count {
            let subKind = subKindInfoList[currentIndex]
            if subKind.enable {
                TopicPostAddVC.pushVC(kind: kindInfo.kind, subKind: subKind.kind)
                return
            }
        }
        TopicPostAddVC.pushVC()
    }
    
}

class TopicPostKindVC: ButtonBarPagerTabStripViewController {
    
    // const
    lazy var barHeight = ScreenUtils.heightFit(50)
    
    // var
    private var subVCList = [TopicPostListVC]()
    private var updateIndicator: ((Int) -> Void)?
    
    public static func get(height: CGFloat, kindInfo: PostKindInfo?, updateIndicator: ((Int) -> Void)?) -> TopicPostKindVC? {
        if kindInfo == nil {
            return nil
        }
        let vc = TopicPostKindVC(nibName: nil, bundle: nil)
        vc.updateIndicator = updateIndicator
        // list
        var vcList = [TopicPostListVC]()
        let subKindList = kindInfo!.postSubKindInfoList
        var pageItem = 0
        if subKindList.count > 0 {
            for subKind in subKindList {
                if !subKind.enable {
                    continue
                }
                let fVC = TopicPostListVC.get(height: height - vc.barHeight, pageItem: pageItem, kindInfo: kindInfo!, subKindInfo: subKind)
                vcList.append(fVC)
                pageItem += 1
            }
        }
        // subVCList
        if vcList.count <= 0 {
            return nil
        }
        vc.subVCList = vcList
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
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex)
        if toIndex < 0 || toIndex >= subVCList.count {
            return
        }
        let searchType = subVCList[toIndex].getSearchType()
        for (index, type) in ApiHelper.LIST_TOPIC_TYPE_TYPE.enumerated() {
            if searchType == type {
                updateIndicator?(index)
                break
            }
        }
    }
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        if !indexWasChanged || toIndex < 0 || toIndex >= subVCList.count {
            return
        }
        let searchType = subVCList[toIndex].getSearchType()
        for (index, type) in ApiHelper.LIST_TOPIC_TYPE_TYPE.enumerated() {
            if searchType == type {
                updateIndicator?(index)
                break
            }
        }
    }
    
}
