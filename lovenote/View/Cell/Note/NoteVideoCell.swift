//
//  NoteVideoCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/30.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteVideoCell: BaseCollectCell {
    
    // const
    private static let CELL_MARGIN = ScreenUtils.widthFit(10)
    private static let ITEM_MARGIN = ScreenUtils.widthFit(10)
    private static let AVATAR_WIDTH = ScreenUtils.widthFit(15)
    private static let ITEM_MARGIN_SMALL = ITEM_MARGIN / 2
    
    // view
    private var ivThumb: UIImageView!
    private var btnAddress: UIButton!
    private var lDuration: UILabel!
    private var lTitle: UILabel!
    private var ivAvatar: UIImageView!
    private var lHappenAt: UILabel!
    private var btnMore: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let maxWidth = frame.size.width
        let maxHeight = frame.size.height
        
        // title
        lTitle = ViewHelper.getLabelBlackNormal(width: maxWidth - NoteVideoCell.ITEM_MARGIN * 2, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        
        // avatar
        ivAvatar = ViewHelper.getImageViewAvatar(width: NoteVideoCell.AVATAR_WIDTH, height: NoteVideoCell.AVATAR_WIDTH)
        
        // happenAt
        lHappenAt = ViewHelper.getLabelGreySmall(text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        
        // more
        btnMore = ViewHelper.getBtnImgCenter(height: lHappenAt.frame.size.height, paddingH: NoteVideoCell.ITEM_MARGIN, paddingV: NoteVideoCell.ITEM_MARGIN_SMALL, bgImg: UIImage(named: "ic_more_horiz_grey_18dp"))
        lHappenAt.frame.size.width = maxWidth - NoteVideoCell.AVATAR_WIDTH - NoteVideoCell.ITEM_MARGIN * 2 - NoteVideoCell.ITEM_MARGIN_SMALL - btnMore.frame.size.width
        
        // topView
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: maxWidth, height: maxHeight - NoteVideoCell.ITEM_MARGIN * 2 - NoteVideoCell.ITEM_MARGIN_SMALL - lTitle.frame.size.height - CountHelper.getMax(ivAvatar.frame.size.height, lHappenAt.frame.size.height)))
        topView.backgroundColor = ColorHelper.getBlack()
        ViewUtils.setViewCorner(topView, corner: ViewHelper.RADIUS_NORMAL, round: [.topLeft, .topRight])
        
        lTitle.frame.origin = CGPoint(x: NoteVideoCell.ITEM_MARGIN, y: topView.frame.origin.y + topView.frame.size.height + NoteVideoCell.ITEM_MARGIN)
        ivAvatar.frame.origin = CGPoint(x: NoteVideoCell.ITEM_MARGIN, y: lTitle.frame.origin.y + lTitle.frame.size.height + NoteVideoCell.ITEM_MARGIN)
        lHappenAt.frame.origin.x = ivAvatar.frame.origin.x + ivAvatar.frame.size.width + NoteVideoCell.ITEM_MARGIN_SMALL
        lHappenAt.center.y = ivAvatar.center.y
        btnMore.frame.origin.x = maxWidth - btnMore.frame.size.width
        btnMore.center.y = ivAvatar.center.y
        
        // thumb
        ivThumb = ViewHelper.getImageViewUrl(width: topView.frame.size.width, height: topView.frame.size.height, indicator: false, radius: 0)
        ivThumb.frame.origin = CGPoint(x: 0, y: 0)
        ivThumb.layer.masksToBounds = true // 不加会超出frame
        ivThumb.backgroundColor = ColorHelper.getBlack()
        
        // address
        btnAddress = ViewHelper.getBtnImgCenter(paddingH: NoteVideoCell.ITEM_MARGIN, paddingV: NoteVideoCell.ITEM_MARGIN, bgImg: UIImage(named: "ic_location_on_white_18dp"))
        btnAddress.frame.origin = CGPoint(x: 0, y: topView.frame.size.height - btnAddress.frame.size.height)
        
        // duration
        lDuration = ViewHelper.getLabelWhiteSmall(width: maxWidth - btnAddress.frame.size.width - NoteVideoCell.ITEM_MARGIN , text: "--:--", lines: 1, align: .right, mode: .byTruncatingTail)
        lDuration.frame.origin = CGPoint(x: btnAddress.frame.origin.x + btnAddress.frame.size.width, y: topView.frame.size.height - NoteVideoCell.ITEM_MARGIN - lDuration.frame.size.height)
        
        topView.addSubview(ivThumb)
        topView.addSubview(btnAddress)
        topView.addSubview(lDuration)
        
        // card
        let vCard = UIView()
        vCard.frame.size = CGSize(width: maxWidth, height: ivAvatar.frame.origin.y + ivAvatar.frame.size.height + NoteVideoCell.ITEM_MARGIN_SMALL)
        vCard.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCard, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vCard, offset: ViewHelper.SHADOW_NORMAL)
        vCard.addSubview(topView)
        vCard.addSubview(lTitle)
        vCard.addSubview(ivAvatar)
        vCard.addSubview(lHappenAt)
        vCard.addSubview(btnMore)
        
        // view
        self.addSubview(vCard)
        
        // hide
        ivThumb.isHidden = true
        btnAddress.isHidden = true
        btnMore.isHidden = true
    }
    
    public static func getLayout(maxWidth: CGFloat = ScreenUtils.getScreenWidth() - CELL_MARGIN * 2, margin: CGFloat = CELL_MARGIN, spanCount: Int = SPAN_COUNT_2) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = getItemSize(maxWidth: maxWidth, margin: margin, spanCount: spanCount)
        // collect间隙的margin
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        // collect本身的margin
        layout.sectionInset = UIEdgeInsets.init(top: margin, left: margin, bottom: margin, right: margin)
        return layout
    }
    
    private static func getItemSize(maxWidth: CGFloat = ScreenUtils.getScreenWidth() - CELL_MARGIN * 2, margin: CGFloat = CELL_MARGIN, spanCount: Int = SPAN_COUNT_2) -> CGSize {
        let itemWidth = spanCount > 1 ? ((maxWidth - margin * CGFloat(spanCount - 1)) / CGFloat(spanCount)) : maxWidth
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    public static func getMuliCellHeight(dataList: [Video]?, spanCount: Int = SPAN_COUNT_2) -> CGFloat {
        if dataList == nil || dataList!.count <= 0 {
            return CGFloat(0)
        }
        let layout = getLayout(spanCount: spanCount)
        var totalHeight = CGFloat(dataList!.count / spanCount) * (layout.itemSize.height + layout.sectionInset.top + layout.sectionInset.bottom)
        totalHeight += (dataList!.count % spanCount) > 0 ? (layout.itemSize.height + layout.sectionInset.top + layout.sectionInset.bottom) : 0
        return totalHeight
    }
    
    public static func getCellWithData(view: UICollectionView, indexPath: IndexPath, dataList: [Video]?, target: Any?, actionAddress: Selector) -> NoteVideoCell {
        let cell = view.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath) as! NoteVideoCell
        cell.tag = indexPath.item
        // data
        if dataList == nil || dataList!.count <= cell.tag {
            return cell
        }
        let video = dataList![cell.tag]
        let me = UDHelper.getMe()
        let avatar = UserHelper.getAvatar(user: me, uid: video.userId)
        // view
        cell.btnMore.isHidden = true
        cell.ivThumb.image = nil
        if StringUtils.isEmpty(video.contentThumb) {
            cell.ivThumb.isHidden = true
        } else {
            cell.ivThumb.isHidden = false
            KFHelper.setImgUrl(iv: cell.ivThumb, objKey: video.contentThumb)
        }
        KFHelper.setImgAvatarUrl(iv: cell.ivAvatar, objKey: avatar, uid: video.userId)
        cell.btnAddress.isHidden = StringUtils.isEmpty(video.address)
        cell.lDuration.text = ShowHelper.getDurationShow(video.duration)
        cell.lTitle.text = video.title
        cell.lHappenAt.text = TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(video.happenAt)
        // target
        cell.btnAddress.addTarget(target, action: actionAddress, for: .touchUpInside)
        return cell
    }
    
    public static func getCellWithData(view: UICollectionView, indexPath: IndexPath, dataList: [Video]?, target: Any?, actionAddress: Selector, actionMore: Selector) -> NoteVideoCell {
        let cell = getCellWithData(view: view, indexPath: indexPath, dataList: dataList, target: target, actionAddress: actionAddress)
        cell.btnMore.isHidden = false
        cell.btnMore.addTarget(target, action: actionMore, for: .touchUpInside)
        return cell
    }
    
    public static func goPlay(view: UICollectionView, indexPath: IndexPath, dataList: [Video]?) {
        if dataList == nil || dataList!.count <= indexPath.item {
            return
        }
        let video = dataList![indexPath.item]
        VideoPlayVC.pushVC(title: video.title, ossKey: video.contentVideo)
    }
    
    public static func selectVideo(view: UICollectionView, indexPath: IndexPath, dataList: [Video]?) {
        RootVC.get().popBack()
        if dataList == nil || dataList!.count <= indexPath.item {
            return
        }
        let video = dataList![indexPath.item]
        NotifyHelper.post(NotifyHelper.TAG_VIDEO_SELECT, obj: video)
    }
    
    public static func goMap(view: UIView?, dataList: [Video]?) {
        if let indexPath = ViewUtils.findCollectIndexPath(view: view) {
            if dataList == nil || dataList!.count <= indexPath.item {
                return
            }
            let video = dataList![indexPath.item]
            MapShowVC.pushVC(address: video.address, lon: video.longitude, lat: video.latitude)
        }
    }
    
}
