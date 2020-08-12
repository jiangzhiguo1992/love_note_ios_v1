//
//  NoteSouvenirEditForeignVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/6.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteSouvenirEditForeignVC: BaseVC, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    
    // view
    private var scroll: UIScrollView!
    private var vTravelLine: UIView!
    private var tableTravel: UITableView!
    private var vTravelAdd: UIView!
    private var vGiftLine: UIView!
    private var tableGift: UITableView!
    private var vGiftAdd: UIView!
    private var vAlbumLine: UIView!
    private var tableAlbum: UITableView!
    private var vAlbumAdd: UIView!
    private var vVideoLine: UIView!
    private var collectVideo: UICollectionView!
    private var vVideoAdd: UIView!
    private var vFoodLine: UIView!
    private var tableFood: UITableView!
    private var vFoodAdd: UIView!
    private var vMovieLine: UIView!
    private var tableMovie: UITableView!
    private var vMovieAdd: UIView!
    private var vDiaryLine: UIView!
    private var tableDiary: UITableView!
    private var vDiaryAdd: UIView!
    
    // var
    private var year = 0
    private var souvenir: Souvenir!
    private var souvenirOld: Souvenir!
    private let tagTravel: Int = 1
    private let tagGift: Int = 2
    private let tagAlbum: Int = 3
    private let tagVideo: Int = 4
    private let tagFood: Int = 5
    private let tagMovie: Int = 6
    private let tagDiary: Int = 7
    
    public static func pushVC(year: Int, souvenir: Souvenir? = nil) {
        AppDelegate.runOnMainAsync {
            if souvenir == nil || souvenir!.id == 0 {
                return
            }
            let vc = NoteSouvenirEditForeignVC(nibName: nil, bundle: nil)
            vc.year = year
            vc.souvenir = souvenir!
            // 需要拷贝可编辑的数据
            vc.souvenirOld = Souvenir()
            vc.souvenirOld.souvenirTravelList = souvenir!.souvenirTravelList
            vc.souvenirOld.souvenirGiftList = souvenir!.souvenirGiftList
            vc.souvenirOld.souvenirAlbumList = souvenir!.souvenirAlbumList
            vc.souvenirOld.souvenirVideoList = souvenir!.souvenirVideoList
            vc.souvenirOld.souvenirFoodList = souvenir!.souvenirFoodList
            vc.souvenirOld.souvenirMovieList = souvenir!.souvenirMovieList
            vc.souvenirOld.souvenirDiaryList = souvenir!.souvenirDiaryList
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "\(year)")
        let barItemCommit = UIBarButtonItem(title: StringUtils.getString("commit"), style: .plain, target: self, action: #selector(checkPush))
        barItemCommit.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        self.navigationItem.setRightBarButtonItems([barItemCommit], animated: true)
        
        // travel-line
        let lTravel = ViewHelper.getLabelGreySmall(text: StringUtils.getString("travel"))
        lTravel.center.x = screenWidth / 2
        lTravel.frame.origin.y = 0
        let lineTravelLeft = ViewHelper.getViewLine(width: (maxWidth - lTravel.frame.size.width) / 2 - margin)
        lineTravelLeft.frame.origin.x = margin
        lineTravelLeft.center.y = lTravel.center.y
        let lineTravelRight = ViewHelper.getViewLine(width: (maxWidth - lTravel.frame.size.width) / 2 - margin)
        lineTravelRight.frame.origin.x = lTravel.frame.origin.x + lTravel.frame.size.width + margin
        lineTravelRight.center.y = lTravel.center.y
        vTravelLine = UIView(frame: CGRect(x: 0, y: ScreenUtils.heightFit(20), width: screenWidth, height: lTravel.frame.size.height))
        vTravelLine.addSubview(lTravel)
        vTravelLine.addSubview(lineTravelLeft)
        vTravelLine.addSubview(lineTravelRight)
        
        // travel-table
        let frameTravel = CGRect(x: 0, y: vTravelLine.frame.origin.y + vTravelLine.frame.size.height + margin, width: screenWidth, height: CGFloat(0))
        tableTravel = ViewUtils.getTableView(target: self, frame: frameTravel, cellCls: NoteTravelCell.self, id: NoteTravelCell.ID)
        tableTravel.tag = tagTravel
        
        // travel-add
        let lTravelAdd = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("add_travel"), lines: 1, mode: .byTruncatingMiddle)
        lTravelAdd.center.x = screenWidth / 2
        let travelAddHeight = lTravelAdd.frame.size.height + margin * 4
        lTravelAdd.center.y = travelAddHeight / 2
        let ivTravelAdd = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_add_circle_outline_grey_18dp"), color: ColorHelper.getFontGrey()), width: lTravelAdd.frame.size.height, height: lTravelAdd.frame.size.height, mode: .scaleAspectFit)
        ivTravelAdd.frame.origin.x = lTravelAdd.frame.origin.x - margin - ivTravelAdd.frame.size.width
        ivTravelAdd.center.y = travelAddHeight / 2
        vTravelAdd = UIView(frame: CGRect(x: 0, y: tableTravel.frame.origin.y + tableTravel.frame.size.height + margin, width: screenWidth, height: travelAddHeight))
        vTravelAdd.tag = tagTravel
        vTravelAdd.addSubview(ivTravelAdd)
        vTravelAdd.addSubview(lTravelAdd)
        
        // gift-line
        let lGift = ViewHelper.getLabelGreySmall(text: StringUtils.getString("gift"))
        lGift.center.x = screenWidth / 2
        lGift.frame.origin.y = 0
        let lineGiftLeft = ViewHelper.getViewLine(width: (maxWidth - lGift.frame.size.width) / 2 - margin)
        lineGiftLeft.frame.origin.x = margin
        lineGiftLeft.center.y = lGift.center.y
        let lineGiftRight = ViewHelper.getViewLine(width: (maxWidth - lGift.frame.size.width) / 2 - margin)
        lineGiftRight.frame.origin.x = lGift.frame.origin.x + lGift.frame.size.width + margin
        lineGiftRight.center.y = lGift.center.y
        vGiftLine = UIView(frame: CGRect(x: 0, y: vTravelAdd.frame.origin.y + vTravelAdd.frame.size.height + ScreenUtils.heightFit(20), width: screenWidth, height: lGift.frame.size.height))
        vGiftLine.addSubview(lGift)
        vGiftLine.addSubview(lineGiftLeft)
        vGiftLine.addSubview(lineGiftRight)
        
        // gift-table
        let frameGift = CGRect(x: 0, y: vGiftLine.frame.origin.y + vGiftLine.frame.size.height + margin, width: screenWidth, height: CGFloat(0))
        tableGift = ViewUtils.getTableView(target: self, frame: frameGift, cellCls: NoteGiftCell.self, id: NoteGiftCell.ID)
        tableGift.tag = tagGift
        
        // gift-add
        let lGiftAdd = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("add_gift"), lines: 1, mode: .byTruncatingMiddle)
        lGiftAdd.center.x = screenWidth / 2
        let giftAddHeight = lGiftAdd.frame.size.height + margin * 4
        lGiftAdd.center.y = giftAddHeight / 2
        let ivGiftAdd = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_add_circle_outline_grey_18dp"), color: ColorHelper.getFontGrey()), width: lGiftAdd.frame.size.height, height: lGiftAdd.frame.size.height, mode: .scaleAspectFit)
        ivGiftAdd.frame.origin.x = lGiftAdd.frame.origin.x - margin - ivGiftAdd.frame.size.width
        ivGiftAdd.center.y = giftAddHeight / 2
        vGiftAdd = UIView(frame: CGRect(x: 0, y: tableGift.frame.origin.y + tableGift.frame.size.height + margin, width: screenWidth, height: giftAddHeight))
        vGiftAdd.tag = tagGift
        vGiftAdd.addSubview(ivGiftAdd)
        vGiftAdd.addSubview(lGiftAdd)
        
        // album-line
        let lAlbum = ViewHelper.getLabelGreySmall(text: StringUtils.getString("album"))
        lAlbum.center.x = screenWidth / 2
        lAlbum.frame.origin.y = 0
        let lineAlbumLeft = ViewHelper.getViewLine(width: (maxWidth - lAlbum.frame.size.width) / 2 - margin)
        lineAlbumLeft.frame.origin.x = margin
        lineAlbumLeft.center.y = lAlbum.center.y
        let lineAlbumRight = ViewHelper.getViewLine(width: (maxWidth - lAlbum.frame.size.width) / 2 - margin)
        lineAlbumRight.frame.origin.x = lAlbum.frame.origin.x + lAlbum.frame.size.width + margin
        lineAlbumRight.center.y = lAlbum.center.y
        vAlbumLine = UIView(frame: CGRect(x: 0, y: vGiftAdd.frame.origin.y + vGiftAdd.frame.size.height + ScreenUtils.heightFit(20), width: screenWidth, height: lAlbum.frame.size.height))
        vAlbumLine.addSubview(lAlbum)
        vAlbumLine.addSubview(lineAlbumLeft)
        vAlbumLine.addSubview(lineAlbumRight)
        
        // album-table
        let frameAlbum = CGRect(x: 0, y: vAlbumLine.frame.origin.y + vAlbumLine.frame.size.height + margin, width: screenWidth, height: CGFloat(0))
        tableAlbum = ViewUtils.getTableView(target: self, frame: frameAlbum, cellCls: NoteAlbumCell.self, id: NoteAlbumCell.ID)
        tableAlbum.tag = tagAlbum
        
        // album-add
        let lAlbumAdd = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("add_album"), lines: 1, mode: .byTruncatingMiddle)
        lAlbumAdd.center.x = screenWidth / 2
        let albumAddHeight = lAlbumAdd.frame.size.height + margin * 4
        lAlbumAdd.center.y = albumAddHeight / 2
        let ivAlbumAdd = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_add_circle_outline_grey_18dp"), color: ColorHelper.getFontGrey()), width: lAlbumAdd.frame.size.height, height: lAlbumAdd.frame.size.height, mode: .scaleAspectFit)
        ivAlbumAdd.frame.origin.x = lAlbumAdd.frame.origin.x - margin - ivAlbumAdd.frame.size.width
        ivAlbumAdd.center.y = albumAddHeight / 2
        vAlbumAdd = UIView(frame: CGRect(x: 0, y: tableAlbum.frame.origin.y + tableAlbum.frame.size.height + margin, width: screenWidth, height: albumAddHeight))
        vAlbumAdd.tag = tagAlbum
        vAlbumAdd.addSubview(ivAlbumAdd)
        vAlbumAdd.addSubview(lAlbumAdd)
        
        // video-line
        let lVideo = ViewHelper.getLabelGreySmall(text: StringUtils.getString("video"))
        lVideo.center.x = screenWidth / 2
        lVideo.frame.origin.y = 0
        let lineVideoLeft = ViewHelper.getViewLine(width: (maxWidth - lVideo.frame.size.width) / 2 - margin)
        lineVideoLeft.frame.origin.x = margin
        lineVideoLeft.center.y = lVideo.center.y
        let lineVideoRight = ViewHelper.getViewLine(width: (maxWidth - lVideo.frame.size.width) / 2 - margin)
        lineVideoRight.frame.origin.x = lVideo.frame.origin.x + lVideo.frame.size.width + margin
        lineVideoRight.center.y = lVideo.center.y
        vVideoLine = UIView(frame: CGRect(x: 0, y: vAlbumAdd.frame.origin.y + vAlbumAdd.frame.size.height + ScreenUtils.heightFit(20), width: screenWidth, height: lVideo.frame.size.height))
        vVideoLine.addSubview(lVideo)
        vVideoLine.addSubview(lineVideoLeft)
        vVideoLine.addSubview(lineVideoRight)
        
        // video-table
        let layoutVideo = NoteVideoCell.getLayout()
        let frameVideo = CGRect(x: 0, y: vVideoLine.frame.origin.y + vVideoLine.frame.size.height + margin, width: screenWidth, height: CGFloat(0))
        collectVideo = ViewUtils.getCollectionView(target: self, frame: frameVideo, layout: layoutVideo, cellCls: NoteVideoCell.self, id: NoteVideoCell.ID)
        collectVideo.tag = tagVideo
        
        // video-add
        let lVideoAdd = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("add_video"), lines: 1, mode: .byTruncatingMiddle)
        lVideoAdd.center.x = screenWidth / 2
        let videoAddHeight = lVideoAdd.frame.size.height + margin * 4
        lVideoAdd.center.y = videoAddHeight / 2
        let ivVideoAdd = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_add_circle_outline_grey_18dp"), color: ColorHelper.getFontGrey()), width: lVideoAdd.frame.size.height, height: lVideoAdd.frame.size.height, mode: .scaleAspectFit)
        ivVideoAdd.frame.origin.x = lVideoAdd.frame.origin.x - margin - ivVideoAdd.frame.size.width
        ivVideoAdd.center.y = videoAddHeight / 2
        vVideoAdd = UIView(frame: CGRect(x: 0, y: collectVideo.frame.origin.y + collectVideo.frame.size.height + margin, width: screenWidth, height: videoAddHeight))
        vVideoAdd.tag = tagVideo
        vVideoAdd.addSubview(ivVideoAdd)
        vVideoAdd.addSubview(lVideoAdd)
        
        // food-line
        let lFood = ViewHelper.getLabelGreySmall(text: StringUtils.getString("food"))
        lFood.center.x = screenWidth / 2
        lFood.frame.origin.y = 0
        let lineFoodLeft = ViewHelper.getViewLine(width: (maxWidth - lFood.frame.size.width) / 2 - margin)
        lineFoodLeft.frame.origin.x = margin
        lineFoodLeft.center.y = lFood.center.y
        let lineFoodRight = ViewHelper.getViewLine(width: (maxWidth - lFood.frame.size.width) / 2 - margin)
        lineFoodRight.frame.origin.x = lFood.frame.origin.x + lFood.frame.size.width + margin
        lineFoodRight.center.y = lFood.center.y
        vFoodLine = UIView(frame: CGRect(x: 0, y: vVideoAdd.frame.origin.y + vVideoAdd.frame.size.height + ScreenUtils.heightFit(20), width: screenWidth, height: lFood.frame.size.height))
        vFoodLine.addSubview(lFood)
        vFoodLine.addSubview(lineFoodLeft)
        vFoodLine.addSubview(lineFoodRight)
        
        // food-table
        let frameFood = CGRect(x: 0, y: vFoodLine.frame.origin.y + vFoodLine.frame.size.height + margin, width: screenWidth, height: CGFloat(0))
        tableFood = ViewUtils.getTableView(target: self, frame: frameFood, cellCls: NoteFoodCell.self, id: NoteFoodCell.ID)
        tableFood.tag = tagFood
        
        // food-add
        let lFoodAdd = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("add_food"), lines: 1, mode: .byTruncatingMiddle)
        lFoodAdd.center.x = screenWidth / 2
        let foodAddHeight = lFoodAdd.frame.size.height + margin * 4
        lFoodAdd.center.y = foodAddHeight / 2
        let ivFoodAdd = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_add_circle_outline_grey_18dp"), color: ColorHelper.getFontGrey()), width: lFoodAdd.frame.size.height, height: lFoodAdd.frame.size.height, mode: .scaleAspectFit)
        ivFoodAdd.frame.origin.x = lFoodAdd.frame.origin.x - margin - ivFoodAdd.frame.size.width
        ivFoodAdd.center.y = foodAddHeight / 2
        vFoodAdd = UIView(frame: CGRect(x: 0, y: tableFood.frame.origin.y + tableFood.frame.size.height + margin, width: screenWidth, height: foodAddHeight))
        vFoodAdd.tag = tagFood
        vFoodAdd.addSubview(ivFoodAdd)
        vFoodAdd.addSubview(lFoodAdd)
        
        // movie-line
        let lMovie = ViewHelper.getLabelGreySmall(text: StringUtils.getString("movie"))
        lMovie.center.x = screenWidth / 2
        lMovie.frame.origin.y = 0
        let lineMovieLeft = ViewHelper.getViewLine(width: (maxWidth - lMovie.frame.size.width) / 2 - margin)
        lineMovieLeft.frame.origin.x = margin
        lineMovieLeft.center.y = lMovie.center.y
        let lineMovieRight = ViewHelper.getViewLine(width: (maxWidth - lMovie.frame.size.width) / 2 - margin)
        lineMovieRight.frame.origin.x = lMovie.frame.origin.x + lMovie.frame.size.width + margin
        lineMovieRight.center.y = lMovie.center.y
        vMovieLine = UIView(frame: CGRect(x: 0, y: vFoodAdd.frame.origin.y + vFoodAdd.frame.size.height + ScreenUtils.heightFit(20), width: screenWidth, height: lMovie.frame.size.height))
        vMovieLine.addSubview(lMovie)
        vMovieLine.addSubview(lineMovieLeft)
        vMovieLine.addSubview(lineMovieRight)
        
        // movie-table
        let frameMovie = CGRect(x: 0, y: vMovieLine.frame.origin.y + vMovieLine.frame.size.height + margin, width: screenWidth, height: CGFloat(0))
        tableMovie = ViewUtils.getTableView(target: self, frame: frameMovie, cellCls: NoteMovieCell.self, id: NoteMovieCell.ID)
        tableMovie.tag = tagMovie
        
        // movie-add
        let lMovieAdd = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("add_movie"), lines: 1, mode: .byTruncatingMiddle)
        lMovieAdd.center.x = screenWidth / 2
        let movieAddHeight = lMovieAdd.frame.size.height + margin * 4
        lMovieAdd.center.y = movieAddHeight / 2
        let ivMovieAdd = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_add_circle_outline_grey_18dp"), color: ColorHelper.getFontGrey()), width: lMovieAdd.frame.size.height, height: lMovieAdd.frame.size.height, mode: .scaleAspectFit)
        ivMovieAdd.frame.origin.x = lMovieAdd.frame.origin.x - margin - ivMovieAdd.frame.size.width
        ivMovieAdd.center.y = movieAddHeight / 2
        vMovieAdd = UIView(frame: CGRect(x: 0, y: tableMovie.frame.origin.y + tableMovie.frame.size.height + margin, width: screenWidth, height: movieAddHeight))
        vMovieAdd.tag = tagMovie
        vMovieAdd.addSubview(ivMovieAdd)
        vMovieAdd.addSubview(lMovieAdd)
        
        // diary-line
        let lDiary = ViewHelper.getLabelGreySmall(text: StringUtils.getString("diary"))
        lDiary.center.x = screenWidth / 2
        lDiary.frame.origin.y = 0
        let lineDiaryLeft = ViewHelper.getViewLine(width: (maxWidth - lDiary.frame.size.width) / 2 - margin)
        lineDiaryLeft.frame.origin.x = margin
        lineDiaryLeft.center.y = lDiary.center.y
        let lineDiaryRight = ViewHelper.getViewLine(width: (maxWidth - lDiary.frame.size.width) / 2 - margin)
        lineDiaryRight.frame.origin.x = lDiary.frame.origin.x + lDiary.frame.size.width + margin
        lineDiaryRight.center.y = lDiary.center.y
        vDiaryLine = UIView(frame: CGRect(x: 0, y: vMovieAdd.frame.origin.y + vMovieAdd.frame.size.height + ScreenUtils.heightFit(20), width: screenWidth, height: lDiary.frame.size.height))
        vDiaryLine.addSubview(lDiary)
        vDiaryLine.addSubview(lineDiaryLeft)
        vDiaryLine.addSubview(lineDiaryRight)
        
        // diary-table
        let frameDiary = CGRect(x: 0, y: vDiaryLine.frame.origin.y + vDiaryLine.frame.size.height + margin, width: screenWidth, height: CGFloat(0))
        tableDiary = ViewUtils.getTableView(target: self, frame: frameDiary, cellCls: NoteDiaryCell.self, id: NoteDiaryCell.ID)
        tableDiary.tag = tagDiary
        
        // diary-add
        let lDiaryAdd = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("add_diary"), lines: 1, mode: .byTruncatingMiddle)
        lDiaryAdd.center.x = screenWidth / 2
        let diaryAddHeight = lDiaryAdd.frame.size.height + margin * 4
        lDiaryAdd.center.y = diaryAddHeight / 2
        let ivDiaryAdd = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_add_circle_outline_grey_18dp"), color: ColorHelper.getFontGrey()), width: lDiaryAdd.frame.size.height, height: lDiaryAdd.frame.size.height, mode: .scaleAspectFit)
        ivDiaryAdd.frame.origin.x = lDiaryAdd.frame.origin.x - margin - ivDiaryAdd.frame.size.width
        ivDiaryAdd.center.y = diaryAddHeight / 2
        vDiaryAdd = UIView(frame: CGRect(x: 0, y: tableDiary.frame.origin.y + tableDiary.frame.size.height + margin, width: screenWidth, height: diaryAddHeight))
        vDiaryAdd.tag = tagDiary
        vDiaryAdd.addSubview(ivDiaryAdd)
        vDiaryAdd.addSubview(lDiaryAdd)
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = vDiaryAdd.frame.origin.y + vDiaryAdd.frame.size.height + ScreenUtils.heightFit(20)
        scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        
        scroll.addSubview(vTravelLine)
        scroll.addSubview(tableTravel)
        scroll.addSubview(vTravelAdd)
        scroll.addSubview(vGiftLine)
        scroll.addSubview(tableGift)
        scroll.addSubview(vGiftAdd)
        scroll.addSubview(vAlbumLine)
        scroll.addSubview(tableAlbum)
        scroll.addSubview(vAlbumAdd)
        scroll.addSubview(vVideoLine)
        scroll.addSubview(collectVideo)
        scroll.addSubview(vVideoAdd)
        scroll.addSubview(vFoodLine)
        scroll.addSubview(tableFood)
        scroll.addSubview(vFoodAdd)
        scroll.addSubview(vMovieLine)
        scroll.addSubview(tableMovie)
        scroll.addSubview(vMovieAdd)
        scroll.addSubview(vDiaryLine)
        scroll.addSubview(tableDiary)
        scroll.addSubview(vDiaryAdd)
        
        // view
        self.view.backgroundColor = ColorHelper.getWhite()
        self.view.addSubview(scroll)
        
        // hide
        tableTravel.isHidden = true
        vTravelAdd.isHidden = true
        tableGift.isHidden = true
        vGiftAdd.isHidden = true
        tableAlbum.isHidden = true
        vAlbumAdd.isHidden = true
        collectVideo.isHidden = true
        vVideoAdd.isHidden = true
        tableFood.isHidden = true
        vFoodAdd.isHidden = true
        tableMovie.isHidden = true
        vMovieAdd.isHidden = true
        tableDiary.isHidden = true
        vDiaryAdd.isHidden = true
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vTravelAdd, action: #selector(targetSelect))
        ViewUtils.addViewTapTarget(target: self, view: vGiftAdd, action: #selector(targetSelect))
        ViewUtils.addViewTapTarget(target: self, view: vAlbumAdd, action: #selector(targetSelect))
        ViewUtils.addViewTapTarget(target: self, view: vVideoAdd, action: #selector(targetSelect))
        ViewUtils.addViewTapTarget(target: self, view: vFoodAdd, action: #selector(targetSelect))
        ViewUtils.addViewTapTarget(target: self, view: vMovieAdd, action: #selector(targetSelect))
        ViewUtils.addViewTapTarget(target: self, view: vDiaryAdd, action: #selector(targetSelect))
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyTravelSelect), name: NotifyHelper.TAG_TRAVEL_SELECT)
        NotifyHelper.addObserver(self, selector: #selector(notifyGiftSelect), name: NotifyHelper.TAG_GIFT_SELECT)
        NotifyHelper.addObserver(self, selector: #selector(notifyAlbumSelect), name: NotifyHelper.TAG_ALBUM_SELECT)
        NotifyHelper.addObserver(self, selector: #selector(notifyVideoSelect), name: NotifyHelper.TAG_VIDEO_SELECT)
        NotifyHelper.addObserver(self, selector: #selector(notifyFoodSelect), name: NotifyHelper.TAG_FOOD_SELECT)
        NotifyHelper.addObserver(self, selector: #selector(notifyMovieSelect), name: NotifyHelper.TAG_MOVIE_SELECT)
        NotifyHelper.addObserver(self, selector: #selector(notifyDiarySelect), name: NotifyHelper.TAG_DIARY_SELECT)
        NotifyHelper.addObserver(self, selector: #selector(notifyTravelItemDelete), name: NotifyHelper.TAG_TRAVEL_LIST_ITEM_DELETE)
        NotifyHelper.addObserver(self, selector: #selector(notifyTravelItemRefresh), name: NotifyHelper.TAG_TRAVEL_LIST_ITEM_REFRESH)
        NotifyHelper.addObserver(self, selector: #selector(notifyAlbumItemDelete), name: NotifyHelper.TAG_ALBUM_LIST_ITEM_DELETE)
        NotifyHelper.addObserver(self, selector: #selector(notifyAlbumItemRefresh), name: NotifyHelper.TAG_ALBUM_LIST_ITEM_REFRESH)
        NotifyHelper.addObserver(self, selector: #selector(notifyDiaryItemDelete), name: NotifyHelper.TAG_DIARY_LIST_ITEM_DELETE)
        NotifyHelper.addObserver(self, selector: #selector(notifyDiaryItemRefresh), name: NotifyHelper.TAG_DIARY_LIST_ITEM_REFRESH)
        // list
        refreshListView()
    }
    
    @objc func notifyTravelSelect(notify: NSNotification) {
        if let travel = notify.object as? Travel {
            let travelList = ListHelper.getTravelListBySouvenir(souvenirTravelList: souvenir.souvenirTravelList, checkStatus: true)
            if ListHelper.findIndexByIdInList(list: travelList, obj: travel) < 0 {
                let souvenirTravel = SouvenirTravel()
                souvenirTravel.status = BaseObj.STATUS_VISIBLE
                souvenirTravel.travelId = travel.id
                souvenirTravel.travel = travel
                souvenir.souvenirTravelList.append(souvenirTravel)
                // view
                refreshListView()
            }
        }
    }
    
    @objc func notifyGiftSelect(notify: NSNotification) {
        if let gift = notify.object as? Gift {
            let giftList = ListHelper.getGiftListBySouvenir(souvenirGiftList: souvenir.souvenirGiftList, checkStatus: true)
            if ListHelper.findIndexByIdInList(list: giftList, obj: gift) < 0 {
                let souvenirGift = SouvenirGift()
                souvenirGift.status = BaseObj.STATUS_VISIBLE
                souvenirGift.giftId = gift.id
                souvenirGift.gift = gift
                souvenir.souvenirGiftList.append(souvenirGift)
                // view
                refreshListView()
            }
        }
    }
    
    @objc func notifyAlbumSelect(notify: NSNotification) {
        if let album = notify.object as? Album {
            let albumList = ListHelper.getAlbumListBySouvenir(souvenirAlbumList: souvenir.souvenirAlbumList, checkStatus: true)
            if ListHelper.findIndexByIdInList(list: albumList, obj: album) < 0 {
                let souvenirAlbum = SouvenirAlbum()
                souvenirAlbum.status = BaseObj.STATUS_VISIBLE
                souvenirAlbum.albumId = album.id
                souvenirAlbum.album = album
                souvenir.souvenirAlbumList.append(souvenirAlbum)
                // view
                refreshListView()
            }
        }
    }
    
    @objc func notifyVideoSelect(notify: NSNotification) {
        if let video = notify.object as? Video {
            let videoList = ListHelper.getVideoListBySouvenir(souvenirVideoList: souvenir.souvenirVideoList, checkStatus: true)
            if ListHelper.findIndexByIdInList(list: videoList, obj: video) < 0 {
                let souvenirVideo = SouvenirVideo()
                souvenirVideo.status = BaseObj.STATUS_VISIBLE
                souvenirVideo.videoId = video.id
                souvenirVideo.video = video
                souvenir.souvenirVideoList.append(souvenirVideo)
                // view
                refreshListView()
            }
        }
    }
    
    @objc func notifyFoodSelect(notify: NSNotification) {
        if let food = notify.object as? Food {
            let foodList = ListHelper.getFoodListBySouvenir(souvenirFoodList: souvenir.souvenirFoodList, checkStatus: true)
            if ListHelper.findIndexByIdInList(list: foodList, obj: food) < 0 {
                let souvenirFood = SouvenirFood()
                souvenirFood.status = BaseObj.STATUS_VISIBLE
                souvenirFood.foodId = food.id
                souvenirFood.food = food
                souvenir.souvenirFoodList.append(souvenirFood)
                // view
                refreshListView()
            }
        }
    }
    
    @objc func notifyMovieSelect(notify: NSNotification) {
        if let movie = notify.object as? Movie {
            let movieList = ListHelper.getMovieListBySouvenir(souvenirMovieList: souvenir.souvenirMovieList, checkStatus: true)
            if ListHelper.findIndexByIdInList(list: movieList, obj: movie) < 0 {
                let souvenirMovie = SouvenirMovie()
                souvenirMovie.status = BaseObj.STATUS_VISIBLE
                souvenirMovie.movieId = movie.id
                souvenirMovie.movie = movie
                souvenir.souvenirMovieList.append(souvenirMovie)
                // view
                refreshListView()
            }
        }
    }
    
    @objc func notifyDiarySelect(notify: NSNotification) {
        if let diary = notify.object as? Diary {
            let diaryList = ListHelper.getDiaryListBySouvenir(souvenirDiaryList: souvenir.souvenirDiaryList, checkStatus: true)
            if ListHelper.findIndexByIdInList(list: diaryList, obj: diary) < 0 {
                let souvenirDiary = SouvenirDiary()
                souvenirDiary.status = BaseObj.STATUS_VISIBLE
                souvenirDiary.diaryId = diary.id
                souvenirDiary.diary = diary
                souvenir.souvenirDiaryList.append(souvenirDiary)
                // view
                refreshListView()
            }
        }
    }
    
    @objc func notifyTravelItemDelete(notify: NSNotification) {
        if let travel = notify.object as? Travel {
            for souvenirTravel in souvenir.souvenirTravelList {
                if souvenirTravel.status == BaseObj.STATUS_DELETE {
                    continue
                } else if souvenirTravel.travelId == travel.id {
                    souvenirTravel.status = BaseObj.STATUS_DELETE
                }
            }
            refreshListView()
        }
    }
    
    @objc func notifyTravelItemRefresh(notify: NSNotification) {
        if let travel = notify.object as? Travel {
            for souvenirTravel in souvenir.souvenirTravelList {
                if souvenirTravel.status == BaseObj.STATUS_DELETE {
                    continue
                } else if souvenirTravel.travelId == travel.id {
                    souvenirTravel.travel = travel
                }
            }
            refreshListView()
        }
    }
    
    @objc func notifyAlbumItemDelete(notify: NSNotification) {
        if let album = notify.object as? Album {
            for souvenirAlbum in souvenir.souvenirAlbumList {
                if souvenirAlbum.status == BaseObj.STATUS_DELETE {
                    continue
                } else if souvenirAlbum.albumId == album.id {
                    souvenirAlbum.status = BaseObj.STATUS_DELETE
                }
            }
            refreshListView()
        }
    }
    
    @objc func notifyAlbumItemRefresh(notify: NSNotification) {
        if let album = notify.object as? Album {
            for souvenirAlbum in souvenir.souvenirAlbumList {
                if souvenirAlbum.status == BaseObj.STATUS_DELETE {
                    continue
                } else if souvenirAlbum.albumId == album.id {
                    souvenirAlbum.album = album
                }
            }
            refreshListView()
        }
    }
    
    @objc func notifyDiaryItemDelete(notify: NSNotification) {
        if let diary = notify.object as? Diary {
            for souvenirDiary in souvenir.souvenirDiaryList {
                if souvenirDiary.status == BaseObj.STATUS_DELETE {
                    continue
                } else if souvenirDiary.diaryId == diary.id {
                    souvenirDiary.status = BaseObj.STATUS_DELETE
                }
            }
            refreshListView()
        }
    }
    
    @objc func notifyDiaryItemRefresh(notify: NSNotification) {
        if let diary = notify.object as? Diary {
            for souvenirDiary in souvenir.souvenirDiaryList {
                if souvenirDiary.status == BaseObj.STATUS_DELETE {
                    continue
                } else if souvenirDiary.diaryId == diary.id {
                    souvenirDiary.diary = diary
                }
            }
            refreshListView()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == tagTravel {
            let travelList = ListHelper.getTravelListBySouvenir(souvenirTravelList: souvenir.souvenirTravelList, checkStatus: true)
            return travelList.count
        } else if tableView.tag == tagGift {
            let giftList = ListHelper.getGiftListBySouvenir(souvenirGiftList: souvenir.souvenirGiftList, checkStatus: true)
            return giftList.count
        } else if tableView.tag == tagAlbum {
            let albumList = ListHelper.getAlbumListBySouvenir(souvenirAlbumList: souvenir.souvenirAlbumList, checkStatus: true)
            return albumList.count
        } else if tableView.tag == tagFood {
            let foodList = ListHelper.getFoodListBySouvenir(souvenirFoodList: souvenir.souvenirFoodList, checkStatus: true)
            return foodList.count
        } else if tableView.tag == tagMovie {
            let movieList = ListHelper.getMovieListBySouvenir(souvenirMovieList: souvenir.souvenirMovieList, checkStatus: true)
            return movieList.count
        } else if tableView.tag == tagDiary {
            let diaryList = ListHelper.getDiaryListBySouvenir(souvenirDiaryList: souvenir.souvenirDiaryList, checkStatus: true)
            return diaryList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == tagTravel {
            return NoteTravelCell.getCellHeight()
        } else if tableView.tag == tagGift {
            let giftList = ListHelper.getGiftListBySouvenir(souvenirGiftList: souvenir.souvenirGiftList, checkStatus: true)
            return NoteGiftCell.getHeightByData(gift: giftList[indexPath.row])
        } else if tableView.tag == tagAlbum {
            return NoteAlbumCell.getCellHeight()
        } else if tableView.tag == tagFood {
            let foodList = ListHelper.getFoodListBySouvenir(souvenirFoodList: souvenir.souvenirFoodList, checkStatus: true)
            return NoteFoodCell.getHeightByData(food: foodList[indexPath.row])
        } else if tableView.tag == tagMovie {
            let movieList = ListHelper.getMovieListBySouvenir(souvenirMovieList: souvenir.souvenirMovieList, checkStatus: true)
            return NoteMovieCell.getHeightByData(movie: movieList[indexPath.row])
        } else if tableView.tag == tagDiary {
            let diaryList = ListHelper.getDiaryListBySouvenir(souvenirDiaryList: souvenir.souvenirDiaryList, checkStatus: true)
            return NoteDiaryCell.getHeightByData(diary: diaryList[indexPath.row])
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == tagTravel {
            let travelList = ListHelper.getTravelListBySouvenir(souvenirTravelList: souvenir.souvenirTravelList, checkStatus: true)
            return NoteTravelCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: travelList, target: self, actionEdit: #selector(targetShowListDeleteAlert))
        } else if tableView.tag == tagGift {
            let giftList = ListHelper.getGiftListBySouvenir(souvenirGiftList: souvenir.souvenirGiftList, checkStatus: true)
            return NoteGiftCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: giftList, heightMap: false, target: self, actionEdit: #selector(targetShowListDeleteAlert))
        } else if tableView.tag == tagAlbum {
            let albumList = ListHelper.getAlbumListBySouvenir(souvenirAlbumList: souvenir.souvenirAlbumList, checkStatus: true)
            return NoteAlbumCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: albumList, target: self, actionEdit: #selector(targetShowListDeleteAlert))
        } else if tableView.tag == tagFood {
            let foodList = ListHelper.getFoodListBySouvenir(souvenirFoodList: souvenir.souvenirFoodList, checkStatus: true)
            return NoteFoodCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: foodList, heightMap: false, target: self, actionEdit: #selector(targetShowListDeleteAlert), actionAddress: #selector(targetFoodGoMap))
        } else if tableView.tag == tagMovie {
            let movieList = ListHelper.getMovieListBySouvenir(souvenirMovieList: souvenir.souvenirMovieList, checkStatus: true)
            return NoteMovieCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: movieList, heightMap: false, target: self, actionEdit: #selector(targetShowListDeleteAlert), actionAddress: #selector(targetMovieGoMap))
        } else if tableView.tag == tagDiary {
            let diaryList = ListHelper.getDiaryListBySouvenir(souvenirDiaryList: souvenir.souvenirDiaryList, checkStatus: true)
            return NoteDiaryCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: diaryList, heightMap: false, target: self, actionEdit: #selector(targetShowListDeleteAlert))
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == tagTravel {
            let travelList = ListHelper.getTravelListBySouvenir(souvenirTravelList: souvenir.souvenirTravelList, checkStatus: true)
            NoteTravelCell.goTravelDetail(view: tableView, indexPath: indexPath, dataList: travelList)
        } else if tableView.tag == tagAlbum {
            let albumList = ListHelper.getAlbumListBySouvenir(souvenirAlbumList: souvenir.souvenirAlbumList, checkStatus: true)
            NoteAlbumCell.goPictureList(view: tableView, indexPath: indexPath, dataList: albumList)
        } else if tableView.tag == tagDiary {
            let diaryList = ListHelper.getDiaryListBySouvenir(souvenirDiaryList: souvenir.souvenirDiaryList, checkStatus: true)
            NoteDiaryCell.goDiaryDetail(view: tableView, indexPath: indexPath, dataList: diaryList)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == tagVideo {
            let videoList = ListHelper.getVideoListBySouvenir(souvenirVideoList: souvenir.souvenirVideoList, checkStatus: true)
            return videoList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == tagVideo {
            let videoList = ListHelper.getVideoListBySouvenir(souvenirVideoList: souvenir.souvenirVideoList, checkStatus: true)
            return NoteVideoCell.getCellWithData(view: collectionView, indexPath: indexPath, dataList: videoList, target: self, actionAddress: #selector(targetVideoGoMap), actionMore: #selector(targetShowListDeleteAlert))
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == tagVideo {
            let videoList = ListHelper.getVideoListBySouvenir(souvenirVideoList: souvenir.souvenirVideoList, checkStatus: true)
            NoteVideoCell.goPlay(view: collectionView, indexPath: indexPath, dataList: videoList)
        }
    }
    
    override func canPop() -> Bool {
        // 更新，返还原来的值
        souvenir.souvenirTravelList = souvenirOld.souvenirTravelList
        souvenir.souvenirGiftList = souvenirOld.souvenirGiftList
        souvenir.souvenirAlbumList = souvenirOld.souvenirAlbumList
        souvenir.souvenirVideoList = souvenirOld.souvenirVideoList
        souvenir.souvenirFoodList = souvenirOld.souvenirFoodList
        souvenir.souvenirMovieList = souvenirOld.souvenirMovieList
        souvenir.souvenirDiaryList = souvenirOld.souvenirDiaryList
        return true
    }
    
    func refreshListView() {
        let foreignYearCount = UDHelper.getLimit().souvenirForeignYearCount
        // place
        let travelList = ListHelper.getTravelListBySouvenir(souvenirTravelList: souvenir.souvenirTravelList, checkStatus: true)
        tableTravel.isHidden = travelList.count <= 0
        vTravelAdd.isHidden = foreignYearCount <= travelList.count
        tableTravel.frame.size.height = NoteTravelCell.getMuliCellHeight(dataList: travelList)
        tableTravel.reloadData()
        vTravelAdd.frame.origin.y = tableTravel.frame.origin.y + tableTravel.frame.size.height + margin
        // gift
        let giftList = ListHelper.getGiftListBySouvenir(souvenirGiftList: souvenir.souvenirGiftList, checkStatus: true)
        tableGift.isHidden = giftList.count <= 0
        vGiftAdd.isHidden = foreignYearCount <= giftList.count
        vGiftLine.frame.origin.y = vTravelAdd.isHidden ? vTravelAdd.frame.origin.y + margin : vTravelAdd.frame.origin.y + vTravelAdd.frame.size.height + ScreenUtils.heightFit(20)
        tableGift.frame.origin.y = vGiftLine.frame.origin.y + vGiftLine.frame.size.height + margin
        tableGift.frame.size.height = NoteGiftCell.getMuliCellHeight(dataList: giftList)
        tableGift.reloadData()
        vGiftAdd.frame.origin.y = tableGift.frame.origin.y + tableGift.frame.size.height + margin
        // album
        let albumList = ListHelper.getAlbumListBySouvenir(souvenirAlbumList: souvenir.souvenirAlbumList, checkStatus: true)
        tableAlbum.isHidden = albumList.count <= 0
        vAlbumAdd.isHidden = foreignYearCount <= albumList.count
        vAlbumLine.frame.origin.y = vGiftAdd.isHidden ? vGiftAdd.frame.origin.y + margin : vGiftAdd.frame.origin.y + vGiftAdd.frame.size.height + ScreenUtils.heightFit(20)
        tableAlbum.frame.origin.y = vAlbumLine.frame.origin.y + vAlbumLine.frame.size.height + margin
        tableAlbum.frame.size.height = NoteAlbumCell.getMuliCellHeight(dataList: albumList)
        tableAlbum.reloadData()
        vAlbumAdd.frame.origin.y = tableAlbum.frame.origin.y + tableAlbum.frame.size.height + margin
        // video
        let videoList = ListHelper.getVideoListBySouvenir(souvenirVideoList: souvenir.souvenirVideoList, checkStatus: true)
        collectVideo.isHidden = videoList.count <= 0
        vVideoAdd.isHidden = foreignYearCount <= videoList.count
        vVideoLine.frame.origin.y = vAlbumAdd.isHidden ? vAlbumAdd.frame.origin.y + margin : vAlbumAdd.frame.origin.y + vAlbumAdd.frame.size.height + ScreenUtils.heightFit(20)
        collectVideo.frame.origin.y = vVideoLine.frame.origin.y + vVideoLine.frame.size.height + margin
        collectVideo.frame.size.height = NoteVideoCell.getMuliCellHeight(dataList: videoList)
        collectVideo.reloadData()
        vVideoAdd.frame.origin.y = collectVideo.frame.origin.y + collectVideo.frame.size.height + margin
        // food
        let foodList = ListHelper.getFoodListBySouvenir(souvenirFoodList: souvenir.souvenirFoodList, checkStatus: true)
        tableFood.isHidden = foodList.count <= 0
        vFoodAdd.isHidden = foreignYearCount <= foodList.count
        vFoodLine.frame.origin.y = vVideoAdd.isHidden ? vVideoAdd.frame.origin.y + margin : vVideoAdd.frame.origin.y + vVideoAdd.frame.size.height + ScreenUtils.heightFit(20)
        tableFood.frame.origin.y = vFoodLine.frame.origin.y + vFoodLine.frame.size.height + margin
        tableFood.frame.size.height = NoteFoodCell.getMuliCellHeight(dataList: foodList)
        tableFood.reloadData()
        vFoodAdd.frame.origin.y = tableFood.frame.origin.y + tableFood.frame.size.height + margin
        // movie
        let movieList = ListHelper.getMovieListBySouvenir(souvenirMovieList: souvenir.souvenirMovieList, checkStatus: true)
        tableMovie.isHidden = movieList.count <= 0
        vMovieAdd.isHidden = foreignYearCount <= movieList.count
        vMovieLine.frame.origin.y = vFoodAdd.isHidden ? vFoodAdd.frame.origin.y + margin : vFoodAdd.frame.origin.y + vFoodAdd.frame.size.height + ScreenUtils.heightFit(20)
        tableMovie.frame.origin.y = vMovieLine.frame.origin.y + vMovieLine.frame.size.height + margin
        tableMovie.frame.size.height = NoteMovieCell.getMuliCellHeight(dataList: movieList)
        tableMovie.reloadData()
        vMovieAdd.frame.origin.y = tableMovie.frame.origin.y + tableMovie.frame.size.height + margin
        // diary
        let diaryList = ListHelper.getDiaryListBySouvenir(souvenirDiaryList: souvenir.souvenirDiaryList, checkStatus: true)
        tableDiary.isHidden = diaryList.count <= 0
        vDiaryAdd.isHidden = foreignYearCount <= diaryList.count
        vDiaryLine.frame.origin.y = vMovieAdd.isHidden ? vMovieAdd.frame.origin.y + margin : vMovieAdd.frame.origin.y + vMovieAdd.frame.size.height + ScreenUtils.heightFit(20)
        tableDiary.frame.origin.y = vDiaryLine.frame.origin.y + vDiaryLine.frame.size.height + margin
        tableDiary.frame.size.height = NoteDiaryCell.getMuliCellHeight(dataList: diaryList)
        tableDiary.reloadData()
        vDiaryAdd.frame.origin.y = tableDiary.frame.origin.y + tableDiary.frame.size.height + margin
        // scroll
        scroll.contentSize.height = vDiaryAdd.frame.origin.y + vDiaryAdd.frame.size.height + ScreenUtils.heightFit(20)
    }
    
    @objc func targetSelect(sender: UIGestureRecognizer) {
        let tag = sender.view?.tag ?? 0
        if tag == tagTravel {
            NoteTravelVC.pushVC(select: true)
        } else if tag == tagGift {
            NoteGiftVC.pushVC(select: true)
        } else if tag == tagAlbum {
            NoteAlbumVC.pushVC(select: true)
        } else if tag == tagVideo {
            NoteVideoVC.pushVC(select: true)
        } else if tag == tagFood {
            NoteFoodVC.pushVC(select: true)
        } else if tag == tagMovie {
            NoteMovieVC.pushVC(select: true)
        } else if tag == tagDiary {
            NoteDiaryVC.pushVC(select: true)
        }
    }
    
    @objc func targetShowListDeleteAlert(sender: UIButton) {
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_delete_this_note"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    self.deleteSingleData(view: sender)
        },
                                  cancelHandler: nil)
    }
    
    func deleteSingleData(view: UIView) {
        var tag = view.tag
        if let tableView = ViewUtils.findSuperTable(view: view) {
            tag = tableView.tag
        } else if let collectView = ViewUtils.findSuperCollect(view: view) {
            tag = collectView.tag
        }
        if tag == tagTravel {
            if let indexPath = ViewUtils.findTableIndexPath(view: view) {
                var jumpIndex = 0
                for (index, souvenirTravel) in souvenir.souvenirTravelList.enumerated() {
                    if souvenirTravel.status == BaseObj.STATUS_DELETE {
                        jumpIndex += 1
                        continue
                    } else if (index - jumpIndex) == indexPath.row {
                        souvenirTravel.status = BaseObj.STATUS_DELETE
                        break
                    }
                }
            }
        } else if tag == tagGift {
            if let indexPath = ViewUtils.findTableIndexPath(view: view) {
                var jumpIndex = 0
                for (index, souvenirGift) in souvenir.souvenirGiftList.enumerated() {
                    if souvenirGift.status == BaseObj.STATUS_DELETE {
                        jumpIndex += 1
                        continue
                    } else if (index - jumpIndex) == indexPath.row {
                        souvenirGift.status = BaseObj.STATUS_DELETE
                        break
                    }
                }
            }
        } else if tag == tagAlbum {
            if let indexPath = ViewUtils.findTableIndexPath(view: view) {
                var jumpIndex = 0
                for (index, souvenirAlbum) in souvenir.souvenirAlbumList.enumerated() {
                    if souvenirAlbum.status == BaseObj.STATUS_DELETE {
                        jumpIndex += 1
                        continue
                    } else if (index - jumpIndex) == indexPath.row {
                        souvenirAlbum.status = BaseObj.STATUS_DELETE
                        break
                    }
                }
            }
        } else if tag == tagVideo {
            if let indexPath = ViewUtils.findCollectIndexPath(view: view) {
                var jumpIndex = 0
                for (index, souvenirVideo) in souvenir.souvenirVideoList.enumerated() {
                    if souvenirVideo.status == BaseObj.STATUS_DELETE {
                        jumpIndex += 1
                        continue
                    } else if (index - jumpIndex) == indexPath.row {
                        souvenirVideo.status = BaseObj.STATUS_DELETE
                        break
                    }
                }
            }
        } else if tag == tagFood {
            if let indexPath = ViewUtils.findTableIndexPath(view: view) {
                var jumpIndex = 0
                for (index, souvenirFood) in souvenir.souvenirFoodList.enumerated() {
                    if souvenirFood.status == BaseObj.STATUS_DELETE {
                        jumpIndex += 1
                        continue
                    } else if (index - jumpIndex) == indexPath.row {
                        souvenirFood.status = BaseObj.STATUS_DELETE
                        break
                    }
                }
            }
        } else if tag == tagMovie {
            if let indexPath = ViewUtils.findTableIndexPath(view: view) {
                var jumpIndex = 0
                for (index, souvenirMovie) in souvenir.souvenirMovieList.enumerated() {
                    if souvenirMovie.status == BaseObj.STATUS_DELETE {
                        jumpIndex += 1
                        continue
                    } else if (index - jumpIndex) == indexPath.row {
                        souvenirMovie.status = BaseObj.STATUS_DELETE
                        break
                    }
                }
            }
        } else if tag == tagDiary {
            if let indexPath = ViewUtils.findTableIndexPath(view: view) {
                var jumpIndex = 0
                for (index, souvenirDiary) in souvenir.souvenirDiaryList.enumerated() {
                    if souvenirDiary.status == BaseObj.STATUS_DELETE {
                        jumpIndex += 1
                        continue
                    } else if (index - jumpIndex) == indexPath.row {
                        souvenirDiary.status = BaseObj.STATUS_DELETE
                        break
                    }
                }
            }
        }
        refreshListView()
    }
    
    @objc func targetVideoGoMap(sender: UIButton) {
        let videoList = ListHelper.getVideoListBySouvenir(souvenirVideoList: souvenir.souvenirVideoList, checkStatus: true)
        NoteVideoCell.goMap(view: sender, dataList: videoList)
    }
    
    @objc func targetFoodGoMap(sender: UIGestureRecognizer) {
        let foodList = ListHelper.getFoodListBySouvenir(souvenirFoodList: souvenir.souvenirFoodList, checkStatus: true)
        NoteFoodCell.goMap(view: sender.view, dataList: foodList)
    }
    
    @objc func targetMovieGoMap(sender: UIGestureRecognizer) {
        let movieList = ListHelper.getMovieListBySouvenir(souvenirMovieList: souvenir.souvenirMovieList, checkStatus: true)
        NoteMovieCell.goMap(view: sender.view, dataList: movieList)
    }
    
    @objc func checkPush() {
        // api
        let api = Api.request(.noteSouvenirUpdateForeign(year: year, souvenir: souvenir.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                let souvenir = data.souvenir
                                NotifyHelper.post(NotifyHelper.TAG_SOUVENIR_DETAIL_REFRESH, obj: souvenir)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
}
