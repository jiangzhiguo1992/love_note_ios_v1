//
//  NoteVideoEditVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/30.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteVideoEditVC: BaseVC {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    lazy var barVerticalMargin = ScreenUtils.heightFit(15)
    lazy var barIconMargin = ScreenUtils.widthFit(5)
    
    // view
    private var scroll: UIScrollView!
    private var tfTitle: UITextField!
    private var vHappenAt: UIView!
    private var lHappenAt: UILabel!
    private var vAddress: UIView!
    private var lAddress: UILabel!
    private var vDuration: UIView!
    private var lDuration: UILabel!
    
    // var
    private var video: Video?
    private var dataThumb: Data?
    private var dataVideo: Data?
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(NoteVideoEditVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "video")
        let barItemCommit = UIBarButtonItem(title: StringUtils.getString("commit"), style: .plain, target: self, action: #selector(checkPush))
        barItemCommit.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        self.navigationItem.setRightBarButtonItems([barItemCommit], animated: true)
        
        // title
        tfTitle = ViewHelper.getTextField(width: maxWidth, paddingV: ScreenUtils.heightFit(10), textSize: ViewHelper.FONT_SIZE_NORMAL, textColor: ColorHelper.getFontGrey(), placeholder: StringUtils.getString("please_input_title"), placeColor: ColorHelper.getFontHint())
        tfTitle.frame.origin = CGPoint(x: margin, y: margin * 2)
        
        // happenAt
        let vLineHappenAt = ViewHelper.getViewLine(width: maxWidth)
        vLineHappenAt.frame.origin = CGPoint(x: margin, y: 0)
        lHappenAt = ViewHelper.getLabelGreyNormal(width: maxWidth, text: StringUtils.getString("time_colon_space_holder"), lines: 1, align: .left, mode: .byTruncatingMiddle)
        let ivHappenAt = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_access_time_grey_18dp"), color: ColorHelper.getFontGrey()), width: lHappenAt.frame.size.height, height: lHappenAt.frame.size.height, mode: .scaleAspectFit)
        ivHappenAt.frame.origin = CGPoint(x: margin, y: barVerticalMargin)
        lHappenAt.frame.size.width = screenWidth - ivHappenAt.frame.origin.x - ivHappenAt.frame.size.width - barIconMargin - margin
        lHappenAt.frame.origin = CGPoint(x: ivHappenAt.frame.origin.x + ivHappenAt.frame.size.width + barIconMargin, y: barVerticalMargin)
        vHappenAt = UIView(frame: CGRect(x: 0, y: tfTitle.frame.origin.y + tfTitle.frame.size.height + ScreenUtils.heightFit(30), width: screenWidth, height: ivHappenAt.frame.size.height + barVerticalMargin * 2))
        
        vHappenAt.addSubview(vLineHappenAt)
        vHappenAt.addSubview(ivHappenAt)
        vHappenAt.addSubview(lHappenAt)
        
        // address
        let vLineAddress = ViewHelper.getViewLine(width: maxWidth)
        vLineAddress.frame.origin = CGPoint(x: margin, y: 0)
        lAddress = ViewHelper.getLabelGreyNormal(width: maxWidth, text: StringUtils.getString("address_colon_space_holder"), lines: 1, align: .left, mode: .byTruncatingMiddle)
        let ivAddress = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_location_on_grey_18dp"), color: ColorHelper.getFontGrey()), width: lAddress.frame.size.height, height: lAddress.frame.size.height, mode: .scaleAspectFit)
        ivAddress.frame.origin = CGPoint(x: margin, y: barVerticalMargin)
        lAddress.frame.size.width = screenWidth - ivAddress.frame.origin.x - ivAddress.frame.size.width - barIconMargin - margin
        lAddress.frame.origin = CGPoint(x: ivAddress.frame.origin.x + ivAddress.frame.size.width + barIconMargin, y: barVerticalMargin)
        vAddress = UIView(frame: CGRect(x: 0, y: vHappenAt.frame.origin.y + vHappenAt.frame.size.height, width: screenWidth, height: ivAddress.frame.size.height + barVerticalMargin * 2))
        
        vAddress.addSubview(vLineAddress)
        vAddress.addSubview(ivAddress)
        vAddress.addSubview(lAddress)
        
        // duration
        let vLineDuration = ViewHelper.getViewLine(width: maxWidth)
        vLineDuration.frame.origin = CGPoint(x: margin, y: 0)
        lDuration = ViewHelper.getLabelGreyNormal(width: maxWidth, text: StringUtils.getString("duration_colon_space_holder"), lines: 1, align: .left, mode: .byTruncatingMiddle)
        let ivDuration = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_av_timer_white_18dp"), color: ColorHelper.getFontGrey()), width: lDuration.frame.size.height, height: lDuration.frame.size.height, mode: .scaleAspectFit)
        ivDuration.frame.origin = CGPoint(x: margin, y: barVerticalMargin)
        lDuration.frame.size.width = screenWidth - ivDuration.frame.origin.x - ivDuration.frame.size.width - barIconMargin - margin
        lDuration.frame.origin = CGPoint(x: ivDuration.frame.origin.x + ivDuration.frame.size.width + barIconMargin, y: barVerticalMargin)
        vDuration = UIView(frame: CGRect(x: 0, y: vAddress.frame.origin.y + vAddress.frame.size.height, width: screenWidth, height: ivDuration.frame.size.height + barVerticalMargin * 2))
        
        vDuration.addSubview(vLineDuration)
        vDuration.addSubview(ivDuration)
        vDuration.addSubview(lDuration)
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = vDuration.frame.origin.y + vDuration.frame.height + ScreenUtils.heightFit(30)
        scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        
        scroll.addSubview(tfTitle)
        scroll.addSubview(vHappenAt)
        scroll.addSubview(vAddress)
        scroll.addSubview(vDuration)
        
        // view
        self.view.backgroundColor = ColorHelper.getWhite()
        self.view.addSubview(scroll)
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vHappenAt, action: #selector(showDatePicker))
        ViewUtils.addViewTapTarget(target: self, view: vAddress, action: #selector(selectLocation))
        ViewUtils.addViewTapTarget(target: self, view: vDuration, action: #selector(selectVideo))
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyLocationSelect), name: NotifyHelper.TAG_MAP_SELECT)
        // init
        if video == nil {
            video = Video()
        }
        if video!.happenAt == 0 {
            video?.happenAt = DateUtils.getCurrentInt64()
        }
        // title
        let placeholder = StringUtils.getString("please_input_title_no_over_holder_text", arguments: [UDHelper.getLimit().videoTitleLength])
        ViewUtils.setTextFiledPlaceholder(textField: tfTitle, placeholder: placeholder)
        tfTitle.text = video?.title
        // view
        refreshDateView()
        refreshLocationView()
        refreshVideoView()
    }
    
    @objc func notifyLocationSelect(notify: NSNotification) {
        let locationInfo = (notify.object as? LocationInfo)
        if locationInfo == nil || (StringUtils.isEmpty(locationInfo?.address) && locationInfo?.longitude == 0 && locationInfo?.latitude == 0) {
            return
        }
        video?.address = locationInfo!.address
        video?.longitude = locationInfo!.longitude ?? 0
        video?.latitude = locationInfo!.latitude ?? 0
        video?.cityId = locationInfo!.cityId
        refreshLocationView()
    }
    
    @objc func showDatePicker() {
        AlertHelper.showDateTimePicker(date: video?.happenAt, actionHandler: { (_, _, _, picker) in
            self.video?.happenAt = DateUtils.getInt64(picker.date)
            self.refreshDateView()
        }, cancelHandler: nil)
    }
    
    func refreshDateView() {
        let happen = TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(video?.happenAt ?? DateUtils.getCurrentInt64())
        lHappenAt.text = StringUtils.getString("time_colon_space_holder", arguments: [happen])
    }
    
    @objc func selectLocation() {
        MapSelectVC.pushVC(address: video?.address, lon: video?.longitude, lat: video?.latitude)
    }
    
    func refreshLocationView() {
        let address = StringUtils.isEmpty(video?.address) ? StringUtils.getString("now_no") : (video?.address ?? "")
        lAddress.text = StringUtils.getString("address_colon_space_holder", arguments: [address])
    }
    
    @objc func selectVideo() {
        PickerHelper.selectVideo(target: self, maxCount: 1) { (thumb, duration, video) in
            self.dataThumb = thumb
            self.dataVideo = video
            self.video?.duration = duration
            self.refreshVideoView()
        }
    }
    
    func refreshVideoView() {
        if video == nil {
            return
        }
        if video!.duration == 0 || dataVideo == nil {
            lDuration.text = StringUtils.getString("duration_colon_space_holder", arguments: [StringUtils.getString("please_select_video")])
            return
        }
        lDuration.text = StringUtils.getString("duration_colon_space_holder", arguments: [ShowHelper.getDurationShow(video!.duration)])
    }
    
    @objc func checkPush() {
        if video == nil {
            return
        }
        // title
        if StringUtils.isEmpty(tfTitle.text) {
            ToastUtils.show(tfTitle.placeholder)
            return
        } else if (tfTitle.text?.count ?? 0) > UDHelper.getLimit().videoTitleLength {
            ToastUtils.show(tfTitle.placeholder)
            return
        } else if dataVideo == nil {
            ToastUtils.show(StringUtils.getString("please_select_video"))
            return
        }
        video?.title = tfTitle.text ?? ""
        if dataThumb != nil {
            ossUploadThumb()
        } else {
            ossUploadVideo()
        }
    }
    
    func ossUploadThumb() {
        if video == nil {
            return
        }
        OssHelper.uploadVideoThumb(data: dataThumb, success: { (_, ossKey) in
            self.video?.contentThumb = ossKey
            self.ossUploadVideo()
        }) { (_, _) in
            // 失败了就直接上传video 不要thumb了
            self.ossUploadVideo()
        }
    }
    
    func ossUploadVideo() {
        if video == nil {
            return
        }
        OssHelper.uploadVideo(data: dataVideo, success: { (_, ossKey) in
            self.video?.contentVideo = ossKey
            self.addApi()
        }, failure: nil)
    }
    
    func addApi() {
        if video == nil {
            return
        }
        let api = Api.request(.noteVideoAdd(video: video?.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_VIDEO_LIST_REFRESH, obj: nil)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
}
