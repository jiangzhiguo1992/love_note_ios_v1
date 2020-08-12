//
//  NoteDreamEditVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/23.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteDreamEditVC: BaseVC {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    lazy var barVerticalMargin = ScreenUtils.heightFit(15)
    lazy var barIconMargin = ScreenUtils.widthFit(5)
    
    // view
    private var scroll: UIScrollView!
    private var tvContent: UITextView!
    private var vHappenAt: UIView!
    private var lHappenAt: UILabel!
    
    // var
    private var dream: Dream?
    private var dreamOld: Dream!
    
    public static func pushVC(dream: Dream? = nil) {
        AppDelegate.runOnMainAsync {
            let vc = NoteDreamEditVC(nibName: nil, bundle: nil)
            if dream == nil {
                vc.actFrom = ACT_EDIT_FROM_ADD
            } else {
                if dream!.isMine() {
                    vc.actFrom = ACT_EDIT_FROM_UPDATE
                    vc.dream = dream
                    // 需要拷贝可编辑的数据
                    vc.dreamOld = Dream()
                    vc.dreamOld.happenAt = dream!.happenAt
                    vc.dreamOld.contentText = dream!.contentText
                } else {
                    ToastUtils.show(StringUtils.getString("can_operation_self_create_note"))
                    return
                }
            }
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "dream")
        let barItemCommit = UIBarButtonItem(title: StringUtils.getString("commit"), style: .plain, target: self, action: #selector(checkPush))
        let barItemDraft = UIBarButtonItem(title: StringUtils.getString("save_draft"), style: .plain, target: self, action: #selector(saveDraft))
        barItemCommit.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        barItemDraft.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        self.navigationItem.setRightBarButtonItems([barItemCommit, barItemDraft], animated: true)
        
        // content
        tvContent = ViewHelper.getTextView(width: maxWidth, height: ViewHelper.FONT_NORMAL_LINE_HEIGHT * 10, text: "", textSize: ViewHelper.FONT_SIZE_NORMAL, textColor: ColorHelper.getFontGrey(), placeholder: StringUtils.getString("please_input_dream_content"), limitLength: UDHelper.getLimit().dreamContentLength)
        tvContent.frame.origin = CGPoint(x: margin, y: margin * 2)
        
        // happenAt
        let vLineHappenAt = ViewHelper.getViewLine(width: maxWidth)
        vLineHappenAt.frame.origin = CGPoint(x: margin, y: 0)
        lHappenAt = ViewHelper.getLabelGreyNormal(width: maxWidth, text: StringUtils.getString("time_colon_space_holder"), lines: 1, align: .left, mode: .byTruncatingMiddle)
        let ivHappenAt = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_access_time_grey_18dp"), color: ColorHelper.getFontGrey()), width: lHappenAt.frame.size.height, height: lHappenAt.frame.size.height, mode: .scaleAspectFit)
        ivHappenAt.frame.origin = CGPoint(x: margin, y: barVerticalMargin)
        lHappenAt.frame.size.width = screenWidth - ivHappenAt.frame.origin.x - ivHappenAt.frame.size.width - barIconMargin - margin
        lHappenAt.frame.origin = CGPoint(x: ivHappenAt.frame.origin.x + ivHappenAt.frame.size.width + barIconMargin, y: barVerticalMargin)
        vHappenAt = UIView(frame: CGRect(x: 0, y: tvContent.frame.origin.y + tvContent.frame.size.height + ScreenUtils.heightFit(30), width: screenWidth, height: ivHappenAt.frame.size.height + barVerticalMargin * 2))
        
        vHappenAt.addSubview(vLineHappenAt)
        vHappenAt.addSubview(ivHappenAt)
        vHappenAt.addSubview(lHappenAt)
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = vHappenAt.frame.origin.y + self.view.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
        scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        
        scroll.addSubview(tvContent)
        scroll.addSubview(vHappenAt)
        
        // view
        self.view.backgroundColor = ColorHelper.getWhite()
        self.view.addSubview(scroll)
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vHappenAt, action: #selector(showDatePicker))
    }
    
    override func initData() {
        // init
        if !isFromUpdate() {
            dream = UDHelper.getDraftDream()
        }
        if dream == nil {
            dream = Dream()
        }
        if dream?.happenAt == 0 {
            dream?.happenAt = DateUtils.getCurrentInt64()
        }
        // content
        ExtensionTextView.setTextViewTextWithPlaceholder(tvContent, text: dream?.contentText)
        // date
        refreshDateView()
    }
    
    override func canPop() -> Bool {
        // 更新，返还原来的值
        if isFromUpdate() {
            dream?.happenAt = dreamOld.happenAt
            dream?.contentText = dreamOld.contentText
            return true
        }
        // 没有数据
        if dream == nil || StringUtils.isEmpty(tvContent.text) {
            return true
        }
        // 相同数据
        let draft = UDHelper.getDraftDream()
        if draft != nil && dream?.contentText == tvContent.text {
            return true
        }
        // 草稿询问
        _ = AlertHelper.showAlert(title: StringUtils.getString("is_save_draft"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("save_draft")],
                                  cancel: StringUtils.getString("cancel"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    self.saveDraft(exit: true)
        },
                                  cancelHandler: { (_) in
                                    RootVC.get().popBack()
        })
        return false
    }
    
    func isFromUpdate() -> Bool {
        return actFrom == BaseVC.ACT_EDIT_FROM_UPDATE
    }
    
    @objc func showDatePicker() {
        _ = AlertHelper.showDatePicker(mode: .date, date: dream?.happenAt, actionHandler: { (_, _, _, picker) in
            self.dream?.happenAt = DateUtils.getInt64(picker.date)
            self.refreshDateView()
        }, cancelHandler: nil)
    }
    
    func refreshDateView() {
        let happen = TimeHelper.getTimeShowLine_HM_MD_YMD_ByGo(dream?.happenAt ?? DateUtils.getCurrentInt64())
        lHappenAt.text = StringUtils.getString("time_colon_space_holder", arguments: [happen])
    }
    
    @objc func saveDraft(exit: Bool = false) {
        dream?.contentText = tvContent.text
        UDHelper.setDraftDream(dream)
        ToastUtils.show(StringUtils.getString("draft_save_success"))
        if exit {
            RootVC.get().popBack()
        }
    }
    
    @objc func checkPush() {
        if dream == nil {
            return
        }
        if StringUtils.isEmpty(tvContent.text) {
            ToastUtils.show(tvContent.placeholder)
            return
        }
        dream?.contentText = tvContent.text
        if isFromUpdate() {
            updateApi()
        } else {
            addApi()
        }
    }
    
    func updateApi() {
        if dream == nil {
            return
        }
        let api = Api.request(.noteDreamUpdate(dream: dream?.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                let dream = data.dream
                                NotifyHelper.post(NotifyHelper.TAG_DREAM_LIST_ITEM_REFRESH, obj: dream)
                                NotifyHelper.post(NotifyHelper.TAG_DREAM_DETAIL_REFRESH, obj: dream)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
    func addApi() {
        if dream == nil {
            return
        }
        let api = Api.request(.noteDreamAdd(dream: dream?.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_DREAM_LIST_REFRESH, obj: nil)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
}
