//
//  TopicPostCommentAddVC.swift
//  
//
//  Created by 蒋治国 on 2019/5/2.
//

import Foundation
import UIKit

class TopicPostCommentAddVC: BaseVC {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenHeight = ScreenUtils.getScreenHeight()
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    
    // view
    private var tvContent: UITextView!
    
    // var
    private var pid: Int64 = 0
    private var tcid: Int64 = 0
    
    public static func pushVC(pid: Int64, tcid: Int64 = 0) {
        if pid == 0 {
            return
        }
        AppDelegate.runOnMainAsync {
            let vc = TopicPostCommentAddVC(nibName: nil, bundle: nil)
            vc.pid = pid
            vc.tcid = tcid
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "comment")
        let barItemCommit = UIBarButtonItem(title: StringUtils.getString("commit"), style: .plain, target: self, action: #selector(checkPush))
        barItemCommit.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        self.navigationItem.setRightBarButtonItems([barItemCommit], animated: true)
        
        // content
        tvContent = ViewHelper.getTextView(width: maxWidth, height: screenHeight / 2, text: "", textSize: ViewHelper.FONT_SIZE_BIG, textColor: ColorHelper.getFontGrey(), placeholder: StringUtils.getString("please_input_comment_content"), limitLength: UDHelper.getLimit().postCommentContentLength)
        tvContent.frame.origin = CGPoint(x: margin, y: margin * 2)
        
        // view
        self.view.backgroundColor = ColorHelper.getWhite()
        self.view.addSubview(tvContent)
    }
    
    override func initData() {
        // content
        ExtensionTextView.setTextViewTextWithPlaceholder(tvContent, text: "")
    }
    
    @objc func checkPush() {
        if StringUtils.isEmpty(tvContent.text) {
            ToastUtils.show(tvContent.placeholder)
            return
        }
        let body = ApiHelper.getPostCommentTextBody(pid: pid, tcid: tcid, content: tvContent.text)
        // api
        let api = Api.request(.topicPostCommentAdd(postComment: body.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_POST_DETAIL_REFRESH, obj: self.pid)
                                NotifyHelper.post(NotifyHelper.TAG_POST_COMMENT_LIST_REFRESH, obj: body)
                                if self.tcid > 0 {
                                    NotifyHelper.post(NotifyHelper.TAG_POST_COMMENT_DETAIL_REFRESH, obj: self.tcid)
                                }
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
}
