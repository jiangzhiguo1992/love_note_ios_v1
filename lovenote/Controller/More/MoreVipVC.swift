//
//  VipHomeVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/18.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class MoreVipVC: BaseVC {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var marginH = ScreenUtils.widthFit(5)
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
    
    private var vLimit: UIView!
    private var lAdVipYes: UILabel!
    private var lAdVipNo: UILabel!
    private var lWallVipYes: UILabel!
    private var lWallVipNo: UILabel!
    private var lTotalVipYes: UILabel!
    private var lTotalVipNo: UILabel!
    private var lSouvenirVipYes: UILabel!
    private var lSouvenirVipNo: UILabel!
    private var lAudioVipYes: UILabel!
    private var lAudioVipNo: UILabel!
    private var lVideoVipYes: UILabel!
    private var lVideoVipNo: UILabel!
    private var lAlbumVipYes: UILabel!
    private var lAlbumVipNo: UILabel!
    private var lDiaryVipYes: UILabel!
    private var lDiaryVipNo: UILabel!
    private var lWhisperVipYes: UILabel!
    private var lWhisperVipNo: UILabel!
    private var lGiftVipYes: UILabel!
    private var lGiftVipNo: UILabel!
    private var lFoodVipYes: UILabel!
    private var lFoodVipNo: UILabel!
    private var lMovieVipYes: UILabel!
    private var lMovieVipNo: UILabel!
    
    public static func pushVC() {
        if UserHelper.isCoupleBreak(couple: UDHelper.getCouple()) {
            CouplePairVC.pushVC()
            return
        }
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(MoreVipVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "vip")
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
        let btnHistory = ViewHelper.getBtnBGPrimary(width: btnWidth, paddingV: ScreenUtils.heightFit(2), title: StringUtils.getString("buy_history"), titleSize: ViewHelper.FONT_SIZE_SMALL, titleColor: ColorHelper.getFontWhite(), circle: true, shadow: true)
        btnHistory.frame.origin.x = ivAvatarLeft.frame.origin.x + ivAvatarLeft.frame.size.width + margin
        btnHistory.frame.origin.y = ivAvatarLeft.frame.origin.y + ivAvatarLeft.frame.size.height - btnHistory.frame.size.height
        let btnBuy = ViewHelper.getBtnBGPrimary(width: btnWidth, paddingV: ScreenUtils.heightFit(2), title: StringUtils.getString("go_to_buy"), titleSize: ViewHelper.FONT_SIZE_SMALL, titleColor: ColorHelper.getFontWhite(), circle: true, shadow: true)
        btnBuy.frame.origin.x = ivAvatarRight.frame.origin.x - margin - btnBuy.frame.size.width
        btnBuy.frame.origin.y = ivAvatarRight.frame.origin.y + ivAvatarRight.frame.size.height - btnBuy.frame.size.height
        
        vTop.addSubview(ivAvatarLeft)
        vTop.addSubview(ivAvatarRight)
        vTop.addSubview(btnHistory)
        vTop.addSubview(btnBuy)
        
        let labelX = imageWidth + marginH * 2
        let labelWidth = itemWidth - labelX
        let itemRightX = screenWidth / 2 + margin / 2
        
        // line
        let lVip = ViewHelper.getLabelWhiteSmall(text: StringUtils.getString("vip_desc"))
        lVip.center.x = screenWidth / 2
        lVip.frame.origin.y = 0
        let lineVipLeft = ViewHelper.getViewLine(width: (maxWidth - lVip.frame.size.width) / 2 - margin, color: ColorHelper.getWhite())
        lineVipLeft.frame.origin.x = margin
        lineVipLeft.center.y = lVip.center.y
        let lineVipRight = ViewHelper.getViewLine(width: (maxWidth - lVip.frame.size.width) / 2 - margin, color: ColorHelper.getWhite())
        lineVipRight.frame.origin.x = lVip.frame.origin.x + lVip.frame.size.width + margin
        lineVipRight.center.y = lVip.center.y
        let vVipLine = UIView(frame: CGRect(x: 0, y: CGFloat(20), width: screenWidth, height: lVip.frame.size.height))
        vVipLine.addSubview(lVip)
        vVipLine.addSubview(lineVipLeft)
        vVipLine.addSubview(lineVipRight)
        
        // ad
        let vAd = UIView(frame: CGRect(x: margin, y: vVipLine.frame.origin.y + vVipLine.frame.size.height + ScreenUtils.heightFit(15), width: itemWidth, height: itemHeight))
        vAd.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vAd, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vAd, offset: ViewHelper.SHADOW_NORMAL)
        
        let ivAd = ViewHelper.getImageView(img: UIImage(named: "ic_vip_ad_24dp"), width: imageWidth, height: imageWidth, mode: .center)
        ivAd.frame.origin.x = marginH
        ivAd.center.y = itemHeight / 2
        
        lAdVipYes = ViewHelper.getLabelBlackSmall(width: labelWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lAdVipYes.frame.origin.x = labelX
        lAdVipYes.frame.origin.y = ivAd.frame.origin.y
        
        lAdVipNo = ViewHelper.getLabelGreySmall(width: labelWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lAdVipNo.frame.origin.x = labelX
        lAdVipNo.frame.origin.y = ivAd.frame.origin.y + imageWidth - lAdVipNo.frame.size.height
        
        vAd.addSubview(ivAd)
        vAd.addSubview(lAdVipYes)
        vAd.addSubview(lAdVipNo)
        
        // wall
        let vWall = UIView(frame: CGRect(x: itemRightX, y: vVipLine.frame.origin.y + vVipLine.frame.size.height + ScreenUtils.heightFit(15), width: itemWidth, height: itemHeight))
        vWall.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vWall, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vWall, offset: ViewHelper.SHADOW_NORMAL)
        
        let ivWall = ViewHelper.getImageView(img: UIImage(named: "ic_vip_wall_24dp"), width: imageWidth, height: imageWidth, mode: .center)
        ivWall.frame.origin.x = marginH
        ivWall.center.y = itemHeight / 2
        
        lWallVipYes = ViewHelper.getLabelBlackSmall(width: labelWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lWallVipYes.frame.origin.x = labelX
        lWallVipYes.frame.origin.y = ivWall.frame.origin.y
        
        lWallVipNo = ViewHelper.getLabelGreySmall(width: labelWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lWallVipNo.frame.origin.x = labelX
        lWallVipNo.frame.origin.y = ivWall.frame.origin.y + imageWidth - lWallVipNo.frame.size.height
        
        vWall.addSubview(ivWall)
        vWall.addSubview(lWallVipYes)
        vWall.addSubview(lWallVipNo)
        
        // total
        let vTotal = UIView(frame: CGRect(x: margin, y: vAd.frame.origin.y + vAd.frame.size.height + margin, width: itemWidth, height: itemHeight))
        vTotal.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vTotal, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vTotal, offset: ViewHelper.SHADOW_NORMAL)
        
        let ivTotal = ViewHelper.getImageView(img: UIImage(named: "ic_note_total_24dp"), width: imageWidth, height: imageWidth, mode: .center)
        ivTotal.frame.origin.x = marginH
        ivTotal.center.y = itemHeight / 2
        
        lTotalVipYes = ViewHelper.getLabelBlackSmall(width: labelWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lTotalVipYes.frame.origin.x = labelX
        lTotalVipYes.frame.origin.y = ivTotal.frame.origin.y
        
        lTotalVipNo = ViewHelper.getLabelGreySmall(width: labelWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lTotalVipNo.frame.origin.x = labelX
        lTotalVipNo.frame.origin.y = ivTotal.frame.origin.y + imageWidth - lTotalVipNo.frame.size.height
        
        vTotal.addSubview(ivTotal)
        vTotal.addSubview(lTotalVipYes)
        vTotal.addSubview(lTotalVipNo)
        
        // souvenir
        let vSouvenir = UIView(frame: CGRect(x: itemRightX, y: vWall.frame.origin.y + vWall.frame.size.height + margin, width: itemWidth, height: itemHeight))
        vSouvenir.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vSouvenir, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vSouvenir, offset: ViewHelper.SHADOW_NORMAL)
        
        let ivSouvenir = ViewHelper.getImageView(img: UIImage(named: "ic_note_souvenir_24dp"), width: imageWidth, height: imageWidth, mode: .center)
        ivSouvenir.frame.origin.x = marginH
        ivSouvenir.center.y = itemHeight / 2
        
        lSouvenirVipYes = ViewHelper.getLabelBlackSmall(width: labelWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lSouvenirVipYes.frame.origin.x = labelX
        lSouvenirVipYes.frame.origin.y = ivSouvenir.frame.origin.y
        
        lSouvenirVipNo = ViewHelper.getLabelGreySmall(width: labelWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lSouvenirVipNo.frame.origin.x = labelX
        lSouvenirVipNo.frame.origin.y = ivSouvenir.frame.origin.y + imageWidth - lSouvenirVipNo.frame.size.height
        
        vSouvenir.addSubview(ivSouvenir)
        vSouvenir.addSubview(lSouvenirVipYes)
        vSouvenir.addSubview(lSouvenirVipNo)
        
        // audio
        let vAudio = UIView(frame: CGRect(x: margin, y: vTotal.frame.origin.y + vTotal.frame.size.height + margin, width: itemWidth, height: itemHeight))
        vAudio.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vAudio, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vAudio, offset: ViewHelper.SHADOW_NORMAL)
        
        let ivAudio = ViewHelper.getImageView(img: UIImage(named: "ic_note_audio_24dp"), width: imageWidth, height: imageWidth, mode: .center)
        ivAudio.frame.origin.x = marginH
        ivAudio.center.y = itemHeight / 2
        
        lAudioVipYes = ViewHelper.getLabelBlackSmall(width: labelWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lAudioVipYes.frame.origin.x = labelX
        lAudioVipYes.frame.origin.y = ivAudio.frame.origin.y
        
        lAudioVipNo = ViewHelper.getLabelGreySmall(width: labelWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lAudioVipNo.frame.origin.x = labelX
        lAudioVipNo.frame.origin.y = ivAudio.frame.origin.y + imageWidth - lAudioVipNo.frame.size.height
        
        vAudio.addSubview(ivAudio)
        vAudio.addSubview(lAudioVipYes)
        vAudio.addSubview(lAudioVipNo)
        
        // video
        let vVideo = UIView(frame: CGRect(x: itemRightX, y: vSouvenir.frame.origin.y + vSouvenir.frame.size.height + margin, width: itemWidth, height: itemHeight))
        vVideo.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vVideo, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vVideo, offset: ViewHelper.SHADOW_NORMAL)
        
        let ivVideo = ViewHelper.getImageView(img: UIImage(named: "ic_note_video_24dp"), width: imageWidth, height: imageWidth, mode: .center)
        ivVideo.frame.origin.x = marginH
        ivVideo.center.y = itemHeight / 2
        
        lVideoVipYes = ViewHelper.getLabelBlackSmall(width: labelWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lVideoVipYes.frame.origin.x = labelX
        lVideoVipYes.frame.origin.y = ivVideo.frame.origin.y
        
        lVideoVipNo = ViewHelper.getLabelGreySmall(width: labelWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lVideoVipNo.frame.origin.x = labelX
        lVideoVipNo.frame.origin.y = ivVideo.frame.origin.y + imageWidth - lVideoVipNo.frame.size.height
        
        vVideo.addSubview(ivVideo)
        vVideo.addSubview(lVideoVipYes)
        vVideo.addSubview(lVideoVipNo)
        
        // album
        let vAlbum = UIView(frame: CGRect(x: margin, y: vAudio.frame.origin.y + vAudio.frame.size.height + margin, width: itemWidth, height: itemHeight))
        vAlbum.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vAlbum, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vAlbum, offset: ViewHelper.SHADOW_NORMAL)
        
        let ivAlbum = ViewHelper.getImageView(img: UIImage(named: "ic_note_album_24dp"), width: imageWidth, height: imageWidth, mode: .center)
        ivAlbum.frame.origin.x = marginH
        ivAlbum.center.y = itemHeight / 2
        
        lAlbumVipYes = ViewHelper.getLabelBlackSmall(width: labelWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lAlbumVipYes.frame.origin.x = labelX
        lAlbumVipYes.frame.origin.y = ivAlbum.frame.origin.y
        
        lAlbumVipNo = ViewHelper.getLabelGreySmall(width: labelWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lAlbumVipNo.frame.origin.x = labelX
        lAlbumVipNo.frame.origin.y = ivAlbum.frame.origin.y + imageWidth - lAlbumVipNo.frame.size.height
        
        vAlbum.addSubview(ivAlbum)
        vAlbum.addSubview(lAlbumVipYes)
        vAlbum.addSubview(lAlbumVipNo)
        
        // diary
        let vDiary = UIView(frame: CGRect(x: itemRightX, y: vVideo.frame.origin.y + vVideo.frame.size.height + margin, width: itemWidth, height: itemHeight))
        vDiary.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vDiary, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vDiary, offset: ViewHelper.SHADOW_NORMAL)
        
        let ivDiary = ViewHelper.getImageView(img: UIImage(named: "ic_note_diary_24dp"), width: imageWidth, height: imageWidth, mode: .center)
        ivDiary.frame.origin.x = marginH
        ivDiary.center.y = itemHeight / 2
        
        lDiaryVipYes = ViewHelper.getLabelBlackSmall(width: labelWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lDiaryVipYes.frame.origin.x = labelX
        lDiaryVipYes.frame.origin.y = ivDiary.frame.origin.y
        
        lDiaryVipNo = ViewHelper.getLabelGreySmall(width: labelWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lDiaryVipNo.frame.origin.x = labelX
        lDiaryVipNo.frame.origin.y = ivDiary.frame.origin.y + imageWidth - lDiaryVipNo.frame.size.height
        
        vDiary.addSubview(ivDiary)
        vDiary.addSubview(lDiaryVipYes)
        vDiary.addSubview(lDiaryVipNo)
        
        // whisper
        let vWhisper = UIView(frame: CGRect(x: margin, y: vAlbum.frame.origin.y + vAlbum.frame.size.height + margin, width: itemWidth, height: itemHeight))
        vWhisper.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vWhisper, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vWhisper, offset: ViewHelper.SHADOW_NORMAL)
        
        let ivWhisper = ViewHelper.getImageView(img: UIImage(named: "ic_note_whisper_24dp"), width: imageWidth, height: imageWidth, mode: .center)
        ivWhisper.frame.origin.x = marginH
        ivWhisper.center.y = itemHeight / 2
        
        lWhisperVipYes = ViewHelper.getLabelBlackSmall(width: labelWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lWhisperVipYes.frame.origin.x = labelX
        lWhisperVipYes.frame.origin.y = ivWhisper.frame.origin.y
        
        lWhisperVipNo = ViewHelper.getLabelGreySmall(width: labelWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lWhisperVipNo.frame.origin.x = labelX
        lWhisperVipNo.frame.origin.y = ivWhisper.frame.origin.y + imageWidth - lWhisperVipNo.frame.size.height
        
        vWhisper.addSubview(ivWhisper)
        vWhisper.addSubview(lWhisperVipYes)
        vWhisper.addSubview(lWhisperVipNo)
        
        // gift
        let vGift = UIView(frame: CGRect(x: itemRightX, y: vDiary.frame.origin.y + vDiary.frame.size.height + margin, width: itemWidth, height: itemHeight))
        vGift.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vGift, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vGift, offset: ViewHelper.SHADOW_NORMAL)
        
        let ivGift = ViewHelper.getImageView(img: UIImage(named: "ic_note_gift_24dp"), width: imageWidth, height: imageWidth, mode: .center)
        ivGift.frame.origin.x = marginH
        ivGift.center.y = itemHeight / 2
        
        lGiftVipYes = ViewHelper.getLabelBlackSmall(width: labelWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lGiftVipYes.frame.origin.x = labelX
        lGiftVipYes.frame.origin.y = ivGift.frame.origin.y
        
        lGiftVipNo = ViewHelper.getLabelGreySmall(width: labelWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lGiftVipNo.frame.origin.x = labelX
        lGiftVipNo.frame.origin.y = ivGift.frame.origin.y + imageWidth - lGiftVipNo.frame.size.height
        
        vGift.addSubview(ivGift)
        vGift.addSubview(lGiftVipYes)
        vGift.addSubview(lGiftVipNo)
        
        // food
        let vFood = UIView(frame: CGRect(x: margin, y: vWhisper.frame.origin.y + vWhisper.frame.size.height + margin, width: itemWidth, height: itemHeight))
        vFood.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vFood, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vFood, offset: ViewHelper.SHADOW_NORMAL)
        
        let ivFood = ViewHelper.getImageView(img: UIImage(named: "ic_note_food_24dp"), width: imageWidth, height: imageWidth, mode: .center)
        ivFood.frame.origin.x = marginH
        ivFood.center.y = itemHeight / 2
        
        lFoodVipYes = ViewHelper.getLabelBlackSmall(width: labelWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lFoodVipYes.frame.origin.x = labelX
        lFoodVipYes.frame.origin.y = ivFood.frame.origin.y
        
        lFoodVipNo = ViewHelper.getLabelGreySmall(width: labelWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lFoodVipNo.frame.origin.x = labelX
        lFoodVipNo.frame.origin.y = ivFood.frame.origin.y + imageWidth - lFoodVipNo.frame.size.height
        
        vFood.addSubview(ivFood)
        vFood.addSubview(lFoodVipYes)
        vFood.addSubview(lFoodVipNo)
        
        // movie
        let vMovie = UIView(frame: CGRect(x: itemRightX, y: vGift.frame.origin.y + vGift.frame.size.height + margin, width: itemWidth, height: itemHeight))
        vMovie.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vMovie, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vMovie, offset: ViewHelper.SHADOW_NORMAL)
        
        let ivMovie = ViewHelper.getImageView(img: UIImage(named: "ic_note_movie_24dp"), width: imageWidth, height: imageWidth, mode: .center)
        ivMovie.frame.origin.x = marginH
        ivMovie.center.y = itemHeight / 2
        
        lMovieVipYes = ViewHelper.getLabelBlackSmall(width: labelWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lMovieVipYes.frame.origin.x = labelX
        lMovieVipYes.frame.origin.y = ivMovie.frame.origin.y
        
        lMovieVipNo = ViewHelper.getLabelGreySmall(width: labelWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lMovieVipNo.frame.origin.x = labelX
        lMovieVipNo.frame.origin.y = ivMovie.frame.origin.y + imageWidth - lMovieVipNo.frame.size.height
        
        vMovie.addSubview(ivMovie)
        vMovie.addSubview(lMovieVipYes)
        vMovie.addSubview(lMovieVipNo)
        
        // limit
        vLimit = UIView(frame: CGRect(x: 0, y: vTop.frame.origin.y + vTop.frame.size.height + margin, width: screenWidth, height: vMovie.frame.origin.y + vMovie.frame.size.height + margin))
        vLimit.addSubview(vVipLine)
        vLimit.addSubview(vAd)
        vLimit.addSubview(vWall)
        vLimit.addSubview(vTotal)
        vLimit.addSubview(vSouvenir)
        vLimit.addSubview(vAudio)
        vLimit.addSubview(vVideo)
        vLimit.addSubview(vAlbum)
        vLimit.addSubview(vDiary)
        vLimit.addSubview(vWhisper)
        vLimit.addSubview(vGift)
        vLimit.addSubview(vFood)
        vLimit.addSubview(vMovie)
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = vLimit.frame.origin.y + vLimit.frame.size.height + ScreenUtils.heightFit(20)
        let scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.width, height: scrollContentHeight))
        
        scroll.addSubview(vTop)
        scroll.addSubview(vLimit)
        
        // view
        self.view.backgroundColor = ThemeHelper.getColorPrimary()
        self.view.addSubview(scroll)
        
        // hide
        vLimit.isHidden = true
        
        // target
        btnHistory.addTarget(self, action: #selector(targetGoHistory), for: .touchUpInside)
        btnBuy.addTarget(self, action: #selector(targetGoBuy), for: .touchUpInside)
        ViewUtils.addViewTapTarget(target: self, view: vWall, action: #selector(targetGoWall))
        ViewUtils.addViewTapTarget(target: self, view: vTotal, action: #selector(targetGoTotal))
        ViewUtils.addViewTapTarget(target: self, view: vSouvenir, action: #selector(targetGoSouvenir))
        ViewUtils.addViewTapTarget(target: self, view: vAudio, action: #selector(targetGoAudio))
        ViewUtils.addViewTapTarget(target: self, view: vVideo, action: #selector(targetGoVideo))
        ViewUtils.addViewTapTarget(target: self, view: vAlbum, action: #selector(targetGoAlbum))
        ViewUtils.addViewTapTarget(target: self, view: vDiary, action: #selector(targetGoDiary))
        ViewUtils.addViewTapTarget(target: self, view: vWhisper, action: #selector(targetGoWhisper))
        ViewUtils.addViewTapTarget(target: self, view: vGift, action: #selector(targetGoGift))
        ViewUtils.addViewTapTarget(target: self, view: vFood, action: #selector(targetGoFood))
        ViewUtils.addViewTapTarget(target: self, view: vMovie, action: #selector(targetGoMovie))
    }
    
    override func initData() {
        // event
        NotifyHelper.addObserver(self, selector: #selector(refreshData), name: NotifyHelper.TAG_VIP_INFO_REFRESH)
        // avatar
        let me = UDHelper.getMe()
        let ta = UDHelper.getTa()
        let myAvaatr = UserHelper.getMyAvatar(user: me)
        let taAvatar = UserHelper.getTaAvatar(user: me)
        KFHelper.setImgAvatarUrl(iv: ivAvatarLeft, objKey: taAvatar, user: ta)
        KFHelper.setImgAvatarUrl(iv: ivAvatarRight, objKey: myAvaatr, user: me)
        // view
        refreshView(yesLimit: nil, noLimit: nil)
        // datae
        refreshData()
    }
    
    @objc private func refreshData() {
        let api = Api.request(.moreVipHomeGet, success: { (_, _, data) in
            UDHelper.setVipLimit(data.vipLimit)
            self.refreshView(yesLimit: data.vipYesLimit, noLimit: data.vipNoLimit)
        }, failure: nil)
        pushApi(api)
    }
    
    private func refreshView(yesLimit: VipLimit?, noLimit: VipLimit?) {
        if yesLimit == nil && noLimit == nil {
            vLimit.isHidden = true
            return
        }
        vLimit.isHidden = false
        if yesLimit != nil {
            lAdVipYes.text = StringUtils.getString(yesLimit!.advertiseHide ? "no_ad": "yes_ad_more_less")
            lWallVipYes.text = StringUtils.getString("holder_paper_single_limit_holder", arguments: [yesLimit!.wallPaperCount, FileUtils.getSizeFormat(size: yesLimit!.wallPaperSize)])
            lTotalVipYes.text = StringUtils.getString(yesLimit!.noteTotalEnable ? "open" : "refuse")
            lSouvenirVipYes.text = StringUtils.getString("can_add_holder", arguments: [yesLimit!.souvenirCount])
            lAudioVipYes.text = StringUtils.getString("single_max_holder", arguments: [FileUtils.getSizeFormat(size: yesLimit!.audioSize)])
            lVideoVipYes.text = StringUtils.getString("single_max_holder", arguments: [FileUtils.getSizeFormat(size: yesLimit!.videoSize)])
            lAlbumVipYes.text = yesLimit!.pictureOriginal ? StringUtils.getString("original_single_limit_holder", arguments: [FileUtils.getSizeFormat(size: yesLimit!.pictureSize)]) : StringUtils.getString("compress_max_holder_paper", arguments: [yesLimit!.pictureTotalCount])
            lDiaryVipYes.text = (yesLimit!.diaryImageCount > 0) ? StringUtils.getString("holder_paper_single_limit_holder", arguments: [yesLimit!.diaryImageCount, FileUtils.getSizeFormat(size: yesLimit!.diaryImageSize)]) : StringUtils.getString("refuse_image_upload")
            lWhisperVipYes.text = StringUtils.getString(yesLimit!.whisperImageEnable ? "open_image_upload" : "refuse_image_upload")
            lGiftVipYes.text = StringUtils.getString("every_can_upload_holder_paper", arguments: [yesLimit!.giftImageCount])
            lFoodVipYes.text = StringUtils.getString("every_can_upload_holder_paper", arguments: [yesLimit!.foodImageCount])
            lMovieVipYes.text = StringUtils.getString("every_can_upload_holder_paper", arguments: [yesLimit!.movieImageCount])
        }
        if noLimit != nil {
            lAdVipNo.text = StringUtils.getString(noLimit!.advertiseHide ? "no_ad": "yes_ad_more_less")
            lWallVipNo.text = StringUtils.getString("holder_paper_single_limit_holder", arguments: [noLimit!.wallPaperCount, FileUtils.getSizeFormat(size: noLimit!.wallPaperSize)])
            lTotalVipNo.text = StringUtils.getString(noLimit!.noteTotalEnable ? "now_stage_open" : "refuse")
            lSouvenirVipNo.text = StringUtils.getString("can_add_holder", arguments: [noLimit!.souvenirCount])
            lAudioVipNo.text = StringUtils.getString("single_max_holder", arguments: [FileUtils.getSizeFormat(size: noLimit!.audioSize)])
            lVideoVipNo.text = StringUtils.getString("single_max_holder", arguments: [FileUtils.getSizeFormat(size: noLimit!.videoSize)])
            lAlbumVipNo.text = noLimit!.pictureOriginal ? StringUtils.getString("original_single_limit_holder", arguments: [FileUtils.getSizeFormat(size: noLimit!.pictureSize)]) : StringUtils.getString("compress_max_holder_paper", arguments: [noLimit!.pictureTotalCount])
            lDiaryVipNo.text = (noLimit!.diaryImageCount > 0) ? StringUtils.getString("holder_paper_single_limit_holder", arguments: [noLimit!.diaryImageCount, FileUtils.getSizeFormat(size: noLimit!.diaryImageSize)]) : StringUtils.getString("refuse_image_upload")
            lWhisperVipNo.text = StringUtils.getString(noLimit!.whisperImageEnable ? "open_image_upload" : "refuse_image_upload")
            lGiftVipNo.text = StringUtils.getString("every_can_upload_holder_paper", arguments: [noLimit!.giftImageCount])
            lFoodVipNo.text = StringUtils.getString("every_can_upload_holder_paper", arguments: [noLimit!.foodImageCount])
            lMovieVipNo.text = StringUtils.getString("every_can_upload_holder_paper", arguments: [noLimit!.movieImageCount])
        }
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_MORE_VIP)
    }
    
    @objc private func targetGoHistory(sender: UIButton) {
        MoreVipListVC.pushVC()
    }
    
    @objc private func targetGoBuy(sender: UIButton) {
        MoreVipBuyVC.pushVC()
    }
    
    @objc private func targetGoWall() {
        CoupleWallPaperVC.pushVC()
    }
    
    @objc private func targetGoTotal() {
        NoteTotalVC.pushVC()
    }
    
    @objc private func targetGoSouvenir() {
        NoteSouvenirVC.pushVC()
    }
    
    @objc private func targetGoAudio() {
        NoteAudioVC.pushVC()
    }
    
    @objc private func targetGoVideo() {
        NoteVideoVC.pushVC()
    }
    
    @objc private func targetGoAlbum() {
        NoteAlbumVC.pushVC()
    }
    
    @objc private func targetGoDiary() {
        NoteDiaryVC.pushVC()
    }
    
    @objc private func targetGoWhisper() {
        NoteWhisperVC.pushVC()
    }
    
    @objc private func targetGoGift() {
        NoteGiftVC.pushVC()
    }
    
    @objc private func targetGoFood() {
        NoteFoodVC.pushVC()
    }
    
    @objc private func targetGoMovie() {
        NoteMovieVC.pushVC()
    }
    
}
