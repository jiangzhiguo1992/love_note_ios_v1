//
//  MoreCoinVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/22.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class MoreCoinVC: BaseVC {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = self.view.frame.size.width
    lazy var maxWidth = screenWidth - margin * 2
    lazy var topHeight = ScreenUtils.heightFit(90)
    lazy var topMargin = ScreenUtils.widthFit(15)
    lazy var avatarWidth = topHeight - topMargin * 2
    lazy var itemWidth = (maxWidth - margin) / 2
    lazy var itemHeight = ScreenUtils.heightFit(55)
    lazy var imageWidth = ScreenUtils.widthFit(35)
    
    // view
    private var ivAvatarLeft: UIImageView!
    private var ivAvatarRight: UIImageView!
    private var lCoinCount: UILabel!
    
    // var
    lazy var model = UDHelper.getModelShow()
    lazy var isPayVisible = model.marketPay
    private var coin: Coin?
    
    public static func pushVC() {
        if UserHelper.isCoupleBreak(couple: UDHelper.getCouple()) {
            CouplePairVC.pushVC()
            return
        }
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(MoreCoinVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "coin")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_help_outline_white_24dp"), style: .plain, target: self, action: #selector(targetGoHelp))
        
        // top
        let vTop = UIView(frame: CGRect(x: margin, y: margin, width: maxWidth, height: topHeight))
        vTop.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vTop, radius: ViewHelper.RADIUS_BIG)
        ViewUtils.setViewShadow(vTop, offset: ViewHelper.SHADOW_BIG)
        
        ivAvatarLeft = ViewHelper.getImageViewAvatar(width: avatarWidth, height: avatarWidth)
        ivAvatarLeft.frame.origin = CGPoint(x: topMargin, y: topMargin)
        ivAvatarRight = ViewHelper.getImageViewAvatar(width: avatarWidth, height: avatarWidth)
        ivAvatarRight.frame.origin = CGPoint(x: vTop.frame.size.width - topMargin - ivAvatarRight.frame.size.width, y: topMargin)
        
        let btnWidth = (vTop.frame.size.width - avatarWidth * 2 - topMargin * 2 - margin * 3) / 2
        let btnHistory = ViewHelper.getBtnBGPrimary(width: btnWidth, title: StringUtils.getString("get_history"), titleSize: ViewHelper.FONT_SIZE_SMALL, titleColor: ColorHelper.getFontWhite(), circle: true, shadow: true)
        btnHistory.frame.origin.x = ivAvatarLeft.frame.origin.x + ivAvatarLeft.frame.size.width + margin
        btnHistory.frame.origin.y = ivAvatarLeft.frame.origin.y + ivAvatarLeft.frame.size.height - btnHistory.frame.size.height
        let btnBuy = ViewHelper.getBtnBGPrimary(width: btnWidth, title: StringUtils.getString("go_to_buy"), titleSize: ViewHelper.FONT_SIZE_SMALL, titleColor: ColorHelper.getFontWhite(), circle: true, shadow: true)
        btnBuy.frame.origin.x = ivAvatarRight.frame.origin.x - margin - btnBuy.frame.size.width
        btnBuy.frame.origin.y = ivAvatarRight.frame.origin.y + ivAvatarRight.frame.size.height - btnBuy.frame.size.height
        btnBuy.isHidden = !isPayVisible
        
        let countWidth = vTop.frame.size.width - avatarWidth * 2 - topMargin * 2 - margin * 2
        let countHeight = ivAvatarLeft.frame.size.height - btnHistory.frame.size.height
        lCoinCount = ViewHelper.getLabelBold(width: countWidth, height: countHeight, text: "-", size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .center, mode: .byTruncatingMiddle)
        lCoinCount.center.x = vTop.frame.size.width / 2
        lCoinCount.frame.origin.y = topMargin
        
        vTop.addSubview(ivAvatarLeft)
        vTop.addSubview(ivAvatarRight)
        vTop.addSubview(btnHistory)
        vTop.addSubview(btnBuy)
        vTop.addSubview(lCoinCount)
        
        let labelX = imageWidth + margin * 2
        let labelWidth = itemWidth - labelX
        let itemRightX = screenWidth / 2 + margin / 2
        
        // line-in
        let lIn = ViewHelper.getLabelWhiteSmall(text: StringUtils.getString("get_method"))
        lIn.center.x = screenWidth / 2
        lIn.frame.origin.y = 0
        let lineInLeft = ViewHelper.getViewLine(width: (maxWidth - lIn.frame.size.width) / 2 - margin, color: ColorHelper.getWhite())
        lineInLeft.frame.origin.x = margin
        lineInLeft.center.y = lIn.center.y
        let lineInRight = ViewHelper.getViewLine(width: (maxWidth - lIn.frame.size.width) / 2 - margin, color: ColorHelper.getWhite())
        lineInRight.frame.origin.x = lIn.frame.origin.x + lIn.frame.size.width + margin
        lineInRight.center.y = lIn.center.y
        let vLineIn = UIView(frame: CGRect(x: 0, y: vTop.frame.origin.y + vTop.frame.size.height + ScreenUtils.heightFit(30), width: screenWidth, height: lIn.frame.size.height))
        vLineIn.addSubview(lIn)
        vLineIn.addSubview(lineInLeft)
        vLineIn.addSubview(lineInRight)
        
        // ad
        let lAdTop = ViewHelper.getLabelBold(width: maxWidth - margin * 2, text: StringUtils.getString("watch_ad_get_coin"), size: ViewHelper.FONT_SIZE_NORMAL, color: ColorHelper.getFontBlack(), lines: 1, align: .center)
        lAdTop.frame.origin = CGPoint(x: margin, y: margin)
        
        let lAdBottom = ViewHelper.getLabelGreySmall(width: maxWidth - margin * 2, text: StringUtils.getString("watch_ad_desc"), lines: 1, align: .center, mode: .byTruncatingMiddle)
        lAdBottom.frame.origin = CGPoint(x: margin, y: lAdTop.frame.origin.y + lAdTop.frame.size.height + margin)
        
        // pay
        let payY = vLineIn.frame.origin.y + vLineIn.frame.size.height + ScreenUtils.heightFit(15)
        let vInPay = UIView(frame: CGRect(x: margin, y: payY, width: itemWidth, height: itemHeight))
        vInPay.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vInPay, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vInPay, offset: ViewHelper.SHADOW_NORMAL)
        
        let ivInPay = ViewHelper.getImageView(img: UIImage(named: "ic_vip_pay_24dp"), width: imageWidth, height: imageWidth, mode: .center)
        ivInPay.frame.origin.x = margin
        ivInPay.center.y = itemHeight / 2
        
        let lInPayTop = ViewHelper.getLabelBold(width: labelWidth, text: StringUtils.getString("pay"), size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontBlack(), lines: 1, align: .left, mode: .byTruncatingTail)
        lInPayTop.frame.origin.x = labelX
        lInPayTop.frame.origin.y = ivInPay.frame.origin.y
        
        let lInPayBottom = ViewHelper.getLabelGreySmall(width: labelWidth, text: StringUtils.getString("more_pay_more_send"), lines: 1, align: .left, mode: .byTruncatingTail)
        lInPayBottom.frame.origin.x = labelX
        lInPayBottom.frame.origin.y = ivInPay.frame.origin.y + imageWidth - lInPayBottom.frame.size.height
        
        vInPay.addSubview(ivInPay)
        vInPay.addSubview(lInPayTop)
        vInPay.addSubview(lInPayBottom)
        vInPay.isHidden = !isPayVisible
        
        // sign
        let signX = vInPay.isHidden ? vInPay.frame.origin.x : itemRightX
        let vInSign = UIView(frame: CGRect(x: signX, y: payY, width: itemWidth, height: itemHeight))
        vInSign.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vInSign, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vInSign, offset: ViewHelper.SHADOW_NORMAL)
        
        let ivInSign = ViewHelper.getImageView(img: UIImage(named: "ic_more_sign_24dp"), width: imageWidth, height: imageWidth, mode: .center)
        ivInSign.frame.origin.x = margin
        ivInSign.center.y = itemHeight / 2
        
        let lInSignTop = ViewHelper.getLabelBold(width: labelWidth, text: StringUtils.getString("sign"), size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontBlack(), lines: 1, align: .left, mode: .byTruncatingTail)
        lInSignTop.frame.origin.x = labelX
        lInSignTop.frame.origin.y = ivInSign.frame.origin.y
        
        let lInSignBottom = ViewHelper.getLabelGreySmall(width: labelWidth, text: StringUtils.getString("more_sign_more_get"), lines: 1, align: .left, mode: .byTruncatingTail)
        lInSignBottom.frame.origin.x = labelX
        lInSignBottom.frame.origin.y = ivInSign.frame.origin.y + imageWidth - lInSignBottom.frame.size.height
        
        vInSign.addSubview(ivInSign)
        vInSign.addSubview(lInSignTop)
        vInSign.addSubview(lInSignBottom)
        
        // wife
        let vInWife = UIView(frame: CGRect(x: margin, y: vInPay.frame.origin.y + vInPay.frame.size.height + margin, width: itemWidth, height: itemHeight))
        vInWife.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vInWife, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vInWife, offset: ViewHelper.SHADOW_NORMAL)
        
        let ivInWife = ViewHelper.getImageView(img: UIImage(named: "ic_more_wife_24dp"), width: imageWidth, height: imageWidth, mode: .center)
        ivInWife.frame.origin.x = margin
        ivInWife.center.y = itemHeight / 2
        
        let lInWifeTop = ViewHelper.getLabelBold(width: labelWidth, text: StringUtils.getString("nav_wife"), size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontBlack(), lines: 1, align: .left, mode: .byTruncatingTail)
        lInWifeTop.frame.origin.x = labelX
        lInWifeTop.frame.origin.y = ivInWife.frame.origin.y
        
        let lInWifeBottom = ViewHelper.getLabelGreySmall(width: labelWidth, text: StringUtils.getString("join_just_send"), lines: 1, align: .left, mode: .byTruncatingTail)
        lInWifeBottom.frame.origin.x = labelX
        lInWifeBottom.frame.origin.y = ivInWife.frame.origin.y + imageWidth - lInWifeBottom.frame.size.height
        
        vInWife.addSubview(ivInWife)
        vInWife.addSubview(lInWifeTop)
        vInWife.addSubview(lInWifeBottom)
        
        // letter
        let vInLetter = UIView(frame: CGRect(x: itemRightX, y: vInSign.frame.origin.y + vInSign.frame.size.height + margin, width: itemWidth, height: itemHeight))
        vInLetter.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vInLetter, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vInLetter, offset: ViewHelper.SHADOW_NORMAL)
        
        let ivInLetter = ViewHelper.getImageView(img: UIImage(named: "ic_more_letter_24dp"), width: imageWidth, height: imageWidth, mode: .center)
        ivInLetter.frame.origin.x = margin
        ivInLetter.center.y = itemHeight / 2
        
        let lInLetterTop = ViewHelper.getLabelBold(width: labelWidth, text: StringUtils.getString("nav_letter"), size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontBlack(), lines: 1, align: .left, mode: .byTruncatingTail)
        lInLetterTop.frame.origin.x = labelX
        lInLetterTop.frame.origin.y = ivInLetter.frame.origin.y
        
        let lInLetterBottom = ViewHelper.getLabelGreySmall(width: labelWidth, text: StringUtils.getString("join_just_send"), lines: 1, align: .left, mode: .byTruncatingTail)
        lInLetterBottom.frame.origin.x = labelX
        lInLetterBottom.frame.origin.y = ivInLetter.frame.origin.y + imageWidth - lInLetterBottom.frame.size.height
        
        vInLetter.addSubview(ivInLetter)
        vInLetter.addSubview(lInLetterTop)
        vInLetter.addSubview(lInLetterBottom)
        
        // line-out
        let lOut = ViewHelper.getLabelWhiteSmall(text: StringUtils.getString("out_method"))
        lOut.center.x = screenWidth / 2
        lOut.frame.origin.y = 0
        let lineOutLeft = ViewHelper.getViewLine(width: (maxWidth - lOut.frame.size.width) / 2 - margin, color: ColorHelper.getWhite())
        lineOutLeft.frame.origin.x = margin
        lineOutLeft.center.y = lOut.center.y
        let lineOutRight = ViewHelper.getViewLine(width: (maxWidth - lOut.frame.size.width) / 2 - margin, color: ColorHelper.getWhite())
        lineOutRight.frame.origin.x = lOut.frame.origin.x + lOut.frame.size.width + margin
        lineOutRight.center.y = lOut.center.y
        let vLineOut = UIView(frame: CGRect(x: 0, y: vInWife.frame.origin.y + vInWife.frame.size.height + ScreenUtils.heightFit(25), width: screenWidth, height: lOut.frame.size.height))
        vLineOut.addSubview(lOut)
        vLineOut.addSubview(lineOutLeft)
        vLineOut.addSubview(lineOutRight)
        
        // wife
        let vOutWife = UIView(frame: CGRect(x: margin, y: vLineOut.frame.origin.y + vLineOut.frame.size.height + ScreenUtils.heightFit(15), width: itemWidth, height: itemHeight))
        vOutWife.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vOutWife, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vOutWife, offset: ViewHelper.SHADOW_NORMAL)
        
        let ivOutWife = ViewHelper.getImageView(img: UIImage(named: "ic_more_wife_24dp"), width: imageWidth, height: imageWidth, mode: .center)
        ivOutWife.frame.origin.x = margin
        ivOutWife.center.y = itemHeight / 2
        
        let lOutWifeTop = ViewHelper.getLabelBold(width: labelWidth, text: StringUtils.getString("nav_wife"), size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontBlack(), lines: 1, align: .left, mode: .byTruncatingTail)
        lOutWifeTop.frame.origin.x = labelX
        lOutWifeTop.frame.origin.y = ivOutWife.frame.origin.y
        
        let lOutWifeBottom = ViewHelper.getLabelGreySmall(width: labelWidth, text: StringUtils.getString("help_you_to_top"), lines: 1, align: .left, mode: .byTruncatingTail)
        lOutWifeBottom.frame.origin.x = labelX
        lOutWifeBottom.frame.origin.y = ivOutWife.frame.origin.y + imageWidth - lOutWifeBottom.frame.size.height
        
        vOutWife.addSubview(ivOutWife)
        vOutWife.addSubview(lOutWifeTop)
        vOutWife.addSubview(lOutWifeBottom)
        
        // letter
        let vOutLetter = UIView(frame: CGRect(x: itemRightX, y: vLineOut.frame.origin.y + vLineOut.frame.size.height + ScreenUtils.heightFit(15), width: itemWidth, height: itemHeight))
        vOutLetter.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vOutLetter, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vOutLetter, offset: ViewHelper.SHADOW_NORMAL)
        
        let ivOutLetter = ViewHelper.getImageView(img: UIImage(named: "ic_more_letter_24dp"), width: imageWidth, height: imageWidth, mode: .center)
        ivOutLetter.frame.origin.x = margin
        ivOutLetter.center.y = itemHeight / 2
        
        let lOutLetterTop = ViewHelper.getLabelBold(width: labelWidth, text: StringUtils.getString("nav_letter"), size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontBlack(), lines: 1, align: .left, mode: .byTruncatingTail)
        lOutLetterTop.frame.origin.x = labelX
        lOutLetterTop.frame.origin.y = ivOutLetter.frame.origin.y
        
        let lOutLetterBottom = ViewHelper.getLabelGreySmall(width: labelWidth, text: StringUtils.getString("help_you_to_top"), lines: 1, align: .left, mode: .byTruncatingTail)
        lOutLetterBottom.frame.origin.x = labelX
        lOutLetterBottom.frame.origin.y = ivOutLetter.frame.origin.y + imageWidth - lOutLetterBottom.frame.size.height
        
        vOutLetter.addSubview(ivOutLetter)
        vOutLetter.addSubview(lOutLetterTop)
        vOutLetter.addSubview(lOutLetterBottom)
        
        // wish
        let vOutWish = UIView(frame: CGRect(x: margin, y: vOutWife.frame.origin.y + vOutWife.frame.size.height + margin, width: itemWidth, height: itemHeight))
        vOutWish.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vOutWish, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vOutWish, offset: ViewHelper.SHADOW_NORMAL)
        
        let ivOutWish = ViewHelper.getImageView(img: UIImage(named: "ic_more_wish_24dp"), width: imageWidth, height: imageWidth, mode: .center)
        ivOutWish.frame.origin.x = margin
        ivOutWish.center.y = itemHeight / 2
        
        let lOutWishTop = ViewHelper.getLabelBold(width: labelWidth, text: StringUtils.getString("nav_wish"), size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontBlack(), lines: 1, align: .left, mode: .byTruncatingTail)
        lOutWishTop.frame.origin.x = labelX
        lOutWishTop.frame.origin.y = ivOutWish.frame.origin.y
        
        let lOutWishBottom = ViewHelper.getLabelGreySmall(width: labelWidth, text: StringUtils.getString("wish_more_long"), lines: 1, align: .left, mode: .byTruncatingTail)
        lOutWishBottom.frame.origin.x = labelX
        lOutWishBottom.frame.origin.y = ivOutWish.frame.origin.y + imageWidth - lOutWishBottom.frame.size.height
        
        vOutWish.addSubview(ivOutWish)
        vOutWish.addSubview(lOutWishTop)
        vOutWish.addSubview(lOutWishBottom)
        
        // card
        let vOutCard = UIView(frame: CGRect(x: itemRightX, y: vOutLetter.frame.origin.y + vOutLetter.frame.size.height + margin, width: itemWidth, height: itemHeight))
        vOutCard.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vOutCard, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vOutCard, offset: ViewHelper.SHADOW_NORMAL)
        
        let ivOutCard = ViewHelper.getImageView(img: UIImage(named: "ic_more_postcard_24dp"), width: imageWidth, height: imageWidth, mode: .center)
        ivOutCard.frame.origin.x = margin
        ivOutCard.center.y = itemHeight / 2
        
        let lOutCardTop = ViewHelper.getLabelBold(width: labelWidth, text: StringUtils.getString("nav_postcard"), size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontBlack(), lines: 1, align: .left, mode: .byTruncatingTail)
        lOutCardTop.frame.origin.x = labelX
        lOutCardTop.frame.origin.y = ivOutCard.frame.origin.y
        
        let lOutCardBottom = ViewHelper.getLabelGreySmall(width: labelWidth, text: StringUtils.getString("postcard_more_long"), lines: 1, align: .left, mode: .byTruncatingTail)
        lOutCardBottom.frame.origin.x = labelX
        lOutCardBottom.frame.origin.y = ivOutCard.frame.origin.y + imageWidth - lOutCardBottom.frame.size.height
        
        vOutCard.addSubview(ivOutCard)
        vOutCard.addSubview(lOutCardTop)
        vOutCard.addSubview(lOutCardBottom)
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = vOutCard.frame.origin.y + vOutCard.frame.size.height + ScreenUtils.heightFit(20)
        let scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.width, height: scrollContentHeight))
        scroll.addSubview(vTop)
        scroll.addSubview(vLineIn)
        scroll.addSubview(vInPay)
        scroll.addSubview(vInSign)
        scroll.addSubview(vInWife)
        scroll.addSubview(vInLetter)
        scroll.addSubview(vLineOut)
        scroll.addSubview(vOutWife)
        scroll.addSubview(vOutLetter)
        scroll.addSubview(vOutWish)
        scroll.addSubview(vOutCard)
        
        // view
        self.view.backgroundColor = ThemeHelper.getColorPrimary()
        self.view.addSubview(scroll)
        
        // target
        btnHistory.addTarget(self, action: #selector(targetGoHistory), for: .touchUpInside)
        btnBuy.addTarget(self, action: #selector(targetGoBuy), for: .touchUpInside)
        ViewUtils.addViewTapTarget(target: self, view: vInPay, action: #selector(targetGoPay))
        ViewUtils.addViewTapTarget(target: self, view: vInSign, action: #selector(targetGoSign))
        ViewUtils.addViewTapTarget(target: self, view: vInWife, action: #selector(targetGoWife))
        ViewUtils.addViewTapTarget(target: self, view: vInLetter, action: #selector(targetGoLetter))
        ViewUtils.addViewTapTarget(target: self, view: vOutWife, action: #selector(targetGoWife))
        ViewUtils.addViewTapTarget(target: self, view: vOutLetter, action: #selector(targetGoLetter))
        ViewUtils.addViewTapTarget(target: self, view: vOutWish, action: #selector(targetGoWish))
        ViewUtils.addViewTapTarget(target: self, view: vOutCard, action: #selector(targetGoCard))
    }
    
    override func initData() {
        // event
        NotifyHelper.addObserver(self, selector: #selector(refreshData), name: NotifyHelper.TAG_COIN_INFO_REFRESH)
        // avatar
        let me = UDHelper.getMe()
        let ta = UDHelper.getTa()
        let myAvaatr = UserHelper.getMyAvatar(user: me)
        let taAvatar = UserHelper.getTaAvatar(user: me)
        KFHelper.setImgAvatarUrl(iv: ivAvatarLeft, objKey: taAvatar, user: ta)
        KFHelper.setImgAvatarUrl(iv: ivAvatarRight, objKey: myAvaatr, user: me)
        // view
        refreshView()
        // datae
        refreshData()
    }
    
    @objc private func refreshData() {
        let api = Api.request(.moreCoinHomeGet, success: { (_, _, data) in
            self.coin = data.coin
            self.refreshView()
        }, failure: nil)
        pushApi(api)
    }
    
    private func refreshView() {
        lCoinCount.text = "\(coin?.count ?? 0)"
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_MORE_COIN)
    }
    
    @objc private func targetGoHistory(sender: UIButton) {
        MoreCoinListVC.pushVC()
    }
    
    @objc private func targetGoBuy(sender: UIButton) {
        MoreCoinBuyVC.pushVC()
    }
    
    @objc private func targetGoPay() {
        MoreCoinBuyVC.pushVC()
    }
    
    @objc private func targetGoSign() {
        MoreSignVC.pushVC()
    }
    
    @objc private func targetGoWife() {
        MoreMatchWifeVC.pushVC()
    }
    
    @objc private func targetGoLetter() {
        MoreMatchLetterVC.pushVC()
    }
    
    @objc private func targetGoWish() {
        // feature
    }
    
    @objc private func targetGoCard() {
        // feature
    }
    
}
