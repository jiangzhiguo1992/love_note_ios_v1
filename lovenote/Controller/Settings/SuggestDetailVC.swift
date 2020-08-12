//
//  SuggestDetailVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/5/5.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class SuggestDetailVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    
    // view
    private var barItemDel: UIBarButtonItem!
    private var tableView: UITableView!
    private var vHead: UIView!
    private var lTitle: UILabel!
    private var lTime: UILabel!
    private var vTag: UIView!
    private var lContent: UILabel!
    private var ivFollow: UIImageView!
    private var lFollow: UILabel!
    private var ivComment: UIImageView!
    private var lComment: UILabel!
    
    // var
    private var suggest: Suggest!
    private var suggestCommentList: [SuggestComment]?
    private var page = 0
    
    public static func pushVC(suggest: Suggest? = nil, sid: Int64 = 0) {
        AppDelegate.runOnMainAsync {
            let vc = SuggestDetailVC(nibName: nil, bundle: nil)
            if suggest != nil {
                vc.suggest = suggest
            } else {
                if sid <= 0 {
                    return
                }
                let s = Suggest()
                s.id = sid
                vc.suggest = s
            }
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "suggest_feedback")
        barItemDel = UIBarButtonItem(image: UIImage(named: "ic_delete_white_24dp"), style: .plain, target: self, action: #selector(showDeleteAlert))
        
        // title
        lTitle = ViewHelper.getLabelBold(width: maxWidth, text: "-", size: ViewHelper.FONT_SIZE_BIG, color: ColorHelper.getFontBlack(), lines: 0, align: .left)
        lTitle.frame.origin = CGPoint(x: margin, y: margin * 2)
        
        // time
        lTime = ViewHelper.getLabelGreySmall(width: maxWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lTime.frame.origin = CGPoint(x: margin, y: lTitle.frame.origin.y + lTitle.frame.size.height + margin)
        
        // tag
        vTag = UIView()
        vTag.frame.size = CGSize(width: maxWidth, height: 0)
        vTag.frame.origin.x = margin
        vTag.frame.origin.y = lTitle.frame.origin.y + lTitle.frame.size.height + margin
        
        // content
        lContent = ViewHelper.getLabelGreyNormal(width: maxWidth, text: "-", lines: 0, align: .left)
        lContent.frame.origin.x = margin
        lContent.frame.origin.y = vTag.frame.origin.y + vTag.frame.size.height + margin
        
        // head
        vHead = UIView()
        vHead.frame.size = CGSize(width: screenWidth, height: lContent.frame.origin.y + lContent.frame.size.height + margin * 2)
        vHead.addSubview(lTitle)
        vHead.addSubview(lTime)
        vHead.addSubview(vTag)
        vHead.addSubview(lContent)
        
        // tableView
        tableView = ViewUtils.getTableView(target: self, frame: self.view.bounds, cellCls: SuggestCommentCell.self, id: SuggestCommentCell.ID)
        initScrollState(scroll: tableView, clipTopBar: true, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: { self.refreshCommentData(more: false) },
                        canMore: true) { self.refreshCommentData(more: true) }
        tableView.tableHeaderView = vHead
        
        // follow
        lFollow = ViewHelper.getLabelGreyNormal(text: "-", lines: 1, align: .center, mode: .byTruncatingTail)
        ivFollow = ViewHelper.getImageView(img: UIImage(named: "ic_visibility_grey_18dp"), mode: .center)
        let vFollow = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth / 2, height: lFollow.frame.size.height + margin * 2))
        
        ivFollow.frame.origin = CGPoint(x: (vFollow.frame.size.width - ivFollow.frame.size.width - margin - lFollow.frame.size.width) / 2, y: margin)
        lFollow.frame.origin = CGPoint(x: ivFollow.frame.origin.x + ivFollow.frame.size.width + margin, y: margin)
        vFollow.addSubview(ivFollow)
        vFollow.addSubview(lFollow)
        
        // comment
        lComment = ViewHelper.getLabelGreySmall(text: "-", lines: 1, align: .center, mode: .byTruncatingTail)
        ivComment = ViewHelper.getImageView(img: UIImage(named: "ic_insert_comment_grey_18dp"), mode: .center)
        let vComment = UIView(frame: CGRect(x: screenWidth / 2, y: 0, width: screenWidth / 2, height: lComment.frame.size.height + margin * 2))
        
        ivComment.frame.origin = CGPoint(x: (vComment.frame.size.width - ivComment.frame.size.width - margin - lComment.frame.size.width) / 2, y: margin)
        lComment.frame.origin = CGPoint(x: ivComment.frame.origin.x + ivComment.frame.size.width + margin, y: margin)
        vComment.addSubview(ivComment)
        vComment.addSubview(lComment)
        
        // line
        let vLineTop = ViewHelper.getViewLine(width: screenWidth)
        vLineTop.frame.origin = CGPoint(x: 0, y: 0)
        let vLineCenter = ViewHelper.getViewLine(height: vFollow.frame.size.height)
        vLineCenter.center.x = screenWidth / 2
        vLineCenter.frame.origin.y = 0
        
        // bottomBar
        let vBottomBar = UIView()
        vBottomBar.frame.size = CGSize(width: screenWidth, height: vFollow.frame.size.height + ScreenUtils.getBottomNavHeight())
        vBottomBar.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height - RootVC.get().getTopBarHeight() - vBottomBar.frame.size.height)
        vBottomBar.backgroundColor = ColorHelper.getWhite()
        
        vBottomBar.addSubview(vFollow)
        vBottomBar.addSubview(vComment)
        vBottomBar.addSubview(vLineTop)
        vBottomBar.addSubview(vLineCenter)
        
        tableView.frame.size.height -= vBottomBar.frame.size.height
        
        // view
        self.view.addSubview(tableView)
        self.view.addSubview(vBottomBar)
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vFollow, action: #selector(targetFollow))
        ViewUtils.addViewTapTarget(target: self, view: vComment, action: #selector(targetComment))
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyDetailRefresh), name: NotifyHelper.TAG_SUGGEST_DETAIL_REFRESH)
        // view
        refreshHeadView()
        refreshFollowView()
        refreshCommentView()
        // data
        refreshSuggest()
    }
    
    @objc func notifyDetailRefresh(notify: NSNotification) {
        refreshSuggest()
    }
    
    func refreshSuggest() {
        // api
        let api = Api.request(.setSuggestGet(sid: suggest.id),
                              success: { (_, _, data) in
                                self.suggest = data.suggest
                                // view
                                self.refreshHeadView()
                                self.refreshFollowView()
                                self.refreshCommentView()
                                // comment
                                self.startScrollDataSet(scroll: self.tableView)
                                // event
                                NotifyHelper.post(NotifyHelper.TAG_SUGGEST_LIST_ITEM_REFRESH, obj: self.suggest)
        }, failure: nil)
        pushApi(api)
    }
    
    func refreshHeadView() {
        // menu
        self.refreshMenu()
        // view
        lTitle.text = suggest.title
        lTime.text = DateUtils.getStr(suggest.createAt, DateUtils.FORMAT_LINE_M_D_H_M)
        lContent.text = suggest.contentText
        let statusShow = ListHelper.getSuggestStatusShow(status: suggest.status)
        let kindShow = ListHelper.getSuggestKindShow(kind: suggest.kind)
        for subView in vTag.subviews {
            subView.removeFromSuperview()
        }
        var nextOrigin = CGPoint(x: 0, y: 0)
        if suggest.top {
            let lTagTop = ViewHelper.getLabelWhiteSmall(text: StringUtils.getString("top"), lines: 1, align: .center)
            lTagTop.frame.size.width += ScreenUtils.widthFit(10)
            lTagTop.frame.size.height += ScreenUtils.heightFit(4)
            lTagTop.frame.origin = nextOrigin
            lTagTop.backgroundColor = ThemeHelper.getColorPrimary()
            ViewUtils.setViewRadius(lTagTop, radius: ScreenUtils.widthFit(2), bounds: true)
            vTag.addSubview(lTagTop)
            // next
            nextOrigin.x = nextOrigin.x + lTagTop.frame.size.width + CGFloat(7)
            vTag.frame.size.height = lTagTop.frame.size.height
        }
        if suggest.official {
            let lTagOfficial = ViewHelper.getLabelWhiteSmall(text: StringUtils.getString("administrators"), lines: 1, align: .center)
            lTagOfficial.frame.size.width += ScreenUtils.widthFit(10)
            lTagOfficial.frame.size.height += ScreenUtils.heightFit(4)
            lTagOfficial.frame.origin = nextOrigin
            lTagOfficial.backgroundColor = ThemeHelper.getColorPrimary()
            ViewUtils.setViewRadius(lTagOfficial, radius: ScreenUtils.widthFit(2), bounds: true)
            vTag.addSubview(lTagOfficial)
            // next
            nextOrigin.x = nextOrigin.x + lTagOfficial.frame.size.width + ScreenUtils.heightFit(7)
        }
        if !StringUtils.isEmpty(statusShow) {
            let lTagStatus = ViewHelper.getLabelWhiteSmall(text: statusShow, lines: 1, align: .center)
            lTagStatus.frame.size.width += ScreenUtils.widthFit(10)
            lTagStatus.frame.size.height += ScreenUtils.heightFit(4)
            lTagStatus.frame.origin = nextOrigin
            lTagStatus.backgroundColor = ThemeHelper.getColorPrimary()
            ViewUtils.setViewRadius(lTagStatus, radius: ScreenUtils.widthFit(2), bounds: true)
            vTag.addSubview(lTagStatus)
            // next
            nextOrigin.x = nextOrigin.x + lTagStatus.frame.size.width + ScreenUtils.heightFit(7)
            vTag.frame.size.height = lTagStatus.frame.size.height
        }
        if !StringUtils.isEmpty(kindShow) {
            let lTagKind = ViewHelper.getLabelWhiteSmall(text: kindShow, lines: 1, align: .center)
            lTagKind.frame.size.width += ScreenUtils.widthFit(10)
            lTagKind.frame.size.height += ScreenUtils.heightFit(4)
            lTagKind.frame.origin = nextOrigin
            lTagKind.backgroundColor = ThemeHelper.getColorPrimary()
            ViewUtils.setViewRadius(lTagKind, radius: ScreenUtils.widthFit(2), bounds: true)
            vTag.addSubview(lTagKind)
            // next
            nextOrigin.x = nextOrigin.x + lTagKind.frame.size.width + ScreenUtils.heightFit(7)
            vTag.frame.size.height = lTagKind.frame.size.height
        }
        if suggest.mine {
            let lTagMine = ViewHelper.getLabelWhiteSmall(text: StringUtils.getString("me_de"), lines: 1, align: .center)
            lTagMine.frame.size.width += ScreenUtils.widthFit(10)
            lTagMine.frame.size.height += ScreenUtils.heightFit(4)
            lTagMine.frame.origin = nextOrigin
            lTagMine.backgroundColor = ThemeHelper.getColorPrimary()
            ViewUtils.setViewRadius(lTagMine, radius: ScreenUtils.widthFit(2), bounds: true)
            vTag.addSubview(lTagMine)
            // next
            nextOrigin.x = nextOrigin.x + lTagMine.frame.size.width + ScreenUtils.heightFit(7)
            vTag.frame.size.height = lTagMine.frame.size.height
        }
        
        // size
        lTitle.frame.size.height = ViewUtils.getFontHeight(font: lTitle.font, width: lTitle.frame.size.width, text: lTitle.text)
        lTime.frame.origin.y = lTitle.frame.origin.y + lTitle.frame.size.height + margin
        vTag.frame.origin.y = lTime.frame.origin.y + lTime.frame.size.height + margin
        lContent.frame.origin.y = vTag.frame.origin.y + vTag.frame.size.height + margin
        lContent.frame.size.height = ViewUtils.getFontHeight(font: lContent.font, width: lContent.frame.size.width, text: lContent.text)
        vHead.frame.size.height = lContent.frame.origin.y + lContent.frame.size.height + margin * 2
    }
    
    func refreshMenu() {
        let bars = suggest.mine ? [UIBarButtonItem](arrayLiteral: barItemDel) : [UIBarButtonItem]()
        self.navigationItem.setRightBarButtonItems(bars, animated: true)
    }
    
    private func refreshCommentData(more: Bool) {
        page = more ? page + 1 : 0
        // api
        let api = Api.request(.setSuggestCommentListGet(sid: suggest.id, page: page),
                              success: { (_, _, data) in
                                SuggestCommentCell.refreshHeightMap(refresh: !more, start: self.suggestCommentList?.count ?? 0, dataList: data.suggestCommentList)
                                if !more {
                                    self.suggestCommentList = data.suggestCommentList
                                    self.endScrollDataRefresh(scroll: self.tableView, msg: data.show, count: data.suggestCommentList?.count ?? 0)
                                } else {
                                    self.suggestCommentList = (self.suggestCommentList ?? [SuggestComment]()) + (data.suggestCommentList ?? [SuggestComment]())
                                    self.endScrollDataMore(scroll: self.tableView, msg: data.show, count: data.suggestCommentList?.count ?? 0)
                                }
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.tableView, msg: msg)
        })
        pushApi(api)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestCommentList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SuggestCommentCell.getCellHeight(view: tableView, indexPath: indexPath, dataList: suggestCommentList)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return SuggestCommentCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: suggestCommentList)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showItemDeleteAlert(indexPath: indexPath)
    }
    
    func refreshFollowView() {
        lFollow.text = suggest!.followCount > 0 ? ShowHelper.getShowCount2Thousand(suggest!.followCount) : StringUtils.getString("follow")
        ivFollow.image = ViewUtils.getImageWithTintColor(img: suggest!.follow ? UIImage(named: "ic_visibility_grey_18dp") : UIImage(named: "ic_visibility_off_grey_18dp"), color: suggest!.follow ? ThemeHelper.getColorPrimary() : ColorHelper.getIconGrey())
        // size
        lFollow.frame.size.width = ViewUtils.getFontWidth(font: lFollow.font, text: lFollow.text)
        ivFollow.frame.origin = CGPoint(x: (screenWidth / 2 - ivFollow.frame.size.width - margin - ivFollow.frame.size.width) / 2, y: margin)
        lFollow.frame.origin = CGPoint(x: ivFollow.frame.origin.x + ivFollow.frame.size.width + margin, y: margin)
    }
    
    func refreshCommentView() {
        lComment.text = suggest!.commentCount > 0 ? ShowHelper.getShowCount2Thousand(suggest!.commentCount) : StringUtils.getString("comment")
        ivComment.image = ViewUtils.getImageWithTintColor(img: ivComment.image, color: suggest!.comment ? ThemeHelper.getColorPrimary() : ColorHelper.getIconGrey())
        // size
        lComment.frame.size.width = ViewUtils.getFontWidth(font: lComment.font, text: lComment.text)
        ivComment.frame.origin = CGPoint(x: (screenWidth / 2 - ivComment.frame.size.width - margin - lComment.frame.size.width) / 2, y: margin)
        lComment.frame.origin = CGPoint(x: ivComment.frame.origin.x + ivComment.frame.size.width + margin, y: margin)
    }
    
    @objc func targetFollow() {
        follow(api: true)
    }
    
    func follow(api: Bool) {
        let newFollow = !suggest!.follow
        var newFollowtCount = newFollow ? suggest!.followCount + 1 : suggest!.followCount - 1
        if newFollowtCount < 0 {
            newFollowtCount = 0
        }
        suggest.follow = newFollow
        suggest.followCount = newFollowtCount
        refreshFollowView()
        if !api {
            return
        }
        let body = SuggestFollow()
        body.suggestId = suggest.id
        // api
        let api = Api.request(.setSuggestFollowToggle(suggestFollow: body.toJSON()),
                              success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_SUGGEST_LIST_ITEM_REFRESH, obj: self.suggest)
                                
        }, failure: { (_, msg, _) in
            self.follow(api: false)
        })
        pushApi(api)
    }
    
    @objc func targetComment() {
        SuggestCommentAddVC.pushVC(sid: suggest.id)
    }
    
    @objc func showDeleteAlert() {
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_del_this_suggest"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    self.delSuggest()
        },
                                  cancelHandler: nil)
    }
    
    private func delSuggest() {
        // api
        let api = Api.request(.setSuggestDel(sid: suggest.id),
                              loading: true, cancel: true, success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_SUGGEST_LIST_ITEM_DELETE, obj: self.suggest)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
    @objc func showItemDeleteAlert(indexPath: IndexPath) {
        if suggestCommentList == nil || suggestCommentList!.count <= indexPath.row {
            return
        }
        let comment = suggestCommentList![indexPath.row]
        if !comment.mine {
            return
        }
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_del_this_comment"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    self.delItemSuggestComment(index: indexPath.row)
        },
                                  cancelHandler: nil)
    }
    
    private func delItemSuggestComment(index: Int) {
        if suggestCommentList == nil || suggestCommentList!.count <= index {
            return
        }
        let comment = suggestCommentList![index]
        if !comment.mine {
            return
        }
        // api
        let api = Api.request(.setSuggestCommentDel(scid: comment.id),
                              loading: true, cancel: true, success: { (_, _, data) in
                                self.suggestCommentList!.remove(at: index)
                                SuggestCommentCell.refreshHeightMap(refresh: true, start: 0, dataList: self.suggestCommentList)
                                self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                                self.endScrollState(scroll: self.tableView, msg: nil)
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_SUGGEST_DETAIL_REFRESH, obj: self.suggest)
        }, failure: nil)
        pushApi(api)
    }
    
}
