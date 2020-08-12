//
//  NoteShyVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/2/23.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar

class NoteShyVC: BaseVC, FSCalendarDataSource, FSCalendarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var screenHeight = ScreenUtils.getScreenHeight()
    lazy var calendarHeight = screenHeight / 8 * 3
    lazy var maxWidth = screenWidth - margin * 2
    lazy var pushWidth = ScreenUtils.widthFit(80)
    
    // view
    private var calendarView: GGCalendarView!
    private var vExtend: UIView!
    private var btnExtendDel: UIButton!
    private var lExtendDuration: UILabel!
    private var lExtendSafe: UILabel!
    private var lExtendDesc: UILabel!
    private var btnPush: UIButton!
    private var tableView: UITableView!
    
    // var
    private var shyList: [Shy] = [Shy]()
    private var dayList = [Shy]()
    private var selectYear: Int = 0
    private var selectMonth: Int = 0
    private var selectDay: Int = 0
    private var selectShyIndex: Int = -1
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(NoteShyVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "shy")
        let barHelp = UIBarButtonItem(image: UIImage(named: "ic_help_outline_white_24dp"), style: .plain, target: self, action: #selector(targetGoHelp))
        self.navigationItem.rightBarButtonItems = [barHelp]
        
        // calendar
        calendarView = GGCalendarView(frame: CGRect(x: margin, y: margin * 2, width: maxWidth, height: calendarHeight))
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(calendarView, radius: ViewHelper.RADIUS_BIG)
        ViewUtils.setViewShadow(calendarView, offset: ViewHelper.SHADOW_BIG)
        
        let bottomY = calendarView.frame.origin.y + calendarView.frame.size.height + margin
        let bottomWidth = (maxWidth - margin) / 2
        let bottomHeight = screenHeight - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomSafeHeight(xYes: margin, xNo: margin * 2) - calendarView.frame.origin.y - calendarView.frame.size.height - margin
        
        // extend
        vExtend = UIView(frame: CGRect(x: margin, y: bottomY, width: bottomWidth, height: bottomHeight))
        vExtend.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vExtend, radius: ViewHelper.RADIUS_BIG)
        ViewUtils.setViewShadow(vExtend, offset: ViewHelper.SHADOW_BIG)
        
        let extendContentWidth = vExtend.frame.size.width - margin * 2
        
        // extend-del
        btnExtendDel = ViewHelper.getBtnImgCenter(paddingH: margin / 2, paddingV: margin / 2, bgImg: UIImage(named: "ic_more_horiz_grey_18dp"))
        btnExtendDel.frame.origin = CGPoint(x: vExtend.frame.size.width - btnExtendDel.frame.size.width, y: 0)
        
        // extend-duration
        lExtendDuration = ViewHelper.getLabelBold(width: extendContentWidth, text: "-", size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .left, mode: .byTruncatingTail)
        lExtendDuration.frame.origin = CGPoint(x: margin, y: btnExtendDel.frame.origin.y + btnExtendDel.frame.size.height)
        
        // extend-safe
        lExtendSafe = ViewHelper.getLabelBold(width: extendContentWidth, text: "-", size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .left, mode: .byTruncatingTail)
        lExtendSafe.frame.origin = CGPoint(x: margin, y: lExtendDuration.frame.origin.y + lExtendDuration.frame.size.height + margin)
        
        // extend-desc
        lExtendDesc = ViewHelper.getLabelPrimaryNormal(width: extendContentWidth, text: "-", lines: 0, align: .left)
        lExtendDesc.frame.origin = CGPoint(x: margin, y: lExtendSafe.frame.origin.y + lExtendSafe.frame.size.height + margin)
        
        vExtend.addSubview(btnExtendDel)
        vExtend.addSubview(lExtendDuration)
        vExtend.addSubview(lExtendSafe)
        vExtend.addSubview(lExtendDesc)
        
        // push
        btnPush = ViewHelper.getBtnBold(width: pushWidth, height: pushWidth, HAlign: .center, VAlign: .center, bgColor: ColorHelper.getWhite(), title: StringUtils.getString("add"), titleSize: ViewHelper.FONT_SIZE_BIG, titleColor: ThemeHelper.getColorPrimary(), titleAlign: .center, circle: true, shadow: false)
        btnPush.center.x = screenWidth - margin - bottomWidth / 2
        btnPush.frame.origin.y = bottomY + bottomHeight - btnPush.frame.size.height
        ViewUtils.setViewShadow(btnPush, offset: ViewHelper.SHADOW_BIG)
        
        // table
        let tableHeight = btnPush.frame.origin.y - vExtend.frame.origin.y - margin
        let frameTable = CGRect(x: (screenWidth + margin) / 2, y: bottomY, width: bottomWidth, height: tableHeight)
        tableView = ViewUtils.getTableView(target: self, frame: frameTable, cellCls: NoteShyCell.self, id: NoteShyCell.ID)
        
        // view
        self.view.backgroundColor = ThemeHelper.getColorPrimary()
        self.view.addSubview(calendarView)
        self.view.addSubview(vExtend)
        self.view.addSubview(btnPush)
        self.view.addSubview(tableView)
        
        // hide
        vExtend.isHidden = true
        
        // target
        btnPush.addTarget(self, action: #selector(shyPush), for: .touchUpInside)
        btnExtendDel.addTarget(self, action: #selector(targetRemoveItem), for: .touchUpInside)
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyListRefresh), name: NotifyHelper.TAG_SHY_LIST_REFRESH)
        NotifyHelper.addObserver(self, selector: #selector(notifyListItemDelete), name: NotifyHelper.TAG_SHY_LIST_ITEM_DELETE)
        // 设置当前日期
        refreshDateToCurrent()
        // 显示当前数据
        refreshCenterMonthView()
        // 开始获取数据
        refreshCenterMonthData()
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_NOTE_SHY)
    }
    
    @objc func notifyListRefresh(notify: NSNotification) {
        refreshCenterMonthData()
    }
    
    @objc func notifyListItemDelete(notify: NSNotification) {
        let indexLeft = ListHelper.findIndexByIdInList(list: dayList, obj: notify.object)
        if indexLeft > 0 && dayList.count > indexLeft {
            dayList.remove(at: indexLeft)
            tableView.deleteRows(at: [IndexPath(row: indexLeft, section: 0)], with: .automatic)
        }
        refreshCenterMonthData()
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
        shyList.removeAll()
        refreshBottomDayView()
        // api
        let api = Api.request(.noteShyListGetByDate(year: selectYear, month: selectMonth),
                              success: { (_, _, data) in
                                self.shyList = data.shyList ?? [Shy]()
                                // view
                                self.refreshCenterMonthView()
                                self.refreshBottomDayView()
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
        if shyList.count > 0 {
            var count: Int = 0
            let showDc = DateUtils.getDC(date)
            for shy in shyList {
                if shy.year == (showDc.year ?? -1) && shy.monthOfYear == (showDc.month ?? -1) && shy.dayOfMonth == (showDc.day ?? -1) {
                    count += 1
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
            self.refreshBottomDayView()
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
    func refreshBottomDayView() {
        dayList.removeAll()
        if shyList.count > 0 {
            for shy in shyList {
                if shy.year == selectYear && shy.monthOfYear == selectMonth && shy.dayOfMonth == selectDay {
                    dayList.append(shy)
                }
            }
        }
        tableView.reloadData()
        // extend
        selectShyIndex = -1
        refreshBottomExtendView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NoteShyCell.getCellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return NoteShyCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: dayList, target: self, action: #selector(targetShowDetail))
    }
    
    @objc func targetShowDetail(sender: UIGestureRecognizer) {
        if let indexPath = ViewUtils.findTableIndexPath(view: sender.view) {
            selectShyIndex = indexPath.row
            refreshBottomExtendView()
        }
    }
    
    func refreshBottomExtendView() {
        if selectShyIndex < 0 || selectShyIndex >= dayList.count {
            vExtend.isHidden = true
            return
        }
        vExtend.isHidden = false
        let shy = dayList[selectShyIndex]
        var durationMin = (shy.endAt - shy.happenAt) / DateUtils.UNIT_MIN
        if (durationMin == 0) {
            durationMin = 1
        }
        let durationMinShow = durationMin > 0 ? StringUtils.getString("holder_minute", arguments: [durationMin]) : StringUtils.getString("nil")
        // view
        lExtendDuration.text = StringUtils.getString("continue_duration_colon_holder", arguments: [durationMinShow])
        lExtendSafe.text = StringUtils.getString("safe_method_colon_holder", arguments: [StringUtils.isEmpty(shy.safe) ? StringUtils.getString("nil") : shy.safe])
        lExtendDesc.text = shy.desc
        
        // size
        let extendDescHeight = vExtend.frame.size.height - lExtendSafe.frame.origin.y - lExtendSafe.frame.size.height - margin * 2
        let height = ViewUtils.getFontHeight(font: lExtendDesc.font, width: lExtendDesc.frame.size.width, text: lExtendDesc.text)
        lExtendDesc.frame.size.height = CountHelper.getMin(extendDescHeight, height)
    }
    
    @objc func shyPush() {
        NoteShyEditVC.pushVC()
    }
    
    @objc private func targetRemoveItem(sender: UIButton) {
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_delete_this_note"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    self.delShy(index: self.selectShyIndex)
        },
                                  cancelHandler: nil)
    }
    
    private func delShy(index: Int) {
        if dayList.count <= index {
            return
        }
        let shy = dayList[index]
        if !shy.isMine() {
            ToastUtils.show(StringUtils.getString("can_operation_self_create_note"))
            return
        }
        // api
        let api = Api.request(.noteShyDel(sid: shy.id),
                              loading: true, cancel: true, success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_SHY_LIST_ITEM_DELETE, obj: shy)
        }, failure: nil)
        pushApi(api)
    }
    
}
