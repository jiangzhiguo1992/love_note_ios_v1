//
//  MoreSignVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/22.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar

class MoreSignVC: BaseVC, FSCalendarDataSource, FSCalendarDelegate {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var screenHeight = ScreenUtils.getScreenHeight()
    lazy var calendarHeight = screenHeight / 8 * 3
    lazy var maxWidth = screenWidth - margin * 2
    lazy var pushWidth = ScreenUtils.widthFit(80)
    lazy var avatarWidth = ScreenUtils.widthFit(40)
    
    // view
    private var calendarView: GGCalendarView!
    private var btnStatus: UIButton!
    private var ivAvatarLeft: UIImageView!
    private var lStatusLeft: UILabel!
    private var ivAvatarRight: UIImageView!
    private var lStatusRight: UILabel!
    private var lContinue: UILabel!
    
    // var
    private var today: Sign?
    private var signList: [Sign] = [Sign]()
    private var selectYear: Int = 0
    private var selectMonth: Int = 0
    private var selectDay: Int = 0
    
    public static func pushVC() {
        if UserHelper.isCoupleBreak(couple: UDHelper.getCouple()) {
            CouplePairVC.pushVC()
            return
        }
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(MoreSignVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "sign")
        let barHelp = UIBarButtonItem(image: UIImage(named: "ic_help_outline_white_24dp"), style: .plain, target: self, action: #selector(targetGoHelp))
        self.navigationItem.rightBarButtonItems = [barHelp]
        
        // calendar
        calendarView = GGCalendarView(frame: CGRect(x: margin, y: margin * 2, width: maxWidth, height: calendarHeight))
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(calendarView, radius: ViewHelper.RADIUS_BIG)
        ViewUtils.setViewShadow(calendarView, offset: ViewHelper.SHADOW_BIG)
        
        // push
        btnStatus = ViewHelper.getBtnBold(width: pushWidth, height: pushWidth, HAlign: .center, VAlign: .center, bgColor: ColorHelper.getWhite(), title: "-", titleSize: ViewHelper.FONT_SIZE_BIG, titleColor: ThemeHelper.getColorPrimary(), titleAlign: .center, circle: true, shadow: false)
        btnStatus.center.x = self.view.frame.size.width / 2
        btnStatus.frame.origin.y = screenHeight - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomSafeHeight(xYes: margin, xNo: margin * 2) - btnStatus.frame.size.height
        ViewUtils.setViewShadow(btnStatus, offset: ViewHelper.SHADOW_BIG)
        
        // left
        ivAvatarLeft = ViewHelper.getImageViewAvatar(width: avatarWidth, height: avatarWidth)
        ivAvatarLeft.center.x = btnStatus.frame.origin.x / 2
        ivAvatarLeft.frame.origin.y = btnStatus.frame.origin.y
        
        lStatusLeft = ViewHelper.getLabelBold(width: (screenWidth - btnStatus.frame.size.width) / 2 - margin * 2, text: "-", size: ViewHelper.FONT_SIZE_NORMAL, color: ColorHelper.getFontWhite(), lines: 1, align: .center, mode: .byTruncatingMiddle)
        lStatusLeft.center.x = btnStatus.frame.origin.x / 2
        lStatusLeft.frame.origin.y = btnStatus.frame.origin.y + btnStatus.frame.size.height - lStatusLeft.frame.size.height
        
        // right
        ivAvatarRight = ViewHelper.getImageViewAvatar(width: avatarWidth, height: avatarWidth)
        ivAvatarRight.center.x = (screenWidth - btnStatus.frame.origin.x - btnStatus.frame.size.width) / 2 + btnStatus.frame.origin.x + btnStatus.frame.size.width
        ivAvatarRight.frame.origin.y = btnStatus.frame.origin.y
        
        lStatusRight = ViewHelper.getLabelBold(width: (screenWidth - btnStatus.frame.size.width) / 2 - margin * 2, text: "-", size: ViewHelper.FONT_SIZE_NORMAL, color: ColorHelper.getFontWhite(), lines: 1, align: .center, mode: .byTruncatingMiddle)
        lStatusRight.center.x = (screenWidth - btnStatus.frame.origin.x - btnStatus.frame.size.width) / 2 + btnStatus.frame.origin.x + btnStatus.frame.size.width
        lStatusRight.frame.origin.y = btnStatus.frame.origin.y + btnStatus.frame.size.height - lStatusRight.frame.size.height
        
        // coinAd
        lContinue = ViewHelper.getLabelBold(width: maxWidth - margin * 2, height: ViewHelper.FONT_HUGE_LINE_HEIGHT + ScreenUtils.heightFit(5), text: "", size: ViewHelper.FONT_SIZE_HUGE, color: ColorHelper.getFontWhite(), lines: 1, align: .center)
        lContinue.frame.origin = CGPoint(x: margin, y: margin)
        
        let centerY = calendarView.frame.origin.y + calendarView.frame.size.height + margin
        let centerHeight = btnStatus.frame.origin.y - margin * 2 - centerY
        let coinAdCenterY = centerY + centerHeight / 2
        let vCoinAd = UIView()
        vCoinAd.frame.size = CGSize(width: maxWidth, height: lContinue.frame.origin.y + lContinue.frame.size.height + margin)
        vCoinAd.frame.origin.x = margin
        vCoinAd.center.y = coinAdCenterY
        vCoinAd.addSubview(lContinue)
        
        // view
        self.view.backgroundColor = ThemeHelper.getColorPrimary()
        self.view.addSubview(calendarView)
        self.view.addSubview(vCoinAd)
        self.view.addSubview(btnStatus)
        self.view.addSubview(ivAvatarLeft)
        self.view.addSubview(lStatusLeft)
        self.view.addSubview(ivAvatarRight)
        self.view.addSubview(lStatusRight)
        
        // target
        btnStatus.addTarget(self, action: #selector(signPush), for: .touchUpInside)
    }
    
    override func initData() {
        // avatar
        let me = UDHelper.getMe()
        let ta = UDHelper.getTa()
        let myAvatar = UserHelper.getMyAvatar(user: me)
        let taAvatar = UserHelper.getTaAvatar(user: me)
        KFHelper.setImgAvatarUrl(iv: ivAvatarRight, objKey: myAvatar, user: me)
        KFHelper.setImgAvatarUrl(iv: ivAvatarLeft, objKey: taAvatar, user: ta)
        // 设置当前日期
        refreshDateToCurrent()
        // 显示当前数据
        today = nil
        refreshCenterMonthView()
        // 开始获取数据
        refreshCenterMonthData()
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_MORE_SIGN)
    }
    
    /**
     * **************************************** top ***********************************************
     */
    func refreshDateToCurrent() {
        let currentDate = DateUtils.getCurrentDate()
        let currentDc = DateUtils.getDC(currentDate)
        selectYear = currentDc.year ?? -1
        selectMonth = currentDc.month ?? -1
        selectDay = currentDc.day ?? -1
        calendarView.setCurrentPage(currentDate, animated: true) // 不走回调
        calendarView.select(currentDate) // 不走回调
    }
    
    /**
     * **************************************** center ***********************************************
     */
    func refreshCenterMonthData() {
        // clear (data + view)
        signList.removeAll()
        refreshBottomStatusView()
        // api
        let api = Api.request(.moreSignDateGet(year: selectYear, month: selectMonth),
                              success: { (_, _, data) in
                                self.signList = data.signList ?? [Sign]()
                                // view
                                self.refreshCenterMonthView()
                                self.refreshBottomStatusView()
        }, failure: nil)
        pushApi(api)
    }
    
    func refreshCenterMonthView() {
        var rightCount = 0
        var leftCount = 0
        if signList.count > 0 {
            let dcCurrent = DateUtils.getCurrentDC()
            for sign in signList {
                if sign.isMine() {
                    rightCount += 1
                } else {
                    leftCount += 1
                }
                if today == nil && (sign.year == (dcCurrent.year ?? -1) && sign.monthOfYear == (dcCurrent.month ?? -1) && sign.dayOfMonth == (dcCurrent.day ?? -1)) {
                    today = sign
                    lContinue.text = StringUtils.getString("continue_sign_holder_day", arguments: [sign.continueDay])
                }
            }
        }
        lStatusLeft.text = StringUtils.getString("to_month_sign_holder_count", arguments: [leftCount])
        lStatusRight.text = StringUtils.getString("to_month_sign_holder_count", arguments: [rightCount])
        // calendar
        calendarView.reloadData()
    }
    
    // 副标题
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let dcLunar = DateUtils.getLunarDC(date: date)
        if (dcLunar.day ?? 0) == 1 {
            return DateUtils.lunarMonths[(dcLunar.month ?? 1) - 1]
        } else {
            return DateUtils.lunarDays[(dcLunar.day ?? 1) - 1]
        }
    }
    
    // 事件数量
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if signList.count > 0 {
            var count: Int = 0
            var hasUserId: Int64 = 0
            let showDc = DateUtils.getDC(date)
            for sign in signList {
                if sign.year == (showDc.year ?? -1) && sign.monthOfYear == (showDc.month ?? -1) && sign.dayOfMonth == (showDc.day ?? -1) {
                    if hasUserId == 0 {
                        hasUserId = sign.userId
                        count += 1
                    } else {
                        if hasUserId != sign.userId {
                            hasUserId = 0
                            count += 1
                            break
                        }
                    }
                }
            }
            return count
        }
        return 0
    }
    
    // 月份切换
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentDate = calendar.currentPage
        let currentDc = DateUtils.getDC(currentDate)
        self.selectYear = currentDc.year ?? -1
        self.selectMonth = currentDc.month ?? -1
        self.selectDay = currentDc.day ?? -1
        // view
        calendarView.select(currentDate) // 不走回调
        // data
        refreshCenterMonthData()
    }
    
    // 日期选择
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectDc = DateUtils.getDC(date)
        if self.selectYear == (selectDc.year ?? 0) && self.selectMonth == (selectDc.month ?? 0) {
            // 只是选择的同月day
            self.selectDay = selectDc.day ?? -1
            self.refreshBottomStatusView()
            return
        }
        self.selectYear = selectDc.year ?? -1
        self.selectMonth = selectDc.month ?? -1
        self.selectDay = selectDc.day ?? -1
        refreshCenterMonthData()
    }
    
    /**
     * **************************************** bottom ***********************************************
     */
    func refreshBottomStatusView() {
        // data
        var signShow = ""
        if signList.count > 0 {
            for sign in signList {
                if sign.year == selectYear && sign.monthOfYear == selectMonth && sign.dayOfMonth == selectDay {
                    signShow = DateUtils.getStr(sign.createAt, DateUtils.FORMAT_H_M)
                }
            }
        }
        if StringUtils.isEmpty(signShow) {
            let dcCurrent = DateUtils.getCurrentDC()
            if (dcCurrent.year ?? -1) == selectYear && (dcCurrent.month ?? -1) == selectMonth && (dcCurrent.day ?? -1) == selectDay {
                signShow = StringUtils.getString("sign")
            } else {
                signShow = StringUtils.getString("now_no")
            }
        }
        // view
        btnStatus.setTitle(signShow, for: .normal)
    }
    
    @objc func signPush() {
        // api
        let api = Api.request(.moreSignAdd,
                              success: { (_, _, data) in
                                self.today = data.sign
                                if self.today != nil {
                                    // 上面不是nil，不会set
                                    self.lContinue.text = StringUtils.getString("continue_sign_holder_day", arguments: [self.today!.continueDay])
                                }
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_COIN_INFO_REFRESH, obj: Coin())
                                // view
                                self.refreshBottomStatusView()
                                // data
                                self.refreshCenterMonthData()
        }, failure: nil)
        pushApi(api)
    }
    
}
