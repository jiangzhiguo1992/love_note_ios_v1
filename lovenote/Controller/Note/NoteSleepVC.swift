//
//  NoteSleepVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/2/23.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar

class NoteSleepVC: BaseVC, FSCalendarDataSource, FSCalendarDelegate, UITableViewDelegate, UITableViewDataSource {
    
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
    private var btnPush: UIButton!
    private var ivAvatarLeft: UIImageView!
    private var lStatusLeft: UILabel!
    private var ivAvatarRight: UIImageView!
    private var lStatusRight: UILabel!
    private var tableLeft: UITableView!
    private var tableRight: UITableView!
    
    // var
    private var sleepMe: Sleep?
    private var sleepTa: Sleep?
    private var sleepList: [Sleep] = [Sleep]()
    private var sleepLeftList: [Sleep] = [Sleep]()
    private var sleepRightList: [Sleep] = [Sleep]()
    private var selectYear: Int = 0
    private var selectMonth: Int = 0
    private var selectDay: Int = 0
    private var tagLeft = 1
    private var tagRight = 2
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(NoteSleepVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "sleep")
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
        btnPush = ViewHelper.getBtnBold(width: pushWidth, height: pushWidth, HAlign: .center, VAlign: .center, bgColor: ColorHelper.getWhite(), title: "-", titleSize: ViewHelper.FONT_SIZE_BIG, titleColor: ThemeHelper.getColorPrimary(), titleAlign: .center, circle: true, shadow: false)
        btnPush.center.x = self.view.frame.size.width / 2
        btnPush.frame.origin.y = screenHeight - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomSafeHeight(xYes: margin, xNo: margin * 2) - btnPush.frame.size.height
        ViewUtils.setViewShadow(btnPush, offset: ViewHelper.SHADOW_BIG)
        
        // left
        ivAvatarLeft = ViewHelper.getImageViewAvatar(width: avatarWidth, height: avatarWidth)
        ivAvatarLeft.center.x = btnPush.frame.origin.x / 2
        ivAvatarLeft.frame.origin.y = btnPush.frame.origin.y
        
        lStatusLeft = ViewHelper.getLabelBold(width: (screenWidth - btnPush.frame.size.width) / 2 - margin * 2, text: "-", size: ViewHelper.FONT_SIZE_NORMAL, color: ColorHelper.getFontWhite(), lines: 1, align: .center, mode: .byTruncatingMiddle)
        lStatusLeft.center.x = btnPush.frame.origin.x / 2
        lStatusLeft.frame.origin.y = btnPush.frame.origin.y + btnPush.frame.size.height - lStatusLeft.frame.size.height
        
        // right
        ivAvatarRight = ViewHelper.getImageViewAvatar(width: avatarWidth, height: avatarWidth)
        ivAvatarRight.center.x = (screenWidth - btnPush.frame.origin.x - btnPush.frame.size.width) / 2 + btnPush.frame.origin.x + btnPush.frame.size.width
        ivAvatarRight.frame.origin.y = btnPush.frame.origin.y
        
        lStatusRight = ViewHelper.getLabelBold(width: (screenWidth - btnPush.frame.size.width) / 2 - margin * 2, text: "-", size: ViewHelper.FONT_SIZE_NORMAL, color: ColorHelper.getFontWhite(), lines: 1, align: .center, mode: .byTruncatingMiddle)
        lStatusRight.center.x = (screenWidth - btnPush.frame.origin.x - btnPush.frame.size.width) / 2 + btnPush.frame.origin.x + btnPush.frame.size.width
        lStatusRight.frame.origin.y = btnPush.frame.origin.y + btnPush.frame.size.height - lStatusRight.frame.size.height
        
        // table
        let tableY = calendarView.frame.origin.y + calendarView.frame.size.height + margin
        let tableWidth = (maxWidth - margin) / 2
        let tableHeight = btnPush.frame.origin.y - margin * 2 - tableY
        let frameLeft = CGRect(x: margin, y: tableY, width: tableWidth, height: tableHeight)
        tableLeft = ViewUtils.getTableView(target: self, frame: frameLeft, cellCls: NoteSleepCell.self, id: NoteSleepCell.ID)
        tableLeft.tag = tagLeft
        
        let frameRight = CGRect(x: tableLeft.frame.origin.x + tableLeft.frame.size.width + margin, y: tableY, width: tableWidth, height: tableHeight)
        tableRight = ViewUtils.getTableView(target: self, frame: frameRight, cellCls: NoteSleepCell.self, id: NoteSleepCell.ID)
        tableRight.tag = tagRight
        
        // view
        self.view.backgroundColor = ThemeHelper.getColorPrimary()
        self.view.addSubview(calendarView)
        self.view.addSubview(btnPush)
        self.view.addSubview(ivAvatarLeft)
        self.view.addSubview(lStatusLeft)
        self.view.addSubview(ivAvatarRight)
        self.view.addSubview(lStatusRight)
        self.view.addSubview(tableLeft)
        self.view.addSubview(tableRight)
        
        // hide
        ivAvatarLeft.isHidden = true
        lStatusLeft.isHidden = true
        ivAvatarRight.isHidden = true
        lStatusRight.isHidden = true
        
        // target
        btnPush.addTarget(self, action: #selector(sleepPush), for: .touchUpInside)
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyListItemDelete), name: NotifyHelper.TAG_SLEEP_LIST_ITEM_DELETE)
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
        refreshCenterMonthView()
        refreshBottomStatusView()
        // 开始获取数据
        refreshCenterMonthData()
        refreshBottomStatusData()
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_NOTE_SLEEP)
    }
    
    @objc func notifyListItemDelete(notify: NSNotification) {
        let indexLeft = ListHelper.findIndexByIdInList(list: sleepLeftList, obj: notify.object)
        if indexLeft > 0 && sleepLeftList.count > indexLeft {
            sleepLeftList.remove(at: indexLeft)
            tableLeft.deleteRows(at: [IndexPath(row: indexLeft, section: 0)], with: .automatic)
        }
        let indexRight = ListHelper.findIndexByIdInList(list: sleepRightList, obj: notify.object)
        if indexRight > 0 && sleepRightList.count > indexRight {
            sleepRightList.remove(at: indexRight)
            tableRight.deleteRows(at: [IndexPath(row: indexRight, section: 0)], with: .automatic)
        }
        refreshCenterMonthData()
        refreshBottomStatusData()
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
        sleepList.removeAll()
        refreshCenterDayView()
        // api
        let api = Api.request(.noteSleepListGetByDate(year: selectYear, month: selectMonth),
                              success: { (_, _, data) in
                                self.sleepList = data.sleepList ?? [Sleep]()
                                // view
                                self.refreshCenterMonthView()
                                self.refreshCenterDayView()
        }, failure: nil)
        pushApi(api)
    }
    
    func refreshCenterMonthView() {
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
        if sleepList.count > 0 {
            var count: Int = 0
            var hasUserId: Int64 = 0
            let showDc = DateUtils.getDC(date)
            for sleep in sleepList {
                if sleep.year == (showDc.year ?? -1) && sleep.monthOfYear == (showDc.month ?? -1) && sleep.dayOfMonth == (showDc.day ?? -1) {
                    if hasUserId == 0 {
                        hasUserId = sleep.userId
                        count += 1
                    } else {
                        if hasUserId != sleep.userId {
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
            self.refreshCenterDayView()
            return
        }
        self.selectYear = selectDc.year ?? -1
        self.selectMonth = selectDc.month ?? -1
        self.selectDay = selectDc.day ?? -1
        refreshCenterMonthData()
    }
    
    func refreshCenterDayView() {
        sleepLeftList.removeAll()
        sleepRightList.removeAll()
        if sleepList.count > 0 {
            for sleep in sleepList {
                if sleep.year == selectYear && sleep.monthOfYear == selectMonth && sleep.dayOfMonth == selectDay {
                    if sleep.isMine() {
                        sleepRightList.append(sleep)
                    } else {
                        sleepLeftList.append(sleep)
                    }
                }
            }
        }
        tableLeft.reloadData()
        tableRight.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == tagLeft {
            return sleepLeftList.count
        } else if tableView.tag == tagRight {
            return sleepRightList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NoteSleepCell.getCellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == tagLeft {
            return NoteSleepCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: sleepLeftList)
        } else if tableView.tag == tagRight {
            return NoteSleepCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: sleepRightList, target: self, actionDel: #selector(targetRemoveItem))
        }
        return UITableViewCell()
    }
    
    /**
     * **************************************** bottom ***********************************************
     */
    func refreshBottomStatusData() {
        // api
        let api = Api.request(.noteSleepLatestGet,
                              success: { (_, _, data) in
                                self.sleepMe = data.sleepMe
                                self.sleepTa = data.sleepTa
                                // view
                                self.refreshBottomStatusView()
        }, failure: nil)
        pushApi(api)
    }
    
    func refreshBottomStatusView() {
        let sleepBtnShow = StringUtils.getString((sleepMe?.isSleep ?? false) ? "i_am_wake" : "good_night")
        btnPush.setTitle(sleepBtnShow, for: .normal)
    }
    
    @objc func sleepPush() {
        let body = Sleep()
        body.isSleep = !(sleepMe?.isSleep ?? false)
        // api
        let api = Api.request(.noteSleepAdd(sleep: body.toJSON()),
                              success: { (_, _, data) in
                                self.sleepMe = data.sleep
                                // view
                                self.refreshBottomStatusView()
                                // data
                                self.refreshCenterMonthData()
        }, failure: nil)
        pushApi(api)
    }
    
    @objc private func targetRemoveItem(sender: UIButton) {
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_delete_this_note"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    if let indexPath = ViewUtils.findTableIndexPath(view: sender) {
                                        self.delSleep(index: indexPath.row)
                                    }
        },
                                  cancelHandler: nil)
    }
    
    private func delSleep(index: Int) {
        if sleepRightList.count <= index {
            return
        }
        let sleep = sleepRightList[index]
        if !sleep.isMine() {
            ToastUtils.show(StringUtils.getString("can_operation_self_create_note"))
            return
        }
        // api
        let api = Api.request(.noteSleepDel(sid: sleep.id),
                              loading: true, cancel: true, success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_SLEEP_LIST_ITEM_DELETE, obj: sleep)
        }, failure: nil)
        pushApi(api)
    }
    
}
