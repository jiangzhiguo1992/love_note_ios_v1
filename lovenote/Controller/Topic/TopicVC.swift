//
//  TopicVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/9.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class TopicVC: BaseVC, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    
    // view
    private var barItemMsg: UIBarButtonItem!
    private var btnAdd: UIButton!
    private var tableView: UITableView!
    private var vHead: UIView!
    private var collectView: UICollectionView!
    private var vPostLine: UIView!
    
    // var
    private static var postKindInfoList = [PostKindInfo]()
    private var postList: [Post]?
    private var heightMap: [Int: CGFloat] = [Int: CGFloat]()
    private var create: Int64 = 0
    private var page = 0
    
    public static func get() -> TopicVC {
        return TopicVC(nibName: nil, bundle: nil)
    }
    
    override func initView() {
        // navigationBar
        self.title = StringUtils.getString("nav_topic")
        let barItemHelp = UIBarButtonItem(image: UIImage(named: "ic_help_outline_white_24dp"), style: .plain, target: self, action: #selector(targetGoHelp))
        let barItemMine = UIBarButtonItem(image: UIImage(named: "ic_perm_identity_white_24dp"), style: .plain, target: self, action: #selector(targetGoMine))
        barItemMsg = UIBarButtonItem(image: UIImage(named: "ic_notifications_none_white_24dp"), style: .plain, target: self, action: #selector(targetGoMessage))
        self.navigationItem.setLeftBarButtonItems([barItemHelp], animated: true)
        self.navigationItem.setRightBarButtonItems([barItemMsg, barItemMine], animated: true)
        
        // search
        let vSearch = UIView(frame: CGRect(x: margin, y: margin, width: maxWidth, height: ScreenUtils.widthFit(40)))
        vSearch.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadiusCircle(vSearch)
        
        let ivSearch = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_search_grey_18dp"), color: ColorHelper.getFontHint()), mode: .center)
        let lSearch = ViewHelper.getLabel(text: StringUtils.getString("please_input_search_content"), size: ViewHelper.FONT_SIZE_NORMAL, color: ColorHelper.getFontHint())
        
        ivSearch.frame.origin.x = (vSearch.frame.size.width - (ivSearch.frame.size.width + lSearch.frame.size.width + margin)) / 2
        lSearch.frame.origin.x = ivSearch.frame.origin.x + ivSearch.frame.size.width + margin
        ivSearch.center.y = vSearch.frame.size.height / 2
        lSearch.center.y = vSearch.frame.size.height / 2
        vSearch.addSubview(ivSearch)
        vSearch.addSubview(lSearch)
        
        // line-kind
        let lKind = ViewHelper.getLabelGreySmall(text: StringUtils.getString("classify"))
        lKind.center.x = screenWidth / 2
        lKind.frame.origin.y = 0
        let lineKindLeft = ViewHelper.getViewLine(width: (maxWidth - lKind.frame.size.width) / 2 - margin)
        lineKindLeft.frame.origin.x = margin
        lineKindLeft.center.y = lKind.center.y
        let lineKindRight = ViewHelper.getViewLine(width: (maxWidth - lKind.frame.size.width) / 2 - margin)
        lineKindRight.frame.origin.x = lKind.frame.origin.x + lKind.frame.size.width + margin
        lineKindRight.center.y = lKind.center.y
        let vKindLine = UIView(frame: CGRect(x: 0, y: vSearch.frame.origin.y + vSearch.frame.size.height + ScreenUtils.heightFit(15), width: screenWidth, height: lKind.frame.size.height))
        vKindLine.addSubview(lKind)
        vKindLine.addSubview(lineKindLeft)
        vKindLine.addSubview(lineKindRight)
        
        // kind
        let layoutKind = TopicHomeKindCell.getLayout()
        let marginKind = layoutKind.sectionInset
        let collectWidth = maxWidth + marginKind.left + marginKind.right
        let collectX = marginKind.left
        let collectY = vKindLine.frame.origin.y + vKindLine.frame.size.height + margin - marginKind.top
        let collectFrame = CGRect(x: collectX, y: collectY, width: collectWidth, height: 0)
        collectView = ViewUtils.getCollectionView(target: self, frame: collectFrame, layout: layoutKind,
                                                  cellCls: TopicHomeKindCell.self, id: TopicHomeKindCell.ID)
        
        // line-post
        let lPost = ViewHelper.getLabelGreySmall(text: StringUtils.getString("most_new"))
        lPost.center.x = screenWidth / 2
        lPost.frame.origin.y = 0
        let linePostLeft = ViewHelper.getViewLine(width: (maxWidth - lPost.frame.size.width) / 2 - margin)
        linePostLeft.frame.origin.x = margin
        linePostLeft.center.y = lPost.center.y
        let linePostRight = ViewHelper.getViewLine(width: (maxWidth - lPost.frame.size.width) / 2 - margin)
        linePostRight.frame.origin.x = lPost.frame.origin.x + lPost.frame.size.width + margin
        linePostRight.center.y = lPost.center.y
        vPostLine = UIView(frame: CGRect(x: 0, y: collectView.frame.origin.y + collectView.frame.size.height + ScreenUtils.heightFit(15) - marginKind.top, width: screenWidth, height: lPost.frame.size.height))
        vPostLine.addSubview(lPost)
        vPostLine.addSubview(linePostLeft)
        vPostLine.addSubview(linePostRight)
        
        // head
        vHead = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: vPostLine.frame.origin.y + vPostLine.frame.size.height + margin / 2))
        vHead.addSubview(vSearch)
        vHead.addSubview(vKindLine)
        vHead.addSubview(collectView)
        vHead.addSubview(vPostLine)
        
        // tableView
        var tableY: CGFloat = 0
        if #available(iOS 11.0, *) {
            tableY = RootVC.get().getTopBarHeight()
        }
        var tableHeight = ScreenUtils.getScreenHeight()
        if #available(iOS 11.0, *) {
            tableHeight -= (self.tabBarController?.tabBar.frame.size.height ?? 0)
        } else {
            tableHeight += ScreenUtils.getTopStatusHeight()
        }
        let tableFrame = CGRect(x: 0, y: tableY, width: self.view.bounds.width, height: tableHeight)
        tableView = ViewUtils.getTableView(target: self, frame: tableFrame, cellCls: TopicPostCell.self, id: TopicPostCell.ID)
        initScrollState(scroll: tableView, clipTopBar: true, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: { self.refreshPostListData(more: false) },
                        canMore: true) { self.refreshPostListData(more: true) }
        tableView.tableHeaderView = vHead
        
        // add
        btnAdd = ViewHelper.getBtnImgCenter(width: ViewHelper.FAB_SIZE, height: ViewHelper.FAB_SIZE, bgColor: ThemeHelper.getColorAccent(), bgImg: UIImage(named: "ic_add_white_24dp"), circle: true, shadow: true)
        btnAdd.frame.origin = CGPoint(x: screenWidth - ViewHelper.FAB_MARGIN - btnAdd.frame.size.width, y: tableFrame.origin.y + tableFrame.size.height - ViewHelper.FAB_MARGIN - btnAdd.frame.size.height - RootVC.get().getTopBarHeight())
        
        // view
        self.view.addSubview(tableView)
        self.view.addSubview(btnAdd)
        
        // target
        btnAdd.addTarget(self, action: #selector(targetGoAdd), for: .touchUpInside)
        ViewUtils.addViewTapTarget(target: self, view: vSearch, action: #selector(targetGoSearch))
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_POST_LIST_REFRESH)
        NotifyHelper.addObserver(self, selector: #selector(notifyListItemDelete), name: NotifyHelper.TAG_POST_LIST_ITEM_DELETE)
        NotifyHelper.addObserver(self, selector: #selector(notifyListItemRefresh), name: NotifyHelper.TAG_POST_LIST_ITEM_REFRESH)
        // view
        refreshHeadView()
        // data
        refreshPostKindData()
        startScrollDataSet(scroll: tableView)
    }
    
    override func onReview(_ animated: Bool) {
        // menu
        refreshMenu()
    }
    
    override func onThemeUpdate(theme: Int?) {
        btnAdd.backgroundColor = ThemeHelper.getColorAccent()
    }
    
    public static func getPostKindInfoList() -> [PostKindInfo] {
        return postKindInfoList
    }
    
    @objc func notifyRefresh(notify: NSNotification) {
        startScrollDataSet(scroll: tableView)
    }
    
    @objc func notifyListItemDelete(notify: NSNotification) {
        let index = ListHelper.findIndexByIdInList(list: postList, obj: notify.object)
        if index < 0 || postList == nil || postList!.count <= index {
            return
        }
        postList?.remove(at: index)
        refreshHeightMap(refresh: true, start: 0, dataList: postList)
        tableView?.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        endScrollState(scroll: tableView, msg: nil)
    }
    
    @objc func notifyListItemRefresh(notify: NSNotification) {
        let index = ListHelper.findIndexByIdInList(list: postList, obj: notify.object)
        if index < 0 || postList == nil || postList!.count <= index {
            return
        }
        postList?[index] = (notify.object as? Post) ?? Post()
        refreshHeightMap(refresh: true, start: 0, dataList: postList)
        tableView?.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func refreshHeadView() {
        // collect
        let postKindInfoList = ListHelper.getPostKindInfoListEnable()
        collectView.frame.size.height = TopicHomeKindCell.getMuliCellHeight(dataList: postKindInfoList)
        self.collectView.reloadData()
        // line
        let layoutKind = TopicHomeKindCell.getLayout()
        let marginKind = layoutKind.sectionInset
        vPostLine.frame.origin.y = collectView.frame.origin.y + collectView.frame.size.height + ScreenUtils.heightFit(15) - marginKind.top
        // head
        vHead.frame.size.height = vPostLine.frame.origin.y + vPostLine.frame.size.height + margin / 2
    }
    
    func refreshMenu() {
        let notice = UDHelper.getCommonCount().topicMsgNewCount > 0
        barItemMsg.image = UIImage(named: notice ? "ic_notifications_none_point_white_24dp" : "ic_notifications_none_white_24dp")?.withRenderingMode(.alwaysOriginal)
    }
    
    private func refreshPostKindData() {
        let api = Api.request(.topicHomeGet,
                              success: { (_, _, data) in
                                TopicVC.postKindInfoList = data.postKindInfoList ?? [PostKindInfo]()
                                // count
                                let oldCC = UDHelper.getCommonCount()
                                oldCC.topicMsgNewCount = data.commonCount?.topicMsgNewCount ?? 0
                                UDHelper.setCommonCount(oldCC)
                                // view
                                self.refreshMenu()
                                self.refreshHeadView()
        })
        pushApi(api)
    }
    
    private func refreshPostListData(more: Bool) {
        page = more ? page + 1 : 0
        if !more || create <= 0 {
            create = DateUtils.getCurrentInt64()
        }
        // api
        let api = Api.request(.topicPostListHomeGet(create: create, page: page),
                              success: { (_, _, data) in
                                self.refreshHeightMap(refresh: !more, start: self.postList?.count ?? 0, dataList: data.postList)
                                if !more {
                                    self.postList = data.postList
                                    self.endScrollDataRefresh(scroll: self.tableView, msg: data.show, count: data.postList?.count ?? 0)
                                } else {
                                    self.postList = (self.postList ?? [Post]()) + (data.postList ?? [Post]())
                                    self.endScrollDataMore(scroll: self.tableView, msg: data.show, count: data.postList?.count ?? 0)
                                }
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.tableView, msg: msg)
        })
        pushApi(api)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let postKindInfoList = ListHelper.getPostKindInfoListEnable()
        return postKindInfoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let postKindInfoList = ListHelper.getPostKindInfoListEnable()
        return TopicHomeKindCell.getCellWithData(view: collectionView, indexPath: indexPath, dataList: postKindInfoList)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let postKindInfoList = ListHelper.getPostKindInfoListEnable()
        TopicHomeKindCell.goPostList(view: collectionView, indexPath: indexPath, dataList: postKindInfoList)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getCellHeight(view: tableView, indexPath: indexPath, dataList: postList)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let height = getCellHeight(view: tableView, indexPath: indexPath, dataList: postList)
        return TopicPostCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: postList, height: height)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TopicPostCell.goPostDetail(view: tableView, indexPath: indexPath, dataList: postList)
    }
    
    public func getCellHeight(view: UITableView, indexPath: IndexPath, dataList: [Post]?) -> CGFloat {
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
        let post = dataList![row]
        return TopicPostCell.getHeightByData(post: post)
    }
    
    public func refreshHeightMap(refresh: Bool, start: Int, dataList: [Post]?) {
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
        for (index, post) in dataList!.enumerated() {
            let height = TopicPostCell.getHeightByData(post: post)
            heightMap[index + startIndex] = height
        }
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_TOPIC_HOME)
    }
    
    @objc private func targetGoMine() {
        TopicPostMineVC.pushVC()
    }
    
    @objc private func targetGoMessage() {
        TopicMessageVC.pushVC()
    }
    
    @objc private func targetGoSearch() {
        TopicPostSearchVC.pushVC()
    }
    
    @objc private func targetGoAdd() {
        TopicPostAddVC.pushVC()
    }
    
}
