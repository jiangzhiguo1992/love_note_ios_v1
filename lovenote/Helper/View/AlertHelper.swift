//
//  AlertHelper.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/18.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import LGAlertView

class AlertHelper {

    public static func diss(_ alert: LGAlertView?) {
        AppDelegate.runOnMainAsync {
            alert?.dismissAnimated()
        }
    }

    public static func show(_ alert: LGAlertView?) {
        AppDelegate.runOnMainAsync {
            alert?.showAnimated()
        }
    }

    //-------------------------------------Alert------------------------------------------------

    private static func getAlertView(style: LGAlertViewStyle = .alert, title: String? = nil, msg: String? = nil,
                                     confirms: [String]? = nil, cancel: String? = nil, canCancel: Bool = false,
                                     actionHandler: ((LGAlertView, UInt, String?) -> Void)? = nil,
                                     cancelHandler: ((LGAlertView) -> Void)? = nil) -> LGAlertView {
        let alert = LGAlertView(title: title, message: msg, style: style, buttonTitles: confirms, cancelButtonTitle: cancel, destructiveButtonTitle: nil)
        alert.actionHandler = { (av, index, confirm) in
            actionHandler?(av, index, confirm)
        }
        alert.cancelHandler = { (av) in
            cancelHandler?(av)
        }
        alert.isDismissOnAction = true
        alert.isCancelOnTouch = canCancel
        //        alert.isCancelButtonEnabled = true
        //        alert.isDestructiveButtonEnabled = true
        alert.tintColor = ThemeHelper.getColorPrimary()
        alert.titleTextColor = ColorHelper.getFontBlack()
        alert.messageTextColor = ColorHelper.getFontGrey()

        alert.coverBlurEffect = UIBlurEffect(style: .regular)
        //        alert.coverColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 0.1)
        alert.coverAlpha = 0.3

        return alert
    }

    public static func getAlert(title: String? = nil, msg: String? = nil, confirms: [String]? = nil,
                                cancel: String? = nil, canCancel: Bool = true,
                                actionHandler: ((LGAlertView, UInt, String?) -> Void)? = nil,
                                calcelHandler: ((LGAlertView) -> Void)? = nil) -> LGAlertView {
        return getAlertView(style: .alert, title: title, msg: msg, confirms: confirms, cancel: cancel, canCancel: canCancel, actionHandler: actionHandler, cancelHandler: calcelHandler)
    }

    public static func showAlert(title: String? = nil, msg: String? = nil, confirms: [String]? = nil,
                                 cancel: String? = nil, canCancel: Bool = true,
                                 actionHandler: ((LGAlertView, UInt, String?) -> Void)? = nil,
                                 cancelHandler: ((LGAlertView) -> Void)? = nil) -> LGAlertView {
        let alert = getAlert(title: title, msg: msg, confirms: confirms, cancel: cancel, canCancel: canCancel, actionHandler: actionHandler, calcelHandler: cancelHandler)
        show(alert)
        return alert
    }

    public static func showVersionCheckAlert(toast: Bool = false, log: Bool = false) {
        let old = AppUtils.getAppVersion()
        AppUtils.getAppStoreVersion { (latest) in
            if old == latest {
                if toast {
                    ToastUtils.show(StringUtils.getString("already_is_latest_version"))
                }
            } else {
                // userDefault
                let commonCount = UDHelper.getCommonCount()
                commonCount.versionNewCount = 1
                UDHelper.setCommonCount(commonCount)
                // alert
                _ = showAlert(title: StringUtils.getString("have_new_version"),
                        msg: StringUtils.getString("version_number_colon") + latest,
                        confirms: [StringUtils.getString("update_now")],
                        cancel: StringUtils.getString("after_say"),
                        canCancel: false, actionHandler: { (_, _, _) in
                    URLUtils.openAPPStore(id: UDHelper.getCommonConst().iosAppId)
                }, cancelHandler: nil)
            }
        }
    }

    public static func showNoPermAlert() {
        _ = showAlert(title: StringUtils.getString("need_check_some_perm"),
                confirms: [StringUtils.getString("go_now")],
                cancel: StringUtils.getString("brutal_refuse"),
                canCancel: false, actionHandler: { (_, _, _) in
            URLUtils.openSettings()
        }, cancelHandler: nil)

    }

    //-------------------------------------Indicator------------------------------------------------

    private static func getIndicator(style: LGAlertViewStyle = .alert, title: String? = nil, msg: String? = nil,
                                     confirms: [String]? = nil, cancel: String? = nil, canCancel: Bool = true,
                                     actionHandler: ((LGAlertView, UInt, String?) -> Void)? = nil,
                                     cancelHandler: ((LGAlertView) -> Void)? = nil) -> LGAlertView {
        let indicator = LGAlertView(activityIndicatorAndTitle: title, message: msg, style: style, progressLabelText: nil, buttonTitles: confirms, cancelButtonTitle: cancel, destructiveButtonTitle: nil, actionHandler: actionHandler, cancelHandler: cancelHandler, destructiveHandler: nil)

        indicator.isDismissOnAction = true
        indicator.isCancelOnTouch = canCancel
        //        indicator.isCancelButtonEnabled = true
        //        indicator.isDestructiveButtonEnabled = true
        indicator.tintColor = ThemeHelper.getColorPrimary()
        indicator.titleTextColor = ColorHelper.getFontBlack()
        indicator.messageTextColor = ColorHelper.getFontGrey()
        indicator.activityIndicatorViewColor = ThemeHelper.getColorDark()

        indicator.coverBlurEffect = UIBlurEffect(style: .regular)
        //        indicator.coverColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 0.1)
        indicator.coverAlpha = 0.3

        indicator.progress = 0.0
        //        indicator.indicatorStyle = .default

        return indicator
    }

    public static func getIndicator(canCancel: Bool = true, cancelHandler: ((LGAlertView) -> Void)? = nil) -> LGAlertView {
        return getIndicator(style: .alert, title: StringUtils.getString("please_wait"), msg: nil, confirms: nil, cancel: nil,
                canCancel: canCancel, actionHandler: nil, cancelHandler: cancelHandler)
    }

    public static func showIndicator(canCancel: Bool = true, cancelHandler: ((LGAlertView) -> Void)? = nil) -> LGAlertView {
        let loading = getIndicator(canCancel: canCancel, cancelHandler: cancelHandler)
        show(loading)
        return loading
    }

    //-------------------------------------Progress------------------------------------------------

    private static func getProgress(style: LGAlertViewStyle = .alert, title: String? = nil, msg: String? = nil,
                                    progress: Float = 0.0, progressText: String? = nil,
                                    confirms: [String]? = nil, cancel: String? = nil, canCancel: Bool = true,
                                    actionHandler: ((LGAlertView, UInt, String?) -> Void)? = nil,
                                    cancelHandler: ((LGAlertView) -> Void)? = nil) -> LGAlertView {
        let progress = LGAlertView(progressViewAndTitle: title, message: msg, style: style, progress: progress, progressLabelText: progressText, buttonTitles: confirms, cancelButtonTitle: cancel, destructiveButtonTitle: nil, actionHandler: actionHandler, cancelHandler: cancelHandler, destructiveHandler: nil)

        progress.isDismissOnAction = true
        progress.isCancelOnTouch = canCancel
        //        progress.isCancelButtonEnabled = true
        //        progress.isDestructiveButtonEnabled = true
        progress.tintColor = ThemeHelper.getColorPrimary()
        progress.titleTextColor = ColorHelper.getFontBlack()
        progress.messageTextColor = ColorHelper.getFontGrey()
        progress.progressViewProgressTintColor = ThemeHelper.getColorDark()

        progress.coverBlurEffect = UIBlurEffect(style: .regular)
        //        progress.coverColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 0.1)
        progress.coverAlpha = 0.3

        progress.progress = 0.0
        //        progress.indicatorStyle = .default

        return progress
    }

    public static func getProgress(title: String? = nil, msg: String? = nil,
                                   cancelHandler: ((LGAlertView) -> Void)? = nil) -> LGAlertView {

        return getProgress(style: .alert, title: title, msg: msg, progress: 0.0, progressText: nil, confirms: nil, cancel: StringUtils.getString("cancel"), canCancel: false, actionHandler: nil, cancelHandler: cancelHandler)
    }

    public static func showProgress(title: String? = nil, msg: String? = nil,
                                    cancelHandler: ((LGAlertView) -> Void)? = nil) -> LGAlertView {
        let progress = getProgress(title: title, msg: msg, cancelHandler: cancelHandler)
        show(progress)
        return progress
    }

    //-------------------------------------TextFiled------------------------------------------------

    private static func getEdit(title: String? = nil, msg: String? = nil, numberOfTF: UInt = 1,
                                text: String? = nil, placeHolder: String? = nil, keyboard: UIKeyboardType = .default,
                                confirms: [String]? = nil, cancel: String? = nil, canCancel: Bool = true,
                                actionHandler: ((LGAlertView, UInt, String?, String?) -> Void)? = nil,
                                cancelHandler: ((LGAlertView) -> Void)? = nil) -> LGAlertView {
        let edit = LGAlertView(textFieldsAndTitle: title, message: msg, numberOfTextFields: numberOfTF,
                textFieldsSetupHandler: { (tf, index) in
                    // 初始化edit
                    tf.text = text
                    tf.placeholder = placeHolder
                    tf.textColor = ColorHelper.getFontBlack()
                    if placeHolder != nil {
                        tf.attributedPlaceholder = NSAttributedString.init(string: placeHolder!, attributes: [NSAttributedString.Key.foregroundColor: ColorHelper.getFontHint()])
                    }
                    tf.textAlignment = .left
                    tf.contentVerticalAlignment = .center
                    tf.adjustsFontSizeToFitWidth = false
                    tf.keyboardType = keyboard
                },
                buttonTitles: confirms, cancelButtonTitle: cancel, destructiveButtonTitle: nil,
                actionHandler: { (alert, index, str) in
                    if alert.textFieldsArray != nil {
                        for obj in alert.textFieldsArray! {
                            let tf = obj as! UITextField
                            actionHandler?(alert, index, str, tf.text)
                        }
                    }
                }, cancelHandler: cancelHandler, destructiveHandler: nil)

        edit.isDismissOnAction = true
        edit.isCancelOnTouch = canCancel
        //        edit.isCancelButtonEnabled = true
        //        edit.isDestructiveButtonEnabled = true
        edit.tintColor = ThemeHelper.getColorPrimary()
        edit.titleTextColor = ColorHelper.getFontBlack()
        edit.messageTextColor = ColorHelper.getFontGrey()

        edit.coverBlurEffect = UIBlurEffect(style: .regular)
        //        edit.coverColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 0.1)
        edit.coverAlpha = 0.3

        return edit
    }

    public static func getEdit(title: String? = nil, msg: String? = nil,
                               text: String? = nil, placeHolder: String? = nil, keyboard: UIKeyboardType = .default,
                               confirms: [String]? = nil, cancel: String? = nil, canCancel: Bool = true,
                               actionHandler: ((LGAlertView, UInt, String?, String?) -> Void)? = nil,
                               cancelHandler: ((LGAlertView) -> Void)? = nil) -> LGAlertView {
        return getEdit(title: title, msg: msg, numberOfTF: 1, text: text, placeHolder: placeHolder, keyboard: keyboard, confirms: confirms, cancel: cancel, canCancel: canCancel, actionHandler: actionHandler, cancelHandler: cancelHandler)
    }

    public static func showEdit(title: String? = nil, msg: String? = nil,
                                text: String? = nil, placeHolder: String? = nil, keyboard: UIKeyboardType = .default,
                                confirms: [String]? = nil, cancel: String? = nil, canCancel: Bool = true,
                                actionHandler: ((LGAlertView, UInt, String?, String?) -> Void)? = nil,
                                cancelHandler: ((LGAlertView) -> Void)? = nil) -> LGAlertView {
        let edit = getEdit(title: title, msg: msg, text: text, placeHolder: placeHolder, keyboard: keyboard, confirms: confirms, cancel: cancel, canCancel: canCancel, actionHandler: actionHandler, cancelHandler: cancelHandler)
        show(edit)
        return edit
    }

    //-------------------------------------DatePicker------------------------------------------------

    public static func getView(style: LGAlertViewStyle = .alert, title: String? = nil, msg: String? = nil, view: UIView?,
                               confirms: [String]? = nil, cancel: String? = nil, canCancel: Bool = false,
                               actionHandler: ((LGAlertView, UInt, String?) -> Void)? = nil,
                               cancelHandler: ((LGAlertView) -> Void)? = nil) -> LGAlertView {
        let alert = LGAlertView(viewAndTitle: title, message: msg, style: style, view: view, buttonTitles: confirms, cancelButtonTitle: cancel, destructiveButtonTitle: nil, actionHandler: actionHandler, cancelHandler: cancelHandler, destructiveHandler: nil)

        alert.isDismissOnAction = true
        alert.isCancelOnTouch = canCancel
        //        alert.isCancelButtonEnabled = true
        //        alert.isDestructiveButtonEnabled = true
        alert.tintColor = ThemeHelper.getColorPrimary()
        alert.titleTextColor = ColorHelper.getFontBlack()
        alert.messageTextColor = ColorHelper.getFontGrey()

        alert.coverBlurEffect = UIBlurEffect(style: .regular)
        //        alert.coverColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 0.1)
        alert.coverAlpha = 0.3

        return alert
    }

    public static func getDatePicker(mode: UIDatePicker.Mode, date: Int64?,
                                     actionHandler: ((LGAlertView, UInt, String?, UIDatePicker) -> Void)? = nil,
                                     cancelHandler: ((LGAlertView) -> Void)? = nil) -> (LGAlertView, UIDatePicker) {
        let width = ScreenUtils.getScreenWidth()
        let height = ScreenUtils.getScreenHeight() / 4 * 1
        let picker = ViewUtils.getDatePicker(width: width, height: height, mode: mode, date: DateUtils.getDate(date))

        let alert = getView(style: .actionSheet, title: nil, msg: nil, view: picker,
                confirms: [StringUtils.getString("confirm")],
                cancel: StringUtils.getString("cancel"),
                canCancel: true, actionHandler: { (view, index, btnTitle) in
            let picker = view.innerView as! UIDatePicker
            actionHandler?(view, index, btnTitle, picker)
        }, cancelHandler: cancelHandler)
        return (alert, picker)
    }

    public static func showDatePicker(mode: UIDatePicker.Mode, date: Int64?,
                                      actionHandler: ((LGAlertView, UInt, String?, UIDatePicker) -> Void)? = nil,
                                      cancelHandler: ((LGAlertView) -> Void)? = nil) -> (LGAlertView, UIDatePicker) {
        let (alert, picker) = getDatePicker(mode: mode, date: date, actionHandler: actionHandler, cancelHandler: cancelHandler)
        show(alert)
        return (alert, picker)
    }

    public static func showDateTimePicker(date: Int64?,
                                          actionHandler: ((LGAlertView, UInt, String?, UIDatePicker) -> Void)? = nil,
                                          cancelHandler: ((LGAlertView) -> Void)? = nil) {
        _ = showDatePicker(mode: .date, date: date, actionHandler: { (_, _, _, pickerD) in
            let pickerDay = DateUtils.getInt64(pickerD.date)
            _ = showDatePicker(mode: .dateAndTime, date: pickerDay, actionHandler: { (view, index, btnTitle, pickerT) in
                actionHandler?(view, index, btnTitle, pickerT)
            }, cancelHandler: cancelHandler)
        }, cancelHandler: cancelHandler)
    }

}
