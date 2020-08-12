//
//  TopicPostCommentDetailVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/5/1.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class TopicPostCommentDetailVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var marginSmall = margin / 2
    lazy var avatarWidth = ScreenUtils.widthFit(40)
    lazy var imgWidth = ScreenUtils.widthFit(15)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    
    // view
    private var barItemOriginal: UIBarButtonItem!
    private var barItemDel: UIBarButtonItem!
    private var tableView: UITableView!
    private var vHead: UIView!
    private var vCouple: UIView!
    private var ivAvatar: UIImageView!
    private var lName: UILabel!
    private var lFloor: UILabel!
    private var lTime: UILabel!
    private var lContent: UILabel!
    private var ivJabAvatar: UIImageView!
    private var vUser: UIView!
    private var vReport: UIView!
    private var ivReport: UIImageView!
    private var lReport: UILabel!
    private var vPoint: UIView!
    private var ivPoint: UIImageView!
    private var lPoint: UILabel!
    private var vGrey: UIView!
    private var vCommentSearch: UIView!
    private var btnCommentUser: UIButton!
    private var btnCommentSort: UIButton!
    private var ivComment: UIImageView!
    private var lComment: UILabel!
    
    // var
    private var postComment: PostComment?
    private var pcid: Int64 = 0
    private var postCommentList: [PostComment]?
    private var heightMap: [Int: CGFloat] = [Int: CGFloat]()
    private var page = 0
    private var orderIndex = 0
    
    public static func pushVC(postComment: PostComment? = nil, pcid: Int64 = 0) {
        AppDelegate.runOnMainAsync {
            let vc = TopicPostCommentDetailVC(nibName: nil, bundle: nil)
            vc.postComment = postComment
            vc.pcid = pcid
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "comment")
        barItemOriginal = UIBarButtonItem(title: StringUtils.getString("original_post"), style: .plain, target: self, action: #selector(targetGoOriginal))
        barItemOriginal.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        barItemDel = UIBarButtonItem(image: UIImage(named: "ic_delete_white_24dp"), style: .plain, target: self, action: #selector(showDeleteAlert))
        self.navigationItem.setRightBarButtonItems([barItemOriginal], animated: true)
        
        // avatar
        ivAvatar = ViewHelper.getImageViewAvatar(width: avatarWidth, height: avatarWidth)
        ivAvatar.frame.origin = CGPoint(x: 0, y: 0)
        
        // name
        let nameX = ivAvatar.frame.origin.x + ivAvatar.frame.size.width + margin
        let nameWidth = maxWidth - nameX
        lName = ViewHelper.getLabelBlackNormal(width: nameWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lName.frame.origin = CGPoint(x: nameX, y: ivAvatar.frame.origin.y)
        
        // floor
        lFloor = ViewHelper.getLabelGreySmall(text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lFloor.frame.origin = CGPoint(x: nameX, y: ivAvatar.frame.origin.y + ivAvatar.frame.size.height - lFloor.frame.size.height)
        
        // time
        let timeWidth = nameWidth - (lFloor.frame.size.width + margin)
        lTime = ViewHelper.getLabelGreySmall(width: timeWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lTime.frame.origin = CGPoint(x: lFloor.frame.origin.x + lFloor.frame.size.width + margin, y: lFloor.frame.origin.y)
        
        // couple
        vCouple = UIView(frame: CGRect(x: margin, y: margin * 2, width: maxWidth, height: avatarWidth))
        vCouple.addSubview(ivAvatar)
        vCouple.addSubview(lName)
        vCouple.addSubview(lFloor)
        vCouple.addSubview(lTime)
        
        // content
        lContent = ViewHelper.getLabelBlackBig(text: StringUtils.getString("jab_a_little"), lines: 0, align: .left)
        lContent.frame.origin.x = margin
        lContent.frame.origin.y = vCouple.isHidden ? vCouple.frame.origin.y : vCouple.frame.origin.y + vCouple.frame.size.height + margin
        
        // jabAvatar
        ivJabAvatar = ViewHelper.getImageViewAvatar(width: ScreenUtils.widthFit(20), height: ScreenUtils.widthFit(20))
        ivJabAvatar.frame.origin.x = lContent.frame.origin.x + lContent.frame.size.width + marginSmall
        ivJabAvatar.center.y = lContent.center.y
        
        lContent.frame.size.width = maxWidth // 投机取巧!
        
        // report
        ivReport = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_report_grey_18dp"), color: ColorHelper.getFontHint()), width: imgWidth, height: imgWidth, mode: .scaleAspectFit)
        ivReport.frame.origin.x = 0
        lReport = ViewHelper.getLabel(text: StringUtils.getString("report"), size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontHint(), lines: 1, align: .left, mode: .byTruncatingTail)
        lReport.frame.origin.x = ivReport.frame.origin.x + ivReport.frame.size.width + marginSmall
        
        vReport = UIView()
        vReport.frame.size.width = lReport.frame.origin.x + lReport.frame.size.width
        vReport.frame.size.height = CountHelper.getMax(ivReport.frame.size.height, lReport.frame.size.height) + margin * 2
        vReport.frame.origin.x = 0
        ivReport.center.y = vReport.frame.size.height / 2
        lReport.center.y = vReport.frame.size.height / 2
        vReport.addSubview(ivReport)
        vReport.addSubview(lReport)
        
        // point
        ivPoint = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_thumb_up_grey_18dp"), color: ColorHelper.getFontHint()), width: imgWidth, height: imgWidth, mode: .scaleAspectFit)
        ivPoint.frame.origin.x = margin * 2
        lPoint = ViewHelper.getLabel(text: "-", size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontHint(), lines: 1, align: .left, mode: .byTruncatingTail)
        lPoint.frame.origin.x = ivPoint.frame.origin.x + ivPoint.frame.size.width + margin
        
        vPoint = UIView()
        vPoint.frame.size.width = lPoint.frame.origin.x + lPoint.frame.size.width + ivPoint.frame.origin.x
        vPoint.frame.size.height = CountHelper.getMax(ivPoint.frame.size.height, lPoint.frame.size.height) + margin * 2
        vPoint.frame.origin.x = vReport.frame.origin.x + vReport.frame.size.width + margin * 2
        ivPoint.center.y = vPoint.frame.size.height / 2
        lPoint.center.y = vPoint.frame.size.height / 2
        vPoint.addSubview(ivPoint)
        vPoint.addSubview(lPoint)
        
        // user
        vUser = UIView(frame: CGRect(x: margin, y: lContent.frame.origin.y + lContent.frame.size.height, width: maxWidth, height: CountHelper.getMax(vReport.frame.size.height, vPoint.frame.size.height)))
        vReport.center.y = vUser.frame.size.height / 2
        vPoint.center.y = vUser.frame.size.height / 2
        vUser.addSubview(vReport)
        vUser.addSubview(vPoint)
        
        // grey
        vGrey = UIView()
        vGrey.frame.size = CGSize(width: screenWidth, height: margin)
        vGrey.frame.origin.x = 0
        vGrey.frame.origin.y = vUser.frame.origin.y + vUser.frame.size.height
        vGrey.backgroundColor = ColorHelper.getBackground()
        
        // commentUser
        btnCommentUser = ViewHelper.getBtnTextGrey(paddingH: margin, paddingV: margin, HAlign: .center, VAlign: .center, title: "-", titleSize: ViewHelper.FONT_SIZE_NORMAL, titleLines: 1, titleAlign: .center, titleMode: .byTruncatingMiddle)
        btnCommentUser.frame.origin.x = 0
        
        // commentSort
        btnCommentSort = ViewHelper.getBtnTextPrimary(paddingH: margin, paddingV: margin, HAlign: .center, VAlign: .center, title: "-", titleSize: ViewHelper.FONT_SIZE_NORMAL, titleLines: 1, titleAlign: .center, titleMode: .byTruncatingMiddle)
        btnCommentSort.frame.origin.x = screenWidth - btnCommentSort.frame.size.width
        
        // comment
        vCommentSearch = UIView()
        vCommentSearch.frame.size = CGSize(width: screenWidth, height: btnCommentUser.frame.size.height)
        vCommentSearch.frame.origin.x = 0
        vCommentSearch.frame.origin.y = vGrey.frame.origin.y + vGrey.frame.size.height
        vCommentSearch.addSubview(btnCommentUser)
        vCommentSearch.addSubview(btnCommentSort)
        
        // head
        vHead = UIView()
        vHead.frame.size = CGSize(width: screenWidth, height: vCommentSearch.frame.origin.y + vCommentSearch.frame.size.height)
        vHead.backgroundColor = ColorHelper.getWhite()
        vHead.addSubview(vCouple)
        vHead.addSubview(lContent)
        vHead.addSubview(ivJabAvatar)
        vHead.addSubview(vUser)
        vHead.addSubview(vGrey)
        vHead.addSubview(vCommentSearch)
        
        // tableView
        tableView = ViewUtils.getTableView(target: self, frame: self.view.bounds, cellCls: TopicPostCommentCell.self, id: TopicPostCommentCell.ID)
        initScrollState(scroll: tableView, clipTopBar: true, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: { self.refreshCommentData(more: false) },
                        canMore: true) { self.refreshCommentData(more: true) }
        tableView.tableHeaderView = vHead
        
        // jab
        let lJab = ViewHelper.getLabelGreySmall(text: StringUtils.getString("jab_ta"), lines: 1, align: .center, mode: .byTruncatingTail)
        let vJab = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth / 2, height: lJab.frame.size.height + margin * 2))
        lJab.center.x = vJab.frame.size.width / 2
        lJab.center.y = vJab.frame.size.height / 2
        vJab.addSubview(lJab)
        
        // comment
        lComment = ViewHelper.getLabelGreySmall(text: StringUtils.getString("comment"), lines: 1, align: .center, mode: .byTruncatingTail)
        ivComment = ViewHelper.getImageView(img: UIImage(named: "ic_insert_comment_grey_18dp"), width: lComment.frame.size.height, height: lComment.frame.size.height, mode: .scaleAspectFit)
        let vComment = UIView(frame: CGRect(x: screenWidth / 2, y: 0, width: screenWidth / 2, height: lComment.frame.size.height + margin * 2))
        
        ivComment.frame.origin = CGPoint(x: (vComment.frame.size.width - ivComment.frame.size.width - margin - lComment.frame.size.width) / 2, y: margin)
        lComment.frame.origin = CGPoint(x: ivComment.frame.origin.x + ivComment.frame.size.width + margin, y: margin)
        vComment.addSubview(ivComment)
        vComment.addSubview(lComment)
        
        // line
        let vLineTop = ViewHelper.getViewLine(width: screenWidth)
        vLineTop.frame.origin = CGPoint(x: 0, y: 0)
        let vLineCenter = ViewHelper.getViewLine(height: vJab.frame.size.height)
        vLineCenter.center.x = screenWidth / 2
        vLineCenter.frame.origin.y = 0
        
        // bottomBar
        let vBottomBar = UIView()
        vBottomBar.frame.size = CGSize(width: screenWidth, height: vJab.frame.size.height + ScreenUtils.getBottomNavHeight())
        vBottomBar.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height - RootVC.get().getTopBarHeight() - vBottomBar.frame.size.height)
        vBottomBar.backgroundColor = ColorHelper.getWhite()
        vBottomBar.addSubview(vJab)
        vBottomBar.addSubview(vComment)
        vBottomBar.addSubview(vLineTop)
        vBottomBar.addSubview(vLineCenter)
        
        tableView.frame.size.height -= vBottomBar.frame.size.height
        
        // view
        self.view.addSubview(tableView)
        self.view.addSubview(vBottomBar)
        
        // hide
        vCouple.isHidden = true
        ivJabAvatar.isHidden = true
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vReport, action: #selector(showReportAlert))
        ViewUtils.addViewTapTarget(target: self, view: vPoint, action: #selector(targetPoint))
        btnCommentSort.addTarget(self, action: #selector(showCommentSortAlert), for: .touchUpInside)
        ViewUtils.addViewTapTarget(target: self, view: vJab, action: #selector(targetJab))
        ViewUtils.addViewTapTarget(target: self, view: vComment, action: #selector(tagertGoAdd))
    }
    
    override func initData() {
        orderIndex = 0
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyListRefresh), name: NotifyHelper.TAG_POST_COMMENT_LIST_REFRESH)
        NotifyHelper.addObserver(self, selector: #selector(notifyDetailRefresh), name: NotifyHelper.TAG_POST_COMMENT_DETAIL_REFRESH)
        // init
        if postComment != nil {
            refreshHeadView()
            startScrollDataSet(scroll: tableView)
        } else if pcid > 0 {
            refreshPostCommentData(pcid: pcid, subComment: true)
        } else {
            RootVC.get().popBack()
        }
        // comment
        refreshCommentView()
    }
    
    @objc func notifyListRefresh(notify: NSNotification) {
        startScrollDataSet(scroll: tableView)
    }
    
    @objc func notifyDetailRefresh(notify: NSNotification) {
        if let pcid = notify.object as? Int64 {
            refreshPostCommentData(pcid: pcid, subComment: false)
        }
    }
    
    func refreshPostCommentData(pcid: Int64, subComment: Bool) {
        // api
        let api = Api.request(.topicPostCommentGet(pcid: pcid),
                              success: { (_, _, data) in
                                self.postComment = data.postComment
                                // view
                                self.refreshHeadView()
                                self.refreshCommentView()
                                // comment
                                if subComment {
                                    self.startScrollDataSet(scroll: self.tableView)
                                }
                                // event
                                NotifyHelper.post(NotifyHelper.TAG_POST_COMMENT_LIST_ITEM_REFRESH, obj: self.postComment)
        }, failure: nil)
        pushApi(api)
    }
    
    func refreshHeadView() {
        if postComment == nil {
            return
        }
        // menu
        self.refreshMenu()
        // top
        let couple = postComment!.couple
        var jabAvatar: String!
        if couple == nil {
            vCouple.isHidden = true
            jabAvatar = ""
        } else {
            vCouple.isHidden = false
            let jabId = (couple!.creatorId == postComment!.userId) ? couple!.inviteeId : couple!.creatorId
            jabAvatar = UserHelper.getAvatar(couple: couple, uid: jabId)
            KFHelper.setImgAvatarUrl(iv: ivAvatar, objKey: UserHelper.getAvatar(couple: couple, uid: postComment!.userId))
            lName.text = postComment!.official ? StringUtils.getString("administrators") : UserHelper.getName(couple: couple, uid: postComment!.userId, empty: true)
            lFloor.text = StringUtils.getString("holder_floor", arguments: [postComment!.floor])
            lTime.text = DateUtils.getStr(postComment!.createAt, DateUtils.FORMAT_LINE_M_D_H_M)
        }
        // center
        lContent.text = postComment!.contentText
        if postComment!.kind != PostComment.KIND_JAB {
            lContent.text = postComment!.contentText
            lContent.textColor = ColorHelper.getFontBlack()
            ivJabAvatar.isHidden = true
        } else {
            lContent.text = StringUtils.getString("jab_a_little")
            lContent.textColor = ThemeHelper.getColorPrimary()
            ivJabAvatar.isHidden = false
            KFHelper.setImgAvatarUrl(iv: ivJabAvatar, objKey: jabAvatar)
        }
        // bottom
        ivReport.image = ViewUtils.getImageWithTintColor(img: ivReport.image, color: postComment!.report ? ThemeHelper.getColorPrimary() : ColorHelper.getFontHint())
        ivPoint.image = ViewUtils.getImageWithTintColor(img: ivPoint.image, color: postComment!.point ? ThemeHelper.getColorPrimary() : ColorHelper.getFontHint())
        lPoint.text = ShowHelper.getShowCount2Thousand(postComment!.pointCount)
        // comment
        btnCommentUser.setTitle(StringUtils.getString("all_space_brackets_holder_brackets", arguments: [postComment!.subCommentCount]), for: .normal)
        refreshCommentOrderView()
        
        // size
        lFloor.frame.size.width = ViewUtils.getFontWidth(font: lFloor.font, text: lFloor.text)
        lTime.frame.size.width = vCouple.frame.size.width - (lFloor.frame.origin.x + lFloor.frame.size.width + margin)
        lTime.frame.origin.x = lFloor.frame.origin.x + lFloor.frame.size.width + margin
        lContent.frame.origin.y = vCouple.isHidden ? vCouple.frame.origin.y : vCouple.frame.origin.y + vCouple.frame.size.height + margin
        lContent.frame.size.height = ViewUtils.getFontHeight(font: lContent.font, width: lContent.frame.size.width, text: lContent.text)
        lPoint.frame.size.width = ViewUtils.getFontWidth(font: lPoint.font, text: lPoint.text)
        vPoint.frame.size.width = lPoint.frame.origin.x + lPoint.frame.size.width + ivPoint.frame.origin.x
        vUser.frame.origin.y = lContent.frame.origin.y + lContent.frame.size.height
        vGrey.frame.origin.y = vUser.frame.origin.y + vUser.frame.size.height
        btnCommentUser.frame.size.width = ViewUtils.getFontWidth(font: btnCommentUser.titleLabel?.font, text: btnCommentUser.title(for: .normal)) + margin * 2
        vCommentSearch.frame.origin.y = vGrey.frame.origin.y + vGrey.frame.size.height
        vHead.frame.size.height = vCommentSearch.frame.origin.y + vCommentSearch.frame.size.height
    }
    
    func refreshMenu() {
        if postComment == nil {
            return
        }
        var bars = [UIBarButtonItem]()
        if postComment!.mine {
            bars = [barItemOriginal, barItemDel]
        } else {
            bars = [barItemOriginal]
        }
        self.navigationItem.setRightBarButtonItems(bars, animated: true)
    }
    
    func refreshCommentOrderView() {
        if postComment == nil {
            return
        }
        if orderIndex >= 0 && orderIndex < ApiHelper.LIST_COMMENT_ORDER_SHOW.count {
            btnCommentSort.setTitle(ApiHelper.LIST_COMMENT_ORDER_SHOW[orderIndex], for: .normal)
        } else {
            btnCommentSort.setTitle("", for: .normal)
        }
        // size
        btnCommentSort.frame.size.width = ViewUtils.getFontWidth(font: btnCommentSort.titleLabel?.font, text: btnCommentSort.title(for: .normal)) + margin * 2
        btnCommentSort.frame.origin.x = screenWidth - btnCommentSort.frame.size.width
    }
    
    private func refreshCommentData(more: Bool) {
        if postComment == nil {
            return
        }
        page = more ? page + 1 : 0
        let orderType = ApiHelper.LIST_COMMENT_ORDER_TYPE[orderIndex]
        // api
        let api = Api.request(.topicPostCommentSubListGet(pid: postComment!.postId , tcid: postComment!.id, order: orderType, page: page),
                              success: { (_, _, data) in
                                self.refreshHeightMap(refresh: !more, start: self.postCommentList?.count ?? 0, dataList: data.postCommentList)
                                if !more {
                                    self.postCommentList = data.postCommentList
                                    self.endScrollDataRefresh(scroll: self.tableView, msg: data.show, count: data.postCommentList?.count ?? 0)
                                } else {
                                    self.postCommentList = (self.postCommentList ?? [PostComment]()) + (data.postCommentList ?? [PostComment]())
                                    self.endScrollDataMore(scroll: self.tableView, msg: data.show, count: data.postCommentList?.count ?? 0)
                                }
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.tableView, msg: msg)
        })
        pushApi(api)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postCommentList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getCellHeight(view: tableView, indexPath: indexPath, dataList: postCommentList)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let height = getCellHeight(view: tableView, indexPath: indexPath, dataList: postCommentList)
        return TopicPostCommentCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: postCommentList, height: height, subComment: true, target: self, actionReport: #selector(targetItemReport), actionPoint: #selector(targetItemPoint))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showItemDeleteAlert(indexPath: indexPath)
    }
    
    public func getCellHeight(view: UITableView, indexPath: IndexPath, dataList: [PostComment]?) -> CGFloat {
        // cache
        let row = indexPath.row
        let height = heightMap[row]
        if height != nil && height! > CGFloat(0) {
            return height!
        }
        // get
        if dataList == nil || dataList!.count <= row {
            return CGFloat(0)
        }
        let comment = dataList![row]
        return TopicPostCommentCell.getHeightByData(comment: comment)
    }
    
    public func refreshHeightMap(refresh: Bool, start: Int, dataList: [PostComment]?) {
        // clear
        var startIndex = start
        if refresh {
            heightMap.removeAll()
            startIndex = 0
        }
        // heightMap
        if dataList == nil || dataList!.count <= 0 {
            return
        }
        for (index, comment) in dataList!.enumerated() {
            let height = TopicPostCommentCell.getHeightByData(comment: comment)
            heightMap[index + startIndex] = height
        }
    }
    
    @objc func targetItemReport(sender: UIGestureRecognizer) {
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_report_this_comment"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    if let indexPath = ViewUtils.findTableIndexPath(view: sender.view) {
                                        self.reportPostComment(index: indexPath.row, api: true)
                                    }
        },
                                  cancelHandler: nil)
    }
    
    private func reportPostComment(index: Int, api: Bool) {
        if postCommentList == nil || postCommentList!.count <= index {
            return
        }
        let postComment = postCommentList![index]
        if postComment.report || postComment.official {
            return
        }
        postComment.report = true
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        if !api {
            return
        }
        let body = PostCommentReport()
        body.postCommentId = postComment.id
        // api
        let api = Api.request(.topicPostCommentReportAdd(postCommentReport: body.toJSON()),
                              success: nil, failure: { (_, msg, _) in
                                self.reportPostComment(index: index, api: false)
        })
        pushApi(api)
    }
    
    @objc func targetItemPoint(sender: UIGestureRecognizer) {
        if let indexPath = ViewUtils.findTableIndexPath(view: sender.view) {
            itemPoint(index: indexPath.row, api: true)
        }
    }
    
    func itemPoint(index: Int, api: Bool) {
        if postCommentList == nil || postCommentList!.count <= index {
            return
        }
        let postComment = postCommentList![index]
        let newPoint = !postComment.point
        var newPointCount = newPoint ? postComment.pointCount + 1 : postComment.pointCount - 1
        if newPointCount < 0 {
            newPointCount = 0
        }
        postComment.point = newPoint
        postComment.pointCount = newPointCount
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        if !api {
            return
        }
        let body = PostCommentPoint()
        body.postCommentId = postComment.id
        // api
        let api = Api.request(.topicPostCommentPointToggle(postCommentPoint: body.toJSON()),
                              success: nil, failure: { (_, msg, _) in
                                self.itemPoint(index: index, api: false)
        })
        pushApi(api)
    }
    
    @objc func showItemDeleteAlert(indexPath: IndexPath) {
        if postCommentList == nil || postCommentList!.count <= indexPath.row {
            return
        }
        let postComment = postCommentList![indexPath.row]
        if !postComment.mine {
            return
        }
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_del_this_comment"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    self.delItemPostComment(index: indexPath.row)
        },
                                  cancelHandler: nil)
    }
    
    private func delItemPostComment(index: Int) {
        if postCommentList == nil || postCommentList!.count <= index {
            return
        }
        let postComment = postCommentList![index]
        if !postComment.mine {
            return
        }
        // api
        let api = Api.request(.topicPostCommentDel(pcid: postComment.id),
                              loading: true, cancel: true, success: { (_, _, data) in
                                self.postCommentList!.remove(at: index)
                                self.refreshHeightMap(refresh: true, start: 0, dataList: self.postCommentList)
                                self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                                self.endScrollState(scroll: self.tableView, msg: nil)
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_POST_DETAIL_REFRESH, obj: postComment.postId)
                                NotifyHelper.post(NotifyHelper.TAG_POST_COMMENT_DETAIL_REFRESH, obj: postComment.toCommentId)
        }, failure: nil)
        pushApi(api)
    }
    
    func refreshCommentView() {
        if postComment == nil {
            return
        }
        ivComment.image = ViewUtils.getImageWithTintColor(img: ivComment.image, color: postComment!.subComment ? ThemeHelper.getColorPrimary() : ColorHelper.getIconGrey())
    }
    
    @objc func showReportAlert() {
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_report_this_comment"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    self.report(api: true)
        },
                                  cancelHandler: nil)
    }
    
    private func report(api: Bool) {
        if postComment == nil {
            return
        }
        postComment?.report = true
        postComment?.reportCount += 1
        refreshHeadView()
        if !api {
            return
        }
        let body = PostCommentReport()
        body.postCommentId = postComment!.id
        // api
        let api = Api.request(.topicPostCommentReportAdd(postCommentReport: body.toJSON()),
                              success: { (_, msg, _) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_POST_COMMENT_LIST_ITEM_REFRESH, obj: self.postComment)
        }, failure: { (_, msg, _) in
            self.report(api: false)
        })
        pushApi(api)
    }
    
    @objc func targetPoint() {
        point(api: true)
    }
    
    func point(api: Bool) {
        if postComment == nil {
            return
        }
        let newPoint = !postComment!.point
        var newPointCount = newPoint ? postComment!.pointCount + 1 : postComment!.pointCount - 1
        if newPointCount < 0 {
            newPointCount = 0
        }
        postComment?.point = newPoint
        postComment?.pointCount = newPointCount
        refreshHeadView()
        if !api {
            return
        }
        let body = PostCommentPoint()
        body.postCommentId = postComment!.id
        // api
        let api = Api.request(.topicPostCommentPointToggle(postCommentPoint: body.toJSON()),
                              success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_POST_COMMENT_LIST_ITEM_REFRESH, obj: self.postComment)
                                
        }, failure: { (_, msg, _) in
            self.point(api: false)
        })
        pushApi(api)
    }
    
    @objc func showCommentSortAlert() {
        _ = AlertHelper.showAlert(title: StringUtils.getString("select_order_type"),
                                  confirms: ApiHelper.LIST_COMMENT_ORDER_SHOW,
                                  cancel: StringUtils.getString("cancel"),
                                  canCancel: true,
                                  actionHandler: { (_, index, _) in
                                    self.orderIndex = Int(index)
                                    self.refreshCommentOrderView()
                                    self.refreshCommentData(more: false) // tableRefresh会置顶
        }, cancelHandler: nil)
    }
    
    
    @objc func targetJab() {
        if postComment == nil {
            return
        }
        let boy = ApiHelper.getPostCommentJabBody(pid: postComment!.postId, tcid: postComment!.id)
        // api
        let api = Api.request(.topicPostCommentAdd(postComment: boy.toJSON()),
                              success: { (_, _, data) in
                                self.postComment?.subComment = true
                                self.postComment?.subCommentCount += 1
                                self.refreshHeadView()
                                self.refreshCommentView()
                                self.refreshCommentData(more: false) // tableRefresh会置顶
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_POST_DETAIL_REFRESH, obj: self.postComment!.postId)
                                NotifyHelper.post(NotifyHelper.TAG_POST_COMMENT_LIST_ITEM_REFRESH, obj: self.postComment)
                                
        }, failure: nil)
        pushApi(api)
    }
    
    @objc func tagertGoAdd() {
        if postComment == nil || postComment!.postId == 0 {
            return
        }
        TopicPostCommentAddVC.pushVC(pid: postComment!.postId, tcid: postComment!.id)
    }
    
    @objc func targetGoOriginal() {
        if postComment == nil || postComment!.postId == 0 {
            return
        }
        TopicPostDetailVC.pushVC(pid: postComment!.postId)
    }
    
    @objc func showDeleteAlert() {
        if postComment == nil || !postComment!.mine {
            return
        }
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_del_this_comment"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    self.delPostComment()
        },
                                  cancelHandler: nil)
    }
    
    private func delPostComment() {
        if postComment == nil {
            return
        }
        // api
        let api = Api.request(.topicPostCommentDel(pcid: postComment?.id ?? pcid),
                              loading: true, cancel: true, success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_POST_DETAIL_REFRESH, obj: self.postComment!.postId)
                                NotifyHelper.post(NotifyHelper.TAG_POST_COMMENT_LIST_ITEM_DELETE, obj: self.postComment)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
}
