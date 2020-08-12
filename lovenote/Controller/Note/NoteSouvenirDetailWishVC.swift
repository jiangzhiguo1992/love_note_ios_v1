//
//  NoteSouvenirDetailWishVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/6.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteSouvenirDetailWishVC: BaseVC {
    
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
    private var lCreate: UILabel!
    
    // var
    private var souvenir: Souvenir?
    private var sid: Int64 = 0
    
    public static func pushVC(souvenir: Souvenir? = nil, sid: Int64 = 0) {
        AppDelegate.runOnMainAsync {
            let vc = NoteSouvenirDetailWishVC(nibName: nil, bundle: nil)
            vc.souvenir = souvenir
            vc.sid = sid
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "wish_list")
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
        vDetail.frame.size = CGSize(width: maxWidth, height: vDetailBottom.frame.origin.y + vDetailBottom.frame.size.height + CGFloat(20))
        vDetail.frame.origin = CGPoint(x: margin, y: margin)
        vDetail.backgroundColor = ThemeHelper.getColorPrimary()
        ViewUtils.setViewRadius(vDetail, radius: ViewHelper.RADIUS_HUGE)
        ViewUtils.setViewShadow(vDetail, offset: ViewHelper.SHADOW_HUGE)
        vDetail.addSubview(lTitle)
        vDetail.addSubview(vDetailBottom)
        
        // create
        lCreate = ViewHelper.getLabelItalic(width: screenWidth, text: "-", size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorDark(), lines: 1, align: .center)
        lCreate.frame.origin.x = 0
        lCreate.frame.origin.y = vDetail.frame.origin.y + vDetail.frame.size.height + margin * 3
        
        // view
        self.view.addSubview(vDetail)
        self.view.addSubview(lCreate)
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: lAddress, action: #selector(targetGoAddress))
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_SOUVENIR_DETAIL_REFRESH)
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
        if let souvenir = notify.object as? Souvenir {
            refreshData(sid: souvenir.id)
        }
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
        let me = UDHelper.getMe()
        // text
        lTitle.text = souvenir!.title
        if DateUtils.getCurrentInt64() > souvenir!.happenAt {
            lDayCount.text = StringUtils.getString("add_holder", arguments: [(DateUtils.getCurrentInt64() - souvenir!.happenAt) / DateUtils.UNIT_DAY])
        } else {
            lDayCount.text = StringUtils.getString("sub_holder", arguments: [(souvenir!.happenAt - DateUtils.getCurrentInt64()) / DateUtils.UNIT_DAY])
        }
        lHappenAt.text = DateUtils.getStr(souvenir?.happenAt, DateUtils.FORMAT_LINE_Y_M_D_H_M)
        lAddress.text = StringUtils.isEmpty(souvenir?.address) ? StringUtils.getString("now_no") : souvenir!.address
        lCreate.text = StringUtils.getString("holder_space_in_space_holder_space_make_this_wish", arguments: [UserHelper.getName(user: me, uid: souvenir!.userId), TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(souvenir!.happenAt)])
        
        // size
        lTitle.frame.size.height = ViewUtils.getFontHeight(font: lTitle.font, width: lTitle.frame.size.width, text: lTitle.text)
        lDayCount.frame.size.width = ViewUtils.getFontWidth(font: lDayCount.font, text: lDayCount.text)
        lDayCount.frame.origin.x = maxWidth - margin * 2 - lDayCount.frame.size.width
        lAddress.frame.size.width = maxWidth - margin - lDayCount.frame.size.width - (ivAddress.frame.origin.x + ivAddress.frame.size.width + margin / 2)
        lHappenAt.frame.size.width = maxWidth - margin - lDayCount.frame.size.width - (ivHappenAt.frame.origin.x + ivHappenAt.frame.size.width + margin / 2)
        vDetailBottom.frame.origin.y = lTitle.frame.origin.y + lTitle.frame.size.height + ScreenUtils.heightFit(40)
        vDetail.frame.size.height = vDetailBottom.frame.origin.y + vDetailBottom.frame.size.height + ScreenUtils.heightFit(20)
        lCreate.frame.origin.y = vDetail.frame.origin.y + vDetail.frame.size.height + margin * 3
        // shadow
        ViewUtils.setViewShadow(vDetail, offset: ViewHelper.SHADOW_NORMAL)
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
