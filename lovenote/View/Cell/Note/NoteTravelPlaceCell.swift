//
//  NoteTravelPlaceCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/2.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteTravelPlaceCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    private static var contentWidth: CGFloat?
    private static var contentFont: UIFont?
    
    private static let ITEM_MARGIN = ScreenUtils.widthFit(10)
    private static let CARD_WIDTH = ScreenUtils.getScreenWidth() - ITEM_MARGIN * 2
    private static let CARD_CONTENT_WIDTH = CARD_WIDTH - ITEM_MARGIN * 2
    
    // view
    private var vCard: UIView!
    private var btnMore: UIButton!
    private var lContent: UILabel!
    private var lHappenAt: UILabel!
    private var lAddress: UILabel!
    
    // var
    private static var heightMap: [Int: CGFloat] = [Int: CGFloat]()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // more
        btnMore = ViewHelper.getBtnImgCenter(paddingH: NoteTravelPlaceCell.ITEM_MARGIN, paddingV: NoteTravelPlaceCell.ITEM_MARGIN, bgImg: UIImage(named: "ic_more_horiz_grey_18dp"))
        btnMore.frame.origin = CGPoint(x: NoteTravelPlaceCell.CARD_WIDTH - btnMore.frame.size.width, y: 0)
        
        // content
        lContent = ViewHelper.getLabelBlackNormal(width: NoteTravelPlaceCell.CARD_CONTENT_WIDTH - btnMore.frame.size.width, height: CGFloat(0), text: "-", lines: 0, align: .left)
        lContent.frame.origin = CGPoint(x: NoteTravelPlaceCell.ITEM_MARGIN, y: NoteTravelPlaceCell.ITEM_MARGIN)
        
        // happen
        lHappenAt = ViewHelper.getLabelGreySmall(width: (NoteTravelPlaceCell.CARD_CONTENT_WIDTH - NoteTravelPlaceCell.ITEM_MARGIN) / 2, text: "-", lines: 1, align: .left, mode: .byTruncatingMiddle)
        lHappenAt.frame.origin.x = NoteTravelPlaceCell.ITEM_MARGIN
        lHappenAt.frame.origin.y = lContent.frame.origin.y + lContent.frame.size.height + NoteTravelPlaceCell.ITEM_MARGIN
        
        // address
        lAddress = ViewHelper.getLabelGreySmall(width: (NoteTravelPlaceCell.CARD_CONTENT_WIDTH - NoteTravelPlaceCell.ITEM_MARGIN) / 2, text: "-", lines: 1, align: .right, mode: .byTruncatingMiddle)
        lAddress.frame.origin.x = lHappenAt.frame.origin.x + lHappenAt.frame.size.width + NoteTravelPlaceCell.ITEM_MARGIN
        lAddress.frame.origin.y = lContent.frame.origin.y + lContent.frame.size.height + NoteTravelPlaceCell.ITEM_MARGIN
        
        // card
        vCard = UIView(frame: CGRect(x: NoteTravelPlaceCell.ITEM_MARGIN, y: NoteTravelPlaceCell.ITEM_MARGIN / 2, width: NoteTravelPlaceCell.CARD_WIDTH, height: lHappenAt.frame.origin.y + lHappenAt.frame.size.height + NoteTravelPlaceCell.ITEM_MARGIN))
        vCard.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCard, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vCard, offset: ViewHelper.SHADOW_NORMAL)
        
        vCard.addSubview(btnMore)
        vCard.addSubview(lContent)
        vCard.addSubview(lHappenAt)
        vCard.addSubview(lAddress)
        
        // view
        self.contentView.addSubview(vCard)
        
        // hide
        btnMore.isHidden = true
    }
    
    public static func getHeightByData(margin: CGFloat = ITEM_MARGIN, travelPlace: TravelPlace) -> CGFloat {
        // const
        if totalHeight == nil || contentWidth == nil || contentFont == nil {
            let cell = NoteTravelPlaceCell(style: .default, reuseIdentifier: NoteTravelPlaceCell.ID)
            totalHeight = cell.vCard.frame.origin.y + cell.vCard.frame.size.height + margin / 2
            contentWidth = cell.lContent.frame.size.width
            contentFont = cell.lContent.font
        }
        // offset
        let height = ViewUtils.getFontHeight(font: contentFont, width: contentWidth, text: travelPlace.contentText)
        return totalHeight! + height
    }
    
    public static func getMuliCellHeight(dataList: [TravelPlace]?) -> CGFloat {
        if dataList == nil || dataList!.count <= 0 {
            return CGFloat(0)
        }
        var totalHeight = CGFloat(0)
        for travelPlace in dataList! {
            totalHeight += getHeightByData(travelPlace: travelPlace)
        }
        return totalHeight
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [TravelPlace]?) -> NoteTravelPlaceCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? NoteTravelPlaceCell
        if cell == nil {
            cell = NoteTravelPlaceCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= cell!.tag {
            return cell!
        }
        let travelPlace = dataList![cell!.tag]
        
        // view
        cell?.lContent.text = travelPlace.contentText
        cell?.lHappenAt.text = TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(travelPlace.happenAt)
        cell?.lAddress.text = StringUtils.isEmpty(travelPlace.address) ? StringUtils.getString("now_no_address_info") : travelPlace.address
        
        // size
        AppDelegate.runOnMainAsync {
            let cellHeight = getHeightByData(travelPlace: travelPlace)
            let vCardHeight = cellHeight - ITEM_MARGIN
            let lContentHeight = cellHeight - (totalHeight ?? 0)
            if (cell?.vCard.frame.size.height ?? 0) != vCardHeight {
                cell?.vCard.frame.size.height = vCardHeight
            }
            ViewUtils.setViewShadow(cell?.vCard, offset: ViewHelper.SHADOW_NORMAL)
            if (cell?.lContent.frame.size.height ?? 0) != lContentHeight {
                cell?.lContent.frame.size.height = lContentHeight
            }
            cell?.lHappenAt.frame.origin.y = (cell?.lContent.frame.origin.y ?? 0) + (cell?.lContent.frame.size.height ?? 0) + ITEM_MARGIN
            cell?.lAddress.frame.origin.y = (cell?.lContent.frame.origin.y ?? 0) + (cell?.lContent.frame.size.height ?? 0) + ITEM_MARGIN
        }
        
        return cell!
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [TravelPlace]?, target: Any?, actionEdit: Selector) -> NoteTravelPlaceCell {
        let cell = getCellWithData(view: view, indexPath: indexPath, dataList: dataList)
        cell.btnMore.isHidden = false
        cell.btnMore.addTarget(target, action: actionEdit, for: .touchUpInside)
        return cell
    }
    
    public static func goMap(view: UITableView, indexPath: IndexPath, dataList: [TravelPlace]?) {
        if dataList == nil || dataList!.count <= indexPath.row {
            return
        }
        let travelPlace = dataList![indexPath.row]
        MapShowVC.pushVC(address: travelPlace.address, lon: travelPlace.longitude, lat: travelPlace.latitude)
    }
    
}
