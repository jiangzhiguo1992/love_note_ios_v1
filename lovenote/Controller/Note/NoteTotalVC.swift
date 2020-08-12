//
//  NoteTotalVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/2/23.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteTotalVC: BaseVC {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var iconInnerPadding = ScreenUtils.heightFit(5)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    lazy var cardWidth = (maxWidth - margin) / 2
    lazy var tagSouvenir = 1
    lazy var tagTravel = 2
    lazy var tagWord = 3
    lazy var tagAward = 4
    lazy var tagDiary = 5
    lazy var tagDream = 6
    lazy var tagMovie = 7
    lazy var tagFood = 8
    lazy var tagPromise = 9
    lazy var tagGift = 10
    lazy var tagAngry = 11
    lazy var tagAudio = 12
    lazy var tagVideo = 13
    lazy var tagPicture = 14
    
    // view
    private var lShow: UILabel!
    private var vTotal: UIView!
    private var lSouvenirTotal: UILabel!
    private var lTravelTotal: UILabel!
    private var lWordTotal: UILabel!
    private var lAwardTotal: UILabel!
    private var lDiaryTotal: UILabel!
    private var lDreamTotal: UILabel!
    private var lMovieTotal: UILabel!
    private var lFoodTotal: UILabel!
    private var lPromiseTotal: UILabel!
    private var lGiftTotal: UILabel!
    private var lAngryTotal: UILabel!
    private var lAudioTotal: UILabel!
    private var lVideoTotal: UILabel!
    private var lPictureTotal: UILabel!
    
    public static func pushVC() {
        if !UDHelper.getVipLimit().noteTotalEnable {
            MoreVipVC.pushVC()
            return
        }
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(NoteTotalVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "statistics")
        
        // show
        lShow = ViewHelper.getLabelWhiteNormal(width: screenWidth, height: ScreenUtils.heightFit(200), text: "-", align: .center)
        lShow.frame.origin = CGPoint(x: margin, y: margin * 2)
        
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
        let vNoteLine = UIView(frame: CGRect(x: 0, y: margin, width: screenWidth, height: lNote.frame.size.height))
        vNoteLine.addSubview(lNote)
        vNoteLine.addSubview(lineNoteLeft)
        vNoteLine.addSubview(lineNoteRight)
        
        // souvenir
        let ivSouvenir = ViewHelper.getImageView(img: UIImage(named: "ic_note_souvenir_24dp"), mode: .center)
        let lSouvenir = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("souvenir"), lines: 1, align: .center)
        let souvenirWidth = cardWidth - CountHelper.getMax(lSouvenir.frame.size.width, ivSouvenir.frame.size.width) - margin * 3
        lSouvenirTotal = ViewHelper.getLabelBold(width: souvenirWidth, text: "-", size: ScreenUtils.fontFit(40), color: ThemeHelper.getColorPrimary(), lines: 1, align: .right, mode: .byTruncatingMiddle)
        
        let souvenirHeight = CountHelper.getMax(lSouvenir.frame.size.height + ivSouvenir.frame.size.height + iconInnerPadding + margin * 2, lSouvenirTotal.frame.size.height)
        let souvenirLeftCenterX = CountHelper.getMax(lSouvenir.frame.size.width, ivSouvenir.frame.size.width) / 2 + margin
        ivSouvenir.center.x = souvenirLeftCenterX
        lSouvenir.center.x = souvenirLeftCenterX
        lSouvenirTotal.frame.origin.x = CountHelper.getMax(lSouvenir.frame.origin.x + lSouvenir.frame.size.width, ivSouvenir.frame.origin.x + ivSouvenir.frame.size.width) + margin
        ivSouvenir.frame.origin.y  = margin
        lSouvenir.frame.origin.y  = ivSouvenir.frame.origin.y + ivSouvenir.frame.size.height + iconInnerPadding
        lSouvenirTotal.center.y  = souvenirHeight / 2
        
        let vSouvenir = UIView(frame: CGRect(x: margin, y: vNoteLine.frame.origin.y + vNoteLine.frame.size.height + ScreenUtils.heightFit(15), width: cardWidth, height: souvenirHeight))
        vSouvenir.tag = tagSouvenir
        vSouvenir.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vSouvenir, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vSouvenir, offset: ViewHelper.SHADOW_NORMAL)
        vSouvenir.addSubview(ivSouvenir)
        vSouvenir.addSubview(lSouvenir)
        vSouvenir.addSubview(lSouvenirTotal)
        
        // travel
        let ivTravel = ViewHelper.getImageView(img: UIImage(named: "ic_note_travel_24dp"), mode: .center)
        let lTravel = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("travel"), lines: 1, align: .center)
        let travelWidth = cardWidth - CountHelper.getMax(lTravel.frame.size.width, ivTravel.frame.size.width) - margin * 3
        lTravelTotal = ViewHelper.getLabelBold(width: travelWidth, text: "-", size: ScreenUtils.fontFit(40), color: ThemeHelper.getColorPrimary(), lines: 1, align: .right, mode: .byTruncatingMiddle)
        
        let travelHeight = CountHelper.getMax(lTravel.frame.size.height + ivTravel.frame.size.height + iconInnerPadding + margin * 2, lTravelTotal.frame.size.height)
        let travelLeftCenterX = CountHelper.getMax(lTravel.frame.size.width, ivTravel.frame.size.width) / 2 + margin
        ivTravel.center.x = travelLeftCenterX
        lTravel.center.x = travelLeftCenterX
        lTravelTotal.frame.origin.x = CountHelper.getMax(lTravel.frame.origin.x + lTravel.frame.size.width, ivTravel.frame.origin.x + ivTravel.frame.size.width) + margin
        ivTravel.frame.origin.y  = margin
        lTravel.frame.origin.y  = ivTravel.frame.origin.y + ivTravel.frame.size.height + iconInnerPadding
        lTravelTotal.center.y  = travelHeight / 2
        
        let vTravel = UIView(frame: CGRect(x: vSouvenir.frame.origin.x + vSouvenir.frame.size.width + margin, y: vSouvenir.frame.origin.y, width: cardWidth, height: travelHeight))
        vTravel.tag = tagTravel
        vTravel.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vTravel, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vTravel, offset: ViewHelper.SHADOW_NORMAL)
        vTravel.addSubview(ivTravel)
        vTravel.addSubview(lTravel)
        vTravel.addSubview(lTravelTotal)
        
        // word
        let ivWord = ViewHelper.getImageView(img: UIImage(named: "ic_note_word_24dp"), mode: .center)
        let lWord = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("word"), lines: 1, align: .center)
        let wordWidth = cardWidth - CountHelper.getMax(lWord.frame.size.width, ivWord.frame.size.width) - margin * 3
        lWordTotal = ViewHelper.getLabelBold(width: wordWidth, text: "-", size: ScreenUtils.fontFit(40), color: ThemeHelper.getColorPrimary(), lines: 1, align: .right, mode: .byTruncatingMiddle)
        
        let wordHeight = CountHelper.getMax(lWord.frame.size.height + ivWord.frame.size.height + iconInnerPadding + margin * 2, lWordTotal.frame.size.height)
        let wordLeftCenterX = CountHelper.getMax(lWord.frame.size.width, ivWord.frame.size.width) / 2 + margin
        ivWord.center.x = wordLeftCenterX
        lWord.center.x = wordLeftCenterX
        lWordTotal.frame.origin.x = CountHelper.getMax(lWord.frame.origin.x + lWord.frame.size.width, ivWord.frame.origin.x + ivWord.frame.size.width) + margin
        ivWord.frame.origin.y  = margin
        lWord.frame.origin.y  = ivWord.frame.origin.y + ivWord.frame.size.height + iconInnerPadding
        lWordTotal.center.y  = wordHeight / 2
        
        let vWord = UIView(frame: CGRect(x: margin, y: vTravel.frame.origin.y + vTravel.frame.size.height + margin, width: cardWidth, height: wordHeight))
        vWord.tag = tagWord
        vWord.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vWord, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vWord, offset: ViewHelper.SHADOW_NORMAL)
        vWord.addSubview(ivWord)
        vWord.addSubview(lWord)
        vWord.addSubview(lWordTotal)
        
        // award
        let ivAward = ViewHelper.getImageView(img: UIImage(named: "ic_note_award_24dp"), mode: .center)
        let lAward = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("award"), lines: 1, align: .center)
        let awardWidth = cardWidth - CountHelper.getMax(lAward.frame.size.width, ivAward.frame.size.width) - margin * 3
        lAwardTotal = ViewHelper.getLabelBold(width: awardWidth, text: "-", size: ScreenUtils.fontFit(40), color: ThemeHelper.getColorPrimary(), lines: 1, align: .right, mode: .byTruncatingMiddle)
        
        let awardHeight = CountHelper.getMax(lAward.frame.size.height + ivAward.frame.size.height + iconInnerPadding + margin * 2, lAwardTotal.frame.size.height)
        let awardLeftCenterX = CountHelper.getMax(lAward.frame.size.width, ivAward.frame.size.width) / 2 + margin
        ivAward.center.x = awardLeftCenterX
        lAward.center.x = awardLeftCenterX
        lAwardTotal.frame.origin.x = CountHelper.getMax(lAward.frame.origin.x + lAward.frame.size.width, ivAward.frame.origin.x + ivAward.frame.size.width) + margin
        ivAward.frame.origin.y  = margin
        lAward.frame.origin.y  = ivAward.frame.origin.y + ivAward.frame.size.height + iconInnerPadding
        lAwardTotal.center.y  = awardHeight / 2
        
        let vAward = UIView(frame: CGRect(x: vWord.frame.origin.x + vWord.frame.size.width + margin, y: vWord.frame.origin.y, width: cardWidth, height: awardHeight))
        vAward.tag = tagAward
        vAward.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vAward, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vAward, offset: ViewHelper.SHADOW_NORMAL)
        vAward.addSubview(ivAward)
        vAward.addSubview(lAward)
        vAward.addSubview(lAwardTotal)
        
        // diary
        let ivDiary = ViewHelper.getImageView(img: UIImage(named: "ic_note_diary_24dp"), mode: .center)
        let lDiary = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("diary"), lines: 1, align: .center)
        let diaryWidth = cardWidth - CountHelper.getMax(lDiary.frame.size.width, ivDiary.frame.size.width) - margin * 3
        lDiaryTotal = ViewHelper.getLabelBold(width: diaryWidth, text: "-", size: ScreenUtils.fontFit(40), color: ThemeHelper.getColorPrimary(), lines: 1, align: .right, mode: .byTruncatingMiddle)
        
        let diaryHeight = CountHelper.getMax(lDiary.frame.size.height + ivDiary.frame.size.height + iconInnerPadding + margin * 2, lDiaryTotal.frame.size.height)
        let diaryLeftCenterX = CountHelper.getMax(lDiary.frame.size.width, ivDiary.frame.size.width) / 2 + margin
        ivDiary.center.x = diaryLeftCenterX
        lDiary.center.x = diaryLeftCenterX
        lDiaryTotal.frame.origin.x = CountHelper.getMax(lDiary.frame.origin.x + lDiary.frame.size.width, ivDiary.frame.origin.x + ivDiary.frame.size.width) + margin
        ivDiary.frame.origin.y  = margin
        lDiary.frame.origin.y  = ivDiary.frame.origin.y + ivDiary.frame.size.height + iconInnerPadding
        lDiaryTotal.center.y  = diaryHeight / 2
        
        let vDiary = UIView(frame: CGRect(x: margin, y: vWord.frame.origin.y + vWord.frame.size.height + margin, width: cardWidth, height: diaryHeight))
        vDiary.tag = tagDiary
        vDiary.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vDiary, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vDiary, offset: ViewHelper.SHADOW_NORMAL)
        vDiary.addSubview(ivDiary)
        vDiary.addSubview(lDiary)
        vDiary.addSubview(lDiaryTotal)
        
        // dream
        let ivDream = ViewHelper.getImageView(img: UIImage(named: "ic_note_dream_24dp"), mode: .center)
        let lDream = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("dream"), lines: 1, align: .center)
        let dreamWidth = cardWidth - CountHelper.getMax(lDream.frame.size.width, ivDream.frame.size.width) - margin * 3
        lDreamTotal = ViewHelper.getLabelBold(width: dreamWidth, text: "-", size: ScreenUtils.fontFit(40), color: ThemeHelper.getColorPrimary(), lines: 1, align: .right, mode: .byTruncatingMiddle)
        
        let dreamHeight = CountHelper.getMax(lDream.frame.size.height + ivDream.frame.size.height + iconInnerPadding + margin * 2, lDreamTotal.frame.size.height)
        let dreamLeftCenterX = CountHelper.getMax(lDream.frame.size.width, ivDream.frame.size.width) / 2 + margin
        ivDream.center.x = dreamLeftCenterX
        lDream.center.x = dreamLeftCenterX
        lDreamTotal.frame.origin.x = CountHelper.getMax(lDream.frame.origin.x + lDream.frame.size.width, ivDream.frame.origin.x + ivDream.frame.size.width) + margin
        ivDream.frame.origin.y  = margin
        lDream.frame.origin.y  = ivDream.frame.origin.y + ivDream.frame.size.height + iconInnerPadding
        lDreamTotal.center.y  = dreamHeight / 2
        
        let vDream = UIView(frame: CGRect(x: vDiary.frame.origin.x + vDiary.frame.size.width + margin, y: vDiary.frame.origin.y, width: cardWidth, height: dreamHeight))
        vDream.tag = tagDream
        vDream.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vDream, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vDream, offset: ViewHelper.SHADOW_NORMAL)
        vDream.addSubview(ivDream)
        vDream.addSubview(lDream)
        vDream.addSubview(lDreamTotal)
        
        // movie
        let ivMovie = ViewHelper.getImageView(img: UIImage(named: "ic_note_movie_24dp"), mode: .center)
        let lMovie = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("movie"), lines: 1, align: .center)
        let movieWidth = cardWidth - CountHelper.getMax(lMovie.frame.size.width, ivMovie.frame.size.width) - margin * 3
        lMovieTotal = ViewHelper.getLabelBold(width: movieWidth, text: "-", size: ScreenUtils.fontFit(40), color: ThemeHelper.getColorPrimary(), lines: 1, align: .right, mode: .byTruncatingMiddle)
        
        let movieHeight = CountHelper.getMax(lMovie.frame.size.height + ivMovie.frame.size.height + iconInnerPadding + margin * 2, lMovieTotal.frame.size.height)
        let movieLeftCenterX = CountHelper.getMax(lMovie.frame.size.width, ivMovie.frame.size.width) / 2 + margin
        ivMovie.center.x = movieLeftCenterX
        lMovie.center.x = movieLeftCenterX
        lMovieTotal.frame.origin.x = CountHelper.getMax(lMovie.frame.origin.x + lMovie.frame.size.width, ivMovie.frame.origin.x + ivMovie.frame.size.width) + margin
        ivMovie.frame.origin.y  = margin
        lMovie.frame.origin.y  = ivMovie.frame.origin.y + ivMovie.frame.size.height + iconInnerPadding
        lMovieTotal.center.y  = movieHeight / 2
        
        let vMovie = UIView(frame: CGRect(x: margin, y: vDiary.frame.origin.y + vDiary.frame.size.height + margin, width: cardWidth, height: movieHeight))
        vMovie.tag = tagMovie
        vMovie.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vMovie, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vMovie, offset: ViewHelper.SHADOW_NORMAL)
        vMovie.addSubview(ivMovie)
        vMovie.addSubview(lMovie)
        vMovie.addSubview(lMovieTotal)
        
        // food
        let ivFood = ViewHelper.getImageView(img: UIImage(named: "ic_note_food_24dp"), mode: .center)
        let lFood = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("food"), lines: 1, align: .center)
        let foodWidth = cardWidth - CountHelper.getMax(lFood.frame.size.width, lFood.frame.size.width) - margin * 3
        lFoodTotal = ViewHelper.getLabelBold(width: foodWidth, text: "-", size: ScreenUtils.fontFit(40), color: ThemeHelper.getColorPrimary(), lines: 1, align: .right, mode: .byTruncatingMiddle)
        
        let foodHeight = CountHelper.getMax(lFood.frame.size.height + ivFood.frame.size.height + iconInnerPadding + margin * 2, lFoodTotal.frame.size.height)
        let foodLeftCenterX = CountHelper.getMax(lFood.frame.size.width, ivFood.frame.size.width) / 2 + margin
        ivFood.center.x = foodLeftCenterX
        lFood.center.x = foodLeftCenterX
        lFoodTotal.frame.origin.x = CountHelper.getMax(lFood.frame.origin.x + lFood.frame.size.width, ivFood.frame.origin.x + ivFood.frame.size.width) + margin
        ivFood.frame.origin.y  = margin
        lFood.frame.origin.y  = ivFood.frame.origin.y + ivFood.frame.size.height + iconInnerPadding
        lFoodTotal.center.y  = foodHeight / 2
        
        let vFood = UIView(frame: CGRect(x: vMovie.frame.origin.x + vMovie.frame.size.width + margin, y: vMovie.frame.origin.y, width: cardWidth, height: foodHeight))
        vFood.tag = tagFood
        vFood.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vFood, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vFood, offset: ViewHelper.SHADOW_NORMAL)
        vFood.addSubview(ivFood)
        vFood.addSubview(lFood)
        vFood.addSubview(lFoodTotal)
        
        // promise
        let ivPromise = ViewHelper.getImageView(img: UIImage(named: "ic_note_promise_24dp"), mode: .center)
        let lPromise = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("promise"), lines: 1, align: .center)
        let promiseWidth = cardWidth - CountHelper.getMax(lPromise.frame.size.width, ivPromise.frame.size.width) - margin * 3
        lPromiseTotal = ViewHelper.getLabelBold(width: promiseWidth, text: "-", size: ScreenUtils.fontFit(40), color: ThemeHelper.getColorPrimary(), lines: 1, align: .right, mode: .byTruncatingMiddle)
        
        let promiseHeight = CountHelper.getMax(lPromise.frame.size.height + ivPromise.frame.size.height + iconInnerPadding + margin * 2, lPromiseTotal.frame.size.height)
        let promiseLeftCenterX = CountHelper.getMax(lPromise.frame.size.width, ivPromise.frame.size.width) / 2 + margin
        ivPromise.center.x = promiseLeftCenterX
        lPromise.center.x = promiseLeftCenterX
        lPromiseTotal.frame.origin.x = CountHelper.getMax(lPromise.frame.origin.x + lPromise.frame.size.width, ivPromise.frame.origin.x + ivPromise.frame.size.width) + margin
        ivPromise.frame.origin.y  = margin
        lPromise.frame.origin.y  = ivPromise.frame.origin.y + ivPromise.frame.size.height + iconInnerPadding
        lPromiseTotal.center.y  = promiseHeight / 2
        
        let vPromise = UIView(frame: CGRect(x: margin, y: vMovie.frame.origin.y + vMovie.frame.size.height + margin, width: cardWidth, height: promiseHeight))
        vPromise.tag = tagPromise
        vPromise.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vPromise, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vPromise, offset: ViewHelper.SHADOW_NORMAL)
        vPromise.addSubview(ivPromise)
        vPromise.addSubview(lPromise)
        vPromise.addSubview(lPromiseTotal)
        
        // gift
        let ivGift = ViewHelper.getImageView(img: UIImage(named: "ic_note_gift_24dp"), mode: .center)
        let lGift = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("gift"), lines: 1, align: .center)
        let giftWidth = cardWidth - CountHelper.getMax(lGift.frame.size.width, ivGift.frame.size.width) - margin * 3
        lGiftTotal = ViewHelper.getLabelBold(width: giftWidth, text: "-", size: ScreenUtils.fontFit(40), color: ThemeHelper.getColorPrimary(), lines: 1, align: .right, mode: .byTruncatingMiddle)
        
        let giftHeight = CountHelper.getMax(lGift.frame.size.height + ivGift.frame.size.height + iconInnerPadding + margin * 2, lGiftTotal.frame.size.height)
        let giftLeftCenterX = CountHelper.getMax(lGift.frame.size.width, ivGift.frame.size.width) / 2 + margin
        ivGift.center.x = giftLeftCenterX
        lGift.center.x = giftLeftCenterX
        lGiftTotal.frame.origin.x = CountHelper.getMax(lGift.frame.origin.x + lGift.frame.size.width, ivGift.frame.origin.x + ivGift.frame.size.width) + margin
        ivGift.frame.origin.y  = margin
        lGift.frame.origin.y  = ivGift.frame.origin.y + ivGift.frame.size.height + iconInnerPadding
        lGiftTotal.center.y  = giftHeight / 2
        
        let vGift = UIView(frame: CGRect(x: vPromise.frame.origin.x + vPromise.frame.size.width + margin, y: vPromise.frame.origin.y, width: cardWidth, height: giftHeight))
        vGift.tag = tagGift
        vGift.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vGift, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vGift, offset: ViewHelper.SHADOW_NORMAL)
        vGift.addSubview(ivGift)
        vGift.addSubview(lGift)
        vGift.addSubview(lGiftTotal)
        
        // angry
        let ivAngry = ViewHelper.getImageView(img: UIImage(named: "ic_note_angry_24dp"), mode: .center)
        let lAngry = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("angry"), lines: 1, align: .center)
        let angryWidth = cardWidth - CountHelper.getMax(lAngry.frame.size.width, ivAngry.frame.size.width) - margin * 3
        lAngryTotal = ViewHelper.getLabelBold(width: angryWidth, text: "-", size: ScreenUtils.fontFit(40), color: ThemeHelper.getColorPrimary(), lines: 1, align: .right, mode: .byTruncatingMiddle)
        
        let angryHeight = CountHelper.getMax(lAngry.frame.size.height + ivAngry.frame.size.height + iconInnerPadding + margin * 2, lAngryTotal.frame.size.height)
        let angryLeftCenterX = CountHelper.getMax(lAngry.frame.size.width, ivAngry.frame.size.width) / 2 + margin
        ivAngry.center.x = angryLeftCenterX
        lAngry.center.x = angryLeftCenterX
        lAngryTotal.frame.origin.x = CountHelper.getMax(lAngry.frame.origin.x + lAngry.frame.size.width, ivAngry.frame.origin.x + ivAngry.frame.size.width) + margin
        ivAngry.frame.origin.y  = margin
        lAngry.frame.origin.y  = ivAngry.frame.origin.y + ivAngry.frame.size.height + iconInnerPadding
        lAngryTotal.center.y  = angryHeight / 2
        
        let vAngry = UIView(frame: CGRect(x: margin, y: vPromise.frame.origin.y + vPromise.frame.size.height + margin, width: cardWidth, height: angryHeight))
        vAngry.tag = tagAngry
        vAngry.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vAngry, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vAngry, offset: ViewHelper.SHADOW_NORMAL)
        vAngry.addSubview(ivAngry)
        vAngry.addSubview(lAngry)
        vAngry.addSubview(lAngryTotal)
        
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
        let vMediaLine = UIView(frame: CGRect(x: 0, y: vAngry.frame.origin.y + vAngry.frame.size.height + ScreenUtils.heightFit(15), width: screenWidth, height: lMedia.frame.size.height))
        vMediaLine.addSubview(lMedia)
        vMediaLine.addSubview(lineMediaLeft)
        vMediaLine.addSubview(lineMediaRight)
        
        // audio
        let ivAudio = ViewHelper.getImageView(img: UIImage(named: "ic_note_audio_24dp"), mode: .center)
        let lAudio = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("audio"), lines: 1, align: .center)
        let audioWidth = cardWidth - CountHelper.getMax(lAudio.frame.size.width, ivAudio.frame.size.width) - margin * 3
        lAudioTotal = ViewHelper.getLabelBold(width: audioWidth, text: "-", size: ScreenUtils.fontFit(40), color: ThemeHelper.getColorPrimary(), lines: 1, align: .right, mode: .byTruncatingMiddle)
        
        let audioHeight = CountHelper.getMax(lAudio.frame.size.height + ivAudio.frame.size.height + iconInnerPadding + margin * 2, lAudioTotal.frame.size.height)
        let audioLeftCenterX = CountHelper.getMax(lAudio.frame.size.width, ivAudio.frame.size.width) / 2 + margin
        ivAudio.center.x = audioLeftCenterX
        lAudio.center.x = audioLeftCenterX
        lAudioTotal.frame.origin.x = CountHelper.getMax(lAudio.frame.origin.x + lAudio.frame.size.width, ivAudio.frame.origin.x + ivAudio.frame.size.width) + margin
        ivAudio.frame.origin.y  = margin
        lAudio.frame.origin.y  = ivAudio.frame.origin.y + ivAudio.frame.size.height + iconInnerPadding
        lAudioTotal.center.y  = audioHeight / 2
        
        let vAudio = UIView(frame: CGRect(x: margin, y: vMediaLine.frame.origin.y + vMediaLine.frame.size.height + ScreenUtils.heightFit(20), width: cardWidth, height: audioHeight))
        vAudio.tag = tagAudio
        vAudio.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vAudio, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vAudio, offset: ViewHelper.SHADOW_NORMAL)
        vAudio.addSubview(ivAudio)
        vAudio.addSubview(lAudio)
        vAudio.addSubview(lAudioTotal)
        
        // video
        let ivVideo = ViewHelper.getImageView(img: UIImage(named: "ic_note_video_24dp"), mode: .center)
        let lVideo = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("video"), lines: 1, align: .center)
        let videoWidth = cardWidth - CountHelper.getMax(lVideo.frame.size.width, ivVideo.frame.size.width) - margin * 3
        lVideoTotal = ViewHelper.getLabelBold(width: videoWidth, text: "-", size: ScreenUtils.fontFit(40), color: ThemeHelper.getColorPrimary(), lines: 1, align: .right, mode: .byTruncatingMiddle)
        
        let videoHeight = CountHelper.getMax(lVideo.frame.size.height + ivVideo.frame.size.height + iconInnerPadding + margin * 2, lVideoTotal.frame.size.height)
        let videoLeftCenterX = CountHelper.getMax(lVideo.frame.size.width, ivVideo.frame.size.width) / 2 + margin
        ivVideo.center.x = videoLeftCenterX
        lVideo.center.x = videoLeftCenterX
        lVideoTotal.frame.origin.x = CountHelper.getMax(lVideo.frame.origin.x + lVideo.frame.size.width, ivVideo.frame.origin.x + ivVideo.frame.size.width) + margin
        ivVideo.frame.origin.y  = margin
        lVideo.frame.origin.y  = ivVideo.frame.origin.y + ivVideo.frame.size.height + iconInnerPadding
        lVideoTotal.center.y  = videoHeight / 2
        
        let vVideo = UIView(frame: CGRect(x: vAudio.frame.origin.x + vAudio.frame.size.width + margin, y: vAudio.frame.origin.y, width: cardWidth, height: videoHeight))
        vVideo.tag = tagVideo
        vVideo.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vVideo, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vVideo, offset: ViewHelper.SHADOW_NORMAL)
        vVideo.addSubview(ivVideo)
        vVideo.addSubview(lVideo)
        vVideo.addSubview(lVideoTotal)
        
        // picture
        let ivPicture = ViewHelper.getImageView(img: UIImage(named: "ic_note_album_24dp"), mode: .center)
        let lPicture = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("picture"), lines: 1, align: .center)
        let pictureWidth = cardWidth - CountHelper.getMax(lPicture.frame.size.width, ivPicture.frame.size.width) - margin * 3
        lPictureTotal = ViewHelper.getLabelBold(width: pictureWidth, text: "-", size: ScreenUtils.fontFit(40), color: ThemeHelper.getColorPrimary(), lines: 1, align: .right, mode: .byTruncatingMiddle)
        
        let pictureHeight = CountHelper.getMax(lPicture.frame.size.height + ivPicture.frame.size.height + iconInnerPadding + margin * 2, lPictureTotal.frame.size.height)
        let pictureLeftCenterX = CountHelper.getMax(lPicture.frame.size.width, ivPicture.frame.size.width) / 2 + margin
        ivPicture.center.x = pictureLeftCenterX
        lPicture.center.x = pictureLeftCenterX
        lPictureTotal.frame.origin.x = CountHelper.getMax(lPicture.frame.origin.x + lPicture.frame.size.width, ivPicture.frame.origin.x + ivPicture.frame.size.width) + margin
        ivPicture.frame.origin.y  = margin
        lPicture.frame.origin.y  = ivPicture.frame.origin.y + ivPicture.frame.size.height + iconInnerPadding
        lPictureTotal.center.y  = pictureHeight / 2
        
        let vPicture = UIView(frame: CGRect(x: margin, y: vAudio.frame.origin.y + vAudio.frame.size.height + margin, width: cardWidth, height: pictureHeight))
        vPicture.tag = tagPicture
        vPicture.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vPicture, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vPicture, offset: ViewHelper.SHADOW_NORMAL)
        vPicture.addSubview(ivPicture)
        vPicture.addSubview(lPicture)
        vPicture.addSubview(lPictureTotal)
        
        // total
        vTotal = UIView(frame: CGRect(x: 0, y: margin, width: screenWidth, height: vPicture.frame.origin.y + vPicture.frame.size.height + margin))
        vTotal.addSubview(vNoteLine)
        vTotal.addSubview(vSouvenir)
        vTotal.addSubview(vTravel)
        vTotal.addSubview(vWord)
        vTotal.addSubview(vAward)
        vTotal.addSubview(vDiary)
        vTotal.addSubview(vDream)
        vTotal.addSubview(vMovie)
        vTotal.addSubview(vFood)
        vTotal.addSubview(vPromise)
        vTotal.addSubview(vGift)
        vTotal.addSubview(vAngry)
        vTotal.addSubview(vMediaLine)
        vTotal.addSubview(vAudio)
        vTotal.addSubview(vVideo)
        vTotal.addSubview(vPicture)
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = vTotal.frame.origin.y + vTotal.frame.size.height + margin
        let scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        scroll.addSubview(lShow)
        scroll.addSubview(vTotal)
        
        // view
        let gradient = ViewHelper.getGradientPrimaryTrans(frame: self.view.bounds)
        self.view.layer.insertSublayer(gradient, at: 0)
        self.view.addSubview(scroll)
        
        // hide
        lShow.isHidden = true
        vTotal.isHidden = true
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vSouvenir, action: #selector(targetGo))
        ViewUtils.addViewTapTarget(target: self, view: vTravel, action: #selector(targetGo))
        ViewUtils.addViewTapTarget(target: self, view: vWord, action: #selector(targetGo))
        ViewUtils.addViewTapTarget(target: self, view: vAward, action: #selector(targetGo))
        ViewUtils.addViewTapTarget(target: self, view: vDiary, action: #selector(targetGo))
        ViewUtils.addViewTapTarget(target: self, view: vDream, action: #selector(targetGo))
        ViewUtils.addViewTapTarget(target: self, view: vMovie, action: #selector(targetGo))
        ViewUtils.addViewTapTarget(target: self, view: vFood, action: #selector(targetGo))
        ViewUtils.addViewTapTarget(target: self, view: vPromise, action: #selector(targetGo))
        ViewUtils.addViewTapTarget(target: self, view: vGift, action: #selector(targetGo))
        ViewUtils.addViewTapTarget(target: self, view: vAngry, action: #selector(targetGo))
        ViewUtils.addViewTapTarget(target: self, view: vAudio, action: #selector(targetGo))
        ViewUtils.addViewTapTarget(target: self, view: vVideo, action: #selector(targetGo))
        ViewUtils.addViewTapTarget(target: self, view: vPicture, action: #selector(targetGo))
    }
    
    override func initData() {
        refreshData()
    }
    
    @objc func targetGo(sender: UIGestureRecognizer) {
        let tag = sender.view?.tag ?? 0
        switch tag {
        case tagSouvenir:
            NoteSouvenirVC.pushVC()
            break
        case tagTravel:
            NoteTravelVC.pushVC()
            break
        case tagWord:
            NoteWordVC.pushVC()
            break
        case tagAward:
            NoteAwardVC.pushVC()
            break
        case tagDiary:
            NoteDiaryVC.pushVC()
            break
        case tagDream:
            NoteDreamVC.pushVC()
            break
        case tagMovie:
            NoteMovieVC.pushVC()
            break
        case tagFood:
            NoteFoodVC.pushVC()
            break
        case tagPromise:
            NotePromiseVC.pushVC()
            break
        case tagGift:
            NoteGiftVC.pushVC()
            break
        case tagAngry:
            NoteAngryVC.pushVC()
            break
        case tagAudio:
            NoteAudioVC.pushVC()
            break
        case tagVideo:
            NoteVideoVC.pushVC()
            break
        case tagPicture:
            NoteAlbumVC.pushVC()
            break
        default:
            break
        }
    }
    
    func refreshData() {
        // api
        let api = Api.request(.noteTrendsTotalGet, success: { (_, _, data) in
            self.refreshView(show: data.show, total: data.noteTotal)
        }, failure: nil)
        pushApi(api)
    }
    
    func refreshView(show: String?, total: NoteTotal?)  {
        if !StringUtils.isEmpty(show) {
            lShow.isHidden = false
            vTotal.isHidden = true
            lShow.text = show
            return
        }
        lShow.isHidden = true
        vTotal.isHidden = false
        lSouvenirTotal.text = "\(total?.totalSouvenir ?? 0)"
        lTravelTotal.text = "\(total?.totalTravel ?? 0)"
        lWordTotal.text = "\(total?.totalWord ?? 0)"
        lAwardTotal.text = "\(total?.totalAward ?? 0)"
        lDiaryTotal.text = "\(total?.totalDiary ?? 0)"
        lDreamTotal.text = "\(total?.totalDream ?? 0)"
        lMovieTotal.text = "\(total?.totalMovie ?? 0)"
        lFoodTotal.text = "\(total?.totalFood ?? 0)"
        lPromiseTotal.text = "\(total?.totalPromise ?? 0)"
        lGiftTotal.text = "\(total?.totalGift ?? 0)"
        lAngryTotal.text = "\(total?.totalAngry ?? 0)"
        lAudioTotal.text = "\(total?.totalAudio ?? 0)"
        lVideoTotal.text = "\(total?.totalVideo ?? 0)"
        lPictureTotal.text = "\(total?.totalPicture ?? 0)"
    }
    
}
