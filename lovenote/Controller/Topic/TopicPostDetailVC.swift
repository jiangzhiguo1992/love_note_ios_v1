//
//  TopicPostDetailVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/30.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class TopicPostDetailVC: BaseVC, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var avatarWidth = ScreenUtils.widthFit(40)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    
    // view
    private var barItemReport: UIBarButtonItem!
    private var barItemDel: UIBarButtonItem!
    private var tableView: UITableView!
    private var vHead: UIView!
    private var vCouple: UIView!
    private var ivAvatar: UIImageView!
    private var lName: UILabel!
    private var lTime: UILabel!
    private var lTitle: UILabel!
    private var vTag: UIView!
    private var lContent: UILabel!
    private var collectImgList: UICollectionView!
    private var vGrey: UIView!
    private var vCommentSearch: UIView!
    private var btnCommentUser: UIButton!
    private var btnCommentSort: UIButton!
    private var ivCollect: UIImageView!
    private var lCollect: UILabel!
    private var ivPoint: UIImageView!
    private var lPoint: UILabel!
    private var ivComment: UIImageView!
    private var lComment: UILabel!
    
    // var
    private var post: Post?
    private var pid: Int64 = 0
    private var imgTop = CGFloat(0)
    private var imgBottom = CGFloat(0)
    private var postCommentList: [PostComment]?
    private var heightMap: [Int: CGFloat] = [Int: CGFloat]()
    private var page = 0
    private var orderIndex = 0
    private var searchUserId: Int64 = 0
    
    public static func pushVC(post: Post? = nil, pid: Int64 = 0) {
        AppDelegate.runOnMainAsync {
            let vc = TopicPostDetailVC(nibName: nil, bundle: nil)
            vc.post = post
            vc.pid = pid
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "post")
        barItemReport = UIBarButtonItem(title: StringUtils.getString("report"), style: .plain, target: self, action: #selector(showReportAlert))
        barItemReport.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        barItemDel = UIBarButtonItem(image: UIImage(named: "ic_delete_white_24dp"), style: .plain, target: self, action: #selector(showDeleteAlert))
        self.navigationItem.setRightBarButtonItems([], animated: true)
        
        // avatar
        ivAvatar = ViewHelper.getImageViewAvatar(width: avatarWidth, height: avatarWidth)
        ivAvatar.frame.origin = CGPoint(x: 0, y: 0)
        let shadowAvatar = ViewUtils.getViewShadow(ivAvatar, bgColor: ColorHelper.getWhite(), offset: ViewHelper.SHADOW_NORMAL)
        
        // name
        let nameX = ivAvatar.frame.origin.x + ivAvatar.frame.size.width + margin
        let nameWidth = maxWidth - nameX
        lName = ViewHelper.getLabelBlackNormal(width: nameWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lName.frame.origin = CGPoint(x: nameX, y: ivAvatar.frame.origin.y)
        
        // time
        lTime = ViewHelper.getLabelGreySmall(width: nameWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lTime.frame.origin = CGPoint(x: nameX, y: ivAvatar.frame.origin.y + ivAvatar.frame.size.height - lTime.frame.size.height)
        
        // couple
        vCouple = UIView(frame: CGRect(x: margin, y: margin * 2, width: maxWidth, height: avatarWidth))
        vCouple.addSubview(shadowAvatar)
        vCouple.addSubview(ivAvatar)
        vCouple.addSubview(lName)
        vCouple.addSubview(lTime)
        
        // title
        lTitle = ViewHelper.getLabelBold(width: maxWidth, text: "-", size: ViewHelper.FONT_SIZE_BIG, color: ColorHelper.getFontBlack(), lines: 0, align: .left)
        lTitle.frame.origin.x = margin
        lTitle.frame.origin.y = vCouple.isHidden ? vCouple.frame.origin.y : vCouple.frame.origin.y + vCouple.frame.size.height + ScreenUtils.heightFit(15)
        
        // tag
        vTag = UIView()
        vTag.frame.size = CGSize(width: maxWidth, height: 0)
        vTag.frame.origin.x = margin
        vTag.frame.origin.y = lTitle.isHidden ? lTitle.frame.origin.y : lTitle.frame.origin.y + lTitle.frame.size.height + margin
        
        // content
        lContent = ViewHelper.getLabelGreyNormal(width: maxWidth, text: "-", lines: 0, align: .left)
        lContent.frame.origin.x = margin
        lContent.frame.origin.y = vTag.isHidden ? vTag.frame.origin.y : vTag.frame.origin.y + vTag.frame.size.height + margin
        
        // imgList
        let layoutImgList = ImgSquareShowCell.getLayout(maxWidth: maxWidth, spanCount: 1)
        let marginImgList = layoutImgList.sectionInset
        imgTop = marginImgList.top
        imgBottom = marginImgList.bottom
        let collectImgListWidth = maxWidth + marginImgList.left + marginImgList.right
        let collectImgListX = margin - marginImgList.left
        let collectImgListY = (lContent.isHidden ? lContent.frame.origin.y : lContent.frame.origin.y + lContent.frame.size.height + margin) - imgTop
        collectImgList = ViewUtils.getCollectionView(target: self, frame: CGRect(x: collectImgListX, y: collectImgListY, width: collectImgListWidth, height: 0), layout: layoutImgList, cellCls: ImgSquareShowCell.self, id: ImgSquareShowCell.ID)
        
        // grey
        vGrey = UIView()
        vGrey.frame.size = CGSize(width: screenWidth, height: margin)
        vGrey.frame.origin.x = 0
        vGrey.frame.origin.y = collectImgList.isHidden ? collectImgList.frame.origin.y : collectImgList.frame.origin.y + collectImgList.frame.size.height + margin - imgBottom
        vGrey.backgroundColor = ColorHelper.getBackground()
        
        // commentUser
        btnCommentUser = ViewHelper.getBtnTextPrimary(paddingH: margin, paddingV: margin, HAlign: .center, VAlign: .center, title: "-", titleSize: ViewHelper.FONT_SIZE_NORMAL, titleLines: 1, titleAlign: .center, titleMode: .byTruncatingMiddle)
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
        vHead.addSubview(lTitle)
        vHead.addSubview(vTag)
        vHead.addSubview(lContent)
        vHead.addSubview(collectImgList)
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
        let vJab = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth / 4, height: lJab.frame.size.height + margin * 2))
        lJab.center.x = vJab.frame.size.width / 2
        lJab.center.y = vJab.frame.size.height / 2
        vJab.addSubview(lJab)
        
        // collect
        lCollect = ViewHelper.getLabelGreySmall(text: "-", lines: 1, align: .center, mode: .byTruncatingTail)
        ivCollect = ViewHelper.getImageView(img: UIImage(named: "ic_favorite_grey_18dp"), width: lCollect.frame.size.height, height: lCollect.frame.size.height, mode: .scaleAspectFit)
        let vCollect = UIView(frame: CGRect(x: screenWidth / 4 * 1, y: 0, width: screenWidth / 4, height: lCollect.frame.size.height + margin * 2))
        
        ivCollect.frame.origin = CGPoint(x: (vCollect.frame.size.width - ivCollect.frame.size.width - margin - lCollect.frame.size.width) / 2, y: margin)
        lCollect.frame.origin = CGPoint(x: ivCollect.frame.origin.x + ivCollect.frame.size.width + margin, y: margin)
        vCollect.addSubview(ivCollect)
        vCollect.addSubview(lCollect)
        
        // point
        lPoint = ViewHelper.getLabelGreySmall(text: "-", lines: 1, align: .center, mode: .byTruncatingTail)
        ivPoint = ViewHelper.getImageView(img: UIImage(named: "ic_thumb_up_grey_18dp"), width: lPoint.frame.size.height, height: lPoint.frame.size.height, mode: .scaleAspectFit)
        let vPoint = UIView(frame: CGRect(x: screenWidth / 2, y: 0, width: screenWidth / 4, height: lPoint.frame.size.height + margin * 2))
        
        ivPoint.frame.origin = CGPoint(x: (vPoint.frame.size.width - ivPoint.frame.size.width - margin - lPoint.frame.size.width) / 2, y: margin)
        lPoint.frame.origin = CGPoint(x: ivPoint.frame.origin.x + ivPoint.frame.size.width + margin, y: margin)
        vPoint.addSubview(ivPoint)
        vPoint.addSubview(lPoint)
        
        // comment
        lComment = ViewHelper.getLabelGreySmall(text: "-", lines: 1, align: .center, mode: .byTruncatingTail)
        ivComment = ViewHelper.getImageView(img: UIImage(named: "ic_insert_comment_grey_18dp"), width: lComment.frame.size.height, height: lComment.frame.size.height, mode: .scaleAspectFit)
        let vComment = UIView(frame: CGRect(x: screenWidth / 4 * 3, y: 0, width: screenWidth / 4, height: lComment.frame.size.height + margin * 2))
        
        ivComment.frame.origin = CGPoint(x: (vComment.frame.size.width - ivComment.frame.size.width - margin - lComment.frame.size.width) / 2, y: margin)
        lComment.frame.origin = CGPoint(x: ivComment.frame.origin.x + ivComment.frame.size.width + margin, y: margin)
        vComment.addSubview(ivComment)
        vComment.addSubview(lComment)
        
        // line
        let vLineTop = ViewHelper.getViewLine(width: screenWidth)
        vLineTop.frame.origin = CGPoint(x: 0, y: 0)
        let vLineLeft = ViewHelper.getViewLine(height: vJab.frame.size.height)
        vLineLeft.center.x = screenWidth / 4
        vLineLeft.frame.origin.y = 0
        let vLineCenter = ViewHelper.getViewLine(height: vJab.frame.size.height)
        vLineCenter.center.x = screenWidth / 2
        vLineCenter.frame.origin.y = 0
        let vLineRight = ViewHelper.getViewLine(height: vJab.frame.size.height)
        vLineRight.center.x = screenWidth / 4 * 3
        vLineRight.frame.origin.y = 0
        
        // bottomBar
        let vBottomBar = UIView()
        vBottomBar.frame.size = CGSize(width: screenWidth, height: vJab.frame.size.height + ScreenUtils.getBottomNavHeight())
        vBottomBar.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height - RootVC.get().getTopBarHeight() - vBottomBar.frame.size.height)
        vBottomBar.backgroundColor = ColorHelper.getWhite()
        
        vBottomBar.addSubview(vJab)
        vBottomBar.addSubview(vCollect)
        vBottomBar.addSubview(vPoint)
        vBottomBar.addSubview(vComment)
        vBottomBar.addSubview(vLineTop)
        vBottomBar.addSubview(vLineLeft)
        vBottomBar.addSubview(vLineCenter)
        vBottomBar.addSubview(vLineRight)
        
        tableView.frame.size.height -= vBottomBar.frame.size.height
        
        // view
        self.view.addSubview(tableView)
        self.view.addSubview(vBottomBar)
        
        // hide
        vCouple.isHidden = true
        lTitle.isHidden = true
        vTag.isHidden = true
        lContent.isHidden = true
        collectImgList.isHidden = true
        
        // target
        btnCommentUser.addTarget(self, action: #selector(showCommentUserAlert), for: .touchUpInside)
        btnCommentSort.addTarget(self, action: #selector(showCommentSortAlert), for: .touchUpInside)
        ViewUtils.addViewTapTarget(target: self, view: vJab, action: #selector(targetJab))
        ViewUtils.addViewTapTarget(target: self, view: vCollect, action: #selector(targetCollect))
        ViewUtils.addViewTapTarget(target: self, view: vPoint, action: #selector(targetPoint))
        ViewUtils.addViewTapTarget(target: self, view: vComment, action: #selector(tagertGoAdd))
    }
    
    override func initData() {
        orderIndex = 0
        searchUserId = 0
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyDetailRefresh), name: NotifyHelper.TAG_POST_DETAIL_REFRESH)
        NotifyHelper.addObserver(self, selector: #selector(notifyListRefresh), name: NotifyHelper.TAG_POST_COMMENT_LIST_REFRESH)
        NotifyHelper.addObserver(self, selector: #selector(notifyListItemDelete), name: NotifyHelper.TAG_POST_COMMENT_LIST_ITEM_DELETE)
        NotifyHelper.addObserver(self, selector: #selector(notifyListItemRefresh), name: NotifyHelper.TAG_POST_COMMENT_LIST_ITEM_REFRESH)
        // init
        if post != nil {
            refreshHeadView()
            // 没有详情页的，可以不加
            refreshPostData(pid: post!.id, comment: true)
            // read
            postRead(pid: post!.id)
        } else if pid > 0 {
            refreshPostData(pid: pid, comment: true)
            // read
            postRead(pid: pid)
        } else {
            RootVC.get().popBack()
        }
        // collect
        refreshCollectView()
        // point
        refreshPointView()
        // comment
        refreshCommentView()
    }
    
    @objc func notifyDetailRefresh(notify: NSNotification) {
        if let pid = notify.object as? Int64 {
            refreshPostData(pid: pid, comment: false)
        }
    }
    
    @objc func notifyListRefresh(notify: NSNotification) {
        startScrollDataSet(scroll: tableView)
    }
    
    @objc func notifyListItemDelete(notify: NSNotification) {
        let index = ListHelper.findIndexByIdInList(list: postCommentList, obj: notify.object)
        if index < 0 || postCommentList == nil || postCommentList!.count <= index {
            return
        }
        postCommentList?.remove(at: index)
        refreshHeightMap(refresh: true, start: 0, dataList: postCommentList)
        tableView?.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        endScrollState(scroll: tableView, msg: nil)
    }
    
    @objc func notifyListItemRefresh(notify: NSNotification) {
        let index = ListHelper.findIndexByIdInList(list: postCommentList, obj: notify.object)
        if index < 0 || postCommentList == nil || postCommentList!.count <= index {
            return
        }
        postCommentList?[index] = (notify.object as? PostComment) ?? PostComment()
        refreshHeightMap(refresh: true, start: 0, dataList: postCommentList)
        tableView?.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func refreshPostData(pid: Int64, comment: Bool) {
        // api
        let api = Api.request(.topicPostGet(pid: pid),
                              success: { (_, _, data) in
                                self.post = data.post
                                // view
                                self.refreshHeadView()
                                self.refreshCollectView()
                                self.refreshPointView()
                                self.refreshCommentView()
                                // comment
                                if comment {
                                    self.startScrollDataSet(scroll: self.tableView)
                                }
                                // event
                                self.post?.read = true
                                NotifyHelper.post(NotifyHelper.TAG_POST_LIST_ITEM_REFRESH, obj: self.post)
        }, failure: nil)
        pushApi(api)
    }
    
    func refreshHeadView() {
        if post == nil || post!.isDelete() || post!.screen {
            RootVC.get().popBack()
            return
        }
        // menu
        self.refreshMenu()
        // couple
        let couple = post!.couple
        if couple == nil {
            vCouple.isHidden = true
        } else {
            vCouple.isHidden = false
            let avatar = UserHelper.getAvatar(couple: couple, uid: post!.userId)
            KFHelper.setImgAvatarUrl(iv: ivAvatar, objKey: avatar)
            lName.text = UserHelper.getName(couple: couple, uid: post!.userId, empty: true)
            lTime.text = DateUtils.getStr(post!.createAt, DateUtils.FORMAT_LINE_M_D_H_M)
        }
        // title
        lTitle.isHidden = StringUtils.isEmpty(post!.title)
        lTitle.text = post!.title
        // tag
        let tagShowList = ShowHelper.getPostTagListShow(post: post, kind: true, subKind: true)
        var tagHeight: CGFloat = 0
        if tagShowList.count <= 0 {
            vTag.isHidden = true
        } else {
            vTag.isHidden = false
            for subView in vTag.subviews {
                subView.removeFromSuperview()
            }
            var nextOrigin = CGPoint(x: 0, y: 0)
            for tagShow in tagShowList {
                let lTag = ViewHelper.getLabelWhiteSmall(text: tagShow, lines: 1, align: .center)
                lTag.frame.size.width += ScreenUtils.widthFit(10)
                lTag.frame.size.height += ScreenUtils.heightFit(4)
                lTag.frame.origin = nextOrigin
                lTag.backgroundColor = ThemeHelper.getColorPrimary()
                ViewUtils.setViewRadius(lTag, radius: CGFloat(2), bounds: true)
                vTag.addSubview(lTag)
                // height
                if tagHeight <= 0 {
                    tagHeight = lTag.frame.size.height
                }
                // next
                nextOrigin.x = nextOrigin.x + lTag.frame.size.width + CGFloat(7)
                if nextOrigin.x > maxWidth + ScreenUtils.widthFit(50) {
                    nextOrigin.x = 0
                    nextOrigin.y = tagHeight + ScreenUtils.heightFit(5)
                    tagHeight += ScreenUtils.heightFit(5) + lTag.frame.size.height
                }
            }
        }
        // content
        lContent.isHidden = StringUtils.isEmpty(post!.contentText)
        lContent.text = post!.contentText
        // imgList
        if post!.contentImageList.count <= 0 {
            collectImgList.isHidden = true
        } else {
            collectImgList.isHidden = false
        }
        // comment
        refreshCommentUserView()
        refreshCommentOrderView()
        
        // size
        lTitle.frame.origin.y = vCouple.isHidden ? vCouple.frame.origin.y : vCouple.frame.origin.y + vCouple.frame.size.height + ScreenUtils.heightFit(15)
        lTitle.frame.size.height = ViewUtils.getFontHeight(font: lTitle.font, width: lTitle.frame.size.width, text: lTitle.text)
        vTag.frame.origin.y = lTitle.isHidden ? lTitle.frame.origin.y : lTitle.frame.origin.y + lTitle.frame.size.height + margin
        vTag.frame.size.height = tagHeight
        lContent.frame.origin.y = vTag.isHidden ? vTag.frame.origin.y : vTag.frame.origin.y + vTag.frame.size.height + margin
        lContent.frame.size.height = ViewUtils.getFontHeight(font: lContent.font, width: lContent.frame.size.width, text: lContent.text)
        collectImgList.frame.origin.y = (lContent.isHidden ? lContent.frame.origin.y : lContent.frame.origin.y + lContent.frame.size.height + margin) - imgTop
        collectImgList.frame.size.height = ImgSquareShowCell.getCollectHeight(collect: collectImgList, dataList: post!.contentImageList, spanCount: 1)
        collectImgList.reloadData()
        vGrey.frame.origin.y = collectImgList.isHidden ? collectImgList.frame.origin.y : collectImgList.frame.origin.y + collectImgList.frame.size.height + margin - imgBottom
        vCommentSearch.frame.origin.y = vGrey.frame.origin.y + vGrey.frame.size.height
        vHead.frame.size.height = vCommentSearch.frame.origin.y + vCommentSearch.frame.size.height
    }
    
    func refreshMenu() {
        if post == nil {
            return
        }
        var bars = [UIBarButtonItem]()
        if post!.official {
            if post!.mine { // 删除
                bars = [barItemDel]
            }
        } else {
            if post!.mine { // 举报 + 删除
                bars = [barItemDel, barItemReport]
            } else { // 举报
                bars = [barItemReport]
            }
        }
        self.navigationItem.setRightBarButtonItems(bars, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post?.contentImageList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return ImgSquareShowCell.getCellWithData(view: collectionView, indexPath: indexPath, dataList: post?.contentImageList)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        BrowserHelper.goBrowserImage(delegate: self, index: indexPath.row, ossKeyList: post?.contentImageList)
    }
    
    func refreshCommentUserView() {
        if post == nil {
            return
        }
        let me = UDHelper.getMe()
        if searchUserId == post!.userId {
            btnCommentUser.setTitle(StringUtils.getString("floor_master"), for: .normal)
        } else if me != nil && searchUserId == me!.id {
            btnCommentUser.setTitle(StringUtils.getString("me_de"), for: .normal)
        } else {
            btnCommentUser.setTitle(StringUtils.getString("all_space_brackets_holder_brackets", arguments: [post!.commentCount]), for: .normal)
        }
        // size
        btnCommentUser.frame.size.width = ViewUtils.getFontWidth(font: btnCommentUser.titleLabel?.font, text: btnCommentUser.title(for: .normal)) + margin * 2
    }
    
    func refreshCommentOrderView() {
        if post == nil {
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
        page = more ? page + 1 : 0
        let orderType = ApiHelper.LIST_COMMENT_ORDER_TYPE[orderIndex]
        // api
        let target: Api = searchUserId > 0 ? Api.topicPostCommentUserListGet(pid: post?.id ?? pid, uid: searchUserId, order: orderType, page: page) : Api.topicPostCommentListGet(pid: post?.id ?? pid, order: orderType, page: page)
        let api = Api.request(target,
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
        return TopicPostCommentCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: postCommentList, height: height, subComment: false, target: self, actionReport: #selector(targetItemReport), actionPoint: #selector(targetItemPoint))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TopicPostCommentCell.goCommentDetail(view: tableView, indexPath: indexPath, dataList: postCommentList)
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
    
    func refreshCollectView() {
        if post == nil {
            return
        }
        lCollect.text = post!.collectCount > 0 ? ShowHelper.getShowCount2Thousand(post!.collectCount) : StringUtils.getString("collect")
        ivCollect.image = ViewUtils.getImageWithTintColor(img:  ivCollect.image, color: post!.collect ? ThemeHelper.getColorPrimary() : ColorHelper.getIconGrey())
        // size
        lCollect.frame.size.width = ViewUtils.getFontWidth(font: lCollect.font, text: lCollect.text)
        ivCollect.frame.origin = CGPoint(x: (screenWidth / 4 - ivCollect.frame.size.width - margin - lCollect.frame.size.width) / 2, y: margin)
        lCollect.frame.origin = CGPoint(x: ivCollect.frame.origin.x + ivCollect.frame.size.width + margin, y: margin)
    }
    
    func refreshPointView() {
        if post == nil {
            return
        }
        lPoint.text = post!.pointCount > 0 ? ShowHelper.getShowCount2Thousand(post!.pointCount) : StringUtils.getString("point")
        ivPoint.image = ViewUtils.getImageWithTintColor(img:  ivPoint.image, color: post!.point ? ThemeHelper.getColorPrimary() : ColorHelper.getIconGrey())
        // size
        lPoint.frame.size.width = ViewUtils.getFontWidth(font: lPoint.font, text: lPoint.text)
        ivPoint.frame.origin = CGPoint(x: (screenWidth / 4 - ivPoint.frame.size.width - margin - lPoint.frame.size.width) / 2, y: margin)
        lPoint.frame.origin = CGPoint(x: ivPoint.frame.origin.x + ivPoint.frame.size.width + margin, y: margin)
    }
    
    func refreshCommentView() {
        if post == nil {
            return
        }
        refreshCommentUserView()
        lComment.text = post!.commentCount > 0 ? ShowHelper.getShowCount2Thousand(post!.commentCount) : StringUtils.getString("comment")
        ivComment.image = ViewUtils.getImageWithTintColor(img: ivComment.image, color: post!.comment ? ThemeHelper.getColorPrimary() : ColorHelper.getIconGrey())
        // size
        lComment.frame.size.width = ViewUtils.getFontWidth(font: lComment.font, text: lComment.text)
        ivComment.frame.origin = CGPoint(x: (screenWidth / 4 - ivComment.frame.size.width - margin - lComment.frame.size.width) / 2, y: margin)
        lComment.frame.origin = CGPoint(x: ivComment.frame.origin.x + ivComment.frame.size.width + margin, y: margin)
    }
    
    @objc func showCommentUserAlert() {
        if post == nil {
            return
        }
        var showList = [String]()
        showList.append(StringUtils.getString("all"))
        showList.append(StringUtils.getString("floor_master"))
        if !post!.mine {
            let kindInfo = ListHelper.getPostKindInfo(kind: post!.kind)
            let subKindInfo = ListHelper.getPostSubKindInfo(kindInfo: kindInfo, subKind: post!.subKind)
            if subKindInfo != nil && !subKindInfo!.anonymous{
                showList.append(StringUtils.getString("me_de"))
            }
        }
        _ = AlertHelper.showAlert(title: StringUtils.getString("select_search_type"),
                                  confirms: showList,
                                  cancel: StringUtils.getString("cancel"),
                                  canCancel: true,
                                  actionHandler: { (_, index, _) in
                                    switch index {
                                    case 1: // 楼主
                                        self.searchUserId = self.post!.userId
                                        break
                                    case 2: // 我的
                                        let me = UDHelper.getMe()
                                        self.searchUserId = (me == nil) ? 0 : me!.id
                                        break
                                    default: // 全部
                                        self.searchUserId = 0
                                        break
                                    }
                                    self.refreshCommentUserView()
                                    self.refreshCommentData(more: false) // tableRefresh会置顶
        }, cancelHandler: nil)
    }
    
    @objc func showCommentSortAlert() {
        if post == nil {
            return
        }
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
        if post == nil {
            return
        }
        let boy = ApiHelper.getPostCommentJabBody(pid: post!.id, tcid: 0)
        // api
        let api = Api.request(.topicPostCommentAdd(postComment: boy.toJSON()),
                              success: { (_, _, data) in
                                self.post?.comment = true
                                self.post?.commentCount += 1
                                self.refreshCommentView()
                                self.refreshCommentData(more: false) // tableRefresh会置顶
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_POST_LIST_ITEM_REFRESH, obj: self.post)
                                
        }, failure: nil)
        pushApi(api)
    }
    
    @objc func targetPoint() {
        point(api: true)
    }
    
    func point(api: Bool) {
        if post == nil {
            return
        }
        let newPoint = !post!.point
        var newPointCount = newPoint ? post!.pointCount + 1 : post!.pointCount - 1
        if newPointCount < 0 {
            newPointCount = 0
        }
        post?.point = newPoint
        post?.pointCount = newPointCount
        refreshPointView()
        if !api {
            return
        }
        let body = PostPoint()
        body.postId = post!.id
        // api
        let api = Api.request(.topicPostPointToggle(postPoint: body.toJSON()),
                              success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_POST_LIST_ITEM_REFRESH, obj: self.post)
                                
        }, failure: { (_, msg, _) in
            self.point(api: false)
        })
        pushApi(api)
    }
    
    @objc func targetCollect() {
        collect(api: true)
    }
    
    func collect(api: Bool) {
        if post == nil {
            return
        }
        let newCollect = !post!.collect
        var newCollectCount = newCollect ? post!.collectCount + 1 : post!.collectCount - 1
        if newCollectCount < 0 {
            newCollectCount = 0
        }
        post?.collect = newCollect
        post?.collectCount = newCollectCount
        refreshCollectView()
        if !api {
            return
        }
        let body = PostCollect()
        body.postId = post!.id
        // api
        let api = Api.request(.topicPostCollectToggle(postCollect: body.toJSON()),
                              success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_POST_LIST_ITEM_REFRESH, obj: self.post)
                                
        }, failure: { (_, msg, _) in
            self.collect(api: false)
        })
        pushApi(api)
    }
    
    @objc func tagertGoAdd() {
        if post == nil {
            return
        }
        TopicPostCommentAddVC.pushVC(pid: post!.id)
    }
    
    @objc func showReportAlert() {
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_report_this_post"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    self.reportPost()
        },
                                  cancelHandler: nil)
    }
    
    private func reportPost() {
        if post == nil {
            return
        }
        let body = PostReport()
        body.postId = post!.id
        // api
        let api = Api.request(.topicPostReportAdd(postReport: body.toJSON()),
                              loading: true, cancel: true, success: { (_, _, data) in
                                // notify
                                self.post?.report = true
                                NotifyHelper.post(NotifyHelper.TAG_POST_LIST_ITEM_REFRESH, obj: self.post)
                                
        }, failure: nil)
        pushApi(api)
    }
    
    @objc func showDeleteAlert() {
        if post == nil || !post!.mine {
            ToastUtils.show(StringUtils.getString("can_delete_self_create_post"))
            return
        }
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_del_this_post"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    self.delPost()
        },
                                  cancelHandler: nil)
    }
    
    private func delPost() {
        if post == nil {
            return
        }
        // api
        let api = Api.request(.topicPostDel(pid: post!.id),
                              loading: true, cancel: true, success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_POST_LIST_ITEM_DELETE, obj: self.post)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
    func postRead(pid: Int64) {
        let api = Api.request(.topicPostRead(pid: pid), success: nil, failure: nil)
        pushApi(api)
    }
    
}
