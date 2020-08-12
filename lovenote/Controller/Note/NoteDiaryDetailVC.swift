//
//  NoteDiaryDetailVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/2/27.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteDiaryDetailVC: BaseVC, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var maxWidth = ScreenUtils.getScreenWidth() - margin * 2
    
    // view
    private var scroll: UIScrollView!
    private var lHappenAt: UILabel!
    private var ivAvatar: UIImageView!
    private var lTextCount: UILabel!
    private var lReadCount: UILabel!
    private var collectImgList: UICollectionView!
    private var lContent: UILabel!
    
    // var
    private var diary: Diary?
    private var did: Int64 = 0
    
    public static func pushVC(diary: Diary? = nil, did: Int64 = 0) {
        AppDelegate.runOnMainAsync {
            let vc = NoteDiaryDetailVC(nibName: nil, bundle: nil)
            vc.diary = diary
            vc.did = did
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "diary")
        let barItemEdit = UIBarButtonItem(image: UIImage(named: "ic_edit_white_24dp"), style: .plain, target: self, action: #selector(targetGoEdit))
        let barItemDel = UIBarButtonItem(image: UIImage(named: "ic_delete_white_24dp"), style: .plain, target: self, action: #selector(showDeleteAlert))
        self.navigationItem.setRightBarButtonItems([barItemEdit, barItemDel], animated: true)
        
        // happen
        lHappenAt = ViewHelper.getLabelBold(width: maxWidth, text: "-", size: ViewHelper.FONT_SIZE_BIG, color: ColorHelper.getFontBlack(), lines: 0, align: .center)
        lHappenAt.frame.origin = CGPoint(x: margin, y: ScreenUtils.heightFit(30))
        
        // avatar
        ivAvatar = ViewHelper.getImageViewAvatar(width: ScreenUtils.widthFit(50), height: ScreenUtils.widthFit(50))
        ivAvatar.center.x = self.view.center.x
        ivAvatar.frame.origin.y = lHappenAt.frame.origin.y + lHappenAt.frame.size.height + ScreenUtils.heightFit(20)
        let vAvatarShadow = ViewUtils.getViewShadow(ivAvatar, bgColor: ColorHelper.getWhite(), offset: ViewHelper.SHADOW_NORMAL)
        
        // count
        lTextCount = ViewHelper.getLabelGreySmall(width: (maxWidth - margin) / 2, text: "-", lines: 1, align: .left, mode: .byTruncatingMiddle)
        lTextCount.frame.origin = CGPoint(x: margin, y: ivAvatar.frame.origin.y + ivAvatar.frame.size.height - lTextCount.frame.size.height)
        
        lReadCount = ViewHelper.getLabelGreySmall(width: (maxWidth - margin) / 2, text: "-", lines: 1, align: .right, mode: .byTruncatingMiddle)
        lReadCount.frame.origin = CGPoint(x: lTextCount.frame.origin.x + lTextCount.frame.size.width + margin, y: lTextCount.frame.origin.y)
        
        // imgList
        let layoutImgList = ImgSquareShowCell.getLayout(maxWidth: maxWidth)
        let marginImgList = layoutImgList.sectionInset
        let collectImgListWidth = maxWidth + marginImgList.left + marginImgList.right
        let collectImgListX = margin - marginImgList.left
        let collectImgListY = ivAvatar.frame.origin.y + ivAvatar.frame.size.height + ScreenUtils.heightFit(15) - marginImgList.top
        collectImgList = ViewUtils.getCollectionView(target: self, frame: CGRect(x: collectImgListX, y: collectImgListY, width: collectImgListWidth, height: 0), layout: layoutImgList, cellCls: ImgSquareShowCell.self, id: ImgSquareShowCell.ID)
        
        // content
        lContent = ViewHelper.getLabelBlackBig(width: maxWidth, text: "-", lines: 0, align: .left)
        lContent.frame.origin = CGPoint(x: margin, y: ivAvatar.frame.origin.y + ivAvatar.frame.size.height + ScreenUtils.heightFit(15))
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = lContent.frame.origin.y + lContent.frame.size.height + ScreenUtils.heightFit(20)
        scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        
        scroll.addSubview(lHappenAt)
        scroll.addSubview(vAvatarShadow)
        scroll.addSubview(ivAvatar)
        scroll.addSubview(lTextCount)
        scroll.addSubview(lReadCount)
        scroll.addSubview(collectImgList)
        scroll.addSubview(lContent)
        
        // view
        self.view.addSubview(scroll)
        
        // hide
        collectImgList.isHidden = true
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_DIARY_DETAIL_REFRESH)
        // init
        if diary != nil {
            refreshView()
            // 没有详情页的，可以不加
            refreshData(did: diary!.id)
        } else if did > 0 {
            refreshData(did: did)
        } else {
            RootVC.get().popBack()
        }
    }
    
    @objc func notifyRefresh(notify: NSNotification) {
        if let diary = notify.object as? Diary {
            refreshData(did: diary.id)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diary?.contentImageList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return ImgSquareShowCell.getCellWithData(view: collectionView, indexPath: indexPath, dataList: diary?.contentImageList)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        BrowserHelper.goBrowserImage(delegate: self, index: indexPath.row, ossKeyList: diary?.contentImageList)
    }
    
    func refreshData(did: Int64) {
        ViewUtils.beginScrollRefresh(scroll)
        // api
        let api = Api.request(.noteDiaryGet(did: did), success: { (_, _, data) in
            ViewUtils.endScrollRefresh(self.scroll)
            self.diary = data.diary
            self.refreshView()
        }, failure: { (_, _, _) in
            ViewUtils.endScrollRefresh(self.scroll)
        })
        self.pushApi(api)
    }
    
    func refreshView() {
        if diary == nil {
            return
        }
        let me = UDHelper.getMe()
        // text
        lHappenAt.text = TimeHelper.getTimeShowLine_HM_MD_YMD_ByGo(diary!.happenAt)
        lTextCount.text = StringUtils.getString("text_number_space_colon_holder", arguments: [diary!.contentText.count])
        lReadCount.text = StringUtils.getString("read_space_colon_holder", arguments: [diary!.readCount])
        lContent.text = diary!.contentText
        // avatar
        let avatar = UserHelper.getAvatar(user: me, uid: diary!.userId)
        KFHelper.setImgAvatarUrl(iv: ivAvatar, objKey: avatar, uid: diary!.userId)
        // img
        if diary?.contentImageList.count ?? 0 > 0 {
            collectImgList.isHidden = false
            collectImgList.frame.size.height = ImgSquareShowCell.getCollectHeight(collect: collectImgList, dataList: diary?.contentImageList)
            collectImgList.reloadData()
            lContent.frame.origin.y = collectImgList.frame.origin.y + collectImgList.frame.size.height + ScreenUtils.heightFit(15) - collectImgList.layoutMargins.bottom
        } else {
            collectImgList.isHidden = true
            lContent.frame.origin.y = ivAvatar.frame.origin.y + ivAvatar.frame.size.height + ScreenUtils.heightFit(15)
        }
        // size
        lContent.frame.size.height = ViewUtils.getFontHeight(font: lContent.font, width: lContent.frame.width, text: lContent.text)
        scroll.contentSize.height = lContent.frame.origin.y + lContent.frame.size.height + ScreenUtils.heightFit(20)
    }
    
    @objc func targetGoEdit() {
        NoteDiaryEditVC.pushVC(diary: diary)
    }
    
    @objc func showDeleteAlert() {
        if diary == nil || !diary!.isMine() {
            ToastUtils.show(StringUtils.getString("can_operation_self_create_note"))
            return
        }
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_delete_this_note"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    self.delDiary()
        },
                                  cancelHandler: nil)
    }
    
    private func delDiary() {
        if diary == nil {
            return
        }
        // api
        let api = Api.request(.noteDiaryDel(did: diary!.id),
                              loading: true, cancel: true, success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_DIARY_LIST_ITEM_DELETE, obj: self.diary!)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
}
