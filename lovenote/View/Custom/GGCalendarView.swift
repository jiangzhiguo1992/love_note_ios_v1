//
//  GGCalendarView.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/15.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import FSCalendar

class GGCalendarView: FSCalendar {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // scroll
        self.pagingEnabled = true
        self.scrollEnabled = true
        self.scrollDirection = .horizontal
        
        // style
        self.allowsMultipleSelection = false
        //self.allowsSelection
        self.scope = .month
        self.placeholderType = .none
        self.firstWeekday = 1
        
        // appearance
        self.appearance.headerMinimumDissolvedAlpha = 0
        self.appearance.headerDateFormat = DateUtils.FORMAT_CHINA_M_SPCAE_Y
        self.appearance.headerTitleFont = ViewUtils.getFontBold(size: ViewHelper.FONT_SIZE_BIG)
        self.appearance.headerTitleColor = ThemeHelper.getColorPrimary()
        
        self.appearance.weekdayFont = ViewUtils.getFont(size: ViewHelper.FONT_SIZE_SMALL)
        self.appearance.weekdayTextColor = ThemeHelper.getColorPrimary()
        self.appearance.titleWeekendColor = ThemeHelper.getColorPrimary()
        self.appearance.subtitleWeekendColor = ThemeHelper.getColorPrimary()
        
        self.appearance.titleFont = ViewUtils.getFontBold(size: ViewHelper.FONT_SIZE_NORMAL)
        self.appearance.titleDefaultColor = ThemeHelper.getColorAccent()
        self.appearance.subtitleFont = ViewUtils.getFont(size: CGFloat(7))
        self.appearance.subtitleDefaultColor = ThemeHelper.getColorAccent()
        
        self.appearance.titlePlaceholderColor = ColorHelper.getFontHint()
        self.appearance.subtitlePlaceholderColor = ColorHelper.getFontHint()
        
        self.appearance.todayColor = ColorHelper.getTrans()
        self.appearance.titleTodayColor = ColorHelper.getFontBlack()
        self.appearance.subtitleTodayColor = ColorHelper.getFontBlack()
        
        self.appearance.selectionColor = ThemeHelper.getColorAccent()
        self.appearance.todaySelectionColor = ThemeHelper.getColorAccent()
        self.appearance.titleSelectionColor = ColorHelper.getFontWhite()
        self.appearance.subtitleSelectionColor = ColorHelper.getFontWhite()
        
        self.appearance.eventDefaultColor = ThemeHelper.getColorDark()
        self.appearance.eventSelectionColor = ThemeHelper.getColorDark()
        
        //self.appearance.borderDefaultColor = ThemeHelper.getColorAccent()
        //self.appearance.borderSelectionColor = ThemeHelper.getColorAccent()
        //self.appearance.borderRadius
    }
    
    // calendarView高度变化
    //func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
    //}
    
}
