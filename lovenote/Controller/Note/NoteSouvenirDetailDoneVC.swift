//
//  NoteSouvenirDetailDoneVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/6.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import XLPagerTabStrip

class NoteSouvenirDetailDoneVC: BaseVC {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    
    // view
    private var vDetail: UIView!
    private var vDetailBottom: UIView!
    private var lTitle: UILabel!
    private var lDayCount: UILabel!
    private var ivAddress: UIImageView!
    private var lAddress: UILabel!
    private var ivHappenAt: UIImageView!
    private var lHappenAt: UILabel!
    private var yearVC: NoteSouvenirYearVC?
    
    // var
    private var souvenir: Souvenir?
    private var sid: Int64 = 0
    
    public static func pushVC(souvenir: Souvenir? = nil, sid: Int64 = 0) {
        AppDelegate.runOnMainAsync {
            let vc = NoteSouvenirDetailDoneVC(nibName: nil, bundle: nil)
            vc.souvenir = souvenir
            vc.sid = sid
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "souvenir")
        let barItemEdit = UIBarButtonItem(image: UIImage(named: "ic_edit_white_24dp"), style: .plain, target: self, action: #selector(targetGoEdit))
        let barItemDel = UIBarButtonItem(image: UIImage(named: "ic_delete_white_24dp"), style: .plain, target: self, action: #selector(showDeleteAlert))
        self.navigationItem.setRightBarButtonItems([barItemEdit, barItemDel], animated: true)
        
        // title
        lTitle = ViewHelper.getLabelBold(width: maxWidth - margin * 2, text: "-", size: ScreenUtils.fontFit(30), color: ColorHelper.getFontWhite(), lines: 0, align: .center)
        lTitle.frame.origin = CGPoint(x: margin, y: ScreenUtils.heightFit(20))
        
        // dayCount
        lDayCount = ViewHelper.getLabelBold(text: "-", size: ScreenUtils.fontFit(40), color: ColorHelper.getFontWhite(), lines: 1, align: .right, mode: .byTruncatingMiddle)
        lDayCount.frame.origin = CGPoint(x: maxWidth - margin * 2 - lDayCount.frame.size.width, y: 0)
        
        // address
        lAddress = ViewHelper.getLabelBold(text: "-", size: ViewHelper.FONT_SIZE_NORMAL, color: ColorHelper.getFontWhite(), lines: 1, align: .left, mode: .byTruncatingTail)
        ivAddress = ViewHelper.getImageView(img: UIImage(named: "ic_location_on_white_18dp"), width: lAddress.frame.size.height, height: lAddress.frame.size.height, mode: .scaleAspectFit)
        ivAddress.frame.origin = CGPoint(x: 0, y: 0)
        lAddress.frame.size.width = maxWidth - margin * 3 - lDayCount.frame.size.width - (ivAddress.frame.origin.x + ivAddress.frame.size.width + margin / 2)
        lAddress.frame.origin.x = ivAddress.frame.origin.x + ivAddress.frame.size.width + margin / 2
        lAddress.frame.origin.y = 0
        
        // happen
        lHappenAt = ViewHelper.getLabelBold(text: "-", size: ViewHelper.FONT_SIZE_NORMAL, color: ColorHelper.getFontWhite(), lines: 1, align: .left, mode: .byTruncatingTail)
        ivHappenAt = ViewHelper.getImageView(img: UIImage(named: "ic_access_time_white_18dp"), width: lHappenAt.frame.size.height, height: lHappenAt.frame.size.height, mode: .scaleAspectFit)
        ivHappenAt.frame.origin = CGPoint(x: 0, y: lDayCount.frame.size.height - lHappenAt.frame.size.height)
        lHappenAt.frame.size.width = maxWidth - margin * 3 - lDayCount.frame.size.width - (ivHappenAt.frame.origin.x + ivHappenAt.frame.size.width + margin / 2)
        lHappenAt.frame.origin.x = ivHappenAt.frame.origin.x + ivHappenAt.frame.size.width + margin / 2
        lHappenAt.frame.origin.y = lDayCount.frame.size.height - lHappenAt.frame.size.height
        
        // detailBottom
        vDetailBottom = UIView()
        vDetailBottom.frame.size = CGSize(width: maxWidth - margin * 2, height: lDayCount.frame.size.height)
        vDetailBottom.frame.origin = CGPoint(x: margin, y: lTitle.frame.origin.y + lTitle.frame.size.height + ScreenUtils.heightFit(40))
        vDetailBottom.addSubview(lDayCount)
        vDetailBottom.addSubview(ivAddress)
        vDetailBottom.addSubview(lAddress)
        vDetailBottom.addSubview(ivHappenAt)
        vDetailBottom.addSubview(lHappenAt)
        
        // detail
        vDetail = UIView()
        vDetail.frame.size = CGSize(width: maxWidth, height: vDetailBottom.frame.origin.y + vDetailBottom.frame.size.height + ScreenUtils.heightFit(20))
        vDetail.frame.origin = CGPoint(x: margin, y: margin)
        vDetail.backgroundColor = ThemeHelper.getColorPrimary()
        ViewUtils.setViewRadius(vDetail, radius: ViewHelper.RADIUS_HUGE)
        ViewUtils.setViewShadow(vDetail, offset: ViewHelper.SHADOW_HUGE)
        vDetail.addSubview(lTitle)
        vDetail.addSubview(vDetailBottom)
        
        // view
        self.view.addSubview(vDetail)
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: lAddress, action: #selector(targetGoAddress))
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_SOUVENIR_DETAIL_REFRESH)
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_TRAVEL_LIST_ITEM_DELETE)
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_TRAVEL_LIST_ITEM_REFRESH)
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_ALBUM_LIST_ITEM_DELETE)
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_ALBUM_LIST_ITEM_REFRESH)
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_DIARY_LIST_ITEM_DELETE)
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_DIARY_LIST_ITEM_REFRESH)
        // init
        if souvenir != nil {
            refreshView()
            // 没有详情页的，可以不加
            refreshData(sid: souvenir!.id)
        } else if sid > 0 {
            refreshData(sid: sid)
        } else {
            RootVC.get().popBack()
        }
    }
    
    @objc func notifyRefresh(notify: NSNotification) {
        let s = notify.object as? Souvenir
        refreshData(sid: s != nil ? s!.id : (souvenir?.id ?? 0))
    }
    
    func refreshData(sid: Int64) {
        // api
        let api = Api.request(.noteSouvenirGet(sid: sid), success: { (_, _, data) in
            self.souvenir = data.souvenir
            self.refreshView()
        }, failure: { (_, _, _) in
        })
        self.pushApi(api)
    }
    
    func refreshView() {
        if souvenir == nil {
            return
        }
        // text
        lTitle.text = souvenir!.title
        if DateUtils.getCurrentInt64() > souvenir!.happenAt {
            lDayCount.text = StringUtils.getString("add_holder", arguments: [(DateUtils.getCurrentInt64() - souvenir!.happenAt) / DateUtils.UNIT_DAY])
        } else {
            lDayCount.text = StringUtils.getString("sub_holder", arguments: [(souvenir!.happenAt - DateUtils.getCurrentInt64()) / DateUtils.UNIT_DAY])
        }
        lHappenAt.text = DateUtils.getStr(souvenir?.happenAt, DateUtils.FORMAT_LINE_Y_M_D_H_M)
        lAddress.text = StringUtils.isEmpty(souvenir?.address) ? StringUtils.getString("now_no") : souvenir!.address
        
        // size
        lTitle.frame.size.height = ViewUtils.getFontHeight(font: lTitle.font, width: lTitle.frame.size.width, text: lTitle.text)
        lDayCount.frame.size.width = ViewUtils.getFontWidth(font: lDayCount.font, text: lDayCount.text)
        lDayCount.frame.origin.x = maxWidth - margin * 2 - lDayCount.frame.size.width
        lAddress.frame.size.width = maxWidth - margin - lDayCount.frame.size.width - (ivAddress.frame.origin.x + ivAddress.frame.size.width + margin / 2)
        lHappenAt.frame.size.width = maxWidth - margin - lDayCount.frame.size.width - (ivHappenAt.frame.origin.x + ivHappenAt.frame.size.width + margin / 2)
        vDetailBottom.frame.origin.y = lTitle.frame.origin.y + lTitle.frame.size.height + ScreenUtils.heightFit(40)
        vDetail.frame.size.height = vDetailBottom.frame.origin.y + vDetailBottom.frame.size.height + ScreenUtils.heightFit(20)
        // shadow
        ViewUtils.setViewShadow(vDetail, offset: ViewHelper.SHADOW_NORMAL)
        
        // year
        if yearVC != nil {
            yearVC?.view.removeFromSuperview()
            yearVC?.removeFromParent()
        }
        let yearHeight = self.view.frame.size.height - vDetail.frame.size.height - margin
        yearVC = NoteSouvenirYearVC.get(height: yearHeight, souvenir: souvenir)
        if yearVC != nil {
            yearVC!.view.frame.size = CGSize(width: screenWidth, height: yearHeight)
            yearVC!.view.frame.origin.x = 0
            yearVC!.view.frame.origin.y = vDetail.frame.origin.y + vDetail.frame.size.height + margin
            self.addChild(yearVC!)
            self.view.addSubview(yearVC!.view)
        }
    }
    
    @objc func targetGoAddress() {
        MapShowVC.pushVC(address: souvenir?.address, lon: souvenir?.longitude, lat: souvenir?.latitude)
    }
    
    @objc func targetGoEdit() {
        NoteSouvenirEditVC.pushVC(souvenir: souvenir)
    }
    
    @objc func showDeleteAlert() {
        if souvenir == nil || !souvenir!.isMine() {
            ToastUtils.show(StringUtils.getString("can_operation_self_create_note"))
            return
        }
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_delete_this_note"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    self.delSouvenir()
        },
                                  cancelHandler: nil)
    }
    
    private func delSouvenir() {
        if souvenir == nil {
            return
        }
        // api
        let api = Api.request(.noteSouvenirDel(sid: souvenir!.id),
                              loading: true, cancel: true, success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_SOUVENIR_LIST_ITEM_DELETE, obj: self.souvenir!)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
}

class NoteSouvenirYearVC: ButtonBarPagerTabStripViewController {
    
    // const
    lazy var barHeight = ScreenUtils.heightFit(50)
    
    // var
    private var subVCList = [NoteSouvenirForeignVC]()
    
    public static func get(height: CGFloat, souvenir: Souvenir?) -> NoteSouvenirYearVC? {
        if souvenir == nil {
            return nil
        }
        let vc = NoteSouvenirYearVC(nibName: nil, bundle: nil)
        // foreign-year
        var dcHappen = DateUtils.getDC(souvenir?.happenAt)
        let dcNow = DateUtils.getCurrentDC()
        let yearHappen = dcHappen.year ?? 0
        var yearNow = dcNow.year ?? 0
        dcHappen.year = yearNow
        if DateUtils.getInt64(dcHappen) > DateUtils.getInt64(dcNow) {
            // 今年的还没过
            yearNow = yearNow - 1
            if yearNow < yearHappen {
                yearNow = yearHappen
            }
        }
        // foreign-data
        var vcList = [NoteSouvenirForeignVC]()
        var year = yearNow
        while year >= yearHappen {
            // souvenir
            let s = Souvenir()
            s.id = souvenir!.id
            s.status = souvenir!.status
            s.createAt = souvenir!.createAt
            s.updateAt = souvenir!.updateAt
            s.userId = souvenir!.userId
            s.coupleId = souvenir!.coupleId
            s.souvenirTravelList = ListHelper.getSouvenirTravelListByYear(souvenirTravelList: souvenir!.souvenirTravelList, year: year)
            s.souvenirGiftList = ListHelper.getSouvenirGiftListByYear(souvenirGiftList: souvenir!.souvenirGiftList, year: year)
            s.souvenirAlbumList = ListHelper.getSouvenirAlbumListByYear(souvenirAlbumList: souvenir!.souvenirAlbumList, year: year)
            s.souvenirVideoList = ListHelper.getSouvenirVideoListByYear(souvenirVideoList: souvenir!.souvenirVideoList, year: year)
            s.souvenirFoodList = ListHelper.getSouvenirFoodListByYear(souvenirFoodList: souvenir!.souvenirFoodList, year: year)
            s.souvenirMovieList = ListHelper.getSouvenirMovieListByYear(souvenirMovieList: souvenir!.souvenirMovieList, year: year)
            s.souvenirDiaryList = ListHelper.getSouvenirDiaryListByYear(souvenirDiaryList: souvenir!.souvenirDiaryList, year: year)
            // title
            var title = ""
            let betweenYear = year - yearHappen
            if betweenYear <= 0 {
                title = "\(yearHappen)"
            } else {
                title = StringUtils.getString("holder_anniversary", arguments: [betweenYear])
            }
            // vc
            let fVC = NoteSouvenirForeignVC.get(height: height - vc.barHeight, year: year, title: title, souvenir: s)
            vcList.append(fVC)
            // year
            year -= 1
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
        self.settings.style.buttonBarBackgroundColor = ColorHelper.getTrans()
        self.settings.style.buttonBarMinimumInteritemSpacing = 0
        self.settings.style.buttonBarHeight = barHeight
        // self.settings.style.buttonBarMinimumLineSpacing: CGFloat?
        // self.settings.style.buttonBarLeftContentInset: CGFloat?
        // self.settings.style.buttonBarRightContentInset: CGFloat?
        // 标签
        self.settings.style.buttonBarItemsShouldFillAvailiableWidth = false
        self.settings.style.buttonBarItemBackgroundColor = ColorHelper.getTrans()
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
}
