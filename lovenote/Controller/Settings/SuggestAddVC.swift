//
//  SuggestAddVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/7.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class SuggestAddVC: BaseVC {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenHeight = ScreenUtils.getScreenHeight()
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    
    // view
    private var btnKind: UIButton!
    private var tfTitle: UITextField!
    private var tvContent: UITextView!
    
    // var
    private var kindIndex = 0
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(SuggestAddVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "suggest_feedback")
        let barItemCommit = UIBarButtonItem(title: StringUtils.getString("commit"), style: .plain, target: self, action: #selector(checkPush))
        barItemCommit.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        self.navigationItem.setRightBarButtonItems([barItemCommit], animated: true)
        
        // kind
        btnKind = ViewHelper.getBtnBold(paddingH: margin * 2, paddingV: margin * 2, HAlign: .center, VAlign: .center, bgColor: ColorHelper.getTrans(), title: StringUtils.getString("click_me_choose_type"), titleSize: ViewHelper.FONT_SIZE_NORMAL, titleColor: ThemeHelper.getColorPrimary(), titleLines: 1, titleAlign: .center, titleMode: .byTruncatingMiddle)
        btnKind.center.x = screenWidth / 2
        btnKind.frame.origin.y = 0
        
        // title
        let lTitle = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("title"))
        lTitle.frame.origin = CGPoint(x: margin, y: btnKind.frame.origin.y + btnKind.frame.size.height + margin)
        
        tfTitle = ViewHelper.getTextField(width: maxWidth, paddingV: margin, text: "", textSize: ViewHelper.FONT_SIZE_NORMAL, textColor: ColorHelper.getFontGrey(), placeholder: StringUtils.getString("please_input_title"), placeColor: ColorHelper.getFontHint(), horizontalAlign: .left, verticalAlign: .center, borderStyle: .none)
        tfTitle.frame.origin = CGPoint(x: margin, y: lTitle.frame.origin.y + lTitle.frame.size.height + margin / 2)
        ViewUtils.setViewBorder(tfTitle, width: CGFloat(1), color: ThemeHelper.getColorPrimary())
        
        // content
        let lContent = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("content"))
        lContent.frame.origin = CGPoint(x: margin, y: tfTitle.frame.origin.y + tfTitle.frame.size.height + margin * 2)
        
        tvContent = ViewHelper.getTextView(width: maxWidth, height: ViewHelper.FONT_NORMAL_LINE_HEIGHT * 10, paddingV: margin, text: "", textSize: ViewHelper.FONT_SIZE_NORMAL, textColor: ColorHelper.getFontGrey(), placeholder: StringUtils.getString("please_input_content"), limitLength: UDHelper.getLimit().suggestContentLength)
        tvContent.frame.origin = CGPoint(x: margin, y: lContent.frame.origin.y + lContent.frame.size.height + margin / 2)
        ViewUtils.setViewBorder(tvContent, width: CGFloat(1), color: ThemeHelper.getColorPrimary())
        
        // view
        self.view.backgroundColor = ColorHelper.getWhite()
        self.view.addSubview(btnKind)
        self.view.addSubview(lTitle)
        self.view.addSubview(tfTitle)
        self.view.addSubview(lContent)
        self.view.addSubview(tvContent)
        
        // target
        btnKind.addTarget(self, action: #selector(showKindAlert), for: .touchUpInside)
    }
    
    override func initData() {
        // title
        let placeholder = StringUtils.getString("please_input_title_no_over_holder_text", arguments: [UDHelper.getLimit().suggestTitleLength])
        ViewUtils.setTextFiledPlaceholder(textField: tfTitle, placeholder: placeholder)
        // content
        ExtensionTextView.setTextViewTextWithPlaceholder(tvContent, text: "")
        // kind
        kindIndex = 0
        refreshKindView()
    }
    
    @objc func showKindAlert() {
        let kindList = ListHelper.getSuggestInfo().kindList
        var items = [String]()
        for kind in kindList {
            items.append(kind.show)
        }
        _ = AlertHelper.showAlert(title: StringUtils.getString("please_select_classify"),
                                  confirms: items,
                                  cancel: StringUtils.getString("cancel"),
                                  canCancel: true,
                                  actionHandler: { (_, index, _) in
                                    self.kindIndex = Int(index)
                                    self.refreshKindView()
        }, cancelHandler: nil)
    }
    
    func refreshKindView() {
        let kindList = ListHelper.getSuggestInfo().kindList
        if kindIndex < 0 || kindIndex >= kindList.count {
            btnKind.setTitle(StringUtils.getString("please_select_classify"), for: .normal)
            return
        }
        let kind = kindList[kindIndex]
        btnKind.setTitle(kind.show, for: .normal)
    }
    
    
    @objc func checkPush() {
        if StringUtils.isEmpty(tfTitle.text) {
            ToastUtils.show(tfTitle.placeholder)
            return
        } else if (tfTitle.text?.count ?? 0) > UDHelper.getLimit().suggestTitleLength {
            ToastUtils.show(tfTitle.placeholder)
            return
        }else if StringUtils.isEmpty(tvContent.text) {
            ToastUtils.show(tvContent.placeholder)
            return
        } else if (tvContent.text?.count ?? 0) > UDHelper.getLimit().suggestContentLength {
            ToastUtils.show(tvContent.placeholder)
            return
        }
        let kindList = ListHelper.getSuggestInfo().kindList
        if kindIndex < 0 || kindIndex >= kindList.count {
            ToastUtils.show(StringUtils.getString("please_select_classify"))
            return
        }
        let body = Suggest()
        body.kind = kindList[kindIndex].kind
        body.title = tfTitle.text ?? ""
        body.contentText = tvContent.text
        // api
        let api = Api.request(.setSuggestAdd(suggest: body.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_SUGGEST_LIST_REFRESH, obj: nil)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
        
    }
    
}
