//
//  NoteAngryDetailVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/26.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteAngryDetailVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    
    // view
    private var scroll: UIScrollView!
    private var ivAvatar: UIImageView!
    private var lHappenAt: UILabel!
    private var lContent: UILabel!
    private var lGift: UIView!
    private var lineGiftLeft: UIView!
    private var lineGiftRight: UIView!
    private var btnGift: UIButton!
    private var tableViewGift: UITableView!
    private var lPromise: UIView!
    private var linePromiseLeft: UIView!
    private var linePromiseRight: UIView!
    private var btnPromise: UIButton!
    private var tableViewPromise: UITableView!
    
    // var
    private var angry: Angry?
    private var aid: Int64 = 0
    private let tagGift: Int = 1
    private let tagPromise: Int = 2
    
    public static func pushVC(angry: Angry? = nil, aid: Int64 = 0) {
        AppDelegate.runOnMainAsync {
            let vc = NoteAngryDetailVC(nibName: nil, bundle: nil)
            vc.angry = angry
            vc.aid = aid
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "angry")
        let barItemDel = UIBarButtonItem(image: UIImage(named: "ic_delete_white_24dp"), style: .plain, target: self, action: #selector(showDeleteAlert))
        self.navigationItem.setRightBarButtonItems([barItemDel], animated: true)
        
        // avatar
        ivAvatar = ViewHelper.getImageViewAvatar(width: ScreenUtils.widthFit(40), height: ScreenUtils.widthFit(40))
        ivAvatar.center.x = self.view.center.x
        ivAvatar.frame.origin.y = ScreenUtils.heightFit(30)
        let vAvatarShadow = ViewUtils.getViewShadow(ivAvatar, bgColor: ColorHelper.getWhite(), offset: ViewHelper.SHADOW_NORMAL)
        
        // happen
        lHappenAt = ViewHelper.getLabelBold(width: maxWidth, text: "-", size: ViewHelper.FONT_SIZE_BIG, color: ColorHelper.getFontBlack(), lines: 0, align: .center)
        lHappenAt.frame.origin = CGPoint(x: margin, y: ivAvatar.frame.origin.y + ivAvatar.frame.size.height + ScreenUtils.heightFit(30))
        
        // content
        lContent = ViewHelper.getLabelBlackBig(width: maxWidth, text: "-", lines: 0, align: .left)
        lContent.frame.origin = CGPoint(x: margin, y: lHappenAt.frame.origin.y + lHappenAt.frame.size.height + ScreenUtils.heightFit(30))
        
        // gift-line
        lGift = ViewHelper.getLabelGreySmall(text: StringUtils.getString("gift"))
        lGift.center.x = screenWidth / 2
        lGift.frame.origin.y = lContent.frame.origin.y + lContent.frame.size.height + ScreenUtils.heightFit(30)
        lineGiftLeft = ViewHelper.getViewLine(width: (maxWidth - lGift.frame.size.width) / 2 - margin)
        lineGiftLeft.frame.origin.x = margin
        lineGiftLeft.center.y = lGift.center.y
        lineGiftRight = ViewHelper.getViewLine(width: (maxWidth - lGift.frame.size.width) / 2 - margin)
        lineGiftRight.frame.origin.x = lGift.frame.origin.x + lGift.frame.size.width + margin
        lineGiftRight.center.y = lGift.center.y
        
        // gift-btn
        btnGift = ViewHelper.getBtnBGTrans(width: maxWidth, paddingV: margin, HAlign: .center, VAlign: .center, title: StringUtils.getString("did_award_some_gift"), titleSize: ViewHelper.FONT_SIZE_SMALL, titleColor: ColorHelper.getFontGrey(), titleLines: 1, titleAlign: .center, circle: false, shadow: false)
        btnGift.frame.origin = CGPoint(x: margin, y: lGift.frame.origin.y + lGift.frame.size.height + ScreenUtils.heightFit(20))
        
        // gift-table
        tableViewGift = ViewUtils.getTableView(target: self, frame: CGRect(x: 0, y: lGift.frame.origin.y + lGift.frame.size.height + ScreenUtils.heightFit(10), width: screenWidth, height: btnGift.frame.size.height), cellCls: NoteGiftCell.self, id: NoteGiftCell.ID)
        tableViewGift.tag = tagGift
        
        // promise-line
        lPromise = ViewHelper.getLabelGreySmall(text: StringUtils.getString("promise"))
        lPromise.center.x = screenWidth / 2
        lPromise.frame.origin.y = btnGift.frame.origin.y + btnGift.frame.size.height + ScreenUtils.heightFit(20)
        linePromiseLeft = ViewHelper.getViewLine(width: (maxWidth - lPromise.frame.size.width) / 2 - margin)
        linePromiseLeft.frame.origin.x = margin
        linePromiseLeft.center.y = lPromise.center.y
        linePromiseRight = ViewHelper.getViewLine(width: (maxWidth - lPromise.frame.size.width) / 2 - margin)
        linePromiseRight.frame.origin.x = lPromise.frame.origin.x + lPromise.frame.size.width + margin
        linePromiseRight.center.y = lPromise.center.y
        
        // promise-btn
        btnPromise = ViewHelper.getBtnBGTrans(width: maxWidth, paddingV: margin, HAlign: .center, VAlign: .center, title: StringUtils.getString("did_do_some_promise"), titleSize: ViewHelper.FONT_SIZE_SMALL, titleColor: ColorHelper.getFontGrey(), titleLines: 1, titleAlign: .center, circle: false, shadow: false)
        btnPromise.frame.origin = CGPoint(x: margin, y: lPromise.frame.origin.y + lPromise.frame.size.height + ScreenUtils.heightFit(20))
        
        // gift-table
        tableViewPromise = ViewUtils.getTableView(target: self, frame: CGRect(x: 0, y: lPromise.frame.origin.y + lPromise.frame.size.height + ScreenUtils.heightFit(10), width: screenWidth, height: btnPromise.frame.size.height), cellCls: NotePromiseCell.self, id: NotePromiseCell.ID)
        tableViewPromise.tag = tagPromise
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = btnPromise.frame.origin.y + btnPromise.frame.size.height + ScreenUtils.heightFit(20)
        scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        
        scroll.addSubview(vAvatarShadow)
        scroll.addSubview(ivAvatar)
        scroll.addSubview(lHappenAt)
        scroll.addSubview(lContent)
        scroll.addSubview(lGift)
        scroll.addSubview(lineGiftLeft)
        scroll.addSubview(lineGiftRight)
        scroll.addSubview(btnGift)
        scroll.addSubview(tableViewGift)
        scroll.addSubview(lPromise)
        scroll.addSubview(linePromiseLeft)
        scroll.addSubview(linePromiseRight)
        scroll.addSubview(btnPromise)
        scroll.addSubview(tableViewPromise)
        
        // view
        self.view.addSubview(scroll)
        
        // hide
        btnGift.isHidden = true
        btnPromise.isHidden = true
        tableViewGift.isHidden = true
        tableViewPromise.isHidden = true
        
        // target
        btnGift.addTarget(self, action: #selector(targetSelectGift), for: .touchUpInside)
        btnPromise.addTarget(self, action: #selector(targetSelectPromise), for: .touchUpInside)
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyGiftSelect), name: NotifyHelper.TAG_GIFT_SELECT)
        NotifyHelper.addObserver(self, selector: #selector(notifyPromiseSelect), name: NotifyHelper.TAG_PROMISE_SELECT)
        NotifyHelper.addObserver(self, selector: #selector(notifyPromiseItemDelete), name: NotifyHelper.TAG_PROMISE_LIST_ITEM_DELETE)
        NotifyHelper.addObserver(self, selector: #selector(notifyPromiseItemRefresh), name: NotifyHelper.TAG_PROMISE_LIST_ITEM_REFRESH)
        // init
        if angry != nil {
            refreshView()
            // 没有详情页的，可以不加
            refreshData(aid: angry!.id)
        } else if aid > 0 {
            refreshData(aid: aid)
        } else {
            RootVC.get().popBack()
        }
    }
    
    @objc func notifyGiftSelect(notify: NSNotification) {
        let gift = (notify.object as? Gift) ?? Gift()
        updateGift(gift: gift)
    }
    
    @objc func notifyPromiseSelect(notify: NSNotification) {
        let promise = (notify.object as? Promise) ?? Promise()
        updatePromise(promise: promise)
    }
    
    @objc func notifyPromiseItemDelete(notify: NSNotification) {
        let promise = (notify.object as? Promise) ?? Promise()
        if promise.id == 0 || promise.id != angry?.promiseId {
            return
        }
        angry?.promiseId = 0
        angry?.promise = nil
        refreshView()
    }
    
    @objc func notifyPromiseItemRefresh(notify: NSNotification) {
        let promise = (notify.object as? Promise) ?? Promise()
        if promise.id == 0 || promise.id != angry?.promiseId {
            return
        }
        angry?.promise = promise
        refreshView()
    }
    
    func refreshData(aid: Int64) {
        ViewUtils.beginScrollRefresh(scroll)
        // api
        let api = Api.request(.noteAngryGet(aid: aid), success: { (_, _, data) in
            ViewUtils.endScrollRefresh(self.scroll)
            self.angry = data.angry
            self.refreshView()
        }, failure: { (_, _, _) in
            ViewUtils.endScrollRefresh(self.scroll)
        })
        self.pushApi(api)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == tagGift {
            if angry?.gift != nil && angry?.gift?.id != 0 {
                return 1
            }
        } else if tableView.tag == tagPromise {
            if angry?.promise != nil && angry?.promise?.id != 0 {
                return 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == tagGift {
            if angry?.gift != nil && angry?.gift?.id != 0 {
                return NoteGiftCell.getHeightByData(gift: angry!.gift!)
            }
        } else if tableView.tag == tagPromise {
            if angry?.promise != nil && angry?.promise?.id != 0 {
                return NotePromiseCell.getHeightByData(promise: angry!.promise!)
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == tagGift {
            if angry?.gift != nil && angry?.gift?.id != 0 {
                return NoteGiftCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: [angry!.gift!], heightMap: false, target: self, actionEdit: #selector(showRemoveGiftDialog))
            }
        } else if tableView.tag == tagPromise {
            if angry?.promise != nil && angry?.promise?.id != 0 {
                return NotePromiseCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: [angry!.promise!], heightMap: false, target: self, actionEdit: #selector(showRemovePromiseDialog))
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == tagPromise {
            if angry?.promise != nil && angry?.promise?.id != 0 {
                NotePromiseDetailVC.pushVC(promise: angry?.promise)
            }
        }
    }
    
    func refreshView() {
        if angry == nil {
            return
        }
        let me = UDHelper.getMe()
        // avatar
        let avatar = UserHelper.getAvatar(user: me, uid: angry!.happenId)
        KFHelper.setImgAvatarUrl(iv: ivAvatar, objKey: avatar, uid: angry!.happenId)
        // text
        lHappenAt.text = TimeHelper.getTimeShowLine_HM_MD_YMD_ByGo(angry!.happenAt)
        lContent.text = angry!.contentText
        // size
        lContent.frame.size.height = ViewUtils.getFontHeight(font: lContent.font, width: lContent.frame.width, text: lContent.text)
        // gift
        lGift.frame.origin.y = lContent.frame.origin.y + lContent.frame.size.height + ScreenUtils.heightFit(30)
        lineGiftLeft.center.y = lGift.center.y
        lineGiftRight.center.y = lGift.center.y
        let isGift = angry?.gift != nil && angry?.gift?.id != 0
        btnGift.isHidden = isGift
        tableViewGift.isHidden = !isGift
        btnGift.frame.origin.y = lGift.frame.origin.y + lGift.frame.size.height + ScreenUtils.heightFit(20)
        tableViewGift.frame.size.height = isGift ? NoteGiftCell.getHeightByData(gift: angry!.gift!) : CGFloat(0)
        tableViewGift.frame.origin.y = lGift.frame.origin.y + lGift.frame.size.height + ScreenUtils.heightFit(10)
        tableViewGift.reloadData()
        // promise
        lPromise.frame.origin.y = isGift ? tableViewGift.frame.origin.y + tableViewGift.frame.size.height + ScreenUtils.heightFit(20) : btnGift.frame.origin.y + btnGift.frame.size.height + ScreenUtils.heightFit(20)
        linePromiseLeft.center.y = lPromise.center.y
        linePromiseRight.center.y = lPromise.center.y
        let isPromise = angry?.promise != nil && angry?.promise?.id != 0
        btnPromise.isHidden = isPromise
        tableViewPromise.isHidden = !isPromise
        btnPromise.frame.origin.y = lPromise.frame.origin.y + lPromise.frame.size.height + ScreenUtils.heightFit(20)
        tableViewPromise.frame.size.height = isPromise ? NotePromiseCell.getHeightByData(promise: angry!.promise!) : CGFloat(0)
        tableViewPromise.frame.origin.y = lPromise.frame.origin.y + lPromise.frame.size.height + ScreenUtils.heightFit(10)
        tableViewPromise.reloadData()
        // scroll
        scroll.contentSize.height = isPromise ? tableViewPromise.frame.origin.y + tableViewPromise.frame.size.height + ScreenUtils.heightFit(20) : btnPromise.frame.origin.y + btnPromise.frame.size.height + ScreenUtils.heightFit(20)
    }
    
    @objc func showDeleteAlert() {
        if angry == nil || !angry!.isMine() {
            ToastUtils.show(StringUtils.getString("can_operation_self_create_note"))
            return
        }
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_delete_this_note"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    self.delAngry()
        },
                                  cancelHandler: nil)
    }
    
    private func delAngry() {
        if angry == nil {
            return
        }
        // api
        let api = Api.request(.noteAngryDel(aid: angry!.id),
                              loading: true, cancel: true, success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_ANGRY_LIST_ITEM_DELETE, obj: self.angry!)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
    @objc func targetSelectGift() {
        NoteGiftVC.pushVC(select: true)
    }
    
    @objc func targetSelectPromise() {
        NotePromiseVC.pushVC(select: true)
    }
    
    @objc func showRemoveGiftDialog() {
        if angry == nil {
            return
        }
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_remove_this_note"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    self.updateGift(gift: Gift())
        },
                                  cancelHandler: nil)
    }
    
    @objc func showRemovePromiseDialog() {
        if angry == nil {
            return
        }
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_remove_this_note"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    self.updatePromise(promise: Promise())
        },
                                  cancelHandler: nil)
    }
    
    func updateGift(gift: Gift?) {
        if angry == nil || gift == nil {
            return
        }
        angry?.giftId = gift!.id
        // api
        let api = Api.request(.noteAngryUpdate(angry: angry?.toJSON()), loading: true, cancel: true,
                              success: { (_, _, data) in
                                self.angry = data.angry
                                // view
                                self.refreshView()
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_ANGRY_LIST_ITEM_REFRESH, obj: self.angry)
        }, failure: nil)
        pushApi(api)
    }
    
    func updatePromise(promise: Promise?) {
        if angry == nil || promise == nil {
            return
        }
        angry?.promiseId = promise!.id
        // api
        let api = Api.request(.noteAngryUpdate(angry: angry?.toJSON()), loading: true, cancel: true,
                              success: { (_, _, data) in
                                self.angry = data.angry
                                // view
                                self.refreshView()
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_ANGRY_LIST_ITEM_REFRESH, obj: self.angry)
        }, failure: nil)
        pushApi(api)
    }
    
}
