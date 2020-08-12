//
//  NoteAudioEditVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/1.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteAudioEditVC: BaseVC {
    
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
    private var vDuration: UIView!
    private var lDuration: UILabel!
    
    // var
    private var audio: Audio?
    private var dataAudio: Data?
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(NoteAudioEditVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "audio")
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
        
        // duration
        let vLineDuration = ViewHelper.getViewLine(width: maxWidth)
        vLineDuration.frame.origin = CGPoint(x: margin, y: 0)
        lDuration = ViewHelper.getLabelGreyNormal(width: maxWidth, text: StringUtils.getString("duration_colon_space_holder"), lines: 1, align: .left, mode: .byTruncatingMiddle)
        let ivDuration = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_av_timer_white_18dp"), color: ColorHelper.getFontGrey()), width: lDuration.frame.size.height, height: lDuration.frame.size.height, mode: .scaleAspectFit)
        ivDuration.frame.origin = CGPoint(x: margin, y: barVerticalMargin)
        lDuration.frame.size.width = screenWidth - ivDuration.frame.origin.x - ivDuration.frame.size.width - barIconMargin - margin
        lDuration.frame.origin = CGPoint(x: ivDuration.frame.origin.x + ivDuration.frame.size.width + barIconMargin, y: barVerticalMargin)
        vDuration = UIView(frame: CGRect(x: 0, y: vHappenAt.frame.origin.y + vHappenAt.frame.size.height, width: screenWidth, height: ivDuration.frame.size.height + barVerticalMargin * 2))
        
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
        scroll.addSubview(vDuration)
        
        // view
        self.view.backgroundColor = ColorHelper.getWhite()
        self.view.addSubview(scroll)
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vHappenAt, action: #selector(showDatePicker))
        ViewUtils.addViewTapTarget(target: self, view: vDuration, action: #selector(selectAudio))
    }
    
    override func initData() {
        // init
        if audio == nil {
            audio = Audio()
        }
        if audio!.happenAt == 0 {
            audio?.happenAt = DateUtils.getCurrentInt64()
        }
        // title
        let placeholder = StringUtils.getString("please_input_title_no_over_holder_text", arguments: [UDHelper.getLimit().audioTitleLength])
        ViewUtils.setTextFiledPlaceholder(textField: tfTitle, placeholder: placeholder)
        tfTitle.text = audio?.title
        // view
        refreshDateView()
        refreshAudioView()
    }
    
    @objc func showDatePicker() {
        AlertHelper.showDateTimePicker(date: audio?.happenAt, actionHandler: { (_, _, _, picker) in
            self.audio?.happenAt = DateUtils.getInt64(picker.date)
            self.refreshDateView()
        }, cancelHandler: nil)
    }
    
    func refreshDateView() {
        let happen = TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(audio?.happenAt ?? DateUtils.getCurrentInt64())
        lHappenAt.text = StringUtils.getString("time_colon_space_holder", arguments: [happen])
    }
    
    @objc func selectAudio() {
//        let everything = MPMediaQuery()
//        let itemsFromGenericQuery = everything.items
//        for song in itemsFromGenericQuery! {
//            //获取音乐名称
//            let songTitle = song.value(forProperty: MPMediaItemPropertyTitle)
//            print("songTitle==\(songTitle!)")
//            //获取作者名称
//            let songArt = song.value(forProperty: MPMediaItemPropertyArtist)
//            print("songArt=\(songArt!)")
//            //获取音乐路径
//            let songUrl = song.value(forProperty: MPMediaItemPropertyAssetURL)
//            print("songUrl==\(songUrl!)")
//        }
    }
    
    func refreshAudioView() {
        if audio == nil {
            return
        }
        if audio!.duration == 0 || dataAudio == nil {
            lDuration.text = StringUtils.getString("duration_colon_space_holder", arguments: [StringUtils.getString("please_select_audio")])
            return
        }
        lDuration.text = StringUtils.getString("duration_colon_space_holder", arguments: [ShowHelper.getDurationShow(audio!.duration)])
    }
    
    @objc func checkPush() {
        if audio == nil {
            return
        }
        // title
        if StringUtils.isEmpty(tfTitle.text) {
            ToastUtils.show(tfTitle.placeholder)
            return
        } else if (tfTitle.text?.count ?? 0) > UDHelper.getLimit().audioTitleLength {
            ToastUtils.show(tfTitle.placeholder)
            return
        } else if dataAudio == nil {
            ToastUtils.show(StringUtils.getString("please_select_audio"))
            return
        }
        audio?.title = tfTitle.text ?? ""
        ossUploadAudio()
    }
    
    func ossUploadAudio() {
        if audio == nil {
            return
        }
        OssHelper.uploadAudio(data: dataAudio, success: { (_, ossKey) in
            self.audio?.contentAudio = ossKey
            self.addApi()
        }, failure: nil)
    }
    
    func addApi() {
        if audio == nil {
            return
        }
        let api = Api.request(.noteAudioAdd(audio: audio?.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_AUDIO_LIST_REFRESH, obj: nil)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
}
