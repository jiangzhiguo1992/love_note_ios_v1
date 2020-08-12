//
//  NoteMensesInfoVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/16.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteMensesInfoVC: BaseVC, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // const
    lazy var margin = ScreenUtils.widthFit(15)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    lazy var tagMeCycle: Int = 1
    lazy var tagMeDuration: Int = 2
    lazy var tagTaCycle: Int = 3
    lazy var tagTaDuration: Int = 4
    
    // view
    private var vMe: UIView!
    private var btnMeCycle: UIButton!
    private var btnMeDuration: UIButton!
    private var vTa: UIView!
    private var btnTaCycle: UIButton!
    private var btnTaDuration: UIButton!
    private var pvDay: UIPickerView!
    
    // var
    private var limit: Limit!
    private var mensesInfo: MensesInfo!
    private var lengthMe: MensesLength?
    private var lengthTa: MensesLength?
    private var selectTag: Int = 0
    
    public static func pushVC(mensesInfo: MensesInfo?) {
        if mensesInfo == nil || (!mensesInfo!.canMe && !mensesInfo!.canTa) {
            return
        }
        AppDelegate.runOnMainAsync {
            let vc = NoteMensesInfoVC(nibName: nil, bundle: nil)
            vc.mensesInfo = mensesInfo!
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "menses_info")
        let barItemCommit = UIBarButtonItem(title: StringUtils.getString("commit"), style: .plain, target: self, action: #selector(commit))
        barItemCommit.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        self.navigationItem.setRightBarButtonItems([barItemCommit], animated: true)
        
        // me
        let lMe = ViewHelper.getLabelGreySmall(text: StringUtils.getString("me_de"))
        lMe.frame.origin = CGPoint(x: margin, y: margin)
        
        btnMeCycle = ViewHelper.getBtnTextBlack(width: maxWidth, paddingV: margin, HAlign: .left, VAlign: .center, title: StringUtils.getString("menses_cycle_colon_holder_day"), titleSize: ViewHelper.FONT_SIZE_NORMAL, titleLines: 1, titleAlign: .center)
        btnMeCycle.frame.origin = CGPoint(x: margin, y: lMe.frame.origin.y + lMe.frame.size.height + margin)
        btnMeCycle.tag = tagMeCycle
        
        let lineMe = ViewHelper.getViewLine(width: maxWidth)
        lineMe.frame.origin = CGPoint(x: margin, y: btnMeCycle.frame.origin.y + btnMeCycle.frame.size.height)
        
        btnMeDuration = ViewHelper.getBtnTextBlack(width: maxWidth, paddingV: margin, HAlign: .left, VAlign: .center, title: StringUtils.getString("menses_duration_colon_holder_day"), titleSize: ViewHelper.FONT_SIZE_NORMAL, titleLines: 1, titleAlign: .center)
        btnMeDuration.frame.origin = CGPoint(x: margin, y: lineMe.frame.origin.y + lineMe.frame.size.height)
        btnMeDuration.tag = tagMeDuration
        
        vMe = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: btnMeDuration.frame.origin.y + btnMeDuration.frame.size.height))
        vMe.addSubview(lMe)
        vMe.addSubview(btnMeCycle)
        vMe.addSubview(lineMe)
        vMe.addSubview(btnMeDuration)
        
        // ta
        let lTa = ViewHelper.getLabelGreySmall(text: StringUtils.getString("ta_de"))
        lTa.frame.origin = CGPoint(x: margin, y: margin)
        
        btnTaCycle = ViewHelper.getBtnTextBlack(width: maxWidth, paddingV: margin, HAlign: .left, VAlign: .center, title: StringUtils.getString("menses_cycle_colon_holder_day"), titleSize: ViewHelper.FONT_SIZE_NORMAL, titleLines: 1, titleAlign: .center)
        btnTaCycle.frame.origin = CGPoint(x: margin, y: lTa.frame.origin.y + lTa.frame.size.height + margin)
        btnTaCycle.tag = tagTaCycle
        
        let lineTa = ViewHelper.getViewLine(width: maxWidth)
        lineTa.frame.origin = CGPoint(x: margin, y: btnTaCycle.frame.origin.y + btnTaCycle.frame.size.height)
        
        btnTaDuration = ViewHelper.getBtnTextBlack(width: maxWidth, paddingV: margin, HAlign: .left, VAlign: .center, title: StringUtils.getString("menses_duration_colon_holder_day"), titleSize: ViewHelper.FONT_SIZE_NORMAL, titleLines: 1, titleAlign: .center)
        btnTaDuration.frame.origin = CGPoint(x: margin, y: lineTa.frame.origin.y + lineTa.frame.size.height)
        btnTaDuration.tag = tagTaDuration
        
        vTa = UIView(frame: CGRect(x: 0, y: vMe.frame.origin.y + vMe.frame.size.height, width: screenWidth, height: btnTaDuration.frame.origin.y + btnTaDuration.frame.size.height))
        vTa.addSubview(lTa)
        vTa.addSubview(btnTaCycle)
        vTa.addSubview(lineTa)
        vTa.addSubview(btnTaDuration)
        
        // picker
        let bottomHeight = self.view.frame.size.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight() - vTa.frame.origin.y - vTa.frame.size.height
        let bottomY = vTa.frame.origin.y + vTa.frame.size.height + bottomHeight / 4
        pvDay = ViewUtils.getPicker(target: self, width: maxWidth, height: bottomHeight / 2, tintColor: ThemeHelper.getColorPrimary())
        pvDay.frame.origin = CGPoint(x: margin, y: bottomY)
        
        // view
        self.view.addSubview(vMe)
        self.view.addSubview(vTa)
        self.view.addSubview(pvDay)
        
        // hide
        vMe.isHidden = true
        vTa.isHidden = true
        pvDay.isHidden = true
        
        // target
        btnMeCycle.addTarget(self, action: #selector(toggleNumberPicker), for: .touchUpInside)
        btnMeDuration.addTarget(self, action: #selector(toggleNumberPicker), for: .touchUpInside)
        btnTaCycle.addTarget(self, action: #selector(toggleNumberPicker), for: .touchUpInside)
        btnTaDuration.addTarget(self, action: #selector(toggleNumberPicker), for: .touchUpInside)
    }
    
    override func initData() {
        // data
        selectTag = 0
        limit = UDHelper.getLimit()
        if mensesInfo == nil {
            RootVC.get().popBack()
            return
        }
        lengthMe = mensesInfo.mensesLengthMe
        if lengthMe == nil {
            lengthMe = MensesLength()
            lengthMe?.cycleDay = limit.mensesDefaultCycleDay
            lengthMe?.durationDay = limit.mensesDefaultDurationDay
        }
        lengthTa = mensesInfo.mensesLengthTa
        if lengthTa == nil {
            lengthTa = MensesLength()
            lengthTa?.cycleDay = limit.mensesDefaultCycleDay
            lengthTa?.durationDay = limit.mensesDefaultDurationDay
        }
        // view
        vMe.isHidden = !mensesInfo.canMe
        vTa.isHidden = !mensesInfo.canTa
        if vMe.isHidden && !vTa.isHidden {
            vTa.frame.origin.y = vMe.frame.origin.y
        }
        refreshView()
    }
    
    func refreshView() {
        let myCycle = lengthMe?.cycleDay ?? limit.mensesDefaultCycleDay
        let myDuration = lengthMe?.durationDay ?? limit.mensesDefaultDurationDay
        let taCycle = lengthTa?.cycleDay ?? limit.mensesDefaultCycleDay
        let taDuration = lengthTa?.durationDay ?? limit.mensesDefaultDurationDay
        btnMeCycle.setTitle(StringUtils.getString("menses_cycle_colon_holder_day", arguments: [myCycle]), for: .normal)
        btnMeDuration.setTitle(StringUtils.getString("menses_duration_colon_holder_day", arguments: [myDuration]), for: .normal)
        btnTaCycle.setTitle(StringUtils.getString("menses_cycle_colon_holder_day", arguments: [taCycle]), for: .normal)
        btnTaDuration.setTitle(StringUtils.getString("menses_duration_colon_holder_day", arguments: [taDuration]), for: .normal)
    }
    
    @objc func toggleNumberPicker(sender: UIButton) {
        if selectTag == sender.tag {
            selectTag = 0
            pvDay.isHidden = true
            return
        }
        selectTag = sender.tag
        pvDay.isHidden = false
        pvDay.reloadAllComponents()
        // data
        let myCycleIndex = (lengthMe?.cycleDay ?? limit.mensesDefaultCycleDay) - 1
        let myDurationIndex = (lengthMe?.durationDay ?? limit.mensesDefaultDurationDay) - 1
        let taCycleIndex = (lengthTa?.cycleDay ?? limit.mensesDefaultCycleDay) - 1
        let taDurationIndex = (lengthTa?.durationDay ?? limit.mensesDefaultDurationDay) - 1
        if selectTag == tagMeCycle {
            pvDay.selectRow(myCycleIndex, inComponent: 0, animated: false)
        } else if selectTag == tagMeDuration {
            pvDay.selectRow(myDurationIndex, inComponent: 0, animated: false)
        } else if selectTag == tagTaCycle {
            pvDay.selectRow(taCycleIndex, inComponent: 0, animated: false)
        } else if selectTag == tagTaDuration {
            pvDay.selectRow(taDurationIndex, inComponent: 0, animated: false)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pvDay.frame.size.height / 3
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if selectTag == tagMeCycle || selectTag == tagTaCycle {
            return limit.mensesMaxCycleDay
        } else if selectTag == tagMeDuration || selectTag == tagTaDuration {
            return limit.mensesMaxDurationDay
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)" + StringUtils.getString("dayT")
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectTag == tagMeCycle {
            if lengthMe != nil && row >= 0 && row < limit.mensesMaxCycleDay {
                lengthMe!.cycleDay = row + 1
            }
        } else if selectTag == tagMeDuration {
            if lengthMe != nil && row >= 0 && row < limit.mensesMaxDurationDay {
                lengthMe!.durationDay = row + 1
            }
        } else if selectTag == tagTaCycle {
            if lengthTa != nil && row >= 0 && row < limit.mensesMaxCycleDay {
                lengthTa!.cycleDay = row + 1
            }
        } else if selectTag == tagTaDuration {
            if lengthTa != nil && row >= 0 && row < limit.mensesMaxDurationDay {
                lengthTa!.durationDay = row + 1
            }
        }
        refreshView()
    }
    
    @objc func commit() {
        if mensesInfo == nil {
            return
        }
        // api
        let api = Api.request(.noteMensesInfoUpdate(mensesInfo: mensesInfo.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_MENSES_INFO_UPDATE, obj: self.mensesInfo)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
}
