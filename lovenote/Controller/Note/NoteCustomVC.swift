//
//  NoteCustomVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/2/23.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteCustomVC: BaseVC {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var marginSmall = ScreenUtils.widthFit(4)
    lazy var paddingCard = ScreenUtils.widthFit(8)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    lazy var cardWidth = (maxWidth - marginSmall * 3) / 4
    lazy var tagSouvenir = 1
    lazy var tagMenses = 2
    lazy var tagShy = 3
    lazy var tagSleep = 4
    lazy var tagWord = 5
    lazy var tagWhisper = 6
    lazy var tagAward = 7
    lazy var tagDiary = 8
    lazy var tagDream = 9
    lazy var tagAngry = 10
    lazy var tagGift = 11
    lazy var tagPromise = 12
    lazy var tagTravel = 13
    lazy var tagMovie = 14
    lazy var tagFood = 15
    lazy var tagAudio = 16
    lazy var tagVideo = 17
    lazy var tagAlbum = 18
    lazy var tagTotal = 19
    
    // view
    private var lSouvenir: UILabel!
    private var ivSouvenir: UIImageView!
    private var lMenses: UILabel!
    private var ivMenses: UIImageView!
    private var lShy: UILabel!
    private var ivShy: UIImageView!
    private var lSleep: UILabel!
    private var ivSleep: UIImageView!
    private var lWord: UILabel!
    private var ivWord: UIImageView!
    private var lWhisper: UILabel!
    private var ivWhisper: UIImageView!
    private var lAward: UILabel!
    private var ivAward: UIImageView!
    private var lDiary: UILabel!
    private var ivDiary: UIImageView!
    private var lDream: UILabel!
    private var ivDream: UIImageView!
    private var lAngry: UILabel!
    private var ivAngry: UIImageView!
    private var lGift: UILabel!
    private var ivGift: UIImageView!
    private var lPromise: UILabel!
    private var ivPromise: UIImageView!
    private var lTravel: UILabel!
    private var ivTravel: UIImageView!
    private var lMovie: UILabel!
    private var ivMovie: UIImageView!
    private var lFood: UILabel!
    private var ivFood: UIImageView!
    private var lAudio: UILabel!
    private var ivAudio: UIImageView!
    private var lVideo: UILabel!
    private var ivVideo: UIImageView!
    private var lAlbum: UILabel!
    private var ivAlbum: UIImageView!
    private var lTotal: UILabel!
    private var ivTotal: UIImageView!
    
    // var
    private var custom: NoteCustom?
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(NoteCustomVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "func_custom")
        
        // souvenir-line
        let lSouvenirr = ViewHelper.getLabelWhiteSmall(text: StringUtils.getString("souvenir"))
        lSouvenirr.center.x = screenWidth / 2
        lSouvenirr.frame.origin.y = 0
        let lineSouvenirLeft = ViewHelper.getViewLine(width: (maxWidth - lSouvenirr.frame.size.width) / 2 - margin, color: ColorHelper.getWhite())
        lineSouvenirLeft.frame.origin.x = margin
        lineSouvenirLeft.center.y = lSouvenirr.center.y
        let lineSouvenirRight = ViewHelper.getViewLine(width: (maxWidth - lSouvenirr.frame.size.width) / 2 - margin, color: ColorHelper.getWhite())
        lineSouvenirRight.frame.origin.x = lSouvenirr.frame.origin.x + lSouvenirr.frame.size.width + margin
        lineSouvenirRight.center.y = lSouvenirr.center.y
        let vSouvenirLine = UIView(frame: CGRect(x: 0, y: margin, width: screenWidth, height: lSouvenirr.frame.size.height))
        vSouvenirLine.addSubview(lSouvenirr)
        vSouvenirLine.addSubview(lineSouvenirLeft)
        vSouvenirLine.addSubview(lineSouvenirRight)
        
        // souvenir
        lSouvenir = ViewHelper.getLabelBold(text: StringUtils.getString("souvenir"), size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .left, mode: .byTruncatingMiddle)
        ivSouvenir = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ThemeHelper.getColorPrimary()), mode: .center)
        
        let vSouvenir = UIView(frame: CGRect(x: margin, y: vSouvenirLine.frame.origin.y + vSouvenirLine.frame.size.height + margin + marginSmall, width: cardWidth, height: CountHelper.getMax(lSouvenir.frame.size.height, ivSouvenir.frame.size.height) + paddingCard * 2))
        vSouvenir.tag = tagSouvenir
        vSouvenir.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vSouvenir, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vSouvenir, offset: ViewHelper.SHADOW_NORMAL)
        
        lSouvenir.frame.origin.x = paddingCard
        ivSouvenir.frame.origin.x = cardWidth - paddingCard - ivSouvenir.frame.size.width
        lSouvenir.center.y = vSouvenir.frame.size.height / 2
        ivSouvenir.center.y = vSouvenir.frame.size.height / 2
        vSouvenir.addSubview(lSouvenir)
        vSouvenir.addSubview(ivSouvenir)
        
        // life-line
        let lLife = ViewHelper.getLabelWhiteSmall(text: StringUtils.getString("live"))
        lLife.center.x = screenWidth / 2
        lLife.frame.origin.y = 0
        let lineLifeLeft = ViewHelper.getViewLine(width: (maxWidth - lLife.frame.size.width) / 2 - margin, color: ColorHelper.getWhite())
        lineLifeLeft.frame.origin.x = margin
        lineLifeLeft.center.y = lLife.center.y
        let lineLifeRight = ViewHelper.getViewLine(width: (maxWidth - lLife.frame.size.width) / 2 - margin, color: ColorHelper.getWhite())
        lineLifeRight.frame.origin.x = lLife.frame.origin.x + lLife.frame.size.width + margin
        lineLifeRight.center.y = lLife.center.y
        let vLifeLine = UIView(frame: CGRect(x: 0, y: vSouvenir.frame.origin.y + vSouvenir.frame.size.height + margin, width: screenWidth, height: lLife.frame.size.height))
        vLifeLine.addSubview(lLife)
        vLifeLine.addSubview(lineLifeLeft)
        vLifeLine.addSubview(lineLifeRight)
        
        // menses
        lMenses = ViewHelper.getLabelBold(text: StringUtils.getString("menses"), size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .left, mode: .byTruncatingMiddle)
        ivMenses = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ThemeHelper.getColorPrimary()), mode: .center)
        
        let vMenses = UIView(frame: CGRect(x: margin, y: vLifeLine.frame.origin.y + vLifeLine.frame.size.height + margin + marginSmall, width: cardWidth, height: CountHelper.getMax(lMenses.frame.size.height, ivMenses.frame.size.height) + paddingCard * 2))
        vMenses.tag = tagMenses
        vMenses.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vMenses, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vMenses, offset: ViewHelper.SHADOW_NORMAL)
        
        lMenses.frame.origin.x = paddingCard
        ivMenses.frame.origin.x = cardWidth - paddingCard - ivMenses.frame.size.width
        lMenses.center.y = vMenses.frame.size.height / 2
        ivMenses.center.y = vMenses.frame.size.height / 2
        vMenses.addSubview(lMenses)
        vMenses.addSubview(ivMenses)
        
        // shy
        lShy = ViewHelper.getLabelBold(text: StringUtils.getString("shy"), size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .left, mode: .byTruncatingMiddle)
        ivShy = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ThemeHelper.getColorPrimary()), mode: .center)
        
        let vShy = UIView(frame: CGRect(x: vMenses.frame.origin.x + vMenses.frame.size.width + marginSmall, y: vMenses.frame.origin.y, width: cardWidth, height: CountHelper.getMax(lShy.frame.size.height, ivShy.frame.size.height) + paddingCard * 2))
        vShy.tag = tagShy
        vShy.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vShy, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vShy, offset: ViewHelper.SHADOW_NORMAL)
        
        lShy.frame.origin.x = paddingCard
        ivShy.frame.origin.x = cardWidth - paddingCard - ivShy.frame.size.width
        lShy.center.y = vShy.frame.size.height / 2
        ivShy.center.y = vShy.frame.size.height / 2
        vShy.addSubview(lShy)
        vShy.addSubview(ivShy)
        
        // sleep
        lSleep = ViewHelper.getLabelBold(text: StringUtils.getString("sleep"), size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .left, mode: .byTruncatingMiddle)
        ivSleep = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ThemeHelper.getColorPrimary()), mode: .center)
        
        let vSleep = UIView(frame: CGRect(x: vShy.frame.origin.x + vShy.frame.size.width + marginSmall, y: vMenses.frame.origin.y, width: cardWidth, height: CountHelper.getMax(lSleep.frame.size.height, ivSleep.frame.size.height) + paddingCard * 2))
        vSleep.tag = tagSleep
        vSleep.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vSleep, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vSleep, offset: ViewHelper.SHADOW_NORMAL)
        
        lSleep.frame.origin.x = paddingCard
        ivSleep.frame.origin.x = cardWidth - paddingCard - ivSleep.frame.size.width
        lSleep.center.y = vSleep.frame.size.height / 2
        ivSleep.center.y = vSleep.frame.size.height / 2
        vSleep.addSubview(lSleep)
        vSleep.addSubview(ivSleep)
        
        // note-line
        let lNote = ViewHelper.getLabelWhiteSmall(text: StringUtils.getString("note"))
        lNote.center.x = screenWidth / 2
        lNote.frame.origin.y = 0
        let lineNoteLeft = ViewHelper.getViewLine(width: (maxWidth - lNote.frame.size.width) / 2 - margin, color: ColorHelper.getWhite())
        lineNoteLeft.frame.origin.x = margin
        lineNoteLeft.center.y = lNote.center.y
        let lineNoteRight = ViewHelper.getViewLine(width: (maxWidth - lNote.frame.size.width) / 2 - margin, color: ColorHelper.getWhite())
        lineNoteRight.frame.origin.x = lNote.frame.origin.x + lNote.frame.size.width + margin
        lineNoteRight.center.y = lNote.center.y
        let vNoteLine = UIView(frame: CGRect(x: 0, y: vSleep.frame.origin.y + vSleep.frame.size.height + margin, width: screenWidth, height: lNote.frame.size.height))
        vNoteLine.addSubview(lNote)
        vNoteLine.addSubview(lineNoteLeft)
        vNoteLine.addSubview(lineNoteRight)
        
        // word
        lWord = ViewHelper.getLabelBold(text: StringUtils.getString("word"), size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .left, mode: .byTruncatingMiddle)
        ivWord = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ThemeHelper.getColorPrimary()), mode: .center)
        
        let vWord = UIView(frame: CGRect(x: margin, y: vNoteLine.frame.origin.y + vNoteLine.frame.size.height + margin + marginSmall, width: cardWidth, height: CountHelper.getMax(lWord.frame.size.height, ivWord.frame.size.height) + paddingCard * 2))
        vWord.tag = tagWord
        vWord.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vWord, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vWord, offset: ViewHelper.SHADOW_NORMAL)
        
        lWord.frame.origin.x = paddingCard
        ivWord.frame.origin.x = cardWidth - paddingCard - ivWord.frame.size.width
        lWord.center.y = vWord.frame.size.height / 2
        ivWord.center.y = vWord.frame.size.height / 2
        vWord.addSubview(lWord)
        vWord.addSubview(ivWord)
        
        // whisper
        lWhisper = ViewHelper.getLabelBold(text: StringUtils.getString("whisper"), size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .left, mode: .byTruncatingMiddle)
        ivWhisper = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ThemeHelper.getColorPrimary()), mode: .center)
        
        let vWhisper = UIView(frame: CGRect(x: vWord.frame.origin.x + vWord.frame.size.width + marginSmall, y: vWord.frame.origin.y, width: cardWidth, height: CountHelper.getMax(lWhisper.frame.size.height, ivWhisper.frame.size.height) + paddingCard * 2))
        vWhisper.tag = tagWhisper
        vWhisper.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vWhisper, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vWhisper, offset: ViewHelper.SHADOW_NORMAL)
        
        lWhisper.frame.origin.x = paddingCard
        ivWhisper.frame.origin.x = cardWidth - paddingCard - ivWhisper.frame.size.width
        lWhisper.center.y = vWhisper.frame.size.height / 2
        ivWhisper.center.y = vWhisper.frame.size.height / 2
        vWhisper.addSubview(lWhisper)
        vWhisper.addSubview(ivWhisper)
        
        // award
        lAward = ViewHelper.getLabelBold(text: StringUtils.getString("award"), size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .left, mode: .byTruncatingMiddle)
        ivAward = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ThemeHelper.getColorPrimary()), mode: .center)
        
        let vAward = UIView(frame: CGRect(x: vWhisper.frame.origin.x + vWhisper.frame.size.width + marginSmall, y: vWord.frame.origin.y, width: cardWidth, height: CountHelper.getMax(lAward.frame.size.height, ivAward.frame.size.height) + paddingCard * 2))
        vAward.tag = tagAward
        vAward.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vAward, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vAward, offset: ViewHelper.SHADOW_NORMAL)
        
        lAward.frame.origin.x = paddingCard
        ivAward.frame.origin.x = cardWidth - paddingCard - ivAward.frame.size.width
        lAward.center.y = vAward.frame.size.height / 2
        ivAward.center.y = vAward.frame.size.height / 2
        vAward.addSubview(lAward)
        vAward.addSubview(ivAward)
        
        // diary
        lDiary = ViewHelper.getLabelBold(text: StringUtils.getString("diary"), size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .left, mode: .byTruncatingMiddle)
        ivDiary = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ThemeHelper.getColorPrimary()), mode: .center)
        
        let vDiary = UIView(frame: CGRect(x: vAward.frame.origin.x + vAward.frame.size.width + marginSmall, y: vWord.frame.origin.y, width: cardWidth, height: CountHelper.getMax(lDiary.frame.size.height, ivDiary.frame.size.height) + paddingCard * 2))
        vDiary.tag = tagDiary
        vDiary.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vDiary, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vDiary, offset: ViewHelper.SHADOW_NORMAL)
        
        lDiary.frame.origin.x = paddingCard
        ivDiary.frame.origin.x = cardWidth - paddingCard - ivDiary.frame.size.width
        lDiary.center.y = vDiary.frame.size.height / 2
        ivDiary.center.y = vDiary.frame.size.height / 2
        vDiary.addSubview(lDiary)
        vDiary.addSubview(ivDiary)
        
        // dream
        lDream = ViewHelper.getLabelBold(text: StringUtils.getString("dream"), size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .left, mode: .byTruncatingMiddle)
        ivDream = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ThemeHelper.getColorPrimary()), mode: .center)
        
        let vDream = UIView(frame: CGRect(x: margin, y: vWord.frame.origin.y + vWord.frame.size.height + marginSmall, width: cardWidth, height: CountHelper.getMax(lDream.frame.size.height, ivDream.frame.size.height) + paddingCard * 2))
        vDream.tag = tagDream
        vDream.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vDream, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vDream, offset: ViewHelper.SHADOW_NORMAL)
        
        lDream.frame.origin.x = paddingCard
        ivDream.frame.origin.x = cardWidth - paddingCard - ivDream.frame.size.width
        lDream.center.y = vDream.frame.size.height / 2
        ivDream.center.y = vDream.frame.size.height / 2
        vDream.addSubview(lDream)
        vDream.addSubview(ivDream)
        
        // angry
        lAngry = ViewHelper.getLabelBold(text: StringUtils.getString("angry"), size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .left, mode: .byTruncatingMiddle)
        ivAngry = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ThemeHelper.getColorPrimary()), mode: .center)
        
        let vAngry = UIView(frame: CGRect(x: vDream.frame.origin.x + vDream.frame.size.width + marginSmall, y: vDream.frame.origin.y, width: cardWidth, height: CountHelper.getMax(lAngry.frame.size.height, ivAngry.frame.size.height) + paddingCard * 2))
        vAngry.tag = tagAngry
        vAngry.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vAngry, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vAngry, offset: ViewHelper.SHADOW_NORMAL)
        
        lAngry.frame.origin.x = paddingCard
        ivAngry.frame.origin.x = cardWidth - paddingCard - ivAngry.frame.size.width
        lAngry.center.y = vAngry.frame.size.height / 2
        ivAngry.center.y = vAngry.frame.size.height / 2
        vAngry.addSubview(lAngry)
        vAngry.addSubview(ivAngry)
        
        // gift
        lGift = ViewHelper.getLabelBold(text: StringUtils.getString("gift"), size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .left, mode: .byTruncatingMiddle)
        ivGift = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ThemeHelper.getColorPrimary()), mode: .center)
        
        let vGift = UIView(frame: CGRect(x: vAngry.frame.origin.x + vAngry.frame.size.width + marginSmall, y: vDream.frame.origin.y, width: cardWidth, height: CountHelper.getMax(lGift.frame.size.height, ivGift.frame.size.height) + paddingCard * 2))
        vGift.tag = tagGift
        vGift.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vGift, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vGift, offset: ViewHelper.SHADOW_NORMAL)
        
        lGift.frame.origin.x = paddingCard
        ivGift.frame.origin.x = cardWidth - paddingCard - ivGift.frame.size.width
        lGift.center.y = vGift.frame.size.height / 2
        ivGift.center.y = vGift.frame.size.height / 2
        vGift.addSubview(lGift)
        vGift.addSubview(ivGift)
        
        // promise
        lPromise = ViewHelper.getLabelBold(text: StringUtils.getString("promise"), size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .left, mode: .byTruncatingMiddle)
        ivPromise = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ThemeHelper.getColorPrimary()), mode: .center)
        
        let vPromise = UIView(frame: CGRect(x: vGift.frame.origin.x + vGift.frame.size.width + marginSmall, y: vDream.frame.origin.y, width: cardWidth, height: CountHelper.getMax(lPromise.frame.size.height, ivPromise.frame.size.height) + paddingCard * 2))
        vPromise.tag = tagPromise
        vPromise.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vPromise, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vPromise, offset: ViewHelper.SHADOW_NORMAL)
        
        lPromise.frame.origin.x = paddingCard
        ivPromise.frame.origin.x = cardWidth - paddingCard - ivPromise.frame.size.width
        lPromise.center.y = vPromise.frame.size.height / 2
        ivPromise.center.y = vPromise.frame.size.height / 2
        vPromise.addSubview(lPromise)
        vPromise.addSubview(ivPromise)
        
        // travel
        lTravel = ViewHelper.getLabelBold(text: StringUtils.getString("travel"), size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .left, mode: .byTruncatingMiddle)
        ivTravel = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ThemeHelper.getColorPrimary()), mode: .center)
        
        let vTravel = UIView(frame: CGRect(x: margin, y: vDream.frame.origin.y + vDream.frame.size.height + marginSmall, width: cardWidth, height: CountHelper.getMax(lTravel.frame.size.height, ivTravel.frame.size.height) + paddingCard * 2))
        vTravel.tag = tagTravel
        vTravel.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vTravel, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vTravel, offset: ViewHelper.SHADOW_NORMAL)
        
        lTravel.frame.origin.x = paddingCard
        ivTravel.frame.origin.x = cardWidth - paddingCard - ivTravel.frame.size.width
        lTravel.center.y = vTravel.frame.size.height / 2
        ivTravel.center.y = vTravel.frame.size.height / 2
        vTravel.addSubview(lTravel)
        vTravel.addSubview(ivTravel)
        
        // movie
        lMovie = ViewHelper.getLabelBold(text: StringUtils.getString("movie"), size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .left, mode: .byTruncatingMiddle)
        ivMovie = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ThemeHelper.getColorPrimary()), mode: .center)
        
        let vMovie = UIView(frame: CGRect(x: vTravel.frame.origin.x + vTravel.frame.size.width + marginSmall, y: vTravel.frame.origin.y, width: cardWidth, height: CountHelper.getMax(lMovie.frame.size.height, ivMovie.frame.size.height) + paddingCard * 2))
        vMovie.tag = tagMovie
        vMovie.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vMovie, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vMovie, offset: ViewHelper.SHADOW_NORMAL)
        
        lMovie.frame.origin.x = paddingCard
        ivMovie.frame.origin.x = cardWidth - paddingCard - ivMovie.frame.size.width
        lMovie.center.y = vMovie.frame.size.height / 2
        ivMovie.center.y = vMovie.frame.size.height / 2
        vMovie.addSubview(lMovie)
        vMovie.addSubview(ivMovie)
        
        // food
        lFood = ViewHelper.getLabelBold(text: StringUtils.getString("food"), size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .left, mode: .byTruncatingMiddle)
        ivFood = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ThemeHelper.getColorPrimary()), mode: .center)
        
        let vFood = UIView(frame: CGRect(x: vMovie.frame.origin.x + vMovie.frame.size.width + marginSmall, y: vTravel.frame.origin.y, width: cardWidth, height: CountHelper.getMax(lFood.frame.size.height, ivFood.frame.size.height) + paddingCard * 2))
        vFood.tag = tagFood
        vFood.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vFood, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vFood, offset: ViewHelper.SHADOW_NORMAL)
        
        lFood.frame.origin.x = paddingCard
        ivFood.frame.origin.x = cardWidth - paddingCard - ivFood.frame.size.width
        lFood.center.y = vFood.frame.size.height / 2
        ivFood.center.y = vFood.frame.size.height / 2
        vFood.addSubview(lFood)
        vFood.addSubview(ivFood)
        
        // media-line
        let lMedia = ViewHelper.getLabelWhiteSmall(text: StringUtils.getString("media"))
        lMedia.center.x = screenWidth / 2
        lMedia.frame.origin.y = 0
        let lineMediaLeft = ViewHelper.getViewLine(width: (maxWidth - lMedia.frame.size.width) / 2 - margin, color: ColorHelper.getWhite())
        lineMediaLeft.frame.origin.x = margin
        lineMediaLeft.center.y = lMedia.center.y
        let lineMediaRight = ViewHelper.getViewLine(width: (maxWidth - lMedia.frame.size.width) / 2 - margin, color: ColorHelper.getWhite())
        lineMediaRight.frame.origin.x = lMedia.frame.origin.x + lMedia.frame.size.width + margin
        lineMediaRight.center.y = lMedia.center.y
        let vMediaLine = UIView(frame: CGRect(x: 0, y: vTravel.frame.origin.y + vTravel.frame.size.height + margin, width: screenWidth, height: lMedia.frame.size.height))
        vMediaLine.addSubview(lMedia)
        vMediaLine.addSubview(lineMediaLeft)
        vMediaLine.addSubview(lineMediaRight)
        
        // audio
        lAudio = ViewHelper.getLabelBold(text: StringUtils.getString("audio"), size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .left, mode: .byTruncatingMiddle)
        ivAudio = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ThemeHelper.getColorPrimary()), mode: .center)
        
        let vAudio = UIView(frame: CGRect(x: margin, y: vMediaLine.frame.origin.y + vMediaLine.frame.size.height + margin + marginSmall, width: cardWidth, height: CountHelper.getMax(lAudio.frame.size.height, ivAudio.frame.size.height) + paddingCard * 2))
        vAudio.tag = tagAudio
        vAudio.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vAudio, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vAudio, offset: ViewHelper.SHADOW_NORMAL)
        
        lAudio.frame.origin.x = paddingCard
        ivAudio.frame.origin.x = cardWidth - paddingCard - ivAudio.frame.size.width
        lAudio.center.y = vAudio.frame.size.height / 2
        ivAudio.center.y = vAudio.frame.size.height / 2
        vAudio.addSubview(lAudio)
        vAudio.addSubview(ivAudio)
        
        // video
        lVideo = ViewHelper.getLabelBold(text: StringUtils.getString("video"), size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .left, mode: .byTruncatingMiddle)
        ivVideo = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ThemeHelper.getColorPrimary()), mode: .center)
        
        let vVideo = UIView(frame: CGRect(x: vAudio.frame.origin.x + vAudio.frame.size.width + marginSmall, y: vAudio.frame.origin.y, width: cardWidth, height: CountHelper.getMax(lVideo.frame.size.height, ivVideo.frame.size.height) + paddingCard * 2))
        vVideo.tag = tagVideo
        vVideo.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vVideo, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vVideo, offset: ViewHelper.SHADOW_NORMAL)
        
        lVideo.frame.origin.x = paddingCard
        ivVideo.frame.origin.x = cardWidth - paddingCard - ivVideo.frame.size.width
        lVideo.center.y = vVideo.frame.size.height / 2
        ivVideo.center.y = vVideo.frame.size.height / 2
        vVideo.addSubview(lVideo)
        vVideo.addSubview(ivVideo)
        
        // album
        lAlbum = ViewHelper.getLabelBold(text: StringUtils.getString("album"), size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .left, mode: .byTruncatingMiddle)
        ivAlbum = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ThemeHelper.getColorPrimary()), mode: .center)
        
        let vAlbum = UIView(frame: CGRect(x: vVideo.frame.origin.x + vVideo.frame.size.width + marginSmall, y: vAudio.frame.origin.y, width: cardWidth, height: CountHelper.getMax(lAlbum.frame.size.height, ivAlbum.frame.size.height) + paddingCard * 2))
        vAlbum.tag = tagAlbum
        vAlbum.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vAlbum, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vAlbum, offset: ViewHelper.SHADOW_NORMAL)
        
        lAlbum.frame.origin.x = paddingCard
        ivAlbum.frame.origin.x = cardWidth - paddingCard - ivAlbum.frame.size.width
        lAlbum.center.y = vAlbum.frame.size.height / 2
        ivAlbum.center.y = vAlbum.frame.size.height / 2
        vAlbum.addSubview(lAlbum)
        vAlbum.addSubview(ivAlbum)
        
        // other-line
        let lOther = ViewHelper.getLabelWhiteSmall(text: StringUtils.getString("other"))
        lOther.center.x = screenWidth / 2
        lOther.frame.origin.y = 0
        let lineOtherLeft = ViewHelper.getViewLine(width: (maxWidth - lOther.frame.size.width) / 2 - margin, color: ColorHelper.getWhite())
        lineOtherLeft.frame.origin.x = margin
        lineOtherLeft.center.y = lOther.center.y
        let lineOtherRight = ViewHelper.getViewLine(width: (maxWidth - lOther.frame.size.width) / 2 - margin, color: ColorHelper.getWhite())
        lineOtherRight.frame.origin.x = lOther.frame.origin.x + lOther.frame.size.width + margin
        lineOtherRight.center.y = lOther.center.y
        let vOtherLine = UIView(frame: CGRect(x: 0, y: vAudio.frame.origin.y + vAudio.frame.size.height + margin, width: screenWidth, height: lOther.frame.size.height))
        vOtherLine.addSubview(lOther)
        vOtherLine.addSubview(lineOtherLeft)
        vOtherLine.addSubview(lineOtherRight)
        
        // total
        lTotal = ViewHelper.getLabelBold(text: StringUtils.getString("statistics"), size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .left, mode: .byTruncatingMiddle)
        ivTotal = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ThemeHelper.getColorPrimary()), mode: .center)
        
        let vTotal = UIView(frame: CGRect(x: margin, y: vOtherLine.frame.origin.y + vOtherLine.frame.size.height + margin + marginSmall, width: cardWidth, height: CountHelper.getMax(lTotal.frame.size.height, ivTotal.frame.size.height) + paddingCard * 2))
        vTotal.tag = tagTotal
        vTotal.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vTotal, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vTotal, offset: ViewHelper.SHADOW_NORMAL)
        
        lTotal.frame.origin.x = paddingCard
        ivTotal.frame.origin.x = cardWidth - paddingCard - ivTotal.frame.size.width
        lTotal.center.y = vTotal.frame.size.height / 2
        ivTotal.center.y = vTotal.frame.size.height / 2
        vTotal.addSubview(lTotal)
        vTotal.addSubview(ivTotal)
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = vTotal.frame.origin.y + vTotal.frame.size.height + margin
        let scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        scroll.addSubview(vSouvenirLine)
        scroll.addSubview(vSouvenir)
        scroll.addSubview(vLifeLine)
        scroll.addSubview(vMenses)
        scroll.addSubview(vShy)
        scroll.addSubview(vSleep)
        scroll.addSubview(vNoteLine)
        scroll.addSubview(vWord)
        scroll.addSubview(vWhisper)
        scroll.addSubview(vAward)
        scroll.addSubview(vDiary)
        scroll.addSubview(vDream)
        scroll.addSubview(vAngry)
        scroll.addSubview(vGift)
        scroll.addSubview(vPromise)
        scroll.addSubview(vTravel)
        scroll.addSubview(vMovie)
        scroll.addSubview(vFood)
        scroll.addSubview(vMediaLine)
        scroll.addSubview(vAudio)
        scroll.addSubview(vVideo)
        scroll.addSubview(vAlbum)
        scroll.addSubview(vOtherLine)
        scroll.addSubview(vTotal)
        
        // view
        let gradient = ViewHelper.getGradientPrimaryTrans(frame: self.view.bounds)
        self.view.layer.insertSublayer(gradient, at: 0)
        self.view.addSubview(scroll)
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vSouvenir, action: #selector(targetClick))
        ViewUtils.addViewTapTarget(target: self, view: vMenses, action: #selector(targetClick))
        ViewUtils.addViewTapTarget(target: self, view: vShy, action: #selector(targetClick))
        ViewUtils.addViewTapTarget(target: self, view: vSleep, action: #selector(targetClick))
        ViewUtils.addViewTapTarget(target: self, view: vWord, action: #selector(targetClick))
        ViewUtils.addViewTapTarget(target: self, view: vWhisper, action: #selector(targetClick))
        ViewUtils.addViewTapTarget(target: self, view: vAward, action: #selector(targetClick))
        ViewUtils.addViewTapTarget(target: self, view: vDiary, action: #selector(targetClick))
        ViewUtils.addViewTapTarget(target: self, view: vDream, action: #selector(targetClick))
        ViewUtils.addViewTapTarget(target: self, view: vAngry, action: #selector(targetClick))
        ViewUtils.addViewTapTarget(target: self, view: vGift, action: #selector(targetClick))
        ViewUtils.addViewTapTarget(target: self, view: vPromise, action: #selector(targetClick))
        ViewUtils.addViewTapTarget(target: self, view: vTravel, action: #selector(targetClick))
        ViewUtils.addViewTapTarget(target: self, view: vMovie, action: #selector(targetClick))
        ViewUtils.addViewTapTarget(target: self, view: vFood, action: #selector(targetClick))
        ViewUtils.addViewTapTarget(target: self, view: vAudio, action: #selector(targetClick))
        ViewUtils.addViewTapTarget(target: self, view: vVideo, action: #selector(targetClick))
        ViewUtils.addViewTapTarget(target: self, view: vAlbum, action: #selector(targetClick))
        ViewUtils.addViewTapTarget(target: self, view: vTotal, action: #selector(targetClick))
    }
    
    override func initData() {
        // init
        custom = UDHelper.getNoteCustom()
        updateView()
    }
    
    @objc func targetClick(sender: UIGestureRecognizer) {
        let tag = sender.view?.tag ?? 0
        switch tag {
        case tagSouvenir:
            custom?.souvenir = !(custom?.souvenir ?? false)
            break
        case tagMenses:
            custom?.menses = !(custom?.menses ?? false)
            break
        case tagShy:
            custom?.shy = !(custom?.shy ?? false)
            break
        case tagSleep:
            custom?.sleep = !(custom?.sleep ?? false)
            break
        case tagWord:
            custom?.word = !(custom?.word ?? false)
            break
        case tagWhisper:
            custom?.whisper = !(custom?.whisper ?? false)
            break
        case tagAward:
            custom?.award = !(custom?.award ?? false)
            break
        case tagDiary:
            custom?.diary = !(custom?.diary ?? false)
            break
        case tagDream:
            custom?.dream = !(custom?.dream ?? false)
            break
        case tagAngry:
            custom?.angry = !(custom?.angry ?? false)
            break
        case tagGift:
            custom?.gift = !(custom?.gift ?? false)
            break
        case tagPromise:
            custom?.promise = !(custom?.promise ?? false)
            break
        case tagTravel:
            custom?.travel = !(custom?.travel ?? false)
            break
        case tagMovie:
            custom?.movie = !(custom?.movie ?? false)
            break
        case tagFood:
            custom?.food = !(custom?.food ?? false)
            break
        case tagAudio:
            custom?.audio = !(custom?.audio ?? false)
            break
        case tagVideo:
            custom?.video = !(custom?.video ?? false)
            break
        case tagAlbum:
            custom?.album = !(custom?.album ?? false)
            break
        case tagTotal:
            custom?.total = !(custom?.total ?? false)
            break
        default:
            break
        }
        UDHelper.setNoteCustom(custom)
        updateView()
        // notify
        NotifyHelper.post(NotifyHelper.TAG_CUSTOM_REFRESH, obj: custom)
    }
    
    func updateView() {
        // laebl
        lSouvenir.textColor = (custom?.souvenir ?? true) ? ThemeHelper.getColorPrimary() : ColorHelper.getFontGrey()
        lMenses.textColor = (custom?.menses ?? true) ? ThemeHelper.getColorPrimary() : ColorHelper.getFontGrey()
        lShy.textColor = (custom?.shy ?? true) ? ThemeHelper.getColorPrimary() : ColorHelper.getFontGrey()
        lSleep.textColor = (custom?.sleep ?? true) ? ThemeHelper.getColorPrimary() : ColorHelper.getFontGrey()
        lWord.textColor = (custom?.word ?? true) ? ThemeHelper.getColorPrimary() : ColorHelper.getFontGrey()
        lWhisper.textColor = (custom?.whisper ?? true) ? ThemeHelper.getColorPrimary() : ColorHelper.getFontGrey()
        lAward.textColor = (custom?.award ?? true) ? ThemeHelper.getColorPrimary() : ColorHelper.getFontGrey()
        lDiary.textColor = (custom?.diary ?? true) ? ThemeHelper.getColorPrimary() : ColorHelper.getFontGrey()
        lDream.textColor = (custom?.dream ?? true) ? ThemeHelper.getColorPrimary() : ColorHelper.getFontGrey()
        lAngry.textColor = (custom?.angry ?? true) ? ThemeHelper.getColorPrimary() : ColorHelper.getFontGrey()
        lGift.textColor = (custom?.gift ?? true) ? ThemeHelper.getColorPrimary() : ColorHelper.getFontGrey()
        lPromise.textColor = (custom?.promise ?? true) ? ThemeHelper.getColorPrimary() : ColorHelper.getFontGrey()
        lTravel.textColor = (custom?.travel ?? true) ? ThemeHelper.getColorPrimary() : ColorHelper.getFontGrey()
        lMovie.textColor = (custom?.movie ?? true) ? ThemeHelper.getColorPrimary() : ColorHelper.getFontGrey()
        lFood.textColor = (custom?.food ?? true) ? ThemeHelper.getColorPrimary() : ColorHelper.getFontGrey()
        lAudio.textColor = (custom?.audio ?? true) ? ThemeHelper.getColorPrimary() : ColorHelper.getFontGrey()
        lVideo.textColor = (custom?.video ?? true) ? ThemeHelper.getColorPrimary() : ColorHelper.getFontGrey()
        lAlbum.textColor = (custom?.album ?? true) ? ThemeHelper.getColorPrimary() : ColorHelper.getFontGrey()
        lTotal.textColor = (custom?.total ?? true) ? ThemeHelper.getColorPrimary() : ColorHelper.getFontGrey()
        // image
        let imgYes = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ThemeHelper.getColorPrimary())
        let imgNo = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_brightness_1_grey_24dp"), color: ColorHelper.getFontGrey())
        ivSouvenir.image = (custom?.souvenir ?? true) ? imgYes : imgNo
        ivMenses.image = (custom?.menses ?? true) ? imgYes : imgNo
        ivShy.image = (custom?.shy ?? true) ? imgYes : imgNo
        ivSleep.image = (custom?.sleep ?? true) ? imgYes : imgNo
        ivWord.image = (custom?.word ?? true) ? imgYes : imgNo
        ivWhisper.image = (custom?.whisper ?? true) ? imgYes : imgNo
        ivAward.image = (custom?.award ?? true) ? imgYes : imgNo
        ivDiary.image = (custom?.diary ?? true) ? imgYes : imgNo
        ivDream.image = (custom?.dream ?? true) ? imgYes : imgNo
        ivAngry.image = (custom?.angry ?? true) ? imgYes : imgNo
        ivGift.image = (custom?.gift ?? true) ? imgYes : imgNo
        ivPromise.image = (custom?.promise ?? true) ? imgYes : imgNo
        ivTravel.image = (custom?.travel ?? true) ? imgYes : imgNo
        ivMovie.image = (custom?.movie ?? true) ? imgYes : imgNo
        ivFood.image = (custom?.food ?? true) ? imgYes : imgNo
        ivAudio.image = (custom?.audio ?? true) ? imgYes : imgNo
        ivVideo.image = (custom?.video ?? true) ? imgYes : imgNo
        ivAlbum.image = (custom?.album ?? true) ? imgYes : imgNo
        ivTotal.image = (custom?.total ?? true) ? imgYes : imgNo
    }
    
}
