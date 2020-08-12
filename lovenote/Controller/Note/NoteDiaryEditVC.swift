//
//  NoteDiaryEditVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/2/27.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteDiaryEditVC: BaseVC, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    lazy var barVerticalMargin = ScreenUtils.heightFit(15)
    lazy var barIconMargin = ScreenUtils.widthFit(5)
    
    // view
    private var scroll: UIScrollView!
    private var tvContent: UITextView!
    private var collectImgList: UICollectionView!
    private var vHappenAt: UIView!
    private var lHappenAt: UILabel!
    
    // var
    private var diary: Diary?
    private var diaryOld: Diary!
    private var newImgDataList = [Data]()
    
    public static func pushVC(diary: Diary? = nil) {
        AppDelegate.runOnMainAsync {
            let vc = NoteDiaryEditVC(nibName: nil, bundle: nil)
            if diary == nil {
                vc.actFrom = ACT_EDIT_FROM_ADD
            } else {
                if diary!.isMine() {
                    vc.actFrom = ACT_EDIT_FROM_UPDATE
                    vc.diary = diary
                    // 需要拷贝可编辑的数据
                    vc.diaryOld = Diary()
                    vc.diaryOld.happenAt = diary!.happenAt
                    vc.diaryOld.contentText = diary!.contentText
                    vc.diaryOld.contentImageList = diary!.contentImageList
                } else {
                    ToastUtils.show(StringUtils.getString("can_operation_self_create_note"))
                    return
                }
            }
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "diary")
        let barItemCommit = UIBarButtonItem(title: StringUtils.getString("commit"), style: .plain, target: self, action: #selector(checkPush))
        let barItemDraft = UIBarButtonItem(title: StringUtils.getString("save_draft"), style: .plain, target: self, action: #selector(saveDraft))
        barItemCommit.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        barItemDraft.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        self.navigationItem.setRightBarButtonItems([barItemCommit, barItemDraft], animated: true)
        
        // content
        tvContent = ViewHelper.getTextView(width: maxWidth, height: ViewHelper.FONT_NORMAL_LINE_HEIGHT * 10, text: "", textSize: ViewHelper.FONT_SIZE_NORMAL, textColor: ColorHelper.getFontGrey(), placeholder: StringUtils.getString("please_input_content"), limitLength: UDHelper.getLimit().diaryContentLength)
        tvContent.frame.origin = CGPoint(x: margin, y: margin * 2)
        
        // imgList
        let layoutImgList = ImgSquareEditCell.getLayout(maxWidth: maxWidth)
        let marginImgList = layoutImgList.sectionInset
        let collectImgListWidth = maxWidth + marginImgList.left + marginImgList.right
        let collectImgListX = margin - marginImgList.left
        let collectImgListY = tvContent.frame.origin.y + tvContent.frame.size.height + ScreenUtils.heightFit(20) - marginImgList.top
        collectImgList = ViewUtils.getCollectionView(target: self, frame: CGRect(x: collectImgListX, y: collectImgListY, width: collectImgListWidth, height: 0), layout: layoutImgList, cellCls: ImgSquareEditCell.self, id: ImgSquareEditCell.ID)
        
        // happenAt
        let vLineHappenAt = ViewHelper.getViewLine(width: maxWidth)
        vLineHappenAt.frame.origin = CGPoint(x: margin, y: 0)
        lHappenAt = ViewHelper.getLabelGreyNormal(width: maxWidth, text: StringUtils.getString("time_colon_space_holder"), lines: 1, align: .left, mode: .byTruncatingMiddle)
        let ivHappenAt = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_access_time_grey_18dp"), color: ColorHelper.getFontGrey()), width: lHappenAt.frame.size.height, height: lHappenAt.frame.size.height, mode: .scaleAspectFit)
        ivHappenAt.frame.origin = CGPoint(x: margin, y: barVerticalMargin)
        lHappenAt.frame.size.width = screenWidth - ivHappenAt.frame.origin.x - ivHappenAt.frame.size.width - barIconMargin - margin
        lHappenAt.frame.origin = CGPoint(x: ivHappenAt.frame.origin.x + ivHappenAt.frame.size.width + barIconMargin, y: barVerticalMargin)
        vHappenAt = UIView(frame: CGRect(x: 0, y: tvContent.frame.origin.y + tvContent.frame.size.height + ScreenUtils.heightFit(30), width: screenWidth, height: ivHappenAt.frame.size.height + barVerticalMargin * 2))
        
        vHappenAt.addSubview(vLineHappenAt)
        vHappenAt.addSubview(ivHappenAt)
        vHappenAt.addSubview(lHappenAt)
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = vHappenAt.frame.origin.y + self.view.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
        scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        
        scroll.addSubview(tvContent)
        scroll.addSubview(collectImgList)
        scroll.addSubview(vHappenAt)
        
        // view
        self.view.backgroundColor = ColorHelper.getWhite()
        self.view.addSubview(scroll)
        
        // hide
        collectImgList.isHidden = true
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vHappenAt, action: #selector(showDatePicker))
    }
    
    override func initData() {
        // init
        if !isFromUpdate() {
            diary = UDHelper.getDraftDiary()
        }
        if diary == nil {
            diary = Diary()
        }
        if diary?.happenAt == 0 {
            diary?.happenAt = DateUtils.getCurrentInt64()
        }
        // content
        ExtensionTextView.setTextViewTextWithPlaceholder(tvContent, text: diary?.contentText)
        // imgList
        let limitImagesCount = UDHelper.getVipLimit().diaryImageCount
        if isFromUpdate() {
            // 编辑
            if diary!.contentImageList.count <= 0 {
                // 旧数据没有图片
                setCollectImgListView(hidden: limitImagesCount <= 0, childCount: limitImagesCount)
            } else {
                // 旧数据有图片
                let imgCount = CountHelper.getMax(limitImagesCount, diary!.contentImageList.count)
                setCollectImgListView(hidden: imgCount <= 0, childCount: imgCount)
            }
        } else {
            // 添加
            setCollectImgListView(hidden: limitImagesCount <= 0, childCount: limitImagesCount)
        }
        // date
        refreshDateView()
    }
    
    override func canPop() -> Bool {
        // 更新，返还原来的值
        if isFromUpdate() {
            diary?.happenAt = diaryOld.happenAt
            diary?.contentText = diaryOld.contentText
            diary?.contentImageList = diaryOld.contentImageList
            return true
        }
        // 没有数据
        if diary == nil || StringUtils.isEmpty(tvContent.text) {
            return true
        }
        // 相同数据
        let draft = UDHelper.getDraftDiary()
        if draft != nil && draft?.contentText == tvContent.text {
            return true
        }
        // 草稿询问
        _ = AlertHelper.showAlert(title: StringUtils.getString("is_save_draft"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("save_draft")],
                                  cancel: StringUtils.getString("cancel"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    self.saveDraft(exit: true)
        },
                                  cancelHandler: { (_) in
                                    RootVC.get().popBack()
        })
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImgSquareEditCell.getNumberOfItems(oldOssKeyList: diary?.contentImageList, newImgDataList: newImgDataList,
                                                  limit: UDHelper.getVipLimit().diaryImageCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return ImgSquareEditCell.getCellWithData(view: collectionView, indexPath: indexPath,
                                                 oldOssKeyList: diary?.contentImageList, newImgDataList: newImgDataList,
                                                 limit: UDHelper.getVipLimit().diaryImageCount, target: self,
                                                 actionGoBig: #selector(targrtGoBigImg), actionAdd: #selector(targrtAdd), actionDel: #selector(targrtDel))
    }
    
    @objc func targrtGoBigImg(sender: UIGestureRecognizer) {
        ImgSquareEditCell.goBigImg(view: sender.view, oldOssKeyList: diary?.contentImageList, newImgDataList: newImgDataList)
    }
    
    @objc func targrtAdd(sender: UIButton) {
        ImgSquareEditCell.goAddImg(view: sender, oldOssKeyList: diary?.contentImageList, newImgDataList: newImgDataList,
                                   limit: UDHelper.getVipLimit().diaryImageCount, gif: true, compress: false, crop: false,
                                   dataChange: { (datas) in
                                    self.newImgDataList = datas
        },
                                   complete: { () in
                                    self.vHappenAt.frame.origin.y = self.collectImgList.frame.origin.y + self.collectImgList.frame.size.height + ScreenUtils.heightFit(30)
                                    self.scroll.contentSize.height = self.vHappenAt.frame.origin.y + self.view.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
        })
    }
    
    @objc func targrtDel(sender: UIButton) {
        ImgSquareEditCell.showDelAlert(sender: sender, oldOssKeyList: diary?.contentImageList, newImgDataList: newImgDataList,
                                       limit: UDHelper.getVipLimit().diaryImageCount,
                                       dataChange: { (keys, datas) in
                                        self.diary?.contentImageList = keys
                                        self.newImgDataList = datas
        },
                                       complete: { () in
                                        self.vHappenAt.frame.origin.y = self.collectImgList.frame.origin.y + self.collectImgList.frame.size.height + ScreenUtils.heightFit(30)
                                        self.scroll.contentSize.height = self.vHappenAt.frame.origin.y + self.view.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
        })
    }
    
    func isFromUpdate() -> Bool {
        return actFrom == BaseVC.ACT_EDIT_FROM_UPDATE
    }
    
    func setCollectImgListView(hidden: Bool = true, childCount: Int = 0) {
        if hidden {
            collectImgList.isHidden = true
            vHappenAt.frame.origin.y = tvContent.frame.origin.y + tvContent.frame.size.height + ScreenUtils.heightFit(30)
            scroll.contentSize.height = vHappenAt.frame.origin.y + self.view.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
            return
        }
        collectImgList.isHidden = false
        // size
        collectImgList.frame.size.height = ImgSquareEditCell.getCollectHeight(collect: collectImgList, oldOssKeyList: diary?.contentImageList, newImgDataList: newImgDataList, limit: UDHelper.getVipLimit().diaryImageCount)
        collectImgList.reloadData()
        vHappenAt.frame.origin.y = collectImgList.frame.origin.y + collectImgList.frame.size.height + ScreenUtils.heightFit(30)
        scroll.contentSize.height = vHappenAt.frame.origin.y + self.view.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
    }
    
    @objc func showDatePicker() {
        AlertHelper.showDateTimePicker(date: diary?.happenAt, actionHandler: { (_, _, _, picker) in
            self.diary?.happenAt = DateUtils.getInt64(picker.date)
            self.refreshDateView()
        }, cancelHandler: nil)
    }
    
    func refreshDateView() {
        let happen = TimeHelper.getTimeShowLine_HM_MD_YMD_ByGo(diary?.happenAt ?? DateUtils.getCurrentInt64())
        lHappenAt.text = StringUtils.getString("time_colon_space_holder", arguments: [happen])
    }
    
    @objc func saveDraft(exit: Bool = false) {
        diary?.contentText = tvContent.text
        UDHelper.setDraftDiary(diary)
        ToastUtils.show(StringUtils.getString("draft_save_success"))
        if exit {
            RootVC.get().popBack()
        }
    }
    
    @objc func checkPush() {
        if diary == nil {
            return
        }
        if newImgDataList.count > 0 {
            ossUploadImages(datas: newImgDataList)
        } else {
            checkApi()
        }
    }
    
    func ossUploadImages(datas: [Data]?) {
        if diary == nil {
            return
        }
        OssHelper.uploadDiary(dataList: datas, success: { (_, _, successList) in
            self.diary?.contentImageList += successList
            self.checkApi()
        }, failure: nil)
    }
    
    func checkApi() {
        diary?.contentText = tvContent.text
        if isFromUpdate() {
            updateApi()
        } else {
            addApi()
        }
    }
    
    func updateApi() {
        if diary == nil {
            return
        }
        let api = Api.request(.noteDiaryUpdate(diary: diary?.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                let diary = data.diary
                                NotifyHelper.post(NotifyHelper.TAG_DIARY_LIST_ITEM_REFRESH, obj: diary)
                                NotifyHelper.post(NotifyHelper.TAG_DIARY_DETAIL_REFRESH, obj: diary)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
    func addApi() {
        if diary == nil {
            return
        }
        let api = Api.request(.noteDiaryAdd(diary: diary?.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_DIARY_LIST_REFRESH, obj: nil)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
}
