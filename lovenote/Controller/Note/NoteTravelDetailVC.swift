//
//  NoteTravelDetailVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/2.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteTravelDetailVC: BaseVC, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    
    // view
    private var scroll: UIScrollView!
    private var vTop: UIView!
    private var lTitle: UILabel!
    private var lHappenAt: UILabel!
    private var lCreator: UILabel!
    private var vPlaceLine: UIView!
    private var tablePlace: UITableView!
    private var vAlbumLine: UIView!
    private var tableAlbum: UITableView!
    private var vVideoLine: UIView!
    private var collectVideo: UICollectionView!
    private var vFoodLine: UIView!
    private var tableFood: UITableView!
    private var vMovieLine: UIView!
    private var tableMovie: UITableView!
    private var vDiaryLine: UIView!
    private var tableDiary: UITableView!
    
    // var
    private var travel: Travel?
    private var tid: Int64 = 0
    private let tagPlace: Int = 1
    private let tagAlbum: Int = 2
    private let tagVideo: Int = 3
    private let tagFood: Int = 4
    private let tagMovie: Int = 5
    private let tagDiary: Int = 6
    
    public static func pushVC(travel: Travel? = nil, tid: Int64 = 0) {
        AppDelegate.runOnMainAsync {
            let vc = NoteTravelDetailVC(nibName: nil, bundle: nil)
            vc.travel = travel
            vc.tid = tid
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "travel")
        let barItemEdit = UIBarButtonItem(image: UIImage(named: "ic_edit_white_24dp"), style: .plain, target: self, action: #selector(targetGoEdit))
        let barItemDel = UIBarButtonItem(image: UIImage(named: "ic_delete_white_24dp"), style: .plain, target: self, action: #selector(showDeleteAlert))
        self.navigationItem.setRightBarButtonItems([barItemEdit, barItemDel], animated: true)
        
        // title
        lTitle = ViewHelper.getLabelBold(width: maxWidth - margin * 2, text: "-", size: ViewHelper.FONT_SIZE_HUGE, color: ColorHelper.getFontWhite(), lines: 1, align: .center, mode: .byTruncatingMiddle)
        lTitle.frame.origin = CGPoint(x: margin, y: margin)
        
        // happen
        lHappenAt = ViewHelper.getLabelWhiteNormal(width: (maxWidth - margin * 3) / 2, text: "-", lines: 1, align: .left, mode: .byTruncatingMiddle)
        lHappenAt.frame.origin = CGPoint(x: margin, y: lTitle.frame.origin.y + lTitle.frame.size.height + ScreenUtils.heightFit(20))
        
        // creator
        lCreator = ViewHelper.getLabelWhiteNormal(width: (maxWidth - margin * 3) / 2, text: "-", lines: 1, align: .right, mode: .byTruncatingMiddle)
        lCreator.frame.origin.x = lHappenAt.frame.origin.x + lHappenAt.frame.size.width + margin
        lCreator.frame.origin.y = lTitle.frame.origin.y + lTitle.frame.size.height + ScreenUtils.heightFit(20)
        
        // top
        vTop = UIView(frame: CGRect(x: margin, y: margin, width: maxWidth, height: lHappenAt.frame.origin.y + lHappenAt.frame.size.height + margin))
        vTop.backgroundColor = ThemeHelper.getColorPrimary()
        ViewUtils.setViewRadius(vTop, radius: ViewHelper.RADIUS_BIG)
        ViewUtils.setViewShadow(vTop, offset: ViewHelper.SHADOW_BIG)
        vTop.addSubview(lTitle)
        vTop.addSubview(lHappenAt)
        vTop.addSubview(lCreator)
        
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
        vPlaceLine = UIView(frame: CGRect(x: 0, y: vTop.frame.origin.y + vTop.frame.size.height + ScreenUtils.heightFit(40), width: screenWidth, height: lPlace.frame.size.height))
        vPlaceLine.addSubview(lPlace)
        vPlaceLine.addSubview(linePlaceLeft)
        vPlaceLine.addSubview(linePlaceRight)
        
        // place-table
        tablePlace = ViewUtils.getTableView(target: self, frame: CGRect(x: 0, y: vPlaceLine.frame.origin.y + vPlaceLine.frame.size.height + margin, width: screenWidth, height: CGFloat(0)), cellCls: NoteTravelPlaceCell.self, id: NoteTravelPlaceCell.ID)
        tablePlace.tag = tagPlace
        
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
        vAlbumLine = UIView(frame: CGRect(x: 0, y: lHappenAt.frame.origin.y + lHappenAt.frame.size.height + ScreenUtils.heightFit(20), width: screenWidth, height: lAlbum.frame.size.height))
        vAlbumLine.addSubview(lAlbum)
        vAlbumLine.addSubview(lineAlbumLeft)
        vAlbumLine.addSubview(lineAlbumRight)
        
        // album-table
        tableAlbum = ViewUtils.getTableView(target: self, frame: CGRect(x: 0, y: vAlbumLine.frame.origin.y + vAlbumLine.frame.size.height + margin, width: screenWidth, height: CGFloat(0)), cellCls: NoteAlbumCell.self, id: NoteAlbumCell.ID)
        tableAlbum.tag = tagAlbum
        
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
        vVideoLine = UIView(frame: CGRect(x: 0, y: lHappenAt.frame.origin.y + lHappenAt.frame.size.height + ScreenUtils.heightFit(20), width: screenWidth, height: lVideo.frame.size.height))
        vVideoLine.addSubview(lVideo)
        vVideoLine.addSubview(lineVideoLeft)
        vVideoLine.addSubview(lineVideoRight)
        
        // video-table
        let layoutVideo = NoteVideoCell.getLayout()
        collectVideo = ViewUtils.getCollectionView(target: self, frame: CGRect(x: 0, y: vVideoLine.frame.origin.y + vVideoLine.frame.size.height + margin, width: screenWidth, height: CGFloat(0)), layout: layoutVideo, cellCls: NoteVideoCell.self, id: NoteVideoCell.ID)
        collectVideo.tag = tagVideo
        
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
        vFoodLine = UIView(frame: CGRect(x: 0, y: lHappenAt.frame.origin.y + lHappenAt.frame.size.height + ScreenUtils.heightFit(20), width: screenWidth, height: lFood.frame.size.height))
        vFoodLine.addSubview(lFood)
        vFoodLine.addSubview(lineFoodLeft)
        vFoodLine.addSubview(lineFoodRight)
        
        // food-table
        tableFood = ViewUtils.getTableView(target: self, frame: CGRect(x: 0, y: vFoodLine.frame.origin.y + vFoodLine.frame.size.height + margin, width: screenWidth, height: CGFloat(0)), cellCls: NoteFoodCell.self, id: NoteFoodCell.ID)
        tableFood.tag = tagFood
        
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
        vMovieLine = UIView(frame: CGRect(x: 0, y: lHappenAt.frame.origin.y + lHappenAt.frame.size.height + ScreenUtils.heightFit(20), width: screenWidth, height: lMovie.frame.size.height))
        vMovieLine.addSubview(lMovie)
        vMovieLine.addSubview(lineMovieLeft)
        vMovieLine.addSubview(lineMovieRight)
        
        // movie-table
        tableMovie = ViewUtils.getTableView(target: self, frame: CGRect(x: 0, y: vMovieLine.frame.origin.y + vMovieLine.frame.size.height + margin, width: screenWidth, height: CGFloat(0)), cellCls: NoteMovieCell.self, id: NoteMovieCell.ID)
        tableMovie.tag = tagMovie
        
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
        vDiaryLine = UIView(frame: CGRect(x: 0, y: lHappenAt.frame.origin.y + lHappenAt.frame.size.height + ScreenUtils.heightFit(20), width: screenWidth, height: lDiary.frame.size.height))
        vDiaryLine.addSubview(lDiary)
        vDiaryLine.addSubview(lineDiaryLeft)
        vDiaryLine.addSubview(lineDiaryRight)
        
        // diary-table
        tableDiary = ViewUtils.getTableView(target: self, frame: CGRect(x: 0, y: vDiaryLine.frame.origin.y + vDiaryLine.frame.size.height + margin, width: screenWidth, height: CGFloat(0)), cellCls: NoteDiaryCell.self, id: NoteDiaryCell.ID)
        tableDiary.tag = tagDiary
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = tableDiary.frame.origin.y + tableDiary.frame.size.height + ScreenUtils.heightFit(20)
        scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        
        scroll.addSubview(vTop)
        scroll.addSubview(vPlaceLine)
        scroll.addSubview(tablePlace)
        scroll.addSubview(vAlbumLine)
        scroll.addSubview(tableAlbum)
        scroll.addSubview(vVideoLine)
        scroll.addSubview(collectVideo)
        scroll.addSubview(vFoodLine)
        scroll.addSubview(tableFood)
        scroll.addSubview(vMovieLine)
        scroll.addSubview(tableMovie)
        scroll.addSubview(vDiaryLine)
        scroll.addSubview(tableDiary)
        
        // view
        self.view.addSubview(scroll)
        
        // hide
        vPlaceLine.isHidden = true
        tablePlace.isHidden = true
        vAlbumLine.isHidden = true
        tableAlbum.isHidden = true
        vVideoLine.isHidden = true
        collectVideo.isHidden = true
        vFoodLine.isHidden = true
        tableFood.isHidden = true
        vMovieLine.isHidden = true
        tableMovie.isHidden = true
        vDiaryLine.isHidden = true
        tableDiary.isHidden = true
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_TRAVEL_DETAIL_REFRESH)
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_ALBUM_LIST_ITEM_DELETE)
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_ALBUM_LIST_ITEM_REFRESH)
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_DIARY_LIST_ITEM_DELETE)
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_DIARY_LIST_ITEM_REFRESH)
        // init
        if travel != nil {
            refreshView()
            // 没有详情页的，可以不加
            refreshData(tid: travel!.id)
        } else if tid > 0 {
            refreshData(tid: tid)
        } else {
            RootVC.get().popBack()
        }
    }
    
    @objc func notifyRefresh(notify: NSNotification) {
        let t = notify.object as? Travel
        refreshData(tid: t != nil ? t!.id : (travel?.id ?? 0))
    }
    
    func refreshData(tid: Int64) {
        ViewUtils.beginScrollRefresh(scroll)
        // api
        let api = Api.request(.noteTravelGet(tid: tid), success: { (_, _, data) in
            ViewUtils.endScrollRefresh(self.scroll)
            self.travel = data.travel
            self.refreshView()
        }, failure: { (_, _, _) in
            ViewUtils.endScrollRefresh(self.scroll)
        })
        self.pushApi(api)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == tagPlace {
            let placeList = ListHelper.getPlaceListByTravel(travelPlaceList: travel?.travelPlaceList, checkStatus: false)
            return placeList.count
        } else if tableView.tag == tagAlbum {
            let albumList = ListHelper.getAlbumListByTravel(travelAlbumList: travel?.travelAlbumList, checkStatus: false)
            return albumList.count
        } else if tableView.tag == tagFood {
            let foodList = ListHelper.getFoodListByTravel(travelFoodList: travel?.travelFoodList, checkStatus: false)
            return foodList.count
        } else if tableView.tag == tagMovie {
            let movieList = ListHelper.getMovieListByTravel(travelMovieList: travel?.travelMovieList, checkStatus: false)
            return movieList.count
        } else if tableView.tag == tagDiary {
            let diaryList = ListHelper.getDiaryListByTravel(travelDiaryList: travel?.travelDiaryList, checkStatus: false)
            return diaryList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == tagPlace {
            let placeList = ListHelper.getPlaceListByTravel(travelPlaceList: travel?.travelPlaceList, checkStatus: false)
            return NoteTravelPlaceCell.getHeightByData(travelPlace: placeList[indexPath.row])
        } else if tableView.tag == tagAlbum {
            return NoteAlbumCell.getCellHeight()
        } else if tableView.tag == tagFood {
            let foodList = ListHelper.getFoodListByTravel(travelFoodList: travel?.travelFoodList, checkStatus: false)
            return NoteFoodCell.getHeightByData(food: foodList[indexPath.row])
        } else if tableView.tag == tagMovie {
            let movieList = ListHelper.getMovieListByTravel(travelMovieList: travel?.travelMovieList, checkStatus: false)
            return NoteMovieCell.getHeightByData(movie: movieList[indexPath.row])
        } else if tableView.tag == tagDiary {
            let diaryList = ListHelper.getDiaryListByTravel(travelDiaryList: travel?.travelDiaryList, checkStatus: false)
            return NoteDiaryCell.getHeightByData(diary: diaryList[indexPath.row])
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == tagPlace {
            let placeList = ListHelper.getPlaceListByTravel(travelPlaceList: travel?.travelPlaceList, checkStatus: false)
            return NoteTravelPlaceCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: placeList)
        } else if tableView.tag == tagAlbum {
            let albumList = ListHelper.getAlbumListByTravel(travelAlbumList: travel?.travelAlbumList, checkStatus: false)
            return NoteAlbumCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: albumList)
        } else if tableView.tag == tagFood {
            let foodList = ListHelper.getFoodListByTravel(travelFoodList: travel?.travelFoodList, checkStatus: false)
            return NoteFoodCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: foodList, heightMap: false, target: self, actionAddress: #selector(targetFoodGoMap))
        } else if tableView.tag == tagMovie {
            let movieList = ListHelper.getMovieListByTravel(travelMovieList: travel?.travelMovieList, checkStatus: false)
            return NoteMovieCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: movieList, heightMap: false, target: self, actionAddress: #selector(targetMovieGoMap))
        } else if tableView.tag == tagDiary {
            let diaryList = ListHelper.getDiaryListByTravel(travelDiaryList: travel?.travelDiaryList, checkStatus: false)
            return NoteDiaryCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: diaryList, heightMap: false)
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == tagPlace {
            let placeList = ListHelper.getPlaceListByTravel(travelPlaceList: travel?.travelPlaceList, checkStatus: false)
            NoteTravelPlaceCell.goMap(view: tableView, indexPath: indexPath, dataList: placeList)
        } else if tableView.tag == tagAlbum {
            let albumList = ListHelper.getAlbumListByTravel(travelAlbumList: travel?.travelAlbumList, checkStatus: false)
            NoteAlbumCell.goPictureList(view: tableView, indexPath: indexPath, dataList: albumList)
        } else if tableView.tag == tagDiary {
            let diaryList = ListHelper.getDiaryListByTravel(travelDiaryList: travel?.travelDiaryList, checkStatus: false)
            NoteDiaryCell.goDiaryDetail(view: tableView, indexPath: indexPath, dataList: diaryList)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == tagVideo {
            let videoList = ListHelper.getVideoListByTravel(travelVideoList: travel?.travelVideoList, checkStatus: false)
            return videoList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == tagVideo {
            let videoList = ListHelper.getVideoListByTravel(travelVideoList: travel?.travelVideoList, checkStatus: false)
            return NoteVideoCell.getCellWithData(view: collectionView, indexPath: indexPath, dataList: videoList, target: self, actionAddress: #selector(targetVideoGoMap))
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == tagVideo {
            let videoList = ListHelper.getVideoListByTravel(travelVideoList: travel?.travelVideoList, checkStatus: false)
            NoteVideoCell.goPlay(view: collectionView, indexPath: indexPath, dataList: videoList)
        }
    }
    
    func refreshView() {
        if travel == nil {
            return
        }
        let me = UDHelper.getMe()
        // text
        lTitle.text = travel!.title
        lHappenAt.text = TimeHelper.getTimeShowLine_HM_MD_YMD_ByGo(travel!.happenAt)
        lCreator.text = UserHelper.getName(user: me, uid: travel!.userId)
        // place
        let isPlace = travel!.travelPlaceList.count > 0
        vPlaceLine.isHidden = !isPlace
        tablePlace.isHidden = !isPlace
        tablePlace.frame.size.height = NoteTravelPlaceCell.getMuliCellHeight(dataList: travel?.travelPlaceList)
        tablePlace.reloadData()
        
        // album
        let isAlbum = travel!.travelAlbumList.count > 0
        vAlbumLine.isHidden = !isAlbum
        tableAlbum.isHidden = !isAlbum
        vAlbumLine.frame.origin.y = isPlace ? tablePlace.frame.origin.y + tablePlace.frame.size.height + ScreenUtils.heightFit(20) : vPlaceLine.frame.origin.y
        tableAlbum.frame.origin.y = vAlbumLine.frame.origin.y + vAlbumLine.frame.size.height + margin
        let albumList = ListHelper.getAlbumListByTravel(travelAlbumList: travel?.travelAlbumList, checkStatus: false)
        tableAlbum.frame.size.height = NoteAlbumCell.getMuliCellHeight(dataList: albumList)
        tableAlbum.reloadData()
        
        // video
        let isVideo = travel!.travelVideoList.count > 0
        vVideoLine.isHidden = !isVideo
        collectVideo.isHidden = !isVideo
        vVideoLine.frame.origin.y = isAlbum ? tableAlbum.frame.origin.y + tableAlbum.frame.size.height + ScreenUtils.heightFit(20) : vAlbumLine.frame.origin.y
        collectVideo.frame.origin.y = vVideoLine.frame.origin.y + vVideoLine.frame.size.height + margin
        let videoList = ListHelper.getVideoListByTravel(travelVideoList: travel?.travelVideoList, checkStatus: false)
        collectVideo.frame.size.height = NoteVideoCell.getMuliCellHeight(dataList: videoList)
        collectVideo.reloadData()
        
        // food
        let isFood = travel!.travelFoodList.count > 0
        vFoodLine.isHidden = !isFood
        tableFood.isHidden = !isFood
        vFoodLine.frame.origin.y = isVideo ? collectVideo.frame.origin.y + collectVideo.frame.size.height + ScreenUtils.heightFit(20) : vVideoLine.frame.origin.y
        tableFood.frame.origin.y = vFoodLine.frame.origin.y + vFoodLine.frame.size.height + margin
        let foodList = ListHelper.getFoodListByTravel(travelFoodList: travel?.travelFoodList, checkStatus: false)
        tableFood.frame.size.height = NoteFoodCell.getMuliCellHeight(dataList: foodList)
        tableFood.reloadData()
        
        // movie
        let isMovie = travel!.travelMovieList.count > 0
        vMovieLine.isHidden = !isMovie
        tableMovie.isHidden = !isMovie
        vMovieLine.frame.origin.y = isFood ? tableFood.frame.origin.y + tableFood.frame.size.height + ScreenUtils.heightFit(20) : vFoodLine.frame.origin.y
        tableMovie.frame.origin.y = vMovieLine.frame.origin.y + vMovieLine.frame.size.height + margin
        let movieList = ListHelper.getMovieListByTravel(travelMovieList: travel?.travelMovieList, checkStatus: false)
        tableMovie.frame.size.height = NoteMovieCell.getMuliCellHeight(dataList: movieList)
        tableMovie.reloadData()
        
        // diary
        let isDiary = travel!.travelDiaryList.count > 0
        vDiaryLine.isHidden = !isDiary
        tableDiary.isHidden = !isDiary
        vDiaryLine.frame.origin.y = isMovie ? tableMovie.frame.origin.y + tableMovie.frame.size.height + ScreenUtils.heightFit(20) : vMovieLine.frame.origin.y
        tableDiary.frame.origin.y = vDiaryLine.frame.origin.y + vDiaryLine.frame.size.height + margin
        let diaryList = ListHelper.getDiaryListByTravel(travelDiaryList: travel?.travelDiaryList, checkStatus: false)
        tableDiary.frame.size.height = NoteDiaryCell.getMuliCellHeight(dataList: diaryList)
        tableDiary.reloadData()
        
        // scroll
        scroll.contentSize.height = tableDiary.frame.origin.y + tableDiary.frame.size.height + ScreenUtils.heightFit(20)
    }
    
    @objc func showDeleteAlert() {
        if travel == nil || !travel!.isMine() {
            ToastUtils.show(StringUtils.getString("can_operation_self_create_note"))
            return
        }
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_delete_this_note"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    self.delTravel()
        },
                                  cancelHandler: nil)
    }
    
    private func delTravel() {
        if travel == nil {
            return
        }
        // api
        let api = Api.request(.noteTravelDel(tid: travel!.id),
                              loading: true, cancel: true, success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_TRAVEL_LIST_ITEM_DELETE, obj: self.travel!)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
    @objc func targetGoEdit() {
        NoteTravelEditVC.pushVC(travel: travel)
    }
    
    @objc func targetVideoGoMap(sender: UIButton) {
        let videoList = ListHelper.getVideoListByTravel(travelVideoList: travel?.travelVideoList, checkStatus: false)
        NoteVideoCell.goMap(view: sender, dataList: videoList)
    }
    
    @objc func targetFoodGoMap(sender: UIGestureRecognizer) {
        let foodList = ListHelper.getFoodListByTravel(travelFoodList: travel?.travelFoodList, checkStatus: false)
        NoteFoodCell.goMap(view: sender.view, dataList: foodList)
    }
    
    @objc func targetMovieGoMap(sender: UIGestureRecognizer) {
        let movieList = ListHelper.getMovieListByTravel(travelMovieList: travel?.travelMovieList, checkStatus: false)
        NoteMovieCell.goMap(view: sender.view, dataList: movieList)
    }
    
}
