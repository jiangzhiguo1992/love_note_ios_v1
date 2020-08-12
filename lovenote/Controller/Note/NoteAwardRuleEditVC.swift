//
//  NoteAwardRuleEditVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/23.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteAwardRuleEditVC: BaseVC {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    lazy var scoreHeight = ScreenUtils.heightFit(60)
    
    // view
    private var scroll: UIScrollView!
    private var lScore: UILabel!
    private var tvTitle: UITextView!
    
    // var
    private var awardRule: AwardRule?
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(NoteAwardRuleEditVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "award_rule")
        let barItemCommit = UIBarButtonItem(title: StringUtils.getString("commit"), style: .plain, target: self, action: #selector(addApi))
        barItemCommit.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        self.navigationItem.setRightBarButtonItems([barItemCommit], animated: true)
        
        // score-label
        lScore = ViewHelper.getLabelBold(width: maxWidth / 3, height: scoreHeight, text: "0", size: ScreenUtils.fontFit(30), color: ColorHelper.getFontWhite(), lines: 1, align: .center, mode: .byTruncatingMiddle)
        lScore.center = CGPoint(x: maxWidth / 2, y: scoreHeight / 2)
        
        // score-btn
        let btnAdd = ViewHelper.getBtnBGTrans(width: maxWidth / 3, height: scoreHeight, HAlign: .center, VAlign: .center, title: StringUtils.getString("symbol_add"), titleSize: ScreenUtils.fontFit(35), titleColor: ColorHelper.getFontWhite(), titleLines: 1, titleAlign: .center, titleMode: .byTruncatingMiddle, circle: false, shadow: false)
        btnAdd.frame.origin = CGPoint(x: 0, y: 0)
        let btnSub = ViewHelper.getBtnBGTrans(width: maxWidth / 3, height: scoreHeight, HAlign: .center, VAlign: .center, title: StringUtils.getString("symbol_sub"), titleSize: ScreenUtils.fontFit(35), titleColor: ColorHelper.getFontWhite(), titleLines: 1, titleAlign: .center, titleMode: .byTruncatingMiddle, circle: false, shadow: false)
        btnSub.frame.origin = CGPoint(x: maxWidth / 3 * 2, y: 0)
        
        // score-root
        let vScore = UIView(frame: CGRect(x: margin, y: margin * 3, width: maxWidth, height: scoreHeight))
        vScore.backgroundColor = ThemeHelper.getColorPrimary()
        ViewUtils.setViewRadius(vScore, radius: scoreHeight / 2)
        ViewUtils.setViewShadow(vScore, offset: ViewHelper.SHADOW_NORMAL)
        vScore.addSubview(lScore)
        vScore.addSubview(btnAdd)
        vScore.addSubview(btnSub)
        
        // content
        tvTitle = ViewHelper.getTextView(width: maxWidth, height: ViewHelper.FONT_NORMAL_LINE_HEIGHT * 5, text: "", textSize: ViewHelper.FONT_SIZE_NORMAL, textColor: ColorHelper.getFontGrey(), placeholder: StringUtils.getString("please_input_rule_content"), limitLength: UDHelper.getLimit().awardRuleTitleLength)
        tvTitle.frame.origin = CGPoint(x: margin, y: vScore.frame.origin.y + vScore.frame.size.height + margin * 3)
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = tvTitle.frame.origin.y + self.view.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
        scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        
        scroll.addSubview(vScore)
        scroll.addSubview(tvTitle)
        
        // view
        self.view.backgroundColor = ColorHelper.getWhite()
        self.view.addSubview(scroll)
        
        // target
        btnAdd.addTarget(self, action: #selector(targetScoreAdd), for: .touchUpInside)
        btnSub.addTarget(self, action: #selector(targetScoreSub), for: .touchUpInside)
    }
    
    override func initData() {
        // init
        awardRule = AwardRule()
        // score
        refreshScoreView()
        // title
        ExtensionTextView.setTextViewTextWithPlaceholder(tvTitle, text: awardRule?.title)
    }
    
    @objc func targetScoreAdd(sender: UIButton) {
        changeScore(add: true)
    }
    
    @objc func targetScoreSub(sender: UIButton) {
        changeScore(add: false)
    }
    
    func changeScore(add: Bool) {
        if awardRule == nil {
            return
        }
        let scoreMax = UDHelper.getLimit().awardRuleScoreMax
        if add {
            if awardRule!.score < scoreMax {
                awardRule!.score += 1
            }
        } else {
            if awardRule!.score > -scoreMax {
                awardRule!.score -= 1
            }
        }
        refreshScoreView()
    }
    
    func refreshScoreView() {
        if awardRule == nil {
            return
        }
        lScore.text = "\(awardRule!.score)"
    }
    
    @objc func addApi() {
        if awardRule == nil {
            return
        }
        if awardRule!.score == 0 {
            ToastUtils.show(StringUtils.getString("please_select_score"))
            return
        } else if StringUtils.isEmpty(tvTitle.text) {
            ToastUtils.show(tvTitle.placeholder)
            return
        }
        awardRule?.title = tvTitle.text
        // api
        let api = Api.request(.noteAwardRuleAdd(awardRule: awardRule!.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_AWARD_RULE_LIST_REFRESH, obj: nil)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
}
