//
//  NoteWordVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/2/23.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteWordVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    
    // view
    private var tfSend: UITextField!
    private var tableView: UITableView!
    
    // var
    private var wordList: [Word]?
    private var page = 0
    private var limitContentLength: Int = 100
    private var isDel = false
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(NoteWordVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "word")
        let barRemove = UIBarButtonItem(image: UIImage(named: "ic_delete_white_24dp"), style: .plain, target: self, action: #selector(targetWordDelete))
        let barHelp = UIBarButtonItem(image: UIImage(named: "ic_help_outline_white_24dp"), style: .plain, target: self, action: #selector(targetGoHelp))
        self.navigationItem.rightBarButtonItems = [barRemove, barHelp]
        
        // send
        let btnSend = ViewHelper.getBtnImgCenter(paddingH: margin, paddingV: margin, bgImg: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_near_me_grey_24dp"), color: ThemeHelper.getColorPrimary()))
        btnSend.frame.origin = CGPoint(x: ScreenUtils.getScreenWidth() - btnSend.frame.size.width, y: 0)
        
        limitContentLength = UDHelper.getLimit().wordContentLength
        let placeHolder = StringUtils.getString("please_input_content_no_over_holder_text", arguments: [limitContentLength])
        tfSend = ViewHelper.getTextField(width: ScreenUtils.getScreenWidth() - btnSend.frame.size.width - margin, height: btnSend.frame.size.height - margin, text: "", textColor: ColorHelper.getFontGrey(), placeholder: placeHolder, borderStyle: .roundedRect)
        tfSend.frame.origin = CGPoint(x: margin, y: margin / 2)
        tfSend.clearButtonMode = .never
        
        let vInput = UIView()
        vInput.frame.size = CGSize(width: ScreenUtils.getScreenWidth(), height: btnSend.frame.size.height + ScreenUtils.getBottomNavHeight())
        vInput.frame.origin = CGPoint(x: 0, y: self.view.frame.height - RootVC.get().getTopBarHeight() - vInput.frame.size.height)
        vInput.backgroundColor = ColorHelper.getWhite()
        vInput.addSubview(btnSend)
        vInput.addSubview(tfSend)
        
        addViewOffsetWithKeyboard(input: vInput)
        
        // tableView
        tableView = ViewUtils.getTableView(target: self, frame: self.view.bounds, cellCls: NoteWordCell.self, id: NoteWordCell.ID)
        initScrollState(scroll: tableView, clipTopBar: true, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: { self.refreshData(more: false) },
                        canMore: true) { self.refreshData(more: true)
        }
        tableView.frame.size.height -= vInput.frame.size.height
        
        // view
        self.view.addSubview(tableView)
        self.view.addSubview(vInput)
        
        // target
        btnSend.addTarget(self, action: #selector(wordPush), for: .touchUpInside)
    }
    
    override func initData() {
        // refresh
        startScrollDataSet(scroll: tableView)
    }
    
    private func refreshData(more: Bool) {
        page = more ? page + 1 : 0
        // api
        let api = Api.request(.noteWordListGet(page: page),
                              success: { (_, _, data) in
                                NoteWordCell.refreshHeightMap(refresh: !more, start: self.wordList?.count ?? 0, dataList: data.wordList)
                                if !more {
                                    self.wordList = data.wordList
                                    self.endScrollDataRefresh(scroll: self.tableView, msg: data.show, count: data.wordList?.count ?? 0)
                                } else {
                                    self.wordList = (self.wordList ?? [Word]()) + (data.wordList ?? [Word]())
                                    self.endScrollDataMore(scroll: self.tableView, msg: data.show, count: data.wordList?.count ?? 0)
                                }
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.tableView, msg: msg)
        })
        pushApi(api)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NoteWordCell.getCellHeight(view: tableView, indexPath: indexPath, dataList: wordList)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return NoteWordCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: wordList, del: isDel, target: self, action: #selector(targetRemoveItem))
    }
    
    @objc func wordPush() {
        if StringUtils.isEmpty(tfSend.text) || (tfSend.text?.count ?? 0) > limitContentLength {
            ToastUtils.show(tfSend.placeholder)
            return
        }
        let body = Word()
        body.contentText = tfSend.text ?? ""
        // api
        let api = Api.request(.noteWordAdd(word: body.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                self.tfSend.text = ""
                                if data.word == nil {
                                    return
                                }
                                if self.wordList == nil {
                                    self.wordList = [Word]()
                                }
                                if self.wordList!.count <= 0 {
                                    self.wordList!.append(data.word!)
                                } else {
                                    self.wordList!.insert(data.word!, at: 0)
                                }
                                NoteWordCell.refreshHeightMap(refresh: true, start: 0, dataList: self.wordList)
                                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                                self.endScrollState(scroll: self.tableView, msg: nil)
        }, failure: nil)
        pushApi(api)
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_NOTE_WORD)
    }
    
    @objc private func targetWordDelete() {
        isDel = !isDel
        NoteWordCell.toggleModel(view: tableView, count: wordList?.count ?? 0, del: isDel)
    }
    
    @objc private func targetRemoveItem(sender: UIButton) {
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_delete_this_note"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    if let indexPath = ViewUtils.findTableIndexPath(view: sender) {
                                        self.delWord(index: indexPath.row)
                                    }
        },
                                  cancelHandler: nil)
    }
    
    private func delWord(index: Int) {
        if wordList == nil || wordList!.count <= index {
            return
        }
        let word = wordList![index]
        // api
        let api = Api.request(.noteWordDel(wid: word.id),
                              loading: true, cancel: true, success: { (_, _, data) in
                                self.wordList!.remove(at: index)
                                NoteWordCell.refreshHeightMap(refresh: true, start: 0, dataList: self.wordList)
                                self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                                self.endScrollState(scroll: self.tableView, msg: nil)
        }, failure: nil)
        pushApi(api)
    }
    
}
