//
// Created by 蒋治国 on 2018-12-09.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteVC: BaseVC, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var maxWidth = self.view.frame.width - margin * 2
    
    // view
    private var barItemLock: UIBarButtonItem!
    private var barItemTrends: UIBarButtonItem!
    private var scroll: UIScrollView!
    
    private var gradientTop: CAGradientLayer!
    private var lSouvenirEmpty: UILabel!
    private var vSouvenirFull: UIView!
    private var lSouvenirYear: UILabel!
    private var lSouvenirTitle: UILabel!
    private var lSouvenirCountdown: UILabel!
    
    private var vSouvenir: UIView!
    private var lineLive: UIView!
    private var collectLiveView: UICollectionView!
    private var lineNote: UIView!
    private var collectNoteView: UICollectionView!
    private var lineMedia: UIView!
    private var collectMediaView: UICollectionView!
    private var lineOther: UIView!
    private var collectOtherView: UICollectionView!
    
    // var
    private var lock: Lock?
    private var souvenirTimer: Timer?
    
    private let collectLiveTag: Int = 1
    private let collectNoteTag: Int = 2
    private let collectMediaTag: Int = 3
    private let collectOtherTag: Int = 4
    
    private var liveDateList: [Int] = [Int]()
    private var noteDateList: [Int] = [Int]()
    private var mediaDateList: [Int] = [Int]()
    private var otherDateList: [Int] = [Int]()
    
    static func get() -> NoteVC {
        return NoteVC(nibName: nil, bundle: nil)
    }
    
    override func initView() {
        // navigationBar
        self.title = StringUtils.getString("nav_note")
        hideNavigationBarShadow()
        let barItemHelp = UIBarButtonItem(image: UIImage(named: "ic_help_outline_white_24dp"), style: .plain, target: self, action: #selector(targetGoHelp))
        barItemTrends = UIBarButtonItem(image: UIImage(named: "ic_notifications_none_white_24dp"), style: .plain, target: self, action: #selector(targetGoTrends))
        barItemLock = UIBarButtonItem(image: UIImage(named: "ic_lock_open_white_24dp"), style: .plain, target: self, action: #selector(targetGoLock))
        self.navigationItem.setLeftBarButtonItems([barItemHelp], animated: true)
        self.navigationItem.setRightBarButtonItems([barItemTrends, barItemLock], animated: true)
        
        // souvenir
        let ivSouvenir = ViewHelper.getImageView(img: UIImage(named: "ic_note_souvenir_48dp"), width: ScreenUtils.widthFit(50), height: ScreenUtils.widthFit(50), mode: .scaleAspectFit)
        ivSouvenir.frame.origin = CGPoint(x: margin, y: margin)
        
        lSouvenirEmpty = ViewHelper.getLabelBold(width: maxWidth - margin * 2 - ivSouvenir.frame.size.width, height: ivSouvenir.frame.size.height, text: StringUtils.getString("per_day_is_souvenir"), size: ViewHelper.FONT_SIZE_BIG, color: ColorHelper.getFontGrey(), lines: 0, align: .center)
        lSouvenirEmpty.frame.origin = CGPoint(x: ivSouvenir.frame.origin.x + ivSouvenir.frame.size.width, y: ivSouvenir.frame.origin.y)
        
        vSouvenirFull = UIView()
        vSouvenirFull.frame.size = CGSize(width: maxWidth - margin * 3 - ivSouvenir.frame.size.width, height: ivSouvenir.frame.size.height)
        vSouvenirFull.frame.origin = CGPoint(x: ivSouvenir.frame.origin.x + ivSouvenir.frame.size.width + margin, y: ivSouvenir.frame.origin.y)
        
        lSouvenirYear = ViewHelper.getLabelPrimaryNormal(text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lSouvenirYear.frame.origin = CGPoint(x: 0, y: 0)
        
        lSouvenirTitle = ViewHelper.getLabelBold(width: vSouvenirFull.frame.size.width - margin - lSouvenirYear.frame.size.width, text: "-", color: ColorHelper.getFontGrey(), lines: 1, align: .left, mode: .byTruncatingTail)
        lSouvenirTitle.frame.origin = CGPoint(x: lSouvenirYear.frame.origin.x + lSouvenirYear.frame.size.width + margin, y: 0)
        
        lSouvenirCountdown = ViewHelper.getLabelBold(width: vSouvenirFull.frame.size.width, text: "-", size: ViewHelper.FONT_SIZE_HUGE, color: ThemeHelper.getColorPrimary(), lines: 1, align: .left, mode: .byTruncatingTail)
        lSouvenirCountdown.frame.origin = CGPoint(x: 0, y: vSouvenirFull.frame.size.height - lSouvenirCountdown.frame.size.height)
        
        vSouvenirFull.addSubview(lSouvenirYear)
        vSouvenirFull.addSubview(lSouvenirTitle)
        vSouvenirFull.addSubview(lSouvenirCountdown)
        
        let vSouvenirRoot = UIView()
        vSouvenirRoot.frame.size = CGSize(width: maxWidth, height: ivSouvenir.frame.size.height + margin * 2)
        vSouvenirRoot.frame.origin = CGPoint(x: margin, y: margin)
        vSouvenirRoot.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vSouvenirRoot, radius: ViewHelper.RADIUS_BIG)
        ViewUtils.setViewShadow(vSouvenirRoot, offset: ViewHelper.SHADOW_BIG)
        
        vSouvenirRoot.addSubview(ivSouvenir)
        vSouvenirRoot.addSubview(lSouvenirEmpty)
        vSouvenirRoot.addSubview(vSouvenirFull)
        
        vSouvenir = UIView()
        vSouvenir.frame.size = CGSize(width: self.view.frame.width, height: vSouvenirRoot.frame.height + margin * 2)
        vSouvenir.frame.origin = CGPoint(x: 0, y: 0)
        gradientTop = ViewHelper.getGradientPrimaryTrans(frame: vSouvenir.bounds)
        vSouvenir.layer.insertSublayer(gradientTop, at: 0)
        vSouvenir.addSubview(vSouvenirRoot)
        
        // life
        let lineLifeLabel = ViewHelper.getLabel(text: StringUtils.getString("live"), size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontHint(), lines: 1)
        lineLive = UIView(frame: CGRect(x: margin, y: vSouvenir.frame.origin.y + vSouvenir.frame.size.height + margin, width: maxWidth, height: lineLifeLabel.frame.size.height))
        lineLifeLabel.center.x = lineLive.frame.size.width / 2
        lineLifeLabel.frame.origin.y = 0
        let lineLiveLeft = ViewHelper.getViewLine(width: (lineLive.frame.size.width - lineLifeLabel.frame.size.width) / 2 - margin)
        lineLiveLeft.frame.origin.x = 0
        lineLiveLeft.center.y = lineLive.frame.size.height / 2
        let lineLiveRight = ViewHelper.getViewLine(width: (lineLive.frame.size.width - lineLifeLabel.frame.size.width) / 2 - margin)
        lineLiveRight.frame.origin.x = lineLifeLabel.frame.origin.x + lineLifeLabel.frame.size.width + margin
        lineLiveRight.center.y = lineLive.frame.size.height / 2
        
        lineLive.addSubview(lineLifeLabel)
        lineLive.addSubview(lineLiveLeft)
        lineLive.addSubview(lineLiveRight)
        
        collectLiveView = ViewUtils.getCollectionView(target: self, frame: CGRect(x: margin, y: lineLive.frame.origin.y + lineLive.frame.size.height + margin, width: maxWidth, height: 0), layout: NoteCell.getLayout(), cellCls: NoteCell.self, id: NoteCell.ID)
        collectLiveView.tag = collectLiveTag
        
        // note
        let lineNoteLabel = ViewHelper.getLabel(text: StringUtils.getString("note"), size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontHint(), lines: 1)
        lineNote = UIView(frame: CGRect(x: margin, y: collectLiveView.frame.origin.y + collectLiveView.frame.size.height + margin / 2 * 3, width: maxWidth, height: lineNoteLabel.frame.size.height))
        lineNoteLabel.center.x = lineNote.frame.size.width / 2
        lineNoteLabel.frame.origin.y = 0
        let lineNoteLeft = ViewHelper.getViewLine(width: (lineNote.frame.size.width - lineNoteLabel.frame.size.width) / 2 - margin)
        lineNoteLeft.frame.origin.x = 0
        lineNoteLeft.center.y = lineNote.frame.size.height / 2
        let lineNoteRight = ViewHelper.getViewLine(width: (lineNote.frame.size.width - lineNoteLabel.frame.size.width) / 2 - margin)
        lineNoteRight.frame.origin.x = lineNoteLabel.frame.origin.x + lineNoteLabel.frame.size.width + margin
        lineNoteRight.center.y = lineNote.frame.size.height / 2
        
        lineNote.addSubview(lineNoteLabel)
        lineNote.addSubview(lineNoteLeft)
        lineNote.addSubview(lineNoteRight)
        
        collectNoteView = ViewUtils.getCollectionView(target: self, frame: CGRect(x: margin, y: lineNote.frame.origin.y + lineNote.frame.size.height + margin, width: maxWidth, height: 0), layout: NoteCell.getLayout(), cellCls: NoteCell.self, id: NoteCell.ID)
        collectNoteView.tag = collectNoteTag
        
        // media
        let lineMediaLabel = ViewHelper.getLabel(text: StringUtils.getString("media"), size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontHint(), lines: 1)
        lineMedia = UIView(frame: CGRect(x: margin, y: collectNoteView.frame.origin.y + collectNoteView.frame.size.height + margin, width: maxWidth, height: lineMediaLabel.frame.size.height))
        lineMediaLabel.center.x = lineMedia.frame.size.width / 2
        lineMediaLabel.frame.origin.y = 0
        let lineMediaLeft = ViewHelper.getViewLine(width: (lineMedia.frame.size.width - lineMediaLabel.frame.size.width) / 2 - margin)
        lineMediaLeft.frame.origin.x = 0
        lineMediaLeft.center.y = lineMedia.frame.size.height / 2
        let lineMediaRight = ViewHelper.getViewLine(width: (lineMedia.frame.size.width - lineMediaLabel.frame.size.width) / 2 - margin)
        lineMediaRight.frame.origin.x = lineMediaLabel.frame.origin.x + lineMediaLabel.frame.size.width + margin
        lineMediaRight.center.y = lineMedia.frame.size.height / 2
        
        lineMedia.addSubview(lineMediaLabel)
        lineMedia.addSubview(lineMediaLeft)
        lineMedia.addSubview(lineMediaRight)
        
        collectMediaView = ViewUtils.getCollectionView(target: self, frame: CGRect(x: margin, y: lineMedia.frame.origin.y + lineMedia.frame.size.height + margin, width: maxWidth, height: 0), layout: NoteCell.getLayout(), cellCls: NoteCell.self, id: NoteCell.ID)
        collectMediaView.tag = collectMediaTag
        
        // other
        let lineOtherLabel = ViewHelper.getLabel(text: StringUtils.getString("other"), size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontHint(), lines: 1)
        lineOther = UIView(frame: CGRect(x: margin, y: collectMediaView.frame.origin.y + collectMediaView.frame.size.height + margin, width: maxWidth, height: lineOtherLabel.frame.size.height))
        lineOtherLabel.center.x = lineOther.frame.size.width / 2
        lineOtherLabel.frame.origin.y = 0
        let lineOtherLeft = ViewHelper.getViewLine(width: (lineOther.frame.size.width - lineOtherLabel.frame.size.width) / 2 - margin)
        lineOtherLeft.frame.origin.x = 0
        lineOtherLeft.center.y = lineOther.frame.size.height / 2
        let lineOtherRight = ViewHelper.getViewLine(width: (lineOther.frame.size.width - lineOtherLabel.frame.size.width) / 2 - margin)
        lineOtherRight.frame.origin.x = lineOtherLabel.frame.origin.x + lineOtherLabel.frame.size.width + margin
        lineOtherRight.center.y = lineOther.frame.size.height / 2
        
        lineOther.addSubview(lineOtherLabel)
        lineOther.addSubview(lineOtherLeft)
        lineOther.addSubview(lineOtherRight)
        
        collectOtherView = ViewUtils.getCollectionView(target: self, frame: CGRect(x: margin, y: lineOther.frame.origin.y + lineOther.frame.size.height + margin, width: maxWidth, height: 0), layout: NoteCell.getLayout(), cellCls: NoteCell.self, id: NoteCell.ID)
        collectOtherView.tag = collectOtherTag
        
        // scroll
        var scrollY: CGFloat = 0
        if #available(iOS 11.0, *) {
            scrollY = RootVC.get().getTopBarHeight()
        }
        var scrollHeight = self.view.frame.height - (self.tabBarController?.tabBar.frame.size.height ?? 0)
        if #available(iOS 11.0, *) {
            scrollHeight -= RootVC.get().getTopBarHeight()
        }
        let scrollReact = CGRect(x: 0, y: scrollY, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = collectOtherView.frame.origin.y + collectOtherView.frame.size.height + ScreenUtils.heightFit(20)
        scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        scroll.refreshControl = UIRefreshControl()
        scroll.refreshControl?.tintColor = ThemeHelper.getColorPrimary()
        
        scroll.addSubview(vSouvenir)
        scroll.addSubview(lineLive)
        scroll.addSubview(collectLiveView)
        scroll.addSubview(lineNote)
        scroll.addSubview(collectNoteView)
        scroll.addSubview(lineMedia)
        scroll.addSubview(collectMediaView)
        scroll.addSubview(lineOther)
        scroll.addSubview(collectOtherView)
        
        // view
        self.view.addSubview(scroll)
        
        // hide
        vSouvenirFull.isHidden = true
        vSouvenir.isHidden = true
        lineLive.isHidden = true
        collectLiveView.isHidden = true
        lineNote.isHidden = true
        collectNoteView.isHidden = true
        lineMedia.isHidden = true
        collectMediaView.isHidden = true
        lineOther.isHidden = true
        collectOtherView.isHidden = true
        
        // target
        scroll.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        ViewUtils.addViewTapTarget(target: self, view: vSouvenirRoot, action: #selector(targetGoSouvenir))
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(onLockChange), name: NotifyHelper.TAG_LOCK_REFRESH)
        NotifyHelper.addObserver(self, selector: #selector(customView), name: NotifyHelper.TAG_CUSTOM_REFRESH)
        NotifyHelper.addObserver(self, selector: #selector(refreshData), name: NotifyHelper.TAG_SOUVENIR_LIST_REFRESH)
        NotifyHelper.addObserver(self, selector: #selector(refreshData), name: NotifyHelper.TAG_SOUVENIR_LIST_ITEM_DELETE)
        NotifyHelper.addObserver(self, selector: #selector(refreshData), name: NotifyHelper.TAG_SOUVENIR_LIST_ITEM_REFRESH)
        // custom
        customView()
        // souvenir
        refreshNoteView(souvenir: nil)
        // data
        refreshData()
    }
    
    override func onReview(_ animated: Bool) {
        // menu
        refreshMenu()
    }
    
    override func onDestroy() {
        stopSouvenirTimer()
    }
    
    override func onThemeUpdate(theme: Int?) {
        scroll.refreshControl?.tintColor = ThemeHelper.getColorPrimary()
        gradientTop.colors = [ThemeHelper.getColorPrimary().cgColor, ColorHelper.getTrans().cgColor]
        lSouvenirYear.textColor = ThemeHelper.getColorPrimary()
        lSouvenirCountdown.textColor = ThemeHelper.getColorPrimary()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == collectLiveTag {
            return liveDateList.count
        }
        if collectionView.tag == collectNoteTag {
            return noteDateList.count
        }
        if collectionView.tag == collectMediaTag {
            return mediaDateList.count
        }
        if collectionView.tag == collectOtherTag {
            return otherDateList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var dataList: [Int]
        if collectionView.tag == collectLiveTag {
            dataList = liveDateList
        } else if collectionView.tag == collectNoteTag {
            dataList = noteDateList
        } else if collectionView.tag == collectMediaTag {
            dataList = mediaDateList
        } else if collectionView.tag == collectOtherTag {
            dataList = otherDateList
        } else {
            dataList = [Int]()
        }
        return NoteCell.getCellWithData(view: collectionView, indexPath: indexPath, dataList: dataList)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if refuseNext() {
            return
        }
        var dataList: [Int]
        if collectionView.tag == collectLiveTag {
            dataList = liveDateList
        } else if collectionView.tag == collectNoteTag {
            dataList = noteDateList
        } else if collectionView.tag == collectMediaTag {
            dataList = mediaDateList
        } else if collectionView.tag == collectOtherTag {
            dataList = otherDateList
        } else {
            dataList = [Int]()
        }
        if dataList.count <= indexPath.item {
            return
        }
        let itemData = dataList[indexPath.item]
        switch itemData {
        case NoteCell.MENSES:
            NoteMensesVC.pushVC()
            break
        case NoteCell.SHY:
            NoteShyVC.pushVC()
            break
        case NoteCell.SLEEP:
            NoteSleepVC.pushVC()
            break
        case NoteCell.WORD:
            NoteWordVC.pushVC()
            break
        case NoteCell.WHISPER:
            NoteWhisperVC.pushVC()
            break
        case NoteCell.AWARD:
            NoteAwardVC.pushVC()
            break
        case NoteCell.DIARY:
            NoteDiaryVC.pushVC()
            break
        case NoteCell.TRAVEL:
            NoteTravelVC.pushVC()
            break
        case NoteCell.ANGRY:
            NoteAngryVC.pushVC()
            break
        case NoteCell.GIFT:
            NoteGiftVC.pushVC()
            break
        case NoteCell.PROMISE:
            NotePromiseVC.pushVC()
            break
        case NoteCell.DREAM:
            NoteDreamVC.pushVC()
            break
        case NoteCell.MOVIE:
            NoteMovieVC.pushVC()
            break
        case NoteCell.FOOD:
            NoteFoodVC.pushVC()
            break
        case NoteCell.AUDIO:
            NoteAudioVC.pushVC()
            break
        case NoteCell.VIDEO:
            NoteVideoVC.pushVC()
            break
        case NoteCell.ALBUM:
            NoteAlbumVC.pushVC()
            break
        case NoteCell.CUSTOM:
            NoteCustomVC.pushVC()
            break
        case NoteCell.TOTAL:
            NoteTotalVC.pushVC()
            break
        case NoteCell.TRENDS:
            NoteTrendsListVC.pushVC()
            break
        default: break
        }
    }
    
    @objc func customView() {
        let custom = UDHelper.getNoteCustom()
        let margin = CGFloat(10)
        let layout = NoteCell.getLayout()
        let itemHeight = layout.itemSize.height
        let lineMargin = layout.minimumLineSpacing
        
        // souvenir
        vSouvenir.isHidden = !custom.souvenir
        
        // live
        let isLive = custom.shy || custom.menses || custom.sleep
        lineLive.isHidden = !isLive
        collectLiveView.isHidden = !isLive
        liveDateList.removeAll()
        if custom.menses {
            liveDateList.append(NoteCell.MENSES)
        }
        if custom.shy {
            liveDateList.append(NoteCell.SHY)
        }
        if custom.sleep {
            liveDateList.append(NoteCell.SLEEP)
        }
        
        if custom.souvenir {
            lineLive.frame.origin.y = vSouvenir.frame.origin.y + vSouvenir.frame.size.height + margin
        } else {
            lineLive.frame.origin.y = margin * 2
        }
        collectLiveView.frame.origin.y = lineLive.frame.origin.y + lineLive.frame.size.height + margin
        
        var liveLineCount = liveDateList.count / NoteCell.SPAN_COUNT_4
        if liveDateList.count % NoteCell.SPAN_COUNT_4 > 0 {
            liveLineCount += 1
        }
        collectLiveView.frame.size.height = itemHeight * CGFloat(liveLineCount)
        if liveLineCount > 1 {
            collectLiveView.frame.size.height += CGFloat(liveLineCount - 1) * lineMargin
        }
        collectLiveView.reloadData()
        
        // note
        let isNote = custom.word || custom.whisper || custom.award || custom.diary || custom.dream
            || custom.travel || custom.food || custom.movie || custom.gift || custom.promise || custom.angry
        lineNote.isHidden = !isNote
        collectNoteView.isHidden = !isNote
        noteDateList.removeAll()
        if custom.word {
            noteDateList.append(NoteCell.WORD)
        }
        if custom.whisper {
            noteDateList.append(NoteCell.WHISPER)
        }
        if custom.award {
            noteDateList.append(NoteCell.AWARD)
        }
        if custom.diary {
            noteDateList.append(NoteCell.DIARY)
        }
        if custom.dream {
            noteDateList.append(NoteCell.DREAM)
        }
        if custom.angry {
            noteDateList.append(NoteCell.ANGRY)
        }
        if custom.gift {
            noteDateList.append(NoteCell.GIFT)
        }
        if custom.promise {
            noteDateList.append(NoteCell.PROMISE)
        }
        if custom.travel {
            noteDateList.append(NoteCell.TRAVEL)
        }
        if custom.movie {
            noteDateList.append(NoteCell.MOVIE)
        }
        if custom.food {
            noteDateList.append(NoteCell.FOOD)
        }
        
        if isLive {
            lineNote.frame.origin.y = collectLiveView.frame.origin.y + collectLiveView.frame.size.height + margin / 2 * 3
        } else {
            lineNote.frame.origin.y = lineLive.frame.origin.y
        }
        collectNoteView.frame.origin.y = lineNote.frame.origin.y + lineNote.frame.size.height + margin
        
        var noteLineCount = noteDateList.count / NoteCell.SPAN_COUNT_4
        if noteDateList.count % NoteCell.SPAN_COUNT_4 > 0 {
            noteLineCount += 1
        }
        collectNoteView.frame.size.height = itemHeight * CGFloat(noteLineCount)
        if noteLineCount > 1 {
            collectNoteView.frame.size.height += CGFloat(noteLineCount - 1) * lineMargin
        }
        collectNoteView.reloadData()
        
        // media
        let isMedia = custom.audio || custom.video || custom.album
        lineMedia.isHidden = !isMedia
        collectMediaView.isHidden = !isMedia
        mediaDateList.removeAll()
        if custom.audio {
            mediaDateList.append(NoteCell.AUDIO)
        }
        if custom.video {
            mediaDateList.append(NoteCell.VIDEO)
        }
        if custom.album {
            mediaDateList.append(NoteCell.ALBUM)
        }
        
        if isNote {
            lineMedia.frame.origin.y = collectNoteView.frame.origin.y + collectNoteView.frame.size.height + margin / 2 * 3
        } else {
            lineMedia.frame.origin.y = lineNote.frame.origin.y
        }
        collectMediaView.frame.origin.y = lineMedia.frame.origin.y + lineMedia.frame.size.height + margin
        
        var mediaLineCount = mediaDateList.count / NoteCell.SPAN_COUNT_4
        if mediaDateList.count % NoteCell.SPAN_COUNT_4 > 0 {
            mediaLineCount += 1
        }
        collectMediaView.frame.size.height = itemHeight * CGFloat(mediaLineCount)
        if mediaLineCount > 1 {
            collectMediaView.frame.size.height += CGFloat(mediaLineCount - 1) * lineMargin
        }
        collectMediaView.reloadData()
        
        // other
        let isOther = custom.total || custom.custom
        lineOther.isHidden = !isOther
        collectOtherView.isHidden = !isOther
        otherDateList.removeAll()
        if custom.custom {
            otherDateList.append(NoteCell.CUSTOM)
        }
        if custom.total {
            otherDateList.append(NoteCell.TOTAL)
        }
        
        if isMedia {
            lineOther.frame.origin.y = collectMediaView.frame.origin.y + collectMediaView.frame.size.height + margin / 2 * 3
        } else {
            lineOther.frame.origin.y = lineMedia.frame.origin.y
        }
        collectOtherView.frame.origin.y = lineOther.frame.origin.y + lineOther.frame.size.height + margin
        
        var otherLineCount = otherDateList.count / NoteCell.SPAN_COUNT_4
        if otherDateList.count % NoteCell.SPAN_COUNT_4 > 0 {
            otherLineCount += 1
        }
        collectOtherView.frame.size.height = itemHeight * CGFloat(otherLineCount)
        if otherLineCount > 1 {
            collectOtherView.frame.size.height += CGFloat(otherLineCount - 1) * lineMargin
        }
        collectOtherView.reloadData()
        
        // scroll
        scroll.contentSize.height = collectOtherView.frame.origin.y + collectOtherView.frame.size.height + 20
    }
    
    func refuseNext() -> Bool {
        if UserHelper.isCoupleBreak(couple: UDHelper.getCouple()) {
            // 无效配对
            CouplePairVC.pushVC()
            return true
        }
        if lock == nil {
            // 锁信息没有返回，防止没配对前就来过这里，配对后这里不刷新
            refreshData()
            return true
        } else if lock!.isLock {
            // 上锁且没有解开
            NoteLockVC.pushVC()
            return true
        }
        return false
    }
    
    @objc private func onLockChange(notify: NSNotification) {
        lock = notify.object as? Lock
        refreshData()
    }
    
    @objc private func refreshData() {
        if UserHelper.isCoupleBreak(couple: UDHelper.getCouple()) {
            // 无效配对
            ViewUtils.endScrollRefresh(self.scroll)
            lSouvenirEmpty.isHidden = false
            vSouvenirFull.isHidden = true
            return
        }
        ViewUtils.beginScrollRefresh(scroll)
        // api
        let api = Api.request(.noteHomeGet(near: DateUtils.getCurrentInt64()), success: { (_, _, data) in
            ViewUtils.endScrollRefresh(self.scroll)
            // lock
            self.lock = data.lock
            if self.lock == nil {
                // 默认没锁
                self.lock = Lock()
                self.lock?.isLock = false
            }
            // count
            let oldCC = UDHelper.getCommonCount()
            oldCC.noteTrendsNewCount = data.commonCount?.noteTrendsNewCount ?? 0
            UDHelper.setCommonCount(oldCC)
            // view
            self.refreshMenu()
            self.refreshNoteView(souvenir: data.souvenirLatest)
        }, failure: { (_, _, _) in
            ViewUtils.endScrollRefresh(self.scroll)
        })
        pushApi(api)
    }
    
    func refreshMenu() {
        let isLock = lock?.isLock ?? true
        let isTrends = UDHelper.getCommonCount().noteTrendsNewCount > 0
        barItemLock.image = UIImage(named: isLock ? "ic_lock_outline_white_24dp" : "ic_lock_open_white_24dp")?.withRenderingMode(.alwaysOriginal)
        barItemTrends.image = UIImage(named: isTrends ? "ic_notifications_none_point_white_24dp" : "ic_notifications_none_white_24dp")?.withRenderingMode(.alwaysOriginal)
    }
    
    func refreshNoteView(souvenir: Souvenir?) {
        stopSouvenirTimer() // 先停止倒计时
        if !UDHelper.getNoteCustom().souvenir {
            return
        } // 没展示
        if lock?.isLock ?? true {
            // 锁信息没有返回，或者是上锁且没有解开
            lSouvenirEmpty.isHidden = false
            vSouvenirFull.isHidden = true
            return
        }
        if souvenir == nil || souvenir!.id <= 0 {
            lSouvenirEmpty.isHidden = false
            vSouvenirFull.isHidden = true
            return
        }
        lSouvenirEmpty.isHidden = true
        vSouvenirFull.isHidden = false
        // data
        let dcNow = DateUtils.getCurrentDC()
        let dcHappen = DateUtils.getDC(souvenir?.happenAt)
        var dcTrigger = DateUtils.getDC(souvenir?.happenAt)
        dcTrigger.year = dcNow.year
        if DateUtils.getInt64(dcTrigger) < DateUtils.getInt64(dcNow) {
            // 是明年的
            dcTrigger.year = (dcTrigger.year ?? Int(DateUtils.getInt64(dcTrigger) / DateUtils.UNIT_YEAR + 1970)) + 1
        }
        let yearBetween = (dcTrigger.year ?? Int(DateUtils.getInt64(dcTrigger) / DateUtils.UNIT_YEAR + 1970)) - (dcHappen.year ?? Int(DateUtils.getInt64(dcHappen) / DateUtils.UNIT_YEAR + 1970))
        // view
        lSouvenirYear.text = StringUtils.getString("holder_anniversary", arguments: [yearBetween])
        lSouvenirTitle.text = souvenir?.title
        let oldWidth = lSouvenirYear.frame.size.width
        lSouvenirYear.sizeToFit()
        let widthOffset = lSouvenirYear.frame.size.width - oldWidth
        lSouvenirTitle.frame.origin.x += widthOffset
        // countdown
        startSouvenirTimer(triggerTime: DateUtils.getInt64(dcTrigger))
    }
    
    private func startSouvenirTimer(triggerTime: Int64) {
        // 创建任务，会先执行一次
        souvenirTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: true, block: { (_) in
            let betweenTime = triggerTime - DateUtils.getCurrentInt64()
            if betweenTime <= 0 {
                self.stopSouvenirTimer() // 停止倒计时
                self.refreshData() // 刷新数据
            } else {
                self.lSouvenirCountdown.text = self.getSouvenirCountDownShow(betweenTime: betweenTime)
            }
        })
        // 立刻启动
        souvenirTimer?.fire()
    }
    
    private func stopSouvenirTimer() {
        souvenirTimer?.invalidate()
        souvenirTimer = nil
    }
    
    private func getSouvenirCountDownShow(betweenTime: Int64) -> String {
        let day = betweenTime / DateUtils.UNIT_DAY
        let hourTotal = betweenTime - (day * DateUtils.UNIT_DAY)
        let hour = hourTotal / DateUtils.UNIT_HOUR
        let minTotal = hourTotal - (hour * DateUtils.UNIT_HOUR)
        let min = minTotal / DateUtils.UNIT_MIN
        let secTotal = minTotal - (min * DateUtils.UNIT_MIN)
        let sec = secTotal / DateUtils.UNIT_SEC
        let hourF = hour >= 10 ? "" : "0"
        let minF = min >= 10 ? ":" : ":0"
        let secF = sec >= 10 ? ":" : ":0"
        let timeShow = String(day) + StringUtils.getString("dayT") + " " + hourF + String(hour) + minF + String(min) + secF + String(sec)
        return StringUtils.getString("count_down_space_holder", arguments: [timeShow])
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_NOTE_HOME)
    }
    
    @objc private func targetGoLock() {
        NoteLockVC.pushVC()
    }
    
    @objc private func targetGoTrends() {
        if refuseNext() {
            return
        }
        NoteTrendsListVC.pushVC()
    }
    
    @objc private func targetGoSouvenir() {
        if refuseNext() {
            return
        }
        NoteSouvenirVC.pushVC()
    }
    
}
