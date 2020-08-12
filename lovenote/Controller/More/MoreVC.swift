//
// Created by 蒋治国 on 2018-12-09.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import SDCycleScrollView

class MoreVC: BaseVC {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var maxWidth = self.view.frame.width - margin * 2
    lazy var itemLineMargin = ScreenUtils.heightFit(15)
    lazy var itemInnerMargin = ScreenUtils.heightFit(8)
    lazy var itemLabelMargin = ScreenUtils.heightFit(2)
    lazy var itemWidth = (maxWidth - margin * 2) / 3
    
    // view
    private var barItemSettings: UIBarButtonItem!
    private var scroll: UIScrollView!
    
    private var vBroadcast: UIView!
    private var lBroadcast: UILabel!
    private var cycleView: SDCycleScrollView!
    
    private var lVipDesc: UILabel!
    private var lCoinDesc: UILabel!
    private var lSignDesc: UILabel!
    private var lWifeDesc: UILabel!
    private var lLetterDesc: UILabel!
    private var lWishDesc: UILabel!
    private var lCardDesc: UILabel!
    
    // var
    lazy var model = UDHelper.getModelShow()
    lazy var isPayVisible = model.moreVip && model.moreCoin
    lazy var isVipVisible = model.moreVip && model.marketPay
    lazy var isCoinVisibile = model.moreCoin
    lazy var isSignVisibile = model.moreCoin
    lazy var isMatchVisible = model.moreMatch
    lazy var isFratureVisibile = false
    private var wifePeriod: MatchPeriod?
    private var letterPeriod: MatchPeriod?
    
    static func get() -> MoreVC {
        return MoreVC(nibName: nil, bundle: nil)
    }
    
    override func initView() {
        // navigationBar
        self.title = StringUtils.getString("nav_more")
        let barItemHelp = UIBarButtonItem(image: UIImage(named: "ic_help_outline_white_24dp"), style: .plain, target: self, action: #selector(targetGoHelp))
        barItemSettings = UIBarButtonItem(image: UIImage(named: "ic_settings_white_24dp"), style: .plain, target: self, action: #selector(targetGoSettings))
        self.navigationItem.setLeftBarButtonItems([barItemHelp], animated: true)
        self.navigationItem.setRightBarButtonItems([barItemSettings], animated: true)
        
        // broadcast
        vBroadcast = UIView()
        vBroadcast.frame.size = CGSize(width: maxWidth, height: ScreenUtils.heightFit(150))
        vBroadcast.frame.origin = CGPoint(x: margin, y: margin)
        vBroadcast.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vBroadcast, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vBroadcast, offset: ViewHelper.SHADOW_NORMAL)
        
        lBroadcast = ViewHelper.getLabelGreyNormal(width: vBroadcast.frame.size.width, height: vBroadcast.frame.size.height, text: StringUtils.getString("now_no_broadcast"), align: .center)
        
        cycleView = SDCycleScrollView(frame: CGRect(x: 0, y: 0, width: vBroadcast.frame.size.width, height: vBroadcast.frame.size.height))
        cycleView.autoScrollTimeInterval = 4
        cycleView.bannerImageViewContentMode = .scaleAspectFill
        ViewUtils.setViewRadius(cycleView, radius: ViewHelper.RADIUS_NORMAL, bounds: true)
        
        // vBroadcast.addSubview(lBroadcast)
        // vBroadcast.addSubview(vLoop)
        
        // pay
        let lLinePayCenter = ViewHelper.getLabelGreySmall(text: StringUtils.getString("nav_pay"))
        lLinePayCenter.center.x = maxWidth / 2
        lLinePayCenter.frame.origin.y = 0
        lLinePayCenter.textColor = ColorHelper.getFontHint()
        
        let vLinePayLeft = ViewHelper.getViewLine(width: (maxWidth - lLinePayCenter.frame.size.width) / 2 - margin)
        vLinePayLeft.frame.origin.x = 0
        vLinePayLeft.center.y = lLinePayCenter.center.y
        
        let vLinePayRight = ViewHelper.getViewLine(width: (maxWidth - lLinePayCenter.frame.size.width) / 2 - margin)
        vLinePayRight.frame.origin.x = maxWidth - vLinePayRight.frame.size.width
        vLinePayRight.center.y = lLinePayCenter.center.y
        
        let vLinePay = UIView()
        vLinePay.frame.size.width = maxWidth
        vLinePay.frame.size.height = lLinePayCenter.frame.size.height
        vLinePay.frame.origin = CGPoint(x: margin, y: vBroadcast.frame.origin.y + vBroadcast.frame.size.height + margin * 2)
        vLinePay.addSubview(lLinePayCenter)
        vLinePay.addSubview(vLinePayLeft)
        vLinePay.addSubview(vLinePayRight)
        vLinePay.isHidden = !isPayVisible
        
        // vip
        let ivVip = ViewHelper.getImageView(img: UIImage(named: "ic_more_vip_24dp"))
        ivVip.frame.origin.x = margin
        let lVipTitle = ViewHelper.getLabelBlackNormal(width: itemWidth - ivVip.frame.origin.x - ivVip.frame.size.width, text: StringUtils.getString("vip"), lines: 1, align: .center)
        lVipTitle.frame.origin = CGPoint(x: ivVip.frame.origin.x + ivVip.frame.size.width, y: itemInnerMargin)
        lVipDesc = ViewHelper.getLabelGreySmall(width: itemWidth - ivVip.frame.origin.x - ivVip.frame.size.width, text: "-", lines: 1, align: .center)
        lVipDesc.frame.origin = CGPoint(x: ivVip.frame.origin.x + ivVip.frame.size.width, y: lVipTitle.frame.origin.y + lVipTitle.frame.size.height + itemLabelMargin)
        
        let vVip = UIView()
        vVip.frame.size = CGSize(width: itemWidth, height: lVipDesc.frame.origin.y + lVipDesc.frame.size.height + itemInnerMargin)
        vVip.frame.origin = CGPoint(x: margin, y: vLinePay.frame.origin.y + vLinePay.frame.size.height + margin)
        vVip.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vVip, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vVip, offset: ViewHelper.SHADOW_NORMAL)
        ivVip.center.y = vVip.frame.size.height / 2
        vVip.addSubview(ivVip)
        vVip.addSubview(lVipTitle)
        vVip.addSubview(lVipDesc)
        vVip.isHidden = !isVipVisible
        
        // coin
        let ivCoin = ViewHelper.getImageView(img: UIImage(named: "ic_more_coin_24dp"))
        ivCoin.frame.origin.x = margin
        let lCoinTitle = ViewHelper.getLabelBlackNormal(width: itemWidth - ivCoin.frame.origin.x - ivCoin.frame.size.width, text: StringUtils.getString("coin"), lines: 1, align: .center)
        lCoinTitle.frame.origin = CGPoint(x: ivCoin.frame.origin.x + ivCoin.frame.size.width, y: itemInnerMargin)
        lCoinDesc = ViewHelper.getLabelGreySmall(width: itemWidth - ivCoin.frame.origin.x - ivCoin.frame.size.width, text: "-", lines: 1, align: .center)
        lCoinDesc.frame.origin = CGPoint(x: ivCoin.frame.origin.x + ivCoin.frame.size.width, y: lCoinTitle.frame.origin.y + lCoinTitle.frame.size.height + itemLabelMargin)
        
        let vCoin = UIView()
        vCoin.frame.size = CGSize(width: itemWidth, height: lCoinDesc.frame.origin.y + lCoinDesc.frame.size.height + itemInnerMargin)
        vCoin.frame.origin = CGPoint(x: vVip.isHidden ? vVip.frame.origin.x : vVip.frame.origin.x + vVip.frame.size.width + margin, y: vLinePay.frame.origin.y + vLinePay.frame.size.height + margin)
        vCoin.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCoin, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vCoin, offset: ViewHelper.SHADOW_NORMAL)
        ivCoin.center.y = vCoin.frame.size.height / 2
        vCoin.addSubview(ivCoin)
        vCoin.addSubview(lCoinTitle)
        vCoin.addSubview(lCoinDesc)
        vCoin.isHidden = !isCoinVisibile
        
        // sign
        let ivSign = ViewHelper.getImageView(img: UIImage(named: "ic_more_sign_24dp"))
        ivSign.frame.origin.x = margin
        let lSignTitle = ViewHelper.getLabelBlackNormal(width: itemWidth - ivSign.frame.origin.x - ivSign.frame.size.width, text: StringUtils.getString("sign"), lines: 1, align: .center)
        lSignTitle.frame.origin = CGPoint(x: ivSign.frame.origin.x + ivSign.frame.size.width, y: itemInnerMargin)
        lSignDesc = ViewHelper.getLabelGreySmall(width: itemWidth - ivSign.frame.origin.x - ivSign.frame.size.width, text: "-", lines: 1, align: .center)
        lSignDesc.frame.origin = CGPoint(x: ivSign.frame.origin.x + ivSign.frame.size.width, y: lSignTitle.frame.origin.y + lSignTitle.frame.size.height + itemLabelMargin)
        
        let vSign = UIView()
        vSign.frame.size = CGSize(width: itemWidth, height: lSignDesc.frame.origin.y + lSignDesc.frame.size.height + itemInnerMargin)
        vSign.frame.origin = CGPoint(x: vCoin.isHidden ? vCoin.frame.origin.x : vCoin.frame.origin.x + vCoin.frame.size.width + margin, y: vLinePay.frame.origin.y + vLinePay.frame.size.height + margin)
        vSign.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vSign, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vSign, offset: ViewHelper.SHADOW_NORMAL)
        ivSign.center.y = vSign.frame.size.height / 2
        vSign.addSubview(ivSign)
        vSign.addSubview(lSignTitle)
        vSign.addSubview(lSignDesc)
        vSign.isHidden = !isSignVisibile
        
        // match
        let lLineMatchCenter = ViewHelper.getLabelGreySmall(text: StringUtils.getString("nav_match"))
        lLineMatchCenter.center.x = maxWidth / 2
        lLineMatchCenter.frame.origin.y = 0
        lLineMatchCenter.textColor = ColorHelper.getFontHint()
        let vLineMatchLeft = ViewHelper.getViewLine(width: (maxWidth - lLineMatchCenter.frame.size.width) / 2 - margin)
        vLineMatchLeft.frame.origin.x = 0
        vLineMatchLeft.center.y = lLineMatchCenter.center.y
        let vLineMatchRight = ViewHelper.getViewLine(width: (maxWidth - lLineMatchCenter.frame.size.width) / 2 - margin)
        vLineMatchRight.frame.origin.x = maxWidth - vLineMatchRight.frame.size.width
        vLineMatchRight.center.y = lLineMatchCenter.center.y
        
        let vLineMatch = UIView()
        vLineMatch.frame.size.width = maxWidth
        vLineMatch.frame.size.height = lLineMatchCenter.frame.size.height
        vLineMatch.frame.origin = CGPoint(x: margin, y: isPayVisible ? vVip.frame.origin.y + vVip.frame.size.height + itemLineMargin : vLinePay.frame.origin.y)
        vLineMatch.addSubview(lLineMatchCenter)
        vLineMatch.addSubview(vLineMatchLeft)
        vLineMatch.addSubview(vLineMatchRight)
        vLineMatch.isHidden = !isMatchVisible
        
        // wife
        let ivWife = ViewHelper.getImageView(img: UIImage(named: "ic_more_wife_24dp"))
        ivWife.frame.origin.x = margin
        let lWifeTitle = ViewHelper.getLabelBlackNormal(width: itemWidth - ivWife.frame.origin.x - ivWife.frame.size.width, text: StringUtils.getString("nav_wife"), lines: 1, align: .center)
        lWifeTitle.frame.origin = CGPoint(x: ivWife.frame.origin.x + ivWife.frame.size.width, y: itemInnerMargin)
        lWifeDesc = ViewHelper.getLabelGreySmall(width: itemWidth - ivWife.frame.origin.x - ivWife.frame.size.width, text: "-", lines: 1, align: .center)
        lWifeDesc.frame.origin = CGPoint(x: ivWife.frame.origin.x + ivWife.frame.size.width, y: lWifeTitle.frame.origin.y + lWifeTitle.frame.size.height + itemLabelMargin)
        
        let vWife = UIView()
        vWife.frame.size = CGSize(width: itemWidth, height: lWifeDesc.frame.origin.y + lWifeDesc.frame.size.height + itemInnerMargin)
        vWife.frame.origin = CGPoint(x: margin, y: vLineMatch.frame.origin.y + vLineMatch.frame.size.height + margin)
        vWife.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vWife, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vWife, offset: ViewHelper.SHADOW_NORMAL)
        ivWife.center.y = vWife.frame.size.height / 2
        vWife.addSubview(ivWife)
        vWife.addSubview(lWifeTitle)
        vWife.addSubview(lWifeDesc)
        vWife.isHidden = !isMatchVisible
        
        // letter
        let ivLetter = ViewHelper.getImageView(img: UIImage(named: "ic_more_letter_24dp"))
        ivLetter.frame.origin.x = margin
        let lLetterTitle = ViewHelper.getLabelBlackNormal(width: itemWidth - ivLetter.frame.origin.x - ivLetter.frame.size.width, text: StringUtils.getString("nav_letter"), lines: 1, align: .center)
        lLetterTitle.frame.origin = CGPoint(x: ivLetter.frame.origin.x + ivLetter.frame.size.width, y: itemInnerMargin)
        lLetterDesc = ViewHelper.getLabelGreySmall(width: itemWidth - ivLetter.frame.origin.x - ivLetter.frame.size.width, text: "-", lines: 1, align: .center)
        lLetterDesc.frame.origin = CGPoint(x: ivLetter.frame.origin.x + ivLetter.frame.size.width, y: lLetterTitle.frame.origin.y + lLetterTitle.frame.size.height + itemLabelMargin)
        
        let vLetter = UIView()
        vLetter.frame.size = CGSize(width: itemWidth, height: lLetterDesc.frame.origin.y + lLetterDesc.frame.size.height + itemInnerMargin)
        vLetter.frame.origin = CGPoint(x: vWife.frame.origin.x + vWife.frame.size.width + margin, y: vLineMatch.frame.origin.y + vLineMatch.frame.size.height + margin)
        vLetter.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vLetter, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vLetter, offset: ViewHelper.SHADOW_NORMAL)
        ivLetter.center.y = vLetter.frame.size.height / 2
        vLetter.addSubview(ivLetter)
        vLetter.addSubview(lLetterTitle)
        vLetter.addSubview(lLetterDesc)
        vLetter.isHidden = !isMatchVisible
        
        // feature
        let lLineFeatureCenter = ViewHelper.getLabelGreySmall(text: StringUtils.getString("nav_future"))
        lLineFeatureCenter.center.x = maxWidth / 2
        lLineFeatureCenter.frame.origin.y = 0
        lLineFeatureCenter.textColor = ColorHelper.getFontHint()
        let vLineFeatureLeft = ViewHelper.getViewLine(width: (maxWidth - lLineFeatureCenter.frame.size.width) / 2 - margin)
        vLineFeatureLeft.frame.origin.x = 0
        vLineFeatureLeft.center.y = lLineFeatureCenter.center.y
        let vLineFeatureRight = ViewHelper.getViewLine(width: (maxWidth - lLineFeatureCenter.frame.size.width) / 2 - margin)
        vLineFeatureRight.frame.origin.x = maxWidth - vLineFeatureRight.frame.size.width
        vLineFeatureRight.center.y = lLineFeatureCenter.center.y
        
        let vLineFeature = UIView()
        vLineFeature.frame.size.width = maxWidth
        vLineFeature.frame.size.height = lLineFeatureCenter.frame.size.height
        vLineFeature.frame.origin = CGPoint(x: margin, y: isMatchVisible ? vWife.frame.origin.y + vWife.frame.size.height + itemLineMargin : vLineMatch.frame.origin.y)
        vLineFeature.addSubview(lLineFeatureCenter)
        vLineFeature.addSubview(vLineFeatureLeft)
        vLineFeature.addSubview(vLineFeatureRight)
        vLineFeature.isHidden = !isFratureVisibile
        
        // wish
        let ivWish = ViewHelper.getImageView(img: UIImage(named: "ic_more_wish_24dp"))
        ivWish.frame.origin.x = margin
        let lWishTitle = ViewHelper.getLabelBlackNormal(width: itemWidth - ivWish.frame.origin.x - ivWish.frame.size.width, text: StringUtils.getString("nav_wish"), lines: 1, align: .center)
        lWishTitle.frame.origin = CGPoint(x: ivWish.frame.origin.x + ivWish.frame.size.width, y: itemInnerMargin)
        lWishDesc = ViewHelper.getLabelGreySmall(width: itemWidth - ivWish.frame.origin.x - ivWish.frame.size.width, text: "-", lines: 1, align: .center)
        lWishDesc.frame.origin = CGPoint(x: ivWish.frame.origin.x + ivWish.frame.size.width, y: lWishTitle.frame.origin.y + lWishTitle.frame.size.height + itemLabelMargin)
        
        let vWish = UIView()
        vWish.frame.size = CGSize(width: itemWidth, height: lWishDesc.frame.origin.y + lWishDesc.frame.size.height + itemInnerMargin)
        vWish.frame.origin = CGPoint(x: margin, y: vLineFeature.frame.origin.y + vLineFeature.frame.size.height + margin)
        vWish.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vWish, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vWish, offset: ViewHelper.SHADOW_NORMAL)
        ivWish.center.y = vWish.frame.size.height / 2
        vWish.addSubview(ivWish)
        vWish.addSubview(lWishTitle)
        vWish.addSubview(lWishDesc)
        vWish.isHidden = !isFratureVisibile
        
        // card
        let ivCard = ViewHelper.getImageView(img: UIImage(named: "ic_more_postcard_24dp"))
        ivCard.frame.origin.x = margin
        let lCardTitle = ViewHelper.getLabelBlackNormal(width: itemWidth - ivCard.frame.origin.x - ivCard.frame.size.width, text: StringUtils.getString("nav_postcard"), lines: 1, align: .center)
        lCardTitle.frame.origin = CGPoint(x: ivCard.frame.origin.x + ivCard.frame.size.width, y: itemInnerMargin)
        lCardDesc = ViewHelper.getLabelGreySmall(width: itemWidth - ivCard.frame.origin.x - ivCard.frame.size.width, text: "-", lines: 1, align: .center)
        lCardDesc.frame.origin = CGPoint(x: ivCard.frame.origin.x + ivCard.frame.size.width, y: lCardTitle.frame.origin.y + lCardTitle.frame.size.height + itemLabelMargin)
        
        let vCard = UIView()
        vCard.frame.size = CGSize(width: itemWidth, height: lCardDesc.frame.origin.y + lCardDesc.frame.size.height + itemInnerMargin)
        vCard.frame.origin = CGPoint(x: vWish.frame.origin.x + vWish.frame.size.width + margin, y: vLineFeature.frame.origin.y + vLineFeature.frame.size.height + margin)
        vCard.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCard, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vCard, offset: ViewHelper.SHADOW_NORMAL)
        ivCard.center.y = vCard.frame.size.height / 2
        vCard.addSubview(ivCard)
        vCard.addSubview(lCardTitle)
        vCard.addSubview(lCardDesc)
        vCard.isHidden = !isFratureVisibile
        
        // scroll
        var scrollY: CGFloat = 0
        if #available(iOS 11.0, *) {
            scrollY = RootVC.get().getTopBarHeight()
        }
        var scrollHeight = self.view.frame.height - (self.tabBarController?.tabBar.frame.size.height ?? 0)
        if #available(iOS 11.0, *) {
            scrollHeight -= RootVC.get().getTopBarHeight()
        }
        let scrollReact = CGRect(x: 0, y: scrollY, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = vWish.frame.origin.y + vWish.frame.size.height + ScreenUtils.heightFit(30)
        scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        scroll.refreshControl = UIRefreshControl()
        scroll.refreshControl?.tintColor = ThemeHelper.getColorPrimary()
        scroll.addSubview(vBroadcast)
        scroll.addSubview(vLinePay)
        scroll.addSubview(vVip)
        scroll.addSubview(vCoin)
        scroll.addSubview(vSign)
        scroll.addSubview(vLineMatch)
        scroll.addSubview(vWife)
        scroll.addSubview(vLetter)
        scroll.addSubview(vLineFeature)
        scroll.addSubview(vWish)
        scroll.addSubview(vCard)
        
        // view
        self.view.addSubview(scroll)
        
        // target
        scroll.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        ViewUtils.addViewTapTarget(target: self, view: vVip, action: #selector(targetGoVip))
        ViewUtils.addViewTapTarget(target: self, view: vCoin, action: #selector(targetGoCoin))
        ViewUtils.addViewTapTarget(target: self, view: vSign, action: #selector(targetGoSign))
        ViewUtils.addViewTapTarget(target: self, view: vWife, action: #selector(targetGoWife))
        ViewUtils.addViewTapTarget(target: self, view: vLetter, action: #selector(targetGoLetter))
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(refreshData), name: NotifyHelper.TAG_VIP_INFO_REFRESH)
        NotifyHelper.addObserver(self, selector: #selector(refreshData), name: NotifyHelper.TAG_COIN_INFO_REFRESH)
        // data
        refreshData()
    }
    
    override func onReview(_ animated: Bool) {
        // 轮播状态恢复
        cycleView.adjustWhenControllerViewWillAppera()
        // settings
        let commonCount = UDHelper.getCommonCount()
        let redpoint = commonCount.noticeNewCount > 0 || commonCount.versionNewCount > 0
        barItemSettings.image = UIImage(named: redpoint ? "ic_settings_point_white_24dp" : "ic_settings_white_24dp")?.withRenderingMode(.alwaysOriginal)
    }
    
    override func onThemeUpdate(theme: Int?) {
        scroll.refreshControl?.tintColor = ThemeHelper.getColorPrimary()
    }
    
    @objc private func refreshData() {
        ViewUtils.beginScrollRefresh(scroll)
        // api
        let api = Api.request(.moreHomeGet, success: { (_, _, data) in
            ViewUtils.endScrollRefresh(self.scroll)
            self.wifePeriod = data.wifePeriod
            self.letterPeriod = data.letterPeriod
            // view
            self.initBroadcastView(broadcastList: data.broadcastList)
            self.initPay(vip: data.vip, coin: data.coin, sign: data.sign)
            self.initMatch()
            self.initFeature()
        }, failure: { (_, _, _) in
            ViewUtils.endScrollRefresh(self.scroll)
        })
        pushApi(api)
    }
    
    private func initBroadcastView(broadcastList: [Broadcast]?) {
        lBroadcast.removeFromSuperview()
        cycleView.removeFromSuperview()
        if (broadcastList?.count ?? 0) <= 0 {
            vBroadcast.addSubview(lBroadcast)
            return
        }
        vBroadcast.addSubview(cycleView)
        // data
        var ossKeyList = [String]()
        for broadcast in broadcastList! {
            ossKeyList.append(OssHelper.getUrl(objKey: broadcast.cover))
        }
        cycleView.imageURLStringsGroup = ossKeyList
        cycleView.clickItemOperationBlock = { (index) in
            let broadcast = broadcastList![index]
            switch broadcast.contentType {
            case Broadcast.TYPE_URL: // 网页
                WebVC.pushVC(title: broadcast.title, url: broadcast.contentText)
            case Broadcast.TYPE_IMAGE: // 图片
                BrowserHelper.goBrowserImage(delegate: self, index: 0, ossKeyList: [broadcast.contentText])
            default: // 文本
                MoreBroadcastVC.pushVC(broadcast: broadcast)
            }
        }
    }
    
    private func initPay(vip: Vip?, coin: Coin?, sign: Sign?) {
        // vip
        let isVip = (vip != nil) && vip!.expireAt >= DateUtils.getCurrentInt64()
        lVipDesc.text = StringUtils.getString(isVip ? "vip_yes" : "vip_no")
        // coin
        lCoinDesc.text = "\(coin?.count ?? 0)"
        // sign
        lSignDesc.text = StringUtils.getString(sign == nil ? "no_sign" : "yes_sign")
    }
    
    private func initMatch() {
        if wifePeriod == nil || wifePeriod!.id <= 0 {
            lWifeDesc.text = StringUtils.getString("now_no_activity")
        } else {
            lWifeDesc.text = StringUtils.getString("the_holder_period", arguments: [wifePeriod!.period])
        }
        if letterPeriod == nil || letterPeriod!.id <= 0 {
            lLetterDesc.text = StringUtils.getString("now_no_activity")
        } else {
            lLetterDesc.text = StringUtils.getString("the_holder_period", arguments: [letterPeriod!.period])
        }
    }
    
    private func initFeature() {
        lWishDesc.text = "暂无活动"
        lCardDesc.text = "暂无活动"
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_MORE_HOME)
    }
    
    @objc private func targetGoSettings() {
        SettingsVC.pushVC()
    }
    
    @objc private func targetGoVip() {
        MoreVipVC.pushVC()
    }
    
    @objc private func targetGoCoin() {
        MoreCoinVC.pushVC()
    }
    
    @objc private func targetGoSign() {
        MoreSignVC.pushVC()
    }
    
    @objc private func targetGoWife() {
        if wifePeriod == nil || wifePeriod!.id <= 0 {
            MoreMatchWifeVC.pushVC()
        } else {
            MoreMatchWifeListVC.pushVC(pid: wifePeriod!.id, showNew: true)
        }
    }
    
    @objc private func targetGoLetter() {
        if letterPeriod == nil || letterPeriod!.id <= 0 {
            MoreMatchLetterVC.pushVC()
        } else {
            MoreMatchLetterListVC.pushVC(pid: letterPeriod!.id, showNew: true)
        }
    }
    
}
