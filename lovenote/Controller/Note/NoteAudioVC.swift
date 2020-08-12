//
//  NoteAudioVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/2/23.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class NoteAudioVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var screenHeight = ScreenUtils.getScreenHeight() - RootVC.get().getTopBarHeight()
    
    // view
    private var tableView: UITableView!
    
    // var
    private var audioList: [Audio]?
    private var page = 0
    private var playIndex = -1
    private var player: AVPlayer?
    
    public static func pushVC(select: Bool = false) {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(NoteAudioVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "audio")
        let barHelp = UIBarButtonItem(image: UIImage(named: "ic_help_outline_white_24dp"), style: .plain, target: self, action: #selector(targetGoHelp))
        self.navigationItem.rightBarButtonItems = [barHelp]
        
        // tableView
        tableView = ViewUtils.getTableView(target: self, frame: self.view.bounds, cellCls: NoteAudioCell.self, id: NoteAudioCell.ID)
        initScrollState(scroll: tableView, clipTopBar: true, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: { self.refreshData(more: false) },
                        canMore: true) { self.refreshData(more: true) }
        
        // add
        let btnAdd = ViewHelper.getBtnImgCenter(width: ViewHelper.FAB_SIZE, height: ViewHelper.FAB_SIZE, bgColor: ThemeHelper.getColorAccent(), bgImg: UIImage(named: "ic_add_white_24dp"), circle: true, shadow: true)
        btnAdd.frame.origin = CGPoint(x: screenWidth - ViewHelper.FAB_MARGIN - btnAdd.frame.size.width, y: screenHeight - ViewHelper.FAB_MARGIN - btnAdd.frame.size.height)
        
        // view
        self.view.addSubview(tableView)
        self.view.addSubview(btnAdd)
        
        // hide
        btnAdd.isHidden = true
        
        // target
        btnAdd.addTarget(self, action: #selector(goAdd), for: .touchUpInside)
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_AUDIO_LIST_REFRESH)
        // refresh
        startScrollDataSet(scroll: tableView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 暂停播放
        let oldPlayIndex = playIndex
        playIndex = -1
        if audioList != nil && audioList!.count > oldPlayIndex && oldPlayIndex >= 0 {
            tableView.reloadRows(at: [IndexPath(row: oldPlayIndex, section: 0)], with: .automatic)
        }
        PlayerHelper.pause(player: player)
    }
    
    @objc func notifyRefresh(notify: NSNotification) {
        startScrollDataSet(scroll: tableView)
    }
    
    func isFromSelect() -> Bool {
        return actFrom == BaseVC.ACT_LIST_FROM_SELECT
    }
    
    private func refreshData(more: Bool) {
        page = more ? page + 1 : 0
        // api
        let api = Api.request(.noteAudioListGet(page: page),
                              success: { (_, _, data) in
                                if !more {
                                    self.audioList = data.audioList
                                    self.endScrollDataRefresh(scroll: self.tableView, msg: data.show, count: data.audioList?.count ?? 0)
                                } else {
                                    self.audioList = (self.audioList ?? [Audio]()) + (data.audioList ?? [Audio]())
                                    self.endScrollDataMore(scroll: self.tableView, msg: data.show, count: data.audioList?.count ?? 0)
                                }
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.tableView, msg: msg)
        })
        pushApi(api)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NoteAudioCell.getCellHeight(view: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return NoteAudioCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: audioList, playIndex: playIndex, target: self, actionPlay: #selector(targetTogglePlay), actionEdit: #selector(targetRemoveItem))
    }
    
    @objc private func targetTogglePlay(sender: UIGestureRecognizer) {
        if let indexPath = ViewUtils.findTableIndexPath(view: sender.view) {
            // pause
            PlayerHelper.pause(player: player)
            // index
            let oldPlayIndex = playIndex
            playIndex = indexPath.row
            if playIndex == oldPlayIndex || audioList == nil || audioList!.count <= playIndex || playIndex < 0 {
                playIndex = -1
                if oldPlayIndex >= 0 && oldPlayIndex < audioList!.count{
                    tableView.reloadRows(at: [IndexPath(row: oldPlayIndex, section: 0)], with: .automatic)
                }
                return
            }
            // view
            if oldPlayIndex >= 0 && oldPlayIndex < audioList!.count{
                tableView.reloadRows(at: [IndexPath(row: oldPlayIndex, section: 0)], with: .automatic)
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
            // play
            let audio = audioList?[playIndex]
            player = PlayerHelper.getPlayer(ossKey: audio?.contentAudio)
            PlayerHelper.play(player: player)
        }
    }
    
    @objc private func targetRemoveItem(sender: UIButton) {
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_delete_this_note"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    if let indexPath = ViewUtils.findTableIndexPath(view: sender) {
                                        self.delAudio(index: indexPath.row)
                                    }
        },
                                  cancelHandler: nil)
    }
    
    private func delAudio(index: Int) {
        if audioList == nil || audioList!.count <= index {
            return
        }
        let audio = audioList![index]
        if !audio.isMine() {
            ToastUtils.show(StringUtils.getString("can_operation_self_create_note"))
            return
        }
        // api
        let api = Api.request(.noteAudioDel(aid: audio.id),
                              loading: true, cancel: true, success: { (_, _, data) in
                                self.audioList!.remove(at: index)
                                self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                                self.endScrollState(scroll: self.tableView, msg: nil)
        }, failure: nil)
        pushApi(api)
    }
    
    @objc func goAdd() {
        NoteAudioEditVC.pushVC()
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_NOTE_AUDIO)
    }
    
}
