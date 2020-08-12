//
//  NoteSouvenirForeignVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/6.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import XLPagerTabStrip

class NoteSouvenirForeignVC: BaseVC, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    
    // view
    private var scroll: UIScrollView!
    private var lTravel: UILabel!
    private var lGift: UILabel!
    private var lAlbum: UILabel!
    private var lVideo: UILabel!
    private var lFood: UILabel!
    private var lMovie: UILabel!
    private var lDiary: UILabel!
    private var tableTravel: UITableView!
    private var tableGift: UITableView!
    private var tableAlbum: UITableView!
    private var collectVideo: UICollectionView!
    private var tableFood: UITableView!
    private var tableMovie: UITableView!
    private var tableDiary: UITableView!
    private var vEdit: UIView!
    
    // var
    private var height = CGFloat(0)
    private var itemInfo: IndicatorInfo = IndicatorInfo(title: "")
    private var year: Int!
    private var souvenir: Souvenir!
    private var travelList = [Travel]()
    private var giftList = [Gift]()
    private var albumList = [Album]()
    private var videoList = [Video]()
    private var foodList = [Food]()
    private var movieList = [Movie]()
    private var diaryList = [Diary]()
    private let tagTravel: Int = 1
    private let tagGift: Int = 2
    private let tagAlbum: Int = 3
    private let tagVideo: Int = 4
    private let tagFood: Int = 5
    private let tagMovie: Int = 6
    private let tagDiary: Int = 7
    
    public static func get(height: CGFloat, year: Int, title: String, souvenir: Souvenir) -> NoteSouvenirForeignVC {
        let vc = NoteSouvenirForeignVC(nibName: nil, bundle: nil)
        vc.height = height
        vc.year = year
        vc.itemInfo.title = title
        vc.souvenir = souvenir
        vc.travelList = ListHelper.getTravelListBySouvenir(souvenirTravelList: souvenir.souvenirTravelList, checkStatus: false)
        vc.giftList = ListHelper.getGiftListBySouvenir(souvenirGiftList: souvenir.souvenirGiftList, checkStatus: false)
        vc.albumList = ListHelper.getAlbumListBySouvenir(souvenirAlbumList: souvenir.souvenirAlbumList, checkStatus: false)
        vc.videoList = ListHelper.getVideoListBySouvenir(souvenirVideoList: souvenir.souvenirVideoList, checkStatus: false)
        vc.foodList = ListHelper.getFoodListBySouvenir(souvenirFoodList: souvenir.souvenirFoodList, checkStatus: false)
        vc.movieList = ListHelper.getMovieListBySouvenir(souvenirMovieList: souvenir.souvenirMovieList, checkStatus: false)
        vc.diaryList = ListHelper.getDiaryListBySouvenir(souvenirDiaryList: souvenir.souvenirDiaryList, checkStatus: false)
        return vc
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    override func initView() {
        // 不设置的话parent顶部会没有nav
        self.navigationBarShow = true
        
        // travel
        let isTravel = travelList.count > 0
        
        lTravel = ViewHelper.getLabelGreySmall(text: StringUtils.getString("travel"))
        lTravel.center.x = screenWidth / 2
        lTravel.frame.origin.y = ScreenUtils.heightFit(20)
        lTravel.isHidden = !isTravel
        
        let tableTravelHeight = NoteTravelCell.getMuliCellHeight(dataList: travelList)
        let tableTravelFrame = CGRect(x: 0, y: lTravel.frame.origin.y + lTravel.frame.size.height + margin, width: screenWidth, height: tableTravelHeight)
        tableTravel = ViewUtils.getTableView(target: self, frame: tableTravelFrame, cellCls: NoteTravelCell.self, id: NoteTravelCell.ID)
        tableTravel.tag = tagTravel
        tableTravel.isHidden = !isTravel
        
        // gift
        let isGift = giftList.count > 0
        
        lGift = ViewHelper.getLabelGreySmall(text: StringUtils.getString("gift"))
        lGift.center.x = screenWidth / 2
        lGift.frame.origin.y = isTravel ? tableTravel.frame.origin.y + tableTravel.frame.size.height + ScreenUtils.heightFit(20) : lTravel.frame.origin.y
        lGift.isHidden = !isGift
        
        let tableGiftHeight = NoteGiftCell.getMuliCellHeight(dataList: giftList)
        let tableGiftFrame = CGRect(x: 0, y: lGift.frame.origin.y + lGift.frame.size.height + margin, width: screenWidth, height: tableGiftHeight)
        tableGift = ViewUtils.getTableView(target: self, frame: tableGiftFrame, cellCls: NoteGiftCell.self, id: NoteGiftCell.ID)
        tableGift.tag = tagGift
        tableGift.isHidden = !isGift
        
        // album
        let isAlbum = albumList.count > 0
        
        lAlbum = ViewHelper.getLabelGreySmall(text: StringUtils.getString("album"))
        lAlbum.center.x = screenWidth / 2
        lAlbum.frame.origin.y = isGift ? tableGift.frame.origin.y + tableGift.frame.size.height + ScreenUtils.heightFit(20) : lGift.frame.origin.y
        lAlbum.isHidden = !isAlbum
        
        let tableAlbumHeight = NoteAlbumCell.getMuliCellHeight(dataList: albumList)
        let tableAlbumFrame = CGRect(x: 0, y: lAlbum.frame.origin.y + lAlbum.frame.size.height + margin, width: screenWidth, height: tableAlbumHeight)
        tableAlbum = ViewUtils.getTableView(target: self, frame: tableAlbumFrame, cellCls: NoteAlbumCell.self, id: NoteAlbumCell.ID)
        tableAlbum.tag = tagAlbum
        tableAlbum.isHidden = !isAlbum
        
        // video
        let isVideo = videoList.count > 0
        
        lVideo = ViewHelper.getLabelGreySmall(text: StringUtils.getString("video"))
        lVideo.center.x = screenWidth / 2
        lVideo.frame.origin.y = isAlbum ? tableAlbum.frame.origin.y + tableAlbum.frame.size.height + ScreenUtils.heightFit(20) : lAlbum.frame.origin.y
        lVideo.isHidden = !isVideo
        
        let tableVideoHeight = NoteVideoCell.getMuliCellHeight(dataList: videoList)
        let tableVideoFrame = CGRect(x: 0, y: lVideo.frame.origin.y + lVideo.frame.size.height + margin, width: screenWidth, height: tableVideoHeight)
        let layoutVideo = NoteVideoCell.getLayout()
        collectVideo = ViewUtils.getCollectionView(target: self, frame: tableVideoFrame, layout: layoutVideo, cellCls: NoteVideoCell.self, id: NoteVideoCell.ID)
        collectVideo.tag = tagVideo
        collectVideo.isHidden = !isVideo
        
        // food
        let isFood = foodList.count > 0
        
        lFood = ViewHelper.getLabelGreySmall(text: StringUtils.getString("food"))
        lFood.center.x = screenWidth / 2
        lFood.frame.origin.y = isVideo ? collectVideo.frame.origin.y + collectVideo.frame.size.height + ScreenUtils.heightFit(20) : lVideo.frame.origin.y
        lFood.isHidden = !isFood
        
        let tableFoodHeight = NoteFoodCell.getMuliCellHeight(dataList: foodList)
        let tableFoodFrame = CGRect(x: 0, y: lFood.frame.origin.y + lFood.frame.size.height + margin, width: screenWidth, height: tableFoodHeight)
        tableFood = ViewUtils.getTableView(target: self, frame: tableFoodFrame, cellCls: NoteFoodCell.self, id: NoteFoodCell.ID)
        tableFood.tag = tagFood
        tableFood.isHidden = !isFood
        
        // movie
        let isMovie = movieList.count > 0
        
        lMovie = ViewHelper.getLabelGreySmall(text: StringUtils.getString("movie"))
        lMovie.center.x = screenWidth / 2
        lMovie.frame.origin.y = isFood ? tableFood.frame.origin.y + tableFood.frame.size.height + ScreenUtils.heightFit(20) : lFood.frame.origin.y
        lMovie.isHidden = !isMovie
        
        let tableMovieHeight = NoteMovieCell.getMuliCellHeight(dataList: movieList)
        let tableMovieFrame = CGRect(x: 0, y: lMovie.frame.origin.y + lMovie.frame.size.height + margin, width: screenWidth, height: tableMovieHeight)
        tableMovie = ViewUtils.getTableView(target: self, frame: tableMovieFrame, cellCls: NoteMovieCell.self, id: NoteMovieCell.ID)
        tableMovie.tag = tagMovie
        tableMovie.isHidden = !isMovie
        
        // diary
        let isDiary = diaryList.count > 0
        
        lDiary = ViewHelper.getLabelGreySmall(text: StringUtils.getString("diary"))
        lDiary.center.x = screenWidth / 2
        lDiary.frame.origin.y = isMovie ? tableMovie.frame.origin.y + tableMovie.frame.size.height + ScreenUtils.heightFit(20) : lMovie.frame.origin.y
        lDiary.isHidden = !isDiary
        
        let tableDiaryHeight = NoteDiaryCell.getMuliCellHeight(dataList: diaryList)
        let tableDiaryFrame = CGRect(x: 0, y: lDiary.frame.origin.y + lDiary.frame.size.height + margin, width: screenWidth, height: tableDiaryHeight)
        tableDiary = ViewUtils.getTableView(target: self, frame: tableDiaryFrame, cellCls: NoteDiaryCell.self, id: NoteDiaryCell.ID)
        tableDiary.tag = tagDiary
        tableDiary.isHidden = !isDiary
        
        // edit
        let lEdit = ViewHelper.getLabel(text: StringUtils.getString("click_me_edit"), size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontHint(), lines: 1, align: .center, mode: .byTruncatingMiddle)
        let ivEdit = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_edit_grey_18dp"), color: ColorHelper.getFontHint()), width: lEdit.frame.size.height, height: lEdit.frame.size.height, mode: .scaleAspectFit)
        
        vEdit = UIView()
        vEdit.frame.size = CGSize(width: screenWidth, height: lEdit.frame.size.height + ScreenUtils.heightFit(40))
        vEdit.frame.origin.x = 0
        vEdit.frame.origin.y = isDiary ? tableDiary.frame.origin.y + tableDiary.frame.size.height : lDiary.frame.origin.y - ScreenUtils.heightFit(20)
        lEdit.center = CGPoint(x: vEdit.frame.size.width / 2, y: vEdit.frame.size.height / 2)
        ivEdit.frame.origin.x = lEdit.frame.origin.x - margin / 2 - ivEdit.frame.size.width
        ivEdit.center.y = lEdit.center.y
        vEdit.addSubview(lEdit)
        vEdit.addSubview(ivEdit)
        
        // scroll
        let scrollHeight = self.height
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = vEdit.frame.origin.y + vEdit.frame.size.height + ScreenUtils.heightFit(20)
        scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        
        // view
        scroll.addSubview(lTravel)
        scroll.addSubview(tableTravel)
        scroll.addSubview(lGift)
        scroll.addSubview(tableGift)
        scroll.addSubview(lAlbum)
        scroll.addSubview(tableAlbum)
        scroll.addSubview(lVideo)
        scroll.addSubview(collectVideo)
        scroll.addSubview(lFood)
        scroll.addSubview(tableFood)
        scroll.addSubview(lMovie)
        scroll.addSubview(tableMovie)
        scroll.addSubview(lDiary)
        scroll.addSubview(tableDiary)
        scroll.addSubview(vEdit)
        
        // view
        self.view.addSubview(scroll)
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vEdit, action: #selector(targetGoEdit))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == tagTravel {
            return travelList.count
        } else if tableView.tag == tagGift {
            return giftList.count
        } else if tableView.tag == tagAlbum {
            return albumList.count
        } else if tableView.tag == tagFood {
            return foodList.count
        } else if tableView.tag == tagMovie {
            return movieList.count
        } else if tableView.tag == tagDiary {
            return diaryList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == tagTravel {
            return NoteTravelCell.getCellHeight()
        } else if tableView.tag == tagGift {
            return NoteGiftCell.getHeightByData(gift: giftList[indexPath.row])
        } else if tableView.tag == tagAlbum {
            return NoteAlbumCell.getCellHeight()
        } else if tableView.tag == tagFood {
            return NoteFoodCell.getHeightByData(food: foodList[indexPath.row])
        } else if tableView.tag == tagMovie {
            return NoteMovieCell.getHeightByData(movie: movieList[indexPath.row])
        } else if tableView.tag == tagDiary {
            return NoteDiaryCell.getHeightByData(diary: diaryList[indexPath.row])
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == tagTravel {
            return NoteTravelCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: travelList)
        } else if tableView.tag == tagGift {
            return NoteGiftCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: giftList, heightMap: false)
        } else if tableView.tag == tagAlbum {
            return NoteAlbumCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: albumList)
        } else if tableView.tag == tagFood {
            return NoteFoodCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: foodList, heightMap: false, target: self, actionAddress: #selector(targetFoodGoMap))
        } else if tableView.tag == tagMovie {
            return NoteMovieCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: movieList, heightMap: false, target: self, actionAddress: #selector(targetMovieGoMap))
        } else if tableView.tag == tagDiary {
            return NoteDiaryCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: diaryList, heightMap: false)
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == tagTravel {
            NoteTravelCell.goTravelDetail(view: tableView, indexPath: indexPath, dataList: travelList)
        } else if tableView.tag == tagAlbum {
            NoteAlbumCell.goPictureList(view: tableView, indexPath: indexPath, dataList: albumList)
        } else if tableView.tag == tagDiary {
            NoteDiaryCell.goDiaryDetail(view: tableView, indexPath: indexPath, dataList: diaryList)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == tagVideo {
            return videoList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == tagVideo {
            return NoteVideoCell.getCellWithData(view: collectionView, indexPath: indexPath, dataList: videoList, target: self, actionAddress: #selector(targetVideoGoMap))
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == tagVideo {
            NoteVideoCell.goPlay(view: collectionView, indexPath: indexPath, dataList: videoList)
        }
    }
    
    @objc func targetGoEdit() {
        NoteSouvenirEditForeignVC.pushVC(year: year, souvenir: souvenir)
    }
    
    @objc func targetVideoGoMap(sender: UIButton) {
        NoteVideoCell.goMap(view: sender, dataList: videoList)
    }
    
    @objc func targetFoodGoMap(sender: UIGestureRecognizer) {
        NoteFoodCell.goMap(view: sender.view, dataList: foodList)
    }
    
    @objc func targetMovieGoMap(sender: UIGestureRecognizer) {
        NoteMovieCell.goMap(view: sender.view, dataList: movieList)
    }
    
}
