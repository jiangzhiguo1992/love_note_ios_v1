//
//  NoteDreamDetailVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/23.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteDreamDetailVC: BaseVC {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var maxWidth = ScreenUtils.getScreenWidth() - margin * 2
    
    // view
    private var scroll: UIScrollView!
    private var lHappenAt: UILabel!
    private var lCreator: UILabel!
    private var lTextCount: UILabel!
    private var lContent: UILabel!
    
    // var
    private var dream: Dream?
    private var did: Int64 = 0
    
    public static func pushVC(dream: Dream? = nil, did: Int64 = 0) {
        AppDelegate.runOnMainAsync {
            let vc = NoteDreamDetailVC(nibName: nil, bundle: nil)
            vc.dream = dream
            vc.did = did
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "dream")
        let barItemEdit = UIBarButtonItem(image: UIImage(named: "ic_edit_white_24dp"), style: .plain, target: self, action: #selector(targetGoEdit))
        let barItemDel = UIBarButtonItem(image: UIImage(named: "ic_delete_white_24dp"), style: .plain, target: self, action: #selector(showDeleteAlert))
        self.navigationItem.setRightBarButtonItems([barItemEdit, barItemDel], animated: true)
        
        // happen
        lHappenAt = ViewHelper.getLabelBold(width: maxWidth, text: "-", size: ViewHelper.FONT_SIZE_BIG, color: ColorHelper.getFontBlack(), lines: 0, align: .center)
        lHappenAt.frame.origin = CGPoint(x: margin, y: ScreenUtils.heightFit(30))
        
        // avatar
        lCreator = ViewHelper.getLabelGreySmall(width: (maxWidth - margin) / 2, text: "-", lines: 1, align: .left, mode: .byTruncatingMiddle)
        lCreator.frame.origin = CGPoint(x: margin, y: lHappenAt.frame.origin.y + lHappenAt.frame.size.height + ScreenUtils.heightFit(20))
        
        // count
        lTextCount = ViewHelper.getLabelGreySmall(width: (maxWidth - margin) / 2, text: "-", lines: 1, align: .right, mode: .byTruncatingMiddle)
        lTextCount.frame.origin = CGPoint(x: lCreator.frame.origin.x + lCreator.frame.size.width + margin, y: lCreator.frame.origin.y)
        
        // content
        lContent = ViewHelper.getLabelBlackBig(width: maxWidth, text: "-", lines: 0, align: .left)
        lContent.frame.origin = CGPoint(x: margin, y: lCreator.frame.origin.y + lCreator.frame.size.height + ScreenUtils.heightFit(20))
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = lContent.frame.origin.y + lContent.frame.size.height + ScreenUtils.heightFit(20)
        scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        
        scroll.addSubview(lHappenAt)
        scroll.addSubview(lCreator)
        scroll.addSubview(lTextCount)
        scroll.addSubview(lContent)
        
        // view
        self.view.addSubview(scroll)
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_DREAM_DETAIL_REFRESH)
        // init
        if dream != nil {
            refreshView()
            // 没有详情页的，可以不加
            refreshData(did: dream!.id)
        } else if did > 0 {
            refreshData(did: did)
        } else {
            RootVC.get().popBack()
        }
    }
    
    @objc func notifyRefresh(notify: NSNotification) {
        if let dream = notify.object as? Dream {
            refreshData(did: dream.id)
        }
    }
    
    func refreshData(did: Int64) {
        ViewUtils.beginScrollRefresh(scroll)
        // api
        let api = Api.request(.noteDreamGet(did: did), success: { (_, _, data) in
            ViewUtils.endScrollRefresh(self.scroll)
            self.dream = data.dream
            self.refreshView()
        }, failure: { (_, _, _) in
            ViewUtils.endScrollRefresh(self.scroll)
        })
        self.pushApi(api)
    }
    
    func refreshView() {
        if dream == nil {
            return
        }
        let me = UDHelper.getMe()
        // text
        lHappenAt.text = TimeHelper.getTimeShowLine_HM_MD_YMD_ByGo(dream!.happenAt)
        lCreator.text = StringUtils.getString("creator_colon_space_holder", arguments: [UserHelper.getName(user: me, uid: dream!.userId)])
        lTextCount.text = StringUtils.getString("text_number_space_colon_holder", arguments: [dream!.contentText.count])
        lContent.text = dream!.contentText
        // size
        lContent.frame.size.height = ViewUtils.getFontHeight(font: lContent.font, width: lContent.frame.width, text: lContent.text)
        scroll.contentSize.height = lContent.frame.origin.y + lContent.frame.size.height + ScreenUtils.heightFit(20)
    }
    
    @objc func targetGoEdit() {
        NoteDreamEditVC.pushVC(dream: dream)
    }
    
    @objc func showDeleteAlert() {
        if dream == nil || !dream!.isMine() {
            ToastUtils.show(StringUtils.getString("can_operation_self_create_note"))
            return
        }
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_delete_this_note"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    self.delDream()
        },
                                  cancelHandler: nil)
    }
    
    private func delDream() {
        if dream == nil {
            return
        }
        // api
        let api = Api.request(.noteDreamDel(did: dream!.id),
                              loading: true, cancel: true, success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_DREAM_LIST_ITEM_DELETE, obj: self.dream!)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
}
