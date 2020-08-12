//
// Created by 蒋治国 on 2018-12-09.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh
import DZNEmptyDataSet
import MWPhotoBrowser
import PhotoTweaks

class BaseVC: UIViewController,
    UITextFieldDelegate, UITextViewDelegate, // 输入
    DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, // 空视图
    MWPhotoBrowserDelegate, // 图片浏览
    PhotoTweaksViewControllerDelegate // 图片裁剪
{
    
    // activityFrom
    public static let ACT_LIST_FROM_BROWSE = 0
    public static let ACT_LIST_FROM_SELECT = 1
    public static let ACT_EDIT_FROM_ADD = 0
    public static let ACT_EDIT_FROM_UPDATE = 1
    public static let ACT_DETAIL_FROM_ID = 0
    public static let ACT_DETAIL_FROM_OBJ = 1
    
    lazy var actFrom = -1
    
    //    public static func get() -> BaseVC {
    //        return BaseVC(nibName: nil, bundle: nil)
    //    }
    //
    //    public static func pushVC() {
    //        RootVC.get().pushNext(BaseVC(nibName: nil, bundle: nil))
    //    }
    //
    //    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    //        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    //    }
    //
    //    required init?(coder aDecoder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    /*************************************************生命周期*********************************************************/
    
    // (重写)初始化view
    func initView() {
    }
    
    // (重写)初始化data
    func initData() {
    }
    
    // (重写)重新展示
    func onReview(_ animated: Bool) {
    }
    
    // (重写)销毁
    func onDestroy() {
    }
    
    // 视图控制器中的视图加载完成，viewController自带的view加载完成
    override func viewDidLoad() {
        super.viewDidLoad()
        // view
        self.view.backgroundColor = ColorHelper.getBackground()
        self.view.autoresizesSubviews = true
        self.view.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleHeight.rawValue
            | UIView.AutoresizingMask.flexibleWidth.rawValue
            | UIView.AutoresizingMask.flexibleLeftMargin.rawValue
            | UIView.AutoresizingMask.flexibleRightMargin.rawValue
            | UIView.AutoresizingMask.flexibleTopMargin.rawValue
            | UIView.AutoresizingMask.flexibleBottomMargin.rawValue)
        // initView
        initView()
        // keyboard
        NotifyHelper.addObserver(self, selector: #selector(onKeyboardWillShow), name: UIResponder.keyboardWillShowNotification.rawValue)
        NotifyHelper.addObserver(self, selector: #selector(onKeyboardWillHide), name: UIResponder.keyboardWillHideNotification.rawValue)
        // theme
        NotifyHelper.addObserver(self, selector: #selector(updateTheme), name: NotifyHelper.TAG_THEME_UPDATE)
        // initData
        initData()
    }
    
    // 视图将要出现
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // navigationBar
        RootVC.get().setNavigationBarHidden(!navigationBarShow, animated: navigationBarShowAnim)
        // textfield
        initAllTextField()
        // onReview
        onReview(animated)
    }
    
    // view 即将布局其 Subviews
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    // view 已经布局其 Subviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // 视图已经出现
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // 视图将要消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // 视图已经消失
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // 出现内存警告
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //    // 销毁(不一定会被调用)
    //    deinit {
    //        willDestroy()
    //    }
    
    func willDestroy() {
        // api
        for api in apiList {
            if api == nil {
                continue
            }
            api?.calcel()
        }
        // notify
        NotifyHelper.removeObserver(self)
        // onDestroy
        onDestroy()
    }
    
    /*************************************************导航栏*********************************************************/
    
    lazy var navigationBarShow: Bool = false
    lazy var navigationBarShowAnim: Bool = true
    
    // 初始化导航栏
    func initNavBar(title: String, amin: Bool = true) {
        self.navigationBarShow = !StringUtils.isEmpty(title)
        //        self.navigationItem.title = StringUtils.getString(title)
        self.title = StringUtils.getString(title)
        self.navigationBarShowAnim = amin
    }
    
    // 状态栏文字颜色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // 去掉NavigationBar下划线
    func hideNavigationBarShadow() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func canPop() -> Bool {
        return true
    }
    
    /*************************************************主题*********************************************************/
    
    // 主题更换触发
    @objc public func updateTheme(notification: NSNotification) {
        self.navigationController?.navigationBar.barTintColor = ThemeHelper.getColorPrimary()
        let theme = notification.object as? Int
        onThemeUpdate(theme: theme)
    }
    
    // (重写)主题更换回调
    func onThemeUpdate(theme: Int?) {
    }
    
    /*************************************************键盘/输入框*********************************************************/
    
    lazy var HoldTextFiledDelete = true
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        //        let subViews = ViewUtils.getSubViews(subviews: view.subviews)
        //        for subView in subViews {
        //            if !(((subView as? UITextView) != nil) || ((subView as? UITextField) != nil)) {
        //                subView.endEditing(true)
        //            }
        //        }
    }
    
    func initAllTextField() {
        if !HoldTextFiledDelete { return }
        let subViews = ViewUtils.getSubViews(subviews: view.subviews)
        for subView in subViews {
            if let tf = subView as? UITextField {
                tf.delegate = self
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // 需要联动的inputView
    var vOffsetInputList: [UIView] = [UIView]()
    
    public func addViewOffsetWithKeyboard(input: UIView) {
        vOffsetInputList.append(input)
    }
    
    public func clearViewOffsetWithKeyboady(input: UIView) {
        vOffsetInputList.removeAll()
    }
    
    @objc func onKeyboardWillShow(noti: NSNotification) {
        let userInfo: NSDictionary = noti.userInfo! as NSDictionary
        let keyBoardInfo: AnyObject? = userInfo.object(forKey: UIResponder.keyboardFrameEndUserInfoKey) as AnyObject
        let endY = keyBoardInfo?.cgRectValue.size.height
        let aTime = userInfo.object(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as! TimeInterval
        //        UIView.animate(withDuration: aTime) { [weak self]() -> Void in
        //            self?.view.transform = CGAffineTransform(translationX: 0, y: -endY!)
        //        }
        UIView.animate(withDuration: aTime) { () -> Void in
            for input in self.vOffsetInputList {
                input.transform = CGAffineTransform(translationX: 0, y: -endY!)
            }
        }
    }
    
    @objc func onKeyboardWillHide(noti: NSNotification) {
        let userInfo: NSDictionary = noti.userInfo! as NSDictionary
        let aTime = userInfo.object(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as! TimeInterval
        //        UIView.animate(withDuration: aTime) { [weak self]() -> Void in
        //            self?.view.transform = CGAffineTransform.identity
        //        }
        UIView.animate(withDuration: aTime) { () -> Void in
            for input in self.vOffsetInputList {
                input.transform = CGAffineTransform.identity
            }
        }
    }
    
    /*************************************************api*********************************************************/
    
    // 保存api
    lazy var apiList = [ApiRuquest?]()
    
    func pushApi(_ api: ApiRuquest?) {
        if api == nil {
            return
        }
        apiList.append(api!)
    }
    
    /*************************************************Scroll视图*********************************************************/
    
    private var listCanEmpty = false
    private var listEmptyColor = ColorHelper.getFontGrey()
    private var listEmptyShow = StringUtils.getString("master_there_nothing")
    
    // empty是否允许
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return listCanEmpty
    }
    
    // empty是否允许交互(并没有交互)
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return false
    }
    
    // empty时是否还可以滚动
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    // empty返回状态内容
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedString.Key.font: ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL), NSAttributedString.Key.foregroundColor: listEmptyColor]
        return NSAttributedString(string: listEmptyShow, attributes: attributes)
    }
    
    // 初始化
    public func initScrollState(scroll: UIScrollView?, clipTopBar: Bool = false, clipBottomNav: Bool = false,
                                canEmpty: Bool = false, emptyColor: UIColor = ColorHelper.getFontGrey(),
                                canRefresh: Bool = false, refreshBlock: (() -> Void)? = nil,
                                canMore: Bool = false, moreBlock: (() -> Void)? = nil) {
        if clipTopBar {
            scroll?.frame.size.height -= RootVC.get().getTopBarHeight()
        }
        if clipBottomNav {
            scroll?.frame.size.height -= ScreenUtils.getBottomNavHeight()
        }
        // empty
        listCanEmpty = canEmpty
        listEmptyColor = emptyColor
        // refresh
        if canRefresh && refreshBlock != nil {
            scroll?.mj_header = MJRefreshNormalHeader(refreshingBlock: refreshBlock!)
            (scroll?.mj_header as? MJRefreshStateHeader)?.stateLabel.font = ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)
            (scroll?.mj_header as? MJRefreshStateHeader)?.stateLabel.textColor = ColorHelper.getFontGrey()
            (scroll?.mj_header as? MJRefreshStateHeader)?.lastUpdatedTimeLabel.isHidden = true
        }
        // more
        if canMore && moreBlock != nil {
            scroll?.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: moreBlock!)
            (scroll?.mj_footer as? MJRefreshAutoStateFooter)?.stateLabel.font = ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)
            (scroll?.mj_footer as? MJRefreshAutoStateFooter)?.stateLabel.textColor = ColorHelper.getFontGrey()
            (scroll?.mj_footer as? MJRefreshAutoStateFooter)?.setTitle(StringUtils.getString("master_no_hurry_quick_ok"), for: .refreshing)
            (scroll?.mj_footer as? MJRefreshAutoStateFooter)?.setTitle(StringUtils.getString("master_no_hurry_quick_ok"), for: .pulling)
            (scroll?.mj_footer as? MJRefreshAutoStateFooter)?.setTitle(StringUtils.getString("master_this_is_my_bottom"), for: .noMoreData)
            scroll?.mj_footer?.isHidden = true
        }
    }
    
    // 开始数据加载
    public func startScrollDataSet(scroll: UIScrollView?) {
        scroll?.mj_header?.beginRefreshing()
    }
    
    // 刷新scroll状态
    public func endScrollState(scroll: UIScrollView?, msg: String? = nil) {
        if listCanEmpty {
            listEmptyShow = StringUtils.isEmpty(msg) ? StringUtils.getString("master_there_nothing") : msg!
            if scroll?.emptyDataSetSource == nil {
                scroll?.emptyDataSetSource = self
            }
            if scroll?.emptyDataSetDelegate == nil {
                scroll?.emptyDataSetDelegate = self
            }
            scroll?.reloadEmptyDataSet()
        }
        scroll?.mj_header?.endRefreshing()
        scroll?.mj_footer?.resetNoMoreData()
        (scroll?.mj_footer as? MJRefreshAutoStateFooter)?.setTitle(StringUtils.getString("master_this_is_my_bottom"), for: .noMoreData)
        if let table = scroll as? UITableView {
            scroll?.mj_footer?.isHidden = ((table.numberOfSections <= 0) || (table.numberOfRows(inSection: 0) <= 0))
        } else if let collect = scroll as? UICollectionView {
            scroll?.mj_footer?.isHidden = ((collect.numberOfSections <= 0) || (collect.numberOfItems(inSection: 0) <= 0))
        }
    }
    
    // 刷新scroll数据
    public func endScrollDataRefresh(scroll: UIScrollView?, msg: String? = nil, count: Int = 0) {
        if listCanEmpty {
            listEmptyShow = StringUtils.isEmpty(msg) ? StringUtils.getString("master_there_nothing") : msg!
            if scroll?.emptyDataSetSource == nil {
                scroll?.emptyDataSetSource = self
            }
            if scroll?.emptyDataSetDelegate == nil {
                scroll?.emptyDataSetDelegate = self
            }
            scroll?.reloadEmptyDataSet()
        }
        scroll?.mj_header?.endRefreshing()
        scroll?.mj_footer?.isHidden = (count <= 0)
        scroll?.mj_footer?.resetNoMoreData()
        (scroll?.mj_footer as? MJRefreshAutoStateFooter)?.setTitle(StringUtils.getString("master_this_is_my_bottom"), for: .noMoreData)
        // 没有新数据
        if count <= 0 {
            if let table = scroll as? UITableView {
                table.reloadData()
            } else if let collect = scroll as? UICollectionView {
                collect.reloadData()
            }
            return
        }
        // 有新数据
        var number = 0
        if let table = scroll as? UITableView {
            number = table.numberOfRows(inSection: 0)
        } else if let collect = scroll as? UICollectionView {
            number = collect.numberOfItems(inSection: 0)
        }
        if number < count {
            // 旧数据 < 新数据，先添加缺少的，再刷新现有的
            var indexAdd = number
            var indexPathsAdd = [IndexPath]()
            while indexAdd < count {
                indexPathsAdd.append(IndexPath(row: indexAdd, section: 0))
                indexAdd += 1
            }
            if let table = scroll as? UITableView {
                table.insertRows(at: indexPathsAdd, with: .automatic)
            } else if let collect = scroll as? UICollectionView {
                collect.insertItems(at: indexPathsAdd)
            }
            if number > 0 {
                var indexReload = 0
                var indexPathsReload = [IndexPath]()
                while indexReload < number {
                    indexPathsReload.append(IndexPath(row: indexReload, section: 0))
                    indexReload += 1
                }
                if let table = scroll as? UITableView {
                    table.reloadRows(at: indexPathsReload, with: .automatic)
                } else if let collect = scroll as? UICollectionView {
                    collect.reloadItems(at: indexPathsReload)
                }
            }
        } else if number > count {
            // 旧数据 > 新数据，先删除多余的，再刷新现有的
            var indexDel = count
            var indexPathsDel = [IndexPath]()
            while indexDel < number {
                indexPathsDel.append(IndexPath(row: indexDel, section: 0))
                indexDel += 1
            }
            if let table = scroll as? UITableView {
                table.deleteRows(at: indexPathsDel, with: .automatic)
            } else if let collect = scroll as? UICollectionView {
                collect.deleteItems(at: indexPathsDel)
            }
            var indexReload = 0
            var indexPathsReload = [IndexPath]()
            while indexReload < count {
                indexPathsReload.append(IndexPath(row: indexReload, section: 0))
                indexReload += 1
            }
            if let table = scroll as? UITableView {
                table.reloadRows(at: indexPathsReload, with: .automatic)
            } else if let collect = scroll as? UICollectionView {
                collect.reloadItems(at: indexPathsReload)
            }
        } else {
            // 旧数据 = 新数据，直接刷新现有的
            var indexReload = 0
            var indexPathsReload = [IndexPath]()
            while indexReload < number {
                indexPathsReload.append(IndexPath(row: indexReload, section: 0))
                indexReload += 1
            }
            if let table = scroll as? UITableView {
                table.reloadRows(at: indexPathsReload, with: .automatic)
            } else if let collect = scroll as? UICollectionView {
                collect.reloadItems(at: indexPathsReload)
            }
        }
    }
    
    // 加载scroll数据
    public func endScrollDataMore(scroll: UIScrollView?, msg: String? = nil, count: Int = 0) {
        if listCanEmpty {
            listEmptyShow = StringUtils.isEmpty(msg) ? StringUtils.getString("master_there_nothing") : msg!
            if scroll?.emptyDataSetSource == nil {
                scroll?.emptyDataSetSource = self
            }
            if scroll?.emptyDataSetDelegate == nil {
                scroll?.emptyDataSetDelegate = self
            }
        }
        if count <= 0 {
            // 没有新数据
            (scroll?.mj_footer as? MJRefreshAutoStateFooter)?.endRefreshingWithNoMoreData()
            if !StringUtils.isEmpty(msg) {
                (scroll?.mj_footer as? MJRefreshAutoStateFooter)?.setTitle(msg, for: .noMoreData)
            }
        } else {
            // 有新数据
            scroll?.mj_footer?.endRefreshing()
            var number = 0
            if let table = scroll as? UITableView {
                number = table.numberOfRows(inSection: 0)
            } else if let collect = scroll as? UICollectionView {
                number = collect.numberOfItems(inSection: 0)
            }
            var indexAdd = number
            var indexPathsAdd = [IndexPath]()
            while indexAdd < (number + count) {
                indexPathsAdd.append(IndexPath(row: indexAdd, section: 0))
                indexAdd += 1
            }
            if let table = scroll as? UITableView {
                table.insertRows(at: indexPathsAdd, with: .automatic)
                let oldNumber = table.numberOfRows(inSection: 0)
                let oldRow = oldNumber - count - 1
                if oldRow >= 0 { // 防止加载完滚到其他位置
                    table.scrollToRow(at: IndexPath(row: oldRow, section: 0), at: .bottom, animated: true)
                }
            } else if let collect = scroll as? UICollectionView {
                collect.insertItems(at: indexPathsAdd)
                let oldNumber = collect.numberOfItems(inSection: 0)
                let oldItem = oldNumber - count - 1
                if oldItem >= 0 { // 防止加载完滚到其他位置
                    collect.scrollToItem(at: IndexPath(item: oldItem, section: 0), at: .bottom, animated: true)
                }
            }
        }
    }
    
    /*************************************************图片浏览*********************************************************/
    
    lazy var photos = [MWPhoto]()
    
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(photos.count)
    }
    
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        return photos[Int(index)]
    }
    
    /*************************************************裁剪*********************************************************/
    
    // 裁剪确定
    func photoTweaksController(_ controller: PhotoTweaksViewController!, didFinishWithCroppedImage croppedImage: UIImage!) {
        AppDelegate.runOnMainAsync {
            RootVC.get().popBack()
            self.onImageCropSuccess(data: croppedImage.pngData())
        }
    }
    
    // 裁剪返回
    func photoTweaksControllerDidCancel(_ controller: PhotoTweaksViewController!) {
        AppDelegate.runOnMainAsync {
            RootVC.get().popBack()
        }
    }
    
    // 裁剪成功
    func onImageCropSuccess(data: Data?) {
    }
    
}
