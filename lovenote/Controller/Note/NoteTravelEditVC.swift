//
//  NoteTravelEditVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/2.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteTravelEditVC: BaseVC, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    lazy var barVerticalMargin = ScreenUtils.heightFit(15)
    lazy var barIconMargin = ScreenUtils.widthFit(5)
    
    // view
    private var scroll: UIScrollView!
    private var tfTitle: UITextField!
    private var vHappenAt: UIView!
    private var lHappenAt: UILabel!
    private var vPlaceLine: UIView!
    private var tablePlace: UITableView!
    private var vPlaceAdd: UIView!
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
    private var travel: Travel?
    private var travelOld: Travel!
    private let tagPlace: Int = 1
    private let tagAlbum: Int = 2
    private let tagVideo: Int = 3
    private let tagFood: Int = 4
    private let tagMovie: Int = 5
    private let tagDiary: Int = 6
    
    public static func pushVC(travel: Travel? = nil) {
        AppDelegate.runOnMainAsync {
            let vc = NoteTravelEditVC(nibName: nil, bundle: nil)
            if travel == nil {
                vc.actFrom = ACT_EDIT_FROM_ADD
            } else {
                vc.actFrom = ACT_EDIT_FROM_UPDATE
                vc.travel = travel
                // 需要拷贝可编辑的数据
                vc.travelOld = Travel()
                vc.travelOld.title = travel!.title
                vc.travelOld.happenAt = travel!.happenAt
                vc.travelOld.travelPlaceList = travel!.travelPlaceList
                vc.travelOld.travelAlbumList = travel!.travelAlbumList
                vc.travelOld.travelVideoList = travel!.travelVideoList
                vc.travelOld.travelFoodList = travel!.travelFoodList
                vc.travelOld.travelMovieList = travel!.travelMovieList
                vc.travelOld.travelDiaryList = travel!.travelDiaryList
            }
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "travel")
        let barItemCommit = UIBarButtonItem(title: StringUtils.getString("commit"), style: .plain, target: self, action: #selector(checkPush))
        barItemCommit.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        self.navigationItem.setRightBarButtonItems([barItemCommit], animated: true)
        
        // title
        tfTitle = ViewHelper.getTextField(width: maxWidth, paddingV: ScreenUtils.heightFit(10), textSize: ViewHelper.FONT_SIZE_NORMAL, textColor: ColorHelper.getFontGrey(), placeholder: StringUtils.getString("please_input_title"), placeColor: ColorHelper.getFontHint())
        tfTitle.frame.origin = CGPoint(x: margin, y: margin * 2)
        
        // happenAt
        let vLineHappenAt = ViewHelper.getViewLine(width: maxWidth)
        vLineHappenAt.frame.origin = CGPoint(x: margin, y: 0)
        lHappenAt = ViewHelper.getLabelGreyNormal(width: maxWidth, text: StringUtils.getString("time_colon_space_holder"), lines: 1, align: .left, mode: .byTruncatingMiddle)
        let ivHappenAt = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_access_time_grey_18dp"), color: ColorHelper.getFontGrey()), width: lHappenAt.frame.size.height, height: lHappenAt.frame.size.height, mode: .scaleAspectFit)
        ivHappenAt.frame.origin = CGPoint(x: margin, y: barVerticalMargin)
        lHappenAt.frame.size.width = screenWidth - ivHappenAt.frame.origin.x - ivHappenAt.frame.size.width - barIconMargin - margin
        lHappenAt.frame.origin = CGPoint(x: ivHappenAt.frame.origin.x + ivHappenAt.frame.size.width + barIconMargin, y: barVerticalMargin)
        vHappenAt = UIView(frame: CGRect(x: 0, y: tfTitle.frame.origin.y + tfTitle.frame.size.height + ScreenUtils.heightFit(30), width: screenWidth, height: ivHappenAt.frame.size.height + barVerticalMargin * 2))
        
        vHappenAt.addSubview(vLineHappenAt)
        vHappenAt.addSubview(ivHappenAt)
        vHappenAt.addSubview(lHappenAt)
        
        // place-line
        let lPlace = ViewHelper.getLabelGreySmall(text: StringUtils.getString("track"))
        lPlace.center.x = screenWidth / 2
        lPlace.frame.origin.y = 0
        let linePlaceLeft = ViewHelper.getViewLine(width: (maxWidth - lPlace.frame.size.width) / 2 - margin)
        linePlaceLeft.frame.origin.x = margin
        linePlaceLeft.center.y = lPlace.center.y
        let linePlaceRight = ViewHelper.getViewLine(width: (maxWidth - lPlace.frame.size.width) / 2 - margin)
        linePlaceRight.frame.origin.x = lPlace.frame.origin.x + lPlace.frame.size.width + margin
        linePlaceRight.center.y = lPlace.center.y
        vPlaceLine = UIView(frame: CGRect(x: 0, y: vHappenAt.frame.origin.y + vHappenAt.frame.size.height + ScreenUtils.heightFit(40), width: screenWidth, height: lPlace.frame.size.height))
        vPlaceLine.addSubview(lPlace)
        vPlaceLine.addSubview(linePlaceLeft)
        vPlaceLine.addSubview(linePlaceRight)
        
        // place-table
        tablePlace = ViewUtils.getTableView(target: self, frame: CGRect(x: 0, y: vPlaceLine.frame.origin.y + vPlaceLine.frame.size.height + margin, width: screenWidth, height: CGFloat(0)), cellCls: NoteTravelPlaceCell.self, id: NoteTravelPlaceCell.ID)
        tablePlace.tag = tagPlace
        
        // place-add
        let lPlaceAdd = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("add_track"), lines: 1, mode: .byTruncatingMiddle)
        lPlaceAdd.center.x = screenWidth / 2
        let placeAddHeight = lPlaceAdd.frame.size.height + margin * 4
        lPlaceAdd.center.y = placeAddHeight / 2
        let ivPlaceAdd = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_add_circle_outline_grey_18dp"), color: ColorHelper.getFontGrey()), width: lPlaceAdd.frame.size.height, height: lPlaceAdd.frame.size.height, mode: .scaleAspectFit)
        ivPlaceAdd.frame.origin.x = lPlaceAdd.frame.origin.x - margin - ivPlaceAdd.frame.size.width
        ivPlaceAdd.center.y = placeAddHeight / 2
        vPlaceAdd = UIView(frame: CGRect(x: 0, y: tablePlace.frame.origin.y + tablePlace.frame.size.height + margin, width: screenWidth, height: placeAddHeight))
        vPlaceAdd.tag = tagPlace
        vPlaceAdd.addSubview(ivPlaceAdd)
        vPlaceAdd.addSubview(lPlaceAdd)
        
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
        vAlbumLine = UIView(frame: CGRect(x: 0, y: vPlaceAdd.frame.origin.y + vPlaceAdd.frame.size.height + ScreenUtils.heightFit(20), width: screenWidth, height: lAlbum.frame.size.height))
        vAlbumLine.addSubview(lAlbum)
        vAlbumLine.addSubview(lineAlbumLeft)
        vAlbumLine.addSubview(lineAlbumRight)
        
        // album-table
        tableAlbum = ViewUtils.getTableView(target: self, frame: CGRect(x: 0, y: vAlbumLine.frame.origin.y + vAlbumLine.frame.size.height + margin, width: screenWidth, height: CGFloat(0)), cellCls: NoteAlbumCell.self, id: NoteAlbumCell.ID)
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
        collectVideo = ViewUtils.getCollectionView(target: self, frame: CGRect(x: 0, y: vVideoLine.frame.origin.y + vVideoLine.frame.size.height + margin, width: screenWidth, height: CGFloat(0)), layout: layoutVideo, cellCls: NoteVideoCell.self, id: NoteVideoCell.ID)
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
        tableFood = ViewUtils.getTableView(target: self, frame: CGRect(x: 0, y: vFoodLine.frame.origin.y + vFoodLine.frame.size.height + margin, width: screenWidth, height: CGFloat(0)), cellCls: NoteFoodCell.self, id: NoteFoodCell.ID)
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
        tableMovie = ViewUtils.getTableView(target: self, frame: CGRect(x: 0, y: vMovieLine.frame.origin.y + vMovieLine.frame.size.height + margin, width: screenWidth, height: CGFloat(0)), cellCls: NoteMovieCell.self, id: NoteMovieCell.ID)
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
        tableDiary = ViewUtils.getTableView(target: self, frame: CGRect(x: 0, y: vDiaryLine.frame.origin.y + vDiaryLine.frame.size.height + margin, width: screenWidth, height: CGFloat(0)), cellCls: NoteDiaryCell.self, id: NoteDiaryCell.ID)
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
        
        scroll.addSubview(tfTitle)
        scroll.addSubview(vHappenAt)
        scroll.addSubview(vPlaceLine)
        scroll.addSubview(tablePlace)
        scroll.addSubview(vPlaceAdd)
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
        tablePlace.isHidden = true
        vPlaceAdd.isHidden = true
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
        ViewUtils.addViewTapTarget(target: self, view: vHappenAt, action: #selector(showDatePicker))
        ViewUtils.addViewTapTarget(target: self, view: vPlaceAdd, action: #selector(targetSelect))
        ViewUtils.addViewTapTarget(target: self, view: vAlbumAdd, action: #selector(targetSelect))
        ViewUtils.addViewTapTarget(target: self, view: vVideoAdd, action: #selector(targetSelect))
        ViewUtils.addViewTapTarget(target: self, view: vFoodAdd, action: #selector(targetSelect))
        ViewUtils.addViewTapTarget(target: self, view: vMovieAdd, action: #selector(targetSelect))
        ViewUtils.addViewTapTarget(target: self, view: vDiaryAdd, action: #selector(targetSelect))
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyPlaceSelect), name: NotifyHelper.TAG_TRAVEL_EDIT_ADD_PLACE)
        NotifyHelper.addObserver(self, selector: #selector(notifyAlbumSelect), name: NotifyHelper.TAG_ALBUM_SELECT)
        NotifyHelper.addObserver(self, selector: #selector(notifyVideoSelect), name: NotifyHelper.TAG_VIDEO_SELECT)
        NotifyHelper.addObserver(self, selector: #selector(notifyFoodSelect), name: NotifyHelper.TAG_FOOD_SELECT)
        NotifyHelper.addObserver(self, selector: #selector(notifyMovieSelect), name: NotifyHelper.TAG_MOVIE_SELECT)
        NotifyHelper.addObserver(self, selector: #selector(notifyDiarySelect), name: NotifyHelper.TAG_DIARY_SELECT)
        NotifyHelper.addObserver(self, selector: #selector(notifyAlbumItemDelete), name: NotifyHelper.TAG_ALBUM_LIST_ITEM_DELETE)
        NotifyHelper.addObserver(self, selector: #selector(notifyAlbumItemRefresh), name: NotifyHelper.TAG_ALBUM_LIST_ITEM_REFRESH)
        NotifyHelper.addObserver(self, selector: #selector(notifyDiaryItemDelete), name: NotifyHelper.TAG_DIARY_LIST_ITEM_DELETE)
        NotifyHelper.addObserver(self, selector: #selector(notifyDiaryItemRefresh), name: NotifyHelper.TAG_DIARY_LIST_ITEM_REFRESH)
        // init
        if travel == nil {
            travel = Travel()
        }
        if travel?.happenAt == 0 {
            travel?.happenAt = DateUtils.getCurrentInt64()
        }
        // title
        let placeholder = StringUtils.getString("please_input_title_no_over_holder_text", arguments: [UDHelper.getLimit().travelTitleLength])
        ViewUtils.setTextFiledPlaceholder(textField: tfTitle, placeholder: placeholder)
        tfTitle.text = travel?.title
        // date
        refreshDateView()
        // list
        refreshListView()
    }
    
    @objc func notifyPlaceSelect(notify: NSNotification) {
        if let place = notify.object as? TravelPlace {
            place.status = BaseObj.STATUS_VISIBLE
            travel?.travelPlaceList.append(place)
            // view
            refreshListView()
        }
    }
    
    @objc func notifyAlbumSelect(notify: NSNotification) {
        if let album = notify.object as? Album {
            let albumList = ListHelper.getAlbumListByTravel(travelAlbumList: travel?.travelAlbumList, checkStatus: true)
            if ListHelper.findIndexByIdInList(list: albumList, obj: album) < 0 {
                let travelAlbum = TravelAlbum()
                travelAlbum.status = BaseObj.STATUS_VISIBLE
                travelAlbum.albumId = album.id
                travelAlbum.album = album
                travel?.travelAlbumList.append(travelAlbum)
                // view
                refreshListView()
            }
        }
    }
    
    @objc func notifyVideoSelect(notify: NSNotification) {
        if let video = notify.object as? Video {
            let videoList = ListHelper.getVideoListByTravel(travelVideoList: travel?.travelVideoList, checkStatus: true)
            if ListHelper.findIndexByIdInList(list: videoList, obj: video) < 0 {
                let travelVideo = TravelVideo()
                travelVideo.status = BaseObj.STATUS_VISIBLE
                travelVideo.videoId = video.id
                travelVideo.video = video
                travel?.travelVideoList.append(travelVideo)
                // view
                refreshListView()
            }
        }
    }
    
    @objc func notifyFoodSelect(notify: NSNotification) {
        if let food = notify.object as? Food {
            let foodList = ListHelper.getFoodListByTravel(travelFoodList: travel?.travelFoodList, checkStatus: true)
            if ListHelper.findIndexByIdInList(list: foodList, obj: food) < 0 {
                let travelFood = TravelFood()
                travelFood.status = BaseObj.STATUS_VISIBLE
                travelFood.foodId = food.id
                travelFood.food = food
                travel?.travelFoodList.append(travelFood)
                // view
                refreshListView()
            }
        }
    }
    
    @objc func notifyMovieSelect(notify: NSNotification) {
        if let movie = notify.object as? Movie {
            let movieList = ListHelper.getMovieListByTravel(travelMovieList: travel?.travelMovieList, checkStatus: true)
            if ListHelper.findIndexByIdInList(list: movieList, obj: movie) < 0 {
                let travelMovie = TravelMovie()
                travelMovie.status = BaseObj.STATUS_VISIBLE
                travelMovie.movieId = movie.id
                travelMovie.movie = movie
                travel?.travelMovieList.append(travelMovie)
                // view
                refreshListView()
            }
        }
    }
    
    @objc func notifyDiarySelect(notify: NSNotification) {
        if let diary = notify.object as? Diary {
            let diaryList = ListHelper.getDiaryListByTravel(travelDiaryList: travel?.travelDiaryList, checkStatus: true)
            if ListHelper.findIndexByIdInList(list: diaryList, obj: diary) < 0 {
                let travelDiary = TravelDiary()
                travelDiary.status = BaseObj.STATUS_VISIBLE
                travelDiary.diaryId = diary.id
                travelDiary.diary = diary
                travel?.travelDiaryList.append(travelDiary)
                // view
                refreshListView()
            }
        }
    }
    
    @objc func notifyAlbumItemDelete(notify: NSNotification) {
        if let album = notify.object as? Album {
            for travelAlbum in travel!.travelAlbumList {
                if travelAlbum.status == BaseObj.STATUS_DELETE {
                    continue
                } else if travelAlbum.albumId == album.id {
                    travelAlbum.status = BaseObj.STATUS_DELETE
                }
            }
            refreshListView()
        }
    }
    
    @objc func notifyAlbumItemRefresh(notify: NSNotification) {
        if let album = notify.object as? Album {
            for travelAlbum in travel!.travelAlbumList {
                if travelAlbum.status == BaseObj.STATUS_DELETE {
                    continue
                } else if travelAlbum.albumId == album.id {
                    travelAlbum.album = album
                }
            }
            refreshListView()
        }
    }
    
    @objc func notifyDiaryItemDelete(notify: NSNotification) {
        if let diary = notify.object as? Diary {
            for travelDiary in travel!.travelDiaryList {
                if travelDiary.status == BaseObj.STATUS_DELETE {
                    continue
                } else if travelDiary.diaryId == diary.id {
                    travelDiary.status = BaseObj.STATUS_DELETE
                }
            }
            refreshListView()
        }
    }
    
    @objc func notifyDiaryItemRefresh(notify: NSNotification) {
        if let diary = notify.object as? Diary {
            for travelDiary in travel!.travelDiaryList {
                if travelDiary.status == BaseObj.STATUS_DELETE {
                    continue
                } else if travelDiary.diaryId == diary.id {
                    travelDiary.diary = diary
                }
            }
            refreshListView()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == tagPlace {
            let placeList = ListHelper.getPlaceListByTravel(travelPlaceList: travel?.travelPlaceList, checkStatus: true)
            return placeList.count
        } else if tableView.tag == tagAlbum {
            let albumList = ListHelper.getAlbumListByTravel(travelAlbumList: travel?.travelAlbumList, checkStatus: true)
            return albumList.count
        } else if tableView.tag == tagFood {
            let foodList = ListHelper.getFoodListByTravel(travelFoodList: travel?.travelFoodList, checkStatus: true)
            return foodList.count
        } else if tableView.tag == tagMovie {
            let movieList = ListHelper.getMovieListByTravel(travelMovieList: travel?.travelMovieList, checkStatus: true)
            return movieList.count
        } else if tableView.tag == tagDiary {
            let diaryList = ListHelper.getDiaryListByTravel(travelDiaryList: travel?.travelDiaryList, checkStatus: true)
            return diaryList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == tagPlace {
            let placeList = ListHelper.getPlaceListByTravel(travelPlaceList: travel?.travelPlaceList, checkStatus: true)
            return NoteTravelPlaceCell.getHeightByData(travelPlace: placeList[indexPath.row])
        } else if tableView.tag == tagAlbum {
            return NoteAlbumCell.getCellHeight()
        } else if tableView.tag == tagFood {
            let foodList = ListHelper.getFoodListByTravel(travelFoodList: travel?.travelFoodList, checkStatus: true)
            return NoteFoodCell.getHeightByData(food: foodList[indexPath.row])
        } else if tableView.tag == tagMovie {
            let movieList = ListHelper.getMovieListByTravel(travelMovieList: travel?.travelMovieList, checkStatus: true)
            return NoteMovieCell.getHeightByData(movie: movieList[indexPath.row])
        } else if tableView.tag == tagDiary {
            let diaryList = ListHelper.getDiaryListByTravel(travelDiaryList: travel?.travelDiaryList, checkStatus: true)
            return NoteDiaryCell.getHeightByData(diary: diaryList[indexPath.row])
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == tagPlace {
            let placeList = ListHelper.getPlaceListByTravel(travelPlaceList: travel?.travelPlaceList, checkStatus: true)
            return NoteTravelPlaceCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: placeList, target: self, actionEdit: #selector(targetShowListDeleteAlert))
        } else if tableView.tag == tagAlbum {
            let albumList = ListHelper.getAlbumListByTravel(travelAlbumList: travel?.travelAlbumList, checkStatus: true)
            return NoteAlbumCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: albumList, target: self, actionEdit: #selector(targetShowListDeleteAlert))
        } else if tableView.tag == tagFood {
            let foodList = ListHelper.getFoodListByTravel(travelFoodList: travel?.travelFoodList, checkStatus: true)
            return NoteFoodCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: foodList, heightMap: false, target: self, actionEdit: #selector(targetShowListDeleteAlert), actionAddress: #selector(targetFoodGoMap))
        } else if tableView.tag == tagMovie {
            let movieList = ListHelper.getMovieListByTravel(travelMovieList: travel?.travelMovieList, checkStatus: true)
            return NoteMovieCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: movieList, heightMap: false, target: self, actionEdit: #selector(targetShowListDeleteAlert), actionAddress: #selector(targetMovieGoMap))
        } else if tableView.tag == tagDiary {
            let diaryList = ListHelper.getDiaryListByTravel(travelDiaryList: travel?.travelDiaryList, checkStatus: true)
            return NoteDiaryCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: diaryList, heightMap: false, target: self, actionEdit: #selector(targetShowListDeleteAlert))
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == tagPlace {
            let placeList = ListHelper.getPlaceListByTravel(travelPlaceList: travel?.travelPlaceList, checkStatus: true)
            NoteTravelPlaceCell.goMap(view: tableView, indexPath: indexPath, dataList: placeList)
        } else if tableView.tag == tagAlbum {
            let albumList = ListHelper.getAlbumListByTravel(travelAlbumList: travel?.travelAlbumList, checkStatus: true)
            NoteAlbumCell.goPictureList(view: tableView, indexPath: indexPath, dataList: albumList)
        } else if tableView.tag == tagDiary {
            let diaryList = ListHelper.getDiaryListByTravel(travelDiaryList: travel?.travelDiaryList, checkStatus: true)
            NoteDiaryCell.goDiaryDetail(view: tableView, indexPath: indexPath, dataList: diaryList)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == tagVideo {
            let videoList = ListHelper.getVideoListByTravel(travelVideoList: travel?.travelVideoList, checkStatus: true)
            return videoList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == tagVideo {
            let videoList = ListHelper.getVideoListByTravel(travelVideoList: travel?.travelVideoList, checkStatus: true)
            return NoteVideoCell.getCellWithData(view: collectionView, indexPath: indexPath, dataList: videoList, target: self, actionAddress: #selector(targetVideoGoMap), actionMore: #selector(targetShowListDeleteAlert))
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == tagVideo {
            let videoList = ListHelper.getVideoListByTravel(travelVideoList: travel?.travelVideoList, checkStatus: true)
            NoteVideoCell.goPlay(view: collectionView, indexPath: indexPath, dataList: videoList)
        }
    }
    
    override func canPop() -> Bool {
        // 更新，返还原来的值
        if isFromUpdate() {
            travel?.title = travelOld.title
            travel?.happenAt = travelOld.happenAt
            travel?.travelPlaceList = travelOld.travelPlaceList
            travel?.travelAlbumList = travelOld.travelAlbumList
            travel?.travelVideoList = travelOld.travelVideoList
            travel?.travelFoodList = travelOld.travelFoodList
            travel?.travelMovieList = travelOld.travelMovieList
            travel?.travelDiaryList = travelOld.travelDiaryList
        }
        return true
    }
    
    func isFromUpdate() -> Bool {
        return actFrom == BaseVC.ACT_EDIT_FROM_UPDATE
    }
    
    @objc func showDatePicker() {
        _ = AlertHelper.showDatePicker(mode: .date, date: travel?.happenAt, actionHandler: { (_, _, _, picker) in
            self.travel?.happenAt = DateUtils.getInt64(picker.date)
            self.refreshDateView()
        }, cancelHandler: nil)
    }
    
    func refreshDateView() {
        let happen = TimeHelper.getTimeShowLine_HM_MD_YMD_ByGo(travel?.happenAt ?? DateUtils.getCurrentInt64())
        lHappenAt.text = StringUtils.getString("time_colon_space_holder", arguments: [happen])
    }
    
    func refreshListView() {
        // place
        let placeList = ListHelper.getPlaceListByTravel(travelPlaceList: travel?.travelPlaceList, checkStatus: true)
        tablePlace.isHidden = placeList.count <= 0
        vPlaceAdd.isHidden = UDHelper.getLimit().travelPlaceCount <= placeList.count
        tablePlace.frame.size.height = NoteTravelPlaceCell.getMuliCellHeight(dataList: placeList)
        tablePlace.reloadData()
        vPlaceAdd.frame.origin.y = tablePlace.frame.origin.y + tablePlace.frame.size.height + margin
        // album
        let albumList = ListHelper.getAlbumListByTravel(travelAlbumList: travel?.travelAlbumList, checkStatus: true)
        tableAlbum.isHidden = albumList.count <= 0
        vAlbumAdd.isHidden = UDHelper.getLimit().travelAlbumCount <= albumList.count
        vAlbumLine.frame.origin.y = vPlaceAdd.isHidden ? vPlaceAdd.frame.origin.y + margin : vPlaceAdd.frame.origin.y + vPlaceAdd.frame.size.height + ScreenUtils.heightFit(20)
        tableAlbum.frame.origin.y = vAlbumLine.frame.origin.y + vAlbumLine.frame.size.height + margin
        tableAlbum.frame.size.height = NoteAlbumCell.getMuliCellHeight(dataList: albumList)
        tableAlbum.reloadData()
        vAlbumAdd.frame.origin.y = tableAlbum.frame.origin.y + tableAlbum.frame.size.height + margin
        // video
        let videoList = ListHelper.getVideoListByTravel(travelVideoList: travel?.travelVideoList, checkStatus: true)
        collectVideo.isHidden = videoList.count <= 0
        vVideoAdd.isHidden = UDHelper.getLimit().travelVideoCount <= videoList.count
        vVideoLine.frame.origin.y = vAlbumAdd.isHidden ? vAlbumAdd.frame.origin.y + margin : vAlbumAdd.frame.origin.y + vAlbumAdd.frame.size.height + ScreenUtils.heightFit(20)
        collectVideo.frame.origin.y = vVideoLine.frame.origin.y + vVideoLine.frame.size.height + margin
        collectVideo.frame.size.height = NoteVideoCell.getMuliCellHeight(dataList: videoList)
        collectVideo.reloadData()
        vVideoAdd.frame.origin.y = collectVideo.frame.origin.y + collectVideo.frame.size.height + margin
        // food
        let foodList = ListHelper.getFoodListByTravel(travelFoodList: travel?.travelFoodList, checkStatus: true)
        tableFood.isHidden = foodList.count <= 0
        vFoodAdd.isHidden = UDHelper.getLimit().travelFoodCount <= foodList.count
        vFoodLine.frame.origin.y = vVideoAdd.isHidden ? vVideoAdd.frame.origin.y + margin : vVideoAdd.frame.origin.y + vVideoAdd.frame.size.height + ScreenUtils.heightFit(20)
        tableFood.frame.origin.y = vFoodLine.frame.origin.y + vFoodLine.frame.size.height + margin
        tableFood.frame.size.height = NoteFoodCell.getMuliCellHeight(dataList: foodList)
        tableFood.reloadData()
        vFoodAdd.frame.origin.y = tableFood.frame.origin.y + tableFood.frame.size.height + margin
        // movie
        let movieList = ListHelper.getMovieListByTravel(travelMovieList: travel?.travelMovieList, checkStatus: true)
        tableMovie.isHidden = movieList.count <= 0
        vMovieAdd.isHidden = UDHelper.getLimit().travelMovieCount <= movieList.count
        vMovieLine.frame.origin.y = vFoodAdd.isHidden ? vFoodAdd.frame.origin.y + margin : vFoodAdd.frame.origin.y + vFoodAdd.frame.size.height + ScreenUtils.heightFit(20)
        tableMovie.frame.origin.y = vMovieLine.frame.origin.y + vMovieLine.frame.size.height + margin
        tableMovie.frame.size.height = NoteMovieCell.getMuliCellHeight(dataList: movieList)
        tableMovie.reloadData()
        vMovieAdd.frame.origin.y = tableMovie.frame.origin.y + tableMovie.frame.size.height + margin
        // diary
        let diaryList = ListHelper.getDiaryListByTravel(travelDiaryList: travel?.travelDiaryList, checkStatus: true)
        tableDiary.isHidden = diaryList.count <= 0
        vDiaryAdd.isHidden = UDHelper.getLimit().travelDiaryCount <= diaryList.count
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
        if tag == tagPlace {
            NoteTravelPlaceEditVC.pushVC()
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
        if travel == nil {
            return
        }
        var tag = view.tag
        if let tableView = ViewUtils.findSuperTable(view: view) {
            tag = tableView.tag
        } else if let collectView = ViewUtils.findSuperCollect(view: view) {
            tag = collectView.tag
        }
        if tag == tagPlace {
            if let indexPath = ViewUtils.findTableIndexPath(view: view) {
                var jumpIndex = 0
                for (index, travelPlace) in travel!.travelPlaceList.enumerated() {
                    if travelPlace.status == BaseObj.STATUS_DELETE {
                        jumpIndex += 1
                        continue
                    } else if (index - jumpIndex) == indexPath.row {
                        travelPlace.status = BaseObj.STATUS_DELETE
                        break
                    }
                }
            }
        } else if tag == tagAlbum {
            if let indexPath = ViewUtils.findTableIndexPath(view: view) {
                var jumpIndex = 0
                for (index, travelAlbum) in travel!.travelAlbumList.enumerated() {
                    if travelAlbum.status == BaseObj.STATUS_DELETE {
                        jumpIndex += 1
                        continue
                    } else if (index - jumpIndex) == indexPath.row {
                        travelAlbum.status = BaseObj.STATUS_DELETE
                        break
                    }
                }
            }
        } else if tag == tagVideo {
            if let indexPath = ViewUtils.findCollectIndexPath(view: view) {
                var jumpIndex = 0
                for (index, travelVideo) in travel!.travelVideoList.enumerated() {
                    if travelVideo.status == BaseObj.STATUS_DELETE {
                        jumpIndex += 1
                        continue
                    } else if (index - jumpIndex) == indexPath.row {
                        travelVideo.status = BaseObj.STATUS_DELETE
                        break
                    }
                }
            }
        } else if tag == tagFood {
            if let indexPath = ViewUtils.findTableIndexPath(view: view) {
                var jumpIndex = 0
                for (index, travelFood) in travel!.travelFoodList.enumerated() {
                    if travelFood.status == BaseObj.STATUS_DELETE {
                        jumpIndex += 1
                        continue
                    } else if (index - jumpIndex) == indexPath.row {
                        travelFood.status = BaseObj.STATUS_DELETE
                        break
                    }
                }
            }
        } else if tag == tagMovie {
            if let indexPath = ViewUtils.findTableIndexPath(view: view) {
                var jumpIndex = 0
                for (index, travelMovie) in travel!.travelMovieList.enumerated() {
                    if travelMovie.status == BaseObj.STATUS_DELETE {
                        jumpIndex += 1
                        continue
                    } else if (index - jumpIndex) == indexPath.row {
                        travelMovie.status = BaseObj.STATUS_DELETE
                        break
                    }
                }
            }
        } else if tag == tagDiary {
            if let indexPath = ViewUtils.findTableIndexPath(view: view) {
                var jumpIndex = 0
                for (index, travelDiary) in travel!.travelDiaryList.enumerated() {
                    if travelDiary.status == BaseObj.STATUS_DELETE {
                        jumpIndex += 1
                        continue
                    } else if (index - jumpIndex) == indexPath.row {
                        travelDiary.status = BaseObj.STATUS_DELETE
                        break
                    }
                }
            }
        }
        refreshListView()
    }
    
    @objc func targetVideoGoMap(sender: UIButton) {
        let videoList = ListHelper.getVideoListByTravel(travelVideoList: travel?.travelVideoList, checkStatus: true)
        NoteVideoCell.goMap(view: sender, dataList: videoList)
    }
    
    @objc func targetFoodGoMap(sender: UIGestureRecognizer) {
        let foodList = ListHelper.getFoodListByTravel(travelFoodList: travel?.travelFoodList, checkStatus: true)
        NoteFoodCell.goMap(view: sender.view, dataList: foodList)
    }
    
    @objc func targetMovieGoMap(sender: UIGestureRecognizer) {
        let movieList = ListHelper.getMovieListByTravel(travelMovieList: travel?.travelMovieList, checkStatus: true)
        NoteMovieCell.goMap(view: sender.view, dataList: movieList)
    }
    
    @objc func checkPush() {
        if travel == nil {
            return
        }
        // title
        if StringUtils.isEmpty(tfTitle.text) {
            ToastUtils.show(tfTitle.placeholder)
            return
        } else if (tfTitle.text?.count ?? 0) > UDHelper.getLimit().travelTitleLength {
            ToastUtils.show(tfTitle.placeholder)
            return
        }
        travel?.title = tfTitle.text ?? ""
        if isFromUpdate() {
            updateApi()
        } else {
            addApi()
        }
    }
    
    func updateApi() {
        if travel == nil {
            return
        }
        let api = Api.request(.noteTravelUpdate(travel: travel?.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                let travel = data.travel
                                NotifyHelper.post(NotifyHelper.TAG_TRAVEL_LIST_ITEM_REFRESH, obj: travel)
                                NotifyHelper.post(NotifyHelper.TAG_TRAVEL_DETAIL_REFRESH, obj: travel)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
    func addApi() {
        if travel == nil {
            return
        }
        let api = Api.request(.noteTravelAdd(travel: travel?.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_TRAVEL_LIST_REFRESH, obj: nil)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
}
