//
//  NoteWhisperVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/2/23.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteWhisperVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    
    // view
    private var lChannel: UILabel!
    private var tfChannel: UITextField!
    private var btnChannel: UIButton!
    private var tfSend: UITextField!
    private var tableView: UITableView!
    
    // var
    private var whisperList: [Whisper]?
    private var channel = ""
    private var page = 0
    private var limitChannelLength: Int = 20
    private var limitContentLength: Int = 100
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(NoteWhisperVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "whisper")
        let barHelp = UIBarButtonItem(image: UIImage(named: "ic_help_outline_white_24dp"), style: .plain, target: self, action: #selector(targetGoHelp))
        self.navigationItem.rightBarButtonItems = [barHelp]
        
        // channel-show
        lChannel = ViewHelper.getLabelBold(width: maxWidth, text: "-", size: ViewHelper.FONT_SIZE_BIG, color: ColorHelper.getFontWhite(), lines: 1, align: .center, mode: .byTruncatingMiddle)
        lChannel.frame.origin = CGPoint(x: margin, y: margin)
        
        // channel-toggle
        btnChannel = ViewHelper.getBtnBGWhite(paddingH: margin, HAlign: .center, VAlign: .center, title: StringUtils.getString("change_channel"), titleSize: ViewHelper.FONT_SIZE_NORMAL, titleColor: ThemeHelper.getColorPrimary(), titleLines: 1, titleAlign: .center, circle: false, shadow: false)
        btnChannel.frame.origin = CGPoint(x: ScreenUtils.getScreenWidth() - margin - btnChannel.frame.size.width, y: lChannel.frame.origin.y + lChannel.frame.size.height + ScreenUtils.heightFit(15))
        
        // channel-input
        limitChannelLength = UDHelper.getLimit().whisperChannelLength
        let placeHolderChannel = StringUtils.getString("please_input_channel_no_over_holder_text", arguments: [limitChannelLength])
        tfChannel = ViewHelper.getTextField(width: maxWidth - btnChannel.frame.size.width - margin, paddingV: ScreenUtils.heightFit(7), text: "", textSize: ViewHelper.FONT_SIZE_NORMAL, textColor: ColorHelper.getFontGrey(), placeholder: placeHolderChannel, horizontalAlign: .center, verticalAlign: .center, borderStyle: .none)
        tfChannel.frame.origin = CGPoint(x: margin, y: lChannel.frame.origin.y + lChannel.frame.size.height + ScreenUtils.heightFit(15))
        tfChannel.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(tfChannel, radius: ViewHelper.RADIUS_NORMAL)
        tfChannel.clearButtonMode = .never
        
        btnChannel.frame.size.height = tfChannel.frame.size.height
        ViewUtils.setViewRadiusCircle(btnChannel)
        ViewUtils.setViewShadow(btnChannel, offset: ViewHelper.SHADOW_NORMAL)
        
        // channel-root
        let vChannel = UIView()
        vChannel.frame.size = CGSize(width: ScreenUtils.getScreenWidth(), height: tfChannel.frame.origin.y + tfChannel.frame.size.height + ScreenUtils.heightFit(15))
        vChannel.frame.origin = CGPoint(x: 0, y: 0)
        vChannel.backgroundColor = ThemeHelper.getColorPrimary()
        vChannel.addSubview(lChannel)
        vChannel.addSubview(tfChannel)
        vChannel.addSubview(btnChannel)
        
        // textAdd
        let btnTextAdd = ViewHelper.getBtnImgCenter(paddingH: margin, paddingV: margin, bgImg: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_near_me_grey_24dp"), color: ThemeHelper.getColorPrimary()))
        btnTextAdd.frame.origin = CGPoint(x: ScreenUtils.getScreenWidth() - btnTextAdd.frame.size.width, y: 0)
        
        // imgAdd
        let btnImgAdd = ViewHelper.getBtnImgCenter(paddingH: margin, paddingV: margin, bgImg: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_image_grey_24dp"), color: ThemeHelper.getColorPrimary()))
        btnImgAdd.frame.origin = CGPoint(x: 0, y: 0)
        
        // send
        limitContentLength = UDHelper.getLimit().whisperContentLength
        let placeHolderSend = StringUtils.getString("please_input_content_no_over_holder_text", arguments: [limitContentLength])
        tfSend = ViewHelper.getTextField(width: ScreenUtils.getScreenWidth() - btnTextAdd.frame.size.width - btnImgAdd.frame.size.width, height: CountHelper.getMax(btnTextAdd.frame.size.height, btnImgAdd.frame.size.height) - margin, text: "", textColor: ColorHelper.getFontGrey(), placeholder: placeHolderSend, borderStyle: .roundedRect)
        tfSend.frame.origin = CGPoint(x: btnImgAdd.frame.origin.x + btnImgAdd.frame.size.width, y: margin / 2)
        tfSend.clearButtonMode = .never
        
        // input
        let vInput = UIView()
        vInput.frame.size = CGSize(width: ScreenUtils.getScreenWidth(), height: CountHelper.getMax(btnTextAdd.frame.size.height, btnImgAdd.frame.size.height) + ScreenUtils.getBottomNavHeight())
        vInput.frame.origin = CGPoint(x: 0, y: self.view.frame.height - RootVC.get().getTopBarHeight() - vInput.frame.size.height)
        vInput.backgroundColor = ColorHelper.getWhite()
        vInput.addSubview(btnImgAdd)
        vInput.addSubview(tfSend)
        vInput.addSubview(btnTextAdd)
        
        addViewOffsetWithKeyboard(input: vInput)
        
        // tableView
        tableView = ViewUtils.getTableView(target: self, frame: self.view.bounds, cellCls: NoteWhisperCell.self, id: NoteWhisperCell.ID)
        initScrollState(scroll: tableView, clipTopBar: true, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: { self.refreshData(more: false) },
                        canMore: true) { self.refreshData(more: true) }
        tableView.frame.size.height -= (vChannel.frame.size.height + vInput.frame.size.height)
        tableView.frame.origin.y = vChannel.frame.origin.y + vChannel.frame.size.height
        
        // gradient
        let vGradient = UIView(frame: CGRect(x: 0, y: tableView.frame.origin.y, width: screenWidth, height: ScreenUtils.heightFit(100)))
        let gradient = ViewHelper.getGradientPrimaryTrans(frame: vGradient.bounds)
        vGradient.layer.insertSublayer(gradient, at: 0)
        
        // view
        self.view.addSubview(vChannel)
        self.view.addSubview(vGradient)
        self.view.addSubview(tableView)
        self.view.addSubview(vInput)
        
        // target
        btnChannel.addTarget(self, action: #selector(targrtToggleChannel), for: .touchUpInside)
        btnImgAdd.addTarget(self, action: #selector(targrtAddImg), for: .touchUpInside)
        btnTextAdd.addTarget(self, action: #selector(targrtAddText), for: .touchUpInside)
    }
    
    override func initData() {
        channel = ""
        // refresh
        startScrollDataSet(scroll: tableView)
    }
    
    private func refreshData(more: Bool) {
        page = more ? page + 1 : 0
        channel = tfChannel.text ?? ""
        let channelShow = StringUtils.isEmpty(channel) ? StringUtils.getString("now_no") : channel
        lChannel.text = StringUtils.getString("current_channel_colon_space_holder", arguments: [channelShow])
        // api
        let api = Api.request(.noteWhisperListGet(channel: channel, page: page),
                              success: { (_, _, data) in
                                NoteWhisperCell.refreshHeightMap(refresh: !more, start: self.whisperList?.count ?? 0, dataList: data.whisperList)
                                if !more {
                                    self.whisperList = data.whisperList
                                    self.endScrollDataRefresh(scroll: self.tableView, msg: data.show, count: data.whisperList?.count ?? 0)
                                } else {
                                    self.whisperList = (self.whisperList ?? [Whisper]()) + (data.whisperList ?? [Whisper]())
                                    self.endScrollDataMore(scroll: self.tableView, msg: data.show, count: data.whisperList?.count ?? 0)
                                }
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.tableView, msg: msg)
        })
        pushApi(api)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return whisperList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NoteWhisperCell.getCellHeight(view: tableView, indexPath: indexPath, dataList: whisperList)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return NoteWhisperCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: whisperList, target: self, actionBigImg: #selector(targrtGoBigImg))
    }
    
    @objc func targrtGoBigImg(sender: UIGestureRecognizer) {
        NoteWhisperCell.goBigImg(view: sender.view, dataList: whisperList)
    }
    
    @objc func targrtToggleChannel(sender: UIButton) {
        startScrollDataSet(scroll: tableView)
    }
    
    @objc func targrtAddImg(sender: UIButton) {
        if !UDHelper.getVipLimit().whisperImageEnable {
            MoreVipVC.pushVC()
            return
        }
        PickerHelper.selectImage(target: self, maxCount: 1, gif: true, compress: true, crop: false) { (datas) in
            if datas.count <= 0 { return }
            OssHelper.uploadWhisper(data: datas[0], success: { (_, ossKey) in
                let body = Whisper()
                body.channel = self.tfChannel.text ?? ""
                body.isImage = true
                body.content = ossKey
                self.apiAdd(body: body)
            }, failure: nil)
        }
    }
    
    @objc func targrtAddText(sender: UIButton) {
        if StringUtils.isEmpty(tfSend.text) {
            ToastUtils.show(tfSend.placeholder)
            return
        }
        let body = Whisper()
        body.channel = tfChannel.text ?? ""
        body.isImage = false
        body.content = tfSend.text ?? ""
        apiAdd(body: body)
    }
    
    func apiAdd(body: Whisper) {
        // api
        let api = Api.request(.noteWhisperAdd(whisper: body.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                self.tfSend.text = ""
                                if data.whisper == nil {
                                    return
                                }
                                if self.whisperList == nil {
                                    self.whisperList = [Whisper]()
                                }
                                if self.whisperList!.count <= 0 {
                                    self.whisperList!.append(data.whisper!)
                                } else {
                                    self.whisperList!.insert(data.whisper!, at: 0)
                                }
                                NoteWhisperCell.refreshHeightMap(refresh: true, start: 0, dataList: self.whisperList)
                                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                                self.endScrollState(scroll: self.tableView, msg: nil)
        }, failure: nil)
        pushApi(api)
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_NOTE_WHISPER)
    }
    
}
