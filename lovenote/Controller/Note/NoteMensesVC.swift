//
//  NoteMensesVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/2/23.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar

class NoteMensesVC: BaseVC, FSCalendarDataSource, FSCalendarDelegate {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var screenHeight = ScreenUtils.getScreenHeight()
    lazy var calendarHeight = screenHeight / 8 * 3
    lazy var maxWidth = screenWidth - margin * 2
    
    // view
    private var calendarView: GGCalendarView!
    private var lShow: UILabel!
    
    private var vMensesInfo: UIView!
    private var lLengthCycle: UILabel!
    private var lLengthDuration: UILabel!
    private var scUser: UISegmentedControl!
    
    private var vDay: UIView!
    private var sMensesStatus: UISwitch!
    private var lMensesStatus: UILabel!
    private var sMensesEnd: UISwitch!
    private var lMensesEnd: UILabel!
    
    private var lForecast: UILabel!
    private var vDayInfo: UIView!
    private var lBlood: UILabel!
    private var ivBlood1: UIButton!
    private var ivBlood2: UIButton!
    private var ivBlood3: UIButton!
    private var lPain: UILabel!
    private var ivPain1: UIButton!
    private var ivPain2: UIButton!
    private var ivPain3: UIButton!
    private var lMood: UILabel!
    private var ivMood1: UIButton!
    private var ivMood2: UIButton!
    private var ivMood3: UIButton!
    
    // var
    private var isMine: Bool = true
    private var mensesInfo: MensesInfo = MensesInfo()
    private var menses2List: [Menses2] = [Menses2]()
    private var selectYear: Int = 0
    private var selectMonth: Int = 0
    private var selectDay: Int = 0
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(NoteMensesVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "menses")
        let barHelp = UIBarButtonItem(image: UIImage(named: "ic_help_outline_white_24dp"), style: .plain, target: self, action: #selector(targetGoHelp))
        self.navigationItem.rightBarButtonItems = [barHelp]
        
        // calendar
        calendarView = GGCalendarView(frame: CGRect(x: margin, y: margin * 2, width: maxWidth, height: calendarHeight))
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(calendarView, radius: ViewHelper.RADIUS_BIG)
        ViewUtils.setViewShadow(calendarView, offset: ViewHelper.SHADOW_BIG)
        
        // show
        lShow = ViewHelper.getLabelBold(text: "-", size: ViewHelper.FONT_SIZE_HUGE, color: ThemeHelper.getColorPrimary(), lines: 0, align: .center)
        lShow.frame = CGRect(x: margin, y: margin * 2, width: maxWidth, height: calendarHeight)
        lShow.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(lShow, radius: ViewHelper.RADIUS_BIG, bounds: true)
        ViewUtils.setViewShadow(lShow, offset: ViewHelper.SHADOW_BIG)
        
        let bottomY = calendarView.frame.origin.y + calendarView.frame.size.height + margin
        let bottomWidth = (maxWidth - margin) / 2
        let bottomHeight = screenHeight - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomSafeHeight(xYes: margin, xNo: margin * 2) - calendarView.frame.origin.y - calendarView.frame.size.height - margin
        
        // day
        vDay = UIView(frame: CGRect(x: margin, y: bottomY, width: bottomWidth, height: bottomHeight))
        vDay.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vDay, radius: ViewHelper.RADIUS_BIG)
        ViewUtils.setViewShadow(vDay, offset: ViewHelper.SHADOW_BIG)
        
        let dayContentWidth = vDay.frame.size.width - margin * 2
        
        // status
        sMensesStatus = ViewHelper.getSwitch()
        sMensesStatus.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        sMensesStatus.frame.origin.x = bottomWidth - margin - sMensesStatus.frame.size.width
        sMensesStatus.frame.origin.y = margin
        lMensesStatus = ViewHelper.getLabelPrimaryNormal(width: dayContentWidth - sMensesStatus.frame.size.width - margin, text: StringUtils.getString("menses_progress"), lines: 1, align: .left, mode: .byTruncatingTail)
        lMensesStatus.frame.origin.x = margin
        lMensesStatus.center.y = sMensesStatus.center.y
        
        sMensesEnd = ViewHelper.getSwitch()
        sMensesEnd.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        sMensesEnd.frame.origin.x = bottomWidth - margin - sMensesEnd.frame.size.width
        sMensesEnd.frame.origin.y = sMensesStatus.frame.origin.y + sMensesStatus.frame.size.height + margin
        lMensesEnd = ViewHelper.getLabelPrimaryNormal(width: dayContentWidth - sMensesEnd.frame.size.width - margin, text: StringUtils.getString("menses_end"), lines: 1, align: .left, mode: .byTruncatingTail)
        lMensesEnd.frame.origin.x = margin
        lMensesEnd.center.y = sMensesEnd.center.y
        
        // forecast
        let forecastHeight = bottomHeight - lMensesEnd.frame.origin.y - lMensesEnd.frame.size.height - margin * 2
        lForecast = ViewHelper.getLabelGreyNormal(width: dayContentWidth, height: forecastHeight, text: StringUtils.getString("forecast_menses"), lines: 0, align: .center)
        lForecast.frame.origin = CGPoint(x: margin, y: lMensesEnd.frame.origin.y + lMensesEnd.frame.size.height + margin)
        
        // blood
        lBlood = ViewHelper.getLabelBold(text: StringUtils.getString("blood_count"), size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .center)
        lBlood.frame.origin = CGPoint(x: margin, y: margin)
        ivBlood3 = ViewHelper.getBtnImgCenter(width: lBlood.frame.size.height, height: lBlood.frame.size.height, paddingH: margin / 2, paddingV: margin / 2, bgImg: UIImage(named: "ic_invert_colors_grey_18dp"))
        ivBlood3.frame.origin.x = bottomWidth - ivBlood3.frame.size.width
        ivBlood3.center.y = lBlood.center.y
        ivBlood2 = ViewHelper.getBtnImgCenter(width: lBlood.frame.size.height, height: lBlood.frame.size.height, paddingH: margin / 2, paddingV: margin / 2, bgImg: UIImage(named: "ic_invert_colors_grey_18dp"))
        ivBlood2.frame.origin.x = ivBlood3.frame.origin.x - ivBlood2.frame.size.width
        ivBlood2.center.y = lBlood.center.y
        ivBlood1 = ViewHelper.getBtnImgCenter(width: lBlood.frame.size.height, height: lBlood.frame.size.height, paddingH: margin / 2, paddingV: margin / 2, bgImg: UIImage(named: "ic_invert_colors_grey_18dp"))
        ivBlood1.frame.origin.x = ivBlood2.frame.origin.x - ivBlood1.frame.size.width
        ivBlood1.center.y = lBlood.center.y
        
        // pain
        lPain = ViewHelper.getLabelBold(text: StringUtils.getString("menses_pain"), size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .center)
        lPain.frame.origin = CGPoint(x: margin, y: lBlood.frame.origin.y + lBlood.frame.size.height + margin * 2)
        ivPain3 = ViewHelper.getBtnImgCenter(width: lPain.frame.size.height, height: lPain.frame.size.height, paddingH: margin / 2, paddingV: margin / 2, bgImg: UIImage(named: "ic_flash_on_grey_18dp"))
        ivPain3.frame.origin.x = bottomWidth - ivPain3.frame.size.width
        ivPain3.center.y = lPain.center.y
        ivPain2 = ViewHelper.getBtnImgCenter(width: lPain.frame.size.height, height: lPain.frame.size.height, paddingH: margin / 2, paddingV: margin / 2, bgImg: UIImage(named: "ic_flash_on_grey_18dp"))
        ivPain2.frame.origin.x = ivPain3.frame.origin.x - ivPain2.frame.size.width
        ivPain2.center.y = lPain.center.y
        ivPain1 = ViewHelper.getBtnImgCenter(width: lPain.frame.size.height, height: lPain.frame.size.height, paddingH: margin / 2, paddingV: margin / 2, bgImg: UIImage(named: "ic_flash_on_grey_18dp"))
        ivPain1.frame.origin.x = ivPain2.frame.origin.x - ivPain1.frame.size.width
        ivPain1.center.y = lPain.center.y
        
        // mood
        lMood = ViewHelper.getLabelBold(text: StringUtils.getString("mood"), size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .center)
        lMood.frame.origin = CGPoint(x: margin, y: lPain.frame.origin.y + lPain.frame.size.height + margin * 2)
        ivMood3 = ViewHelper.getBtnImgCenter(width: lMood.frame.size.height, height: lMood.frame.size.height, paddingH: margin / 2, paddingV: margin / 2, bgImg: UIImage(named: "ic_sentiment_very_satisfied_grey_18dp"))
        ivMood3.frame.origin.x = bottomWidth - ivMood3.frame.size.width
        ivMood3.center.y = lMood.center.y
        ivMood2 = ViewHelper.getBtnImgCenter(width: lMood.frame.size.height, height: lMood.frame.size.height, paddingH: margin / 2, paddingV: margin / 2, bgImg: UIImage(named: "ic_sentiment_neutral_grey_18dp"))
        ivMood2.frame.origin.x = ivMood3.frame.origin.x - ivMood2.frame.size.width
        ivMood2.center.y = lMood.center.y
        ivMood1 = ViewHelper.getBtnImgCenter(width: lMood.frame.size.height, height: lMood.frame.size.height, paddingH: margin / 2, paddingV: margin / 2, bgImg: UIImage(named: "ic_sentiment_very_dissatisfied_grey_18dp"))
        ivMood1.frame.origin.x = ivMood2.frame.origin.x - ivMood1.frame.size.width
        ivMood1.center.y = lMood.center.y
        
        // dayInfo
        let dayInfoHeight = lMood.frame.origin.y + lMood.frame.size.height + margin
        vDayInfo = UIView(frame: CGRect(x: 0, y: vDay.frame.size.height - dayInfoHeight, width: bottomWidth, height: dayInfoHeight))
        vDayInfo.addSubview(lBlood)
        vDayInfo.addSubview(ivBlood1)
        vDayInfo.addSubview(ivBlood2)
        vDayInfo.addSubview(ivBlood3)
        vDayInfo.addSubview(lPain)
        vDayInfo.addSubview(ivPain1)
        vDayInfo.addSubview(ivPain2)
        vDayInfo.addSubview(ivPain3)
        vDayInfo.addSubview(lMood)
        vDayInfo.addSubview(ivMood1)
        vDayInfo.addSubview(ivMood2)
        vDayInfo.addSubview(ivMood3)
        
        vDay.addSubview(lMensesStatus)
        vDay.addSubview(sMensesStatus)
        vDay.addSubview(lMensesEnd)
        vDay.addSubview(sMensesEnd)
        vDay.addSubview(lForecast)
        vDay.addSubview(vDayInfo)
        
        // length
        lLengthCycle = ViewHelper.getLabelPrimaryNormal(width: bottomWidth, text: "-", lines: 1, align: .center, mode: .byTruncatingTail)
        lLengthCycle.frame.size.height += margin * 2
        lLengthCycle.frame.origin = CGPoint(x: 0, y: 0)
        let lineLength = ViewHelper.getViewLine(width: bottomWidth, color: ThemeHelper.getColorPrimary())
        lineLength.frame.origin = CGPoint(x: 0, y: lLengthCycle.frame.origin.y + lLengthCycle.frame.size.height)
        lLengthDuration = ViewHelper.getLabelPrimaryNormal(width: bottomWidth, text: "-", lines: 1, align: .center, mode: .byTruncatingTail)
        lLengthDuration.frame.size.height += margin * 2
        lLengthDuration.frame.origin = CGPoint(x: 0, y: lineLength.frame.origin.y + lineLength.frame.size.height)
        
        vMensesInfo = UIView(frame: CGRect(x: (screenWidth + margin) / 2, y: bottomY, width: bottomWidth, height: lLengthDuration.frame.origin.y + lLengthDuration.frame.size.height))
        vMensesInfo.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vMensesInfo, radius: ViewHelper.RADIUS_BIG)
        ViewUtils.setViewShadow(vMensesInfo, offset: ViewHelper.SHADOW_BIG)
        
        vMensesInfo.addSubview(lLengthCycle)
        vMensesInfo.addSubview(lineLength)
        vMensesInfo.addSubview(lLengthDuration)
        
        // user
        let userItems = [StringUtils.getString("me_de"), StringUtils.getString("ta_de")]
        scUser = ViewHelper.getSegmentedControl(width: bottomWidth, items: userItems, tintColor: ColorHelper.getWhite(), titleSize: ViewHelper.FONT_SIZE_NORMAL, multiLine: false)
        scUser.frame.size.height += margin
        scUser.frame.origin.x = (screenWidth + margin) / 2
        scUser.frame.origin.y = bottomY + bottomHeight - scUser.frame.size.height
        
        // view
        self.view.backgroundColor = ThemeHelper.getColorPrimary()
        self.view.addSubview(calendarView)
        self.view.addSubview(lShow)
        self.view.addSubview(vDay)
        self.view.addSubview(vMensesInfo)
        self.view.addSubview(scUser)
        
        // hide
        calendarView.isHidden = true
        lShow.isHidden = true
        vMensesInfo.isHidden = true
        vDay.isHidden = true
        lForecast.isHidden = true
        vDayInfo.isHidden = true
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vMensesInfo, action: #selector(targetGoInfoEdit))
        scUser.addTarget(self, action: #selector(targetUserToggle), for: .valueChanged)
        sMensesStatus.addTarget(self, action: #selector(targetMessageStatus), for: .valueChanged)
        sMensesEnd.addTarget(self, action: #selector(targetMessageEnd), for: .valueChanged)
        ivBlood1.addTarget(self, action: #selector(targetBlood1), for: .touchUpInside)
        ivBlood2.addTarget(self, action: #selector(targetBlood2), for: .touchUpInside)
        ivBlood3.addTarget(self, action: #selector(targetBlood3), for: .touchUpInside)
        ivPain1.addTarget(self, action: #selector(targetPain1), for: .touchUpInside)
        ivPain2.addTarget(self, action: #selector(targetPain2), for: .touchUpInside)
        ivPain3.addTarget(self, action: #selector(targetPain3), for: .touchUpInside)
        ivMood1.addTarget(self, action: #selector(targetMood1), for: .touchUpInside)
        ivMood2.addTarget(self, action: #selector(targetMood2), for: .touchUpInside)
        ivMood3.addTarget(self, action: #selector(targetMood3), for: .touchUpInside)
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyMensesInfoRefresh), name: NotifyHelper.TAG_MENSES_INFO_UPDATE)
        // info
        mensesInfo.canMe = false
        mensesInfo.canTa = false
        // user
        initBottomUserView()
        // 设置当前日期
        refreshDateToCurrent()
        // 显示当前数据
        refreshCenterMonthView(show: "")
        refreshBottomMensesInfoView()
        // 开始获取数据
        refreshCenterMonthData()
        refreshBottomMensesInfoData()
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_NOTE_MENSES)
    }
    
    @objc private func targetGoInfoEdit() {
        NoteMensesInfoVC.pushVC(mensesInfo: mensesInfo)
    }
    
    @objc func targetUserToggle() {
        isMine = scUser.selectedSegmentIndex == 0
        refreshBottomMensesInfoView()
        refreshCenterMonthData()
    }
    
    @objc func targetMessageStatus() {
        mensesPush(year: selectYear, month: selectMonth, day: selectDay, come: sMensesStatus.isOn)
    }
    
    @objc func targetMessageEnd() {
        if !sMensesEnd.isOn { return }
        mensesPush(year: selectYear, month: selectMonth, day: selectDay, come: false)
    }
    
    @objc func notifyMensesInfoRefresh(notify: NSNotification) {
        refreshCenterMonthData()
        refreshBottomMensesInfoData()
    }
    
    @objc func targetBlood1() {
        lBlood.tag = 1
        ivBlood1.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_invert_colors_grey_18dp"), color: ThemeHelper.getColorPrimary()).withRenderingMode(.alwaysOriginal)
        ivBlood2.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_invert_colors_grey_18dp"), color: ColorHelper.getIconGrey()).withRenderingMode(.alwaysOriginal)
        ivBlood3.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_invert_colors_grey_18dp"), color: ColorHelper.getIconGrey()).withRenderingMode(.alwaysOriginal)
        pushMensesDay()
    }
    
    @objc func targetBlood2() {
        lBlood.tag = 2
        ivBlood1.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_invert_colors_grey_18dp"), color: ThemeHelper.getColorPrimary()).withRenderingMode(.alwaysOriginal)
        ivBlood2.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_invert_colors_grey_18dp"), color: ThemeHelper.getColorPrimary()).withRenderingMode(.alwaysOriginal)
        ivBlood3.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_invert_colors_grey_18dp"), color: ColorHelper.getIconGrey()).withRenderingMode(.alwaysOriginal)
        pushMensesDay()
    }
    
    @objc func targetBlood3() {
        lBlood.tag = 3
        ivBlood1.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_invert_colors_grey_18dp"), color: ThemeHelper.getColorPrimary()).withRenderingMode(.alwaysOriginal)
        ivBlood2.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_invert_colors_grey_18dp"), color: ThemeHelper.getColorPrimary()).withRenderingMode(.alwaysOriginal)
        ivBlood3.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_invert_colors_grey_18dp"), color: ThemeHelper.getColorPrimary()).withRenderingMode(.alwaysOriginal)
        pushMensesDay()
    }
    
    @objc func targetPain1() {
        lPain.tag = 1
        ivPain1.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_flash_on_grey_18dp"), color: ThemeHelper.getColorPrimary()).withRenderingMode(.alwaysOriginal)
        ivPain2.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_flash_on_grey_18dp"), color: ColorHelper.getIconGrey()).withRenderingMode(.alwaysOriginal)
        ivPain3.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_flash_on_grey_18dp"), color: ColorHelper.getIconGrey()).withRenderingMode(.alwaysOriginal)
        pushMensesDay()
    }
    
    @objc func targetPain2() {
        lPain.tag = 2
        ivPain1.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_flash_on_grey_18dp"), color: ThemeHelper.getColorPrimary()).withRenderingMode(.alwaysOriginal)
        ivPain2.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_flash_on_grey_18dp"), color: ThemeHelper.getColorPrimary()).withRenderingMode(.alwaysOriginal)
        ivPain3.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_flash_on_grey_18dp"), color: ColorHelper.getIconGrey()).withRenderingMode(.alwaysOriginal)
        pushMensesDay()
    }
    
    @objc func targetPain3() {
        lPain.tag = 3
        ivPain1.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_flash_on_grey_18dp"), color: ThemeHelper.getColorPrimary()).withRenderingMode(.alwaysOriginal)
        ivPain2.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_flash_on_grey_18dp"), color: ThemeHelper.getColorPrimary()).withRenderingMode(.alwaysOriginal)
        ivPain3.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_flash_on_grey_18dp"), color: ThemeHelper.getColorPrimary()).withRenderingMode(.alwaysOriginal)
        pushMensesDay()
    }
    
    @objc func targetMood1() {
        lMood.tag = 1
        ivMood1.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_sentiment_very_dissatisfied_grey_18dp"), color: ThemeHelper.getColorPrimary()).withRenderingMode(.alwaysOriginal)
        ivMood2.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_sentiment_neutral_grey_18dp"), color: ColorHelper.getIconGrey()).withRenderingMode(.alwaysOriginal)
        ivMood3.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_sentiment_very_satisfied_grey_18dp"), color: ColorHelper.getIconGrey()).withRenderingMode(.alwaysOriginal)
        pushMensesDay()
    }
    
    @objc func targetMood2() {
        lMood.tag = 2
        ivMood1.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_sentiment_very_dissatisfied_grey_18dp"), color: ColorHelper.getIconGrey()).withRenderingMode(.alwaysOriginal)
        ivMood2.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_sentiment_neutral_grey_18dp"), color: ThemeHelper.getColorPrimary()).withRenderingMode(.alwaysOriginal)
        ivMood3.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_sentiment_very_satisfied_grey_18dp"), color: ColorHelper.getIconGrey()).withRenderingMode(.alwaysOriginal)
        pushMensesDay()
    }
    
    @objc func targetMood3() {
        lMood.tag = 3
        ivMood1.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_sentiment_very_dissatisfied_grey_18dp"), color: ColorHelper.getIconGrey()).withRenderingMode(.alwaysOriginal)
        ivMood2.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_sentiment_neutral_grey_18dp"), color: ColorHelper.getIconGrey()).withRenderingMode(.alwaysOriginal)
        ivMood3.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_sentiment_very_satisfied_grey_18dp"), color: ThemeHelper.getColorPrimary()).withRenderingMode(.alwaysOriginal)
        pushMensesDay()
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
        menses2List.removeAll()
        refreshBottomDayInfoView()
        // api
        let api = Api.request(.noteMenses2ListGetByDate(mine: isMine, year: selectYear, month: selectMonth),
                              success: { (_, _, data) in
                                self.menses2List = data.menses2List ?? [Menses2]()
                                // view
                                self.refreshCenterMonthView(show: data.show)
                                self.refreshBottomDayInfoView()
        }, failure: nil)
        pushApi(api)
    }
    
    func refreshCenterMonthView(show: String?) {
        // show
        if !StringUtils.isEmpty(show) {
            lShow.isHidden = false
            calendarView.isHidden = true
            lShow.text = show ?? ""
            return
        }
        // calendar
        lShow.isHidden = true
        calendarView.isHidden = false
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
        if menses2List.count > 0 {
            var count: Int = 0
            let showTimestamp = DateUtils.getInt64(date)
            for menses2 in menses2List {
                // 姨妈期
                if showTimestamp >= menses2.startAt && showTimestamp <= menses2.endAt {
                    count += 1
                    break
                }
                // 安全期
                // 危险期
                // 排卵日
            }
            return count
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        let showTimestamp = DateUtils.getInt64(date)
        for menses2 in menses2List {
            // 姨妈期
            if showTimestamp >= menses2.startAt && showTimestamp <= menses2.endAt {
                if menses2.isReal {
                    cell.eventIndicator.color = calendarView.appearance.eventDefaultColor
                } else {
                    cell.eventIndicator.color = ColorHelper.getBlack25()
                }
                break
            }
            // 安全期
            // 危险期
            // 排卵日
        }
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
            self.refreshBottomDayInfoView()
            return
        }
        self.selectYear = selectDc.year ?? -1
        self.selectMonth = selectDc.month ?? -1
        self.selectDay = selectDc.day ?? -1
        refreshCenterMonthData()
    }
    
    // 取消选择
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let cell = calendar.cell(for: date, at: monthPosition)
        let showTimestamp = DateUtils.getInt64(date)
        for menses2 in menses2List {
            // 姨妈期
            if showTimestamp >= menses2.startAt && showTimestamp <= menses2.endAt {
                if menses2.isReal {
                    cell?.eventIndicator.color = calendarView.appearance.eventDefaultColor
                } else {
                    cell?.eventIndicator.color = ColorHelper.getBlack25()
                }
                break
            }
            // 安全期
            // 危险期
            // 排卵日
        }
    }
    
    /**
     * **************************************** bottom ***********************************************
     */
    func initBottomUserView() {
        let me = UDHelper.getMe()
        isMine = (me != nil && me!.sex == User.SEX_GIRL)
        scUser.selectedSegmentIndex = isMine ? 0 : 1
    }
    
    func refreshBottomMensesInfoData() {
        // api
        let api = Api.request(.noteMensesInfoGet,
                              success: { (_, _, data) in
                                if data.mensesInfo != nil {
                                    self.mensesInfo = data.mensesInfo!
                                }
                                // view
                                self.refreshBottomMensesInfoView()
        }, failure: nil)
        pushApi(api)
    }
    
    func refreshBottomMensesInfoView() {
        if isMine {
            if !mensesInfo.canMe {
                vMensesInfo.isHidden = true
                vDay.isHidden = true
                return
            }
        } else {
            if !mensesInfo.canTa {
                vMensesInfo.isHidden = true
                vDay.isHidden = true
                return
            }
        }
        // dayInfo
        vDay.isHidden = false
        // length
        let length = isMine ? mensesInfo.mensesLengthMe : mensesInfo.mensesLengthTa
        if length == nil {
            vMensesInfo.isHidden = true
            return
        }
        vMensesInfo.isHidden = false
        lLengthCycle.text = StringUtils.getString("menses_cycle_colon_holder_day", arguments: [length!.cycleDay])
        lLengthDuration.text = StringUtils.getString("menses_duration_colon_holder_day", arguments: [length!.durationDay])
    }
    
    func refreshBottomDayInfoView() {
        var isProgress = false
        var isForecast = false
        var mensesDay: MensesDay?
        if menses2List.count > 0 {
            for menses2 in menses2List {
                // 先找出所属menses2
                var dcStart = DateUtils.getCurrentDC()
                dcStart.year = menses2.startYear
                dcStart.month = menses2.startMonthOfYear
                dcStart.day = menses2.startDayOfMonth
                let iStart = DateUtils.getInt64(dcStart)
                
                var dcEnd = DateUtils.getCurrentDC()
                dcEnd.year = menses2.endYear
                dcEnd.month = menses2.endMonthOfYear
                dcEnd.day = menses2.endDayOfMonth
                let iEnd = DateUtils.getInt64(dcEnd)
                
                var dcSelect = DateUtils.getCurrentDC()
                dcSelect.year = selectYear
                dcSelect.month = selectMonth
                dcSelect.day = selectDay
                let iSelect = DateUtils.getInt64(dcSelect)
                
                if iSelect >= iStart && iSelect <= iEnd {
                    // menses
                    isProgress = menses2.isReal
                    isForecast = !menses2.isReal
                    // dayInfo
                    let dayInfoList = menses2.mensesDayList
                    if dayInfoList.count <= 0 { continue }
                    for dayInfo in dayInfoList {
                        if dayInfo.year == selectYear && dayInfo.monthOfYear == selectMonth && dayInfo.dayOfMonth == selectDay {
                            mensesDay = dayInfo
                            break
                        }
                    }
                    break
                }
            }
        }
        // view
        sMensesStatus.isOn = isProgress // 不会回调
        sMensesEnd.isOn = false // 不会回调
        lForecast.isHidden = !isForecast
        if !isProgress {
            vDayInfo.isHidden = true
            return
        }
        vDayInfo.isHidden = false
        // blood
        lBlood.tag = mensesDay?.blood ?? 0
        if lBlood.tag > 2 {
            ivBlood3.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_invert_colors_grey_18dp"), color: ThemeHelper.getColorPrimary()).withRenderingMode(.alwaysOriginal)
        } else {
            ivBlood3.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_invert_colors_grey_18dp"), color: ColorHelper.getIconGrey()).withRenderingMode(.alwaysOriginal)
        }
        if lBlood.tag > 1 {
            ivBlood2.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_invert_colors_grey_18dp"), color: ThemeHelper.getColorPrimary()).withRenderingMode(.alwaysOriginal)
        } else {
            ivBlood2.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_invert_colors_grey_18dp"), color: ColorHelper.getIconGrey()).withRenderingMode(.alwaysOriginal)
        }
        if lBlood.tag > 0 {
            ivBlood1.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_invert_colors_grey_18dp"), color: ThemeHelper.getColorPrimary()).withRenderingMode(.alwaysOriginal)
        } else {
            ivBlood1.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_invert_colors_grey_18dp"), color: ColorHelper.getIconGrey()).withRenderingMode(.alwaysOriginal)
        }
        // pain
        lPain.tag = mensesDay?.pain ?? 0
        if lPain.tag > 2 {
            ivPain3.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_flash_on_grey_18dp"), color: ThemeHelper.getColorPrimary()).withRenderingMode(.alwaysOriginal)
        } else {
            ivPain3.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_flash_on_grey_18dp"), color: ColorHelper.getIconGrey()).withRenderingMode(.alwaysOriginal)
        }
        if lPain.tag > 1 {
            ivPain2.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_flash_on_grey_18dp"), color: ThemeHelper.getColorPrimary()).withRenderingMode(.alwaysOriginal)
        } else {
            ivPain2.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_flash_on_grey_18dp"), color: ColorHelper.getIconGrey()).withRenderingMode(.alwaysOriginal)
        }
        if lPain.tag > 0 {
            ivPain1.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_flash_on_grey_18dp"), color: ThemeHelper.getColorPrimary()).withRenderingMode(.alwaysOriginal)
        } else {
            ivPain1.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_flash_on_grey_18dp"), color: ColorHelper.getIconGrey()).withRenderingMode(.alwaysOriginal)
        }
        // mood
        lMood.tag = mensesDay?.mood ?? 0
        if lMood.tag == 1 {
            ivMood1.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_sentiment_very_dissatisfied_grey_18dp"), color: ThemeHelper.getColorPrimary()).withRenderingMode(.alwaysOriginal)
        } else {
            ivMood1.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_sentiment_very_dissatisfied_grey_18dp"), color: ColorHelper.getIconGrey()).withRenderingMode(.alwaysOriginal)
        }
        if lMood.tag == 2 {
            ivMood2.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_sentiment_neutral_grey_18dp"), color: ThemeHelper.getColorPrimary()).withRenderingMode(.alwaysOriginal)
        } else {
            ivMood2.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_sentiment_neutral_grey_18dp"), color: ColorHelper.getIconGrey()).withRenderingMode(.alwaysOriginal)
        }
        if lMood.tag == 3 {
            ivMood3.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_sentiment_very_satisfied_grey_18dp"), color: ThemeHelper.getColorPrimary()).withRenderingMode(.alwaysOriginal)
        } else {
            ivMood3.imageView?.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_sentiment_very_satisfied_grey_18dp"), color: ColorHelper.getIconGrey()).withRenderingMode(.alwaysOriginal)
        }
    }
    
    /**
     * **************************************** push ***********************************************
     */
    @objc func mensesPush(year: Int, month: Int, day: Int, come: Bool) {
        let body = Menses()
        body.isMe = isMine
        body.year = year
        body.monthOfYear = month
        body.dayOfMonth = day
        body.isStart = come
        // api
        let api = Api.request(.noteMenses2Add(menses: body.toJSON()),
                              success: { (_, _, data) in
                                // data
                                self.refreshCenterMonthData()
        }, failure: nil)
        pushApi(api)
    }
    
    func pushMensesDay() {
        let body = MensesDay()
        body.year = selectYear
        body.monthOfYear = selectMonth
        body.dayOfMonth = selectDay
        body.blood = lBlood.tag
        body.pain = lPain.tag
        body.mood = lMood.tag
        // api
        let api = Api.request(.noteMensesDayAdd(mensesDay: body.toJSON()),
                              success: { (_, _, data) in
                                // data
                                self.refreshCenterMonthData()
        }, failure: nil)
        pushApi(api)
    }
    
}
