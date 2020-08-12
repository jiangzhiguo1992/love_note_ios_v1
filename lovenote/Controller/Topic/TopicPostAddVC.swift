//
//  TopicPostAddVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/5/2.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class TopicPostAddVC: BaseVC, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    lazy var barVerticalMargin = ScreenUtils.heightFit(15)
    lazy var barIconMargin = ScreenUtils.widthFit(5)
    
    // view
    private var scroll: UIScrollView!
    private var tfTitle: UITextField!
    private var tvContent: UITextView!
    private var collectImgList: UICollectionView!
    private var vKind: UIView!
    private var lKind: UILabel!
    
    // var
    lazy var post = Post()
    private var newImgDataList = [Data]()
    public static func pushVC(kind: Int = 0, subKind: Int = 0) {
        if UserHelper.isCoupleBreak(couple: UDHelper.getCouple()) {
            CouplePairVC.pushVC()
            return
        }
        AppDelegate.runOnMainAsync {
            let vc = TopicPostAddVC(nibName: nil, bundle: nil)
            vc.post.kind = kind
            vc.post.subKind = subKind
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "post")
        let barItemCommit = UIBarButtonItem(title: StringUtils.getString("commit"), style: .plain, target: self, action: #selector(checkPush))
        let barItemDraft = UIBarButtonItem(title: StringUtils.getString("save_draft"), style: .plain, target: self, action: #selector(saveDraft))
        barItemCommit.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        barItemDraft.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        self.navigationItem.setRightBarButtonItems([barItemCommit, barItemDraft], animated: true)
        
        // title
        tfTitle = ViewHelper.getTextField(width: maxWidth, paddingV: ScreenUtils.heightFit(10), textSize: ViewHelper.FONT_SIZE_NORMAL, textColor: ColorHelper.getFontGrey(), placeholder: StringUtils.getString("please_input_title"), placeColor: ColorHelper.getFontHint())
        tfTitle.frame.origin = CGPoint(x: margin, y: margin * 2)
        
        // content
        tvContent = ViewHelper.getTextView(width: maxWidth, height: ViewHelper.FONT_NORMAL_LINE_HEIGHT * 10, text: "", textSize: ViewHelper.FONT_SIZE_NORMAL, textColor: ColorHelper.getFontGrey(), placeholder: StringUtils.getString("please_input_content"), limitLength: UDHelper.getLimit().foodContentLength)
        tvContent.frame.origin = CGPoint(x: margin, y: tfTitle.frame.origin.y + tfTitle.frame.size.height + margin * 2)
        
        // imgList
        let layoutImgList = ImgSquareEditCell.getLayout(maxWidth: maxWidth)
        let marginImgList = layoutImgList.sectionInset
        let collectImgListWidth = maxWidth + marginImgList.left + marginImgList.right
        let collectImgListX = margin - marginImgList.left
        let collectImgListY = tvContent.frame.origin.y + tvContent.frame.size.height + ScreenUtils.heightFit(20) - marginImgList.top
        collectImgList = ViewUtils.getCollectionView(target: self, frame: CGRect(x: collectImgListX, y: collectImgListY, width: collectImgListWidth, height: 0), layout: layoutImgList, cellCls: ImgSquareEditCell.self, id: ImgSquareEditCell.ID)
        
        // kind
        let vLineKind = ViewHelper.getViewLine(width: maxWidth)
        vLineKind.frame.origin = CGPoint(x: margin, y: 0)
        lKind = ViewHelper.getLabelGreyNormal(width: maxWidth, text: StringUtils.getString("time_colon_space_holder"), lines: 1, align: .left, mode: .byTruncatingMiddle)
        let ivKind = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_access_time_grey_18dp"), color: ColorHelper.getFontGrey()), width: lKind.frame.size.height, height: lKind.frame.size.height, mode: .scaleAspectFit)
        ivKind.frame.origin = CGPoint(x: margin, y: barVerticalMargin)
        lKind.frame.size.width = screenWidth - ivKind.frame.origin.x - ivKind.frame.size.width - barIconMargin - margin
        lKind.frame.origin = CGPoint(x: ivKind.frame.origin.x + ivKind.frame.size.width + barIconMargin, y: barVerticalMargin)
        vKind = UIView(frame: CGRect(x: 0, y: collectImgList.frame.origin.y + collectImgList.frame.size.height + ScreenUtils.heightFit(30), width: screenWidth, height: ivKind.frame.size.height + barVerticalMargin * 2))
        
        vKind.addSubview(vLineKind)
        vKind.addSubview(ivKind)
        vKind.addSubview(lKind)
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = vKind.frame.origin.y + self.view.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
        scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        
        scroll.addSubview(tfTitle)
        scroll.addSubview(tvContent)
        scroll.addSubview(collectImgList)
        scroll.addSubview(vKind)
        
        // view
        self.view.backgroundColor = ColorHelper.getWhite()
        self.view.addSubview(scroll)
        
        // hide
        collectImgList.isHidden = true
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vKind, action: #selector(showKindPicker))
    }
    
    override func initData() {
        // init
        if UDHelper.getDraftPost() != nil {
            let kind = post.kind
            let subKind = post.subKind
            post = UDHelper.getDraftPost()!
            post.kind = kind
            post.subKind = subKind
        }
        // title
        let placeholder = StringUtils.getString("please_input_title_no_over_holder_text", arguments: [UDHelper.getLimit().postTitleLength])
        ViewUtils.setTextFiledPlaceholder(textField: tfTitle, placeholder: placeholder)
        tfTitle.text = post.title
        // content
        ExtensionTextView.setTextViewTextWithPlaceholder(tvContent, text: post.contentText)
        // imgList
        let limitImagesCount = UDHelper.getVipLimit().topicPostImageCount
        if limitImagesCount <= 0 {
            collectImgList.isHidden = true
            vKind.frame.origin.y = tvContent.frame.origin.y + tvContent.frame.size.height + ScreenUtils.heightFit(30)
            scroll.contentSize.height = vKind.frame.origin.y + view.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
            return
        } else {
            collectImgList.isHidden = false
            collectImgList.frame.size.height = ImgSquareEditCell.getCollectHeight(collect: collectImgList, oldOssKeyList: post.contentImageList, newImgDataList: newImgDataList, limit: limitImagesCount)
            vKind.frame.origin.y = collectImgList.frame.origin.y + collectImgList.frame.size.height + ScreenUtils.heightFit(30)
            scroll.contentSize.height = vKind.frame.origin.y + view.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
        }
        // kind
        refreshKindView(kind: post.kind, subKind: post.subKind)
    }
    
    override func canPop() -> Bool {
        // 没有数据
        if StringUtils.isEmpty(tvContent.text) {
            return true
        }
        // 相同数据
        let draft = UDHelper.getDraftPost()
        if draft != nil && post.contentText == tvContent.text {
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
        return ImgSquareEditCell.getNumberOfItems(oldOssKeyList: post.contentImageList, newImgDataList: newImgDataList,
                                                  limit: UDHelper.getVipLimit().topicPostImageCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return ImgSquareEditCell.getCellWithData(view: collectionView, indexPath: indexPath,
                                                 oldOssKeyList: post.contentImageList, newImgDataList: newImgDataList,
                                                 limit: UDHelper.getVipLimit().topicPostImageCount, target: self,
                                                 actionGoBig: #selector(targrtGoBigImg), actionAdd: #selector(targrtAdd), actionDel: #selector(targrtDel))
    }
    
    @objc func targrtGoBigImg(sender: UIGestureRecognizer) {
        ImgSquareEditCell.goBigImg(view: sender.view, oldOssKeyList: post.contentImageList, newImgDataList: newImgDataList)
    }
    
    @objc func targrtAdd(sender: UIButton) {
        ImgSquareEditCell.goAddImg(view: sender, oldOssKeyList: post.contentImageList, newImgDataList: newImgDataList,
                                   limit: UDHelper.getVipLimit().topicPostImageCount, gif: true, compress: true, crop: false,
                                   dataChange: { (datas) in
                                    self.newImgDataList = datas
        },
                                   complete: { () in
                                    self.vKind.frame.origin.y = self.collectImgList.frame.origin.y + self.collectImgList.frame.size.height + ScreenUtils.heightFit(30)
                                    self.scroll.contentSize.height = self.vKind.frame.origin.y + self.view.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
        })
    }
    
    @objc func targrtDel(sender: UIButton) {
        ImgSquareEditCell.showDelAlert(sender: sender, oldOssKeyList: post.contentImageList, newImgDataList: newImgDataList,
                                       limit: UDHelper.getVipLimit().topicPostImageCount,
                                       dataChange: { (keys, datas) in
                                        self.post.contentImageList = keys
                                        self.newImgDataList = datas
        },
                                       complete: { () in
                                        self.vKind.frame.origin.y = self.collectImgList.frame.origin.y + self.collectImgList.frame.size.height + ScreenUtils.heightFit(30)
                                        self.scroll.contentSize.height = self.vKind.frame.origin.y + self.view.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
        })
    }
    
    @objc func showKindPicker() {
        let nameList = ListHelper.getPostKindInfoListEnableShow()
        _ = AlertHelper.showAlert(title: StringUtils.getString("please_select_classify"),
                                  confirms: nameList,
                                  cancel: StringUtils.getString("cancel"),
                                  canCancel: true,
                                  actionHandler: { (_, index, _) in
                                    let kindList = ListHelper.getPostKindInfoListEnable()
                                    if index < 0 || index >= kindList.count {
                                        return
                                    }
                                    self.showSubKindPicker(kindInfo: kindList[Int(index)])
        }, cancelHandler: nil)
    }
    
    func showSubKindPicker(kindInfo: PostKindInfo) {
        let subKindPushShowList = ListHelper.getPostSubKindInfoListPushShow(kindInfo: kindInfo)
        _ = AlertHelper.showAlert(title: StringUtils.getString("please_select_classify"),
                                  confirms: subKindPushShowList,
                                  cancel: StringUtils.getString("cancel"),
                                  canCancel: true,
                                  actionHandler: { (_, index, _) in
                                    let subKindPushList = ListHelper.getPostSubKindInfoListPush(kindInfo: kindInfo)
                                    if index < 0 || index >= subKindPushList.count {
                                        return
                                    }
                                    let subKindInfo = subKindPushList[Int(index)]
                                    self.refreshKindView(kind: kindInfo.kind, subKind: subKindInfo.kind)
        }, cancelHandler: nil)
    }
    
    func refreshKindView(kind: Int, subKind: Int) {
        var kindInfo = ListHelper.getPostKindInfo(kind: kind)
        var subKindInfo = ListHelper.getPostSubKindInfo(kindInfo: kindInfo, subKind: subKind)
        // kind
        if kindInfo == nil {
            let kindList = ListHelper.getPostKindInfoListEnable()
            if kindList.count > 0 {
                kindInfo = kindList[0]
            }
            if kindInfo == nil {
                RootVC.get().popBack()
                return
            }
        }
        // subKind
        if subKindInfo == nil || !subKindInfo!.push {
            let subKindPushList = ListHelper.getPostSubKindInfoListPush(kindInfo: kindInfo)
            if subKindPushList.count > 0 {
                subKindInfo = subKindPushList[0]
            }
            if subKindInfo == nil {
                RootVC.get().popBack()
                return
            }
        }
        // data
        post.kind = kindInfo!.kind
        post.subKind = subKindInfo!.kind
        // view
        let kindShow = StringUtils.getString("holder_space_line_space_holder", arguments: [kindInfo!.name, subKindInfo!.name])
        lKind.text = StringUtils.getString("type_colon_space_holder", arguments: [kindShow])
    }
    
    @objc func saveDraft(exit: Bool = false) {
        post.title = tfTitle.text ?? ""
        post.contentText = tvContent.text
        UDHelper.setDraftPost(post)
        ToastUtils.show(StringUtils.getString("draft_save_success"))
        if exit {
            RootVC.get().popBack()
        }
    }
    
    @objc func checkPush() {
        // title
        if StringUtils.isEmpty(tfTitle.text) {
            ToastUtils.show(tfTitle.placeholder)
            return
        } else if (tfTitle.text?.count ?? 0) > UDHelper.getLimit().postTitleLength {
            ToastUtils.show(tfTitle.placeholder)
            return
        } else if StringUtils.isEmpty(tvContent.text) {
            ToastUtils.show(tvContent.placeholder)
            return
        }
        post.title = tfTitle.text ?? ""
        post.contentText = tvContent.text
        // img
        if newImgDataList.count > 0 {
            ossUploadImages(datas: newImgDataList)
        } else {
            addApi()
        }
    }
    
    func ossUploadImages(datas: [Data]?) {
        OssHelper.uploadTopicPost(dataList: datas, success: { (_, _, successList) in
            self.post.contentImageList += successList
            self.addApi()
        }, failure: nil)
    }
    
    func addApi() {
        // api
        let api = Api.request(.topicPostAdd(post: post.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_POST_LIST_REFRESH, obj: self.post)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
}
