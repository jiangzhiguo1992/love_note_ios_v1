//
//  MoreMatchPeriodCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/5/8.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class MoreMatchPeriodCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    private static var contentFont: UIFont?
    
    private static let ITEM_MARGIN = ScreenUtils.widthFit(10)
    private static let ITEM_MARGIN_BIG = ITEM_MARGIN * 2
    private static let MAX_WIDTH = ScreenUtils.getScreenWidth()
    private static let CARD_WIDTH = MAX_WIDTH - ITEM_MARGIN * 2
    private static let CARD_CONTENT_WIDTH = CARD_WIDTH - ITEM_MARGIN * 2
    
    // view
    private var vCard: UIView!
    private var lTitle: UILabel!
    private var vBottom: UIView!
    private var lPeriod: UILabel!
    private var lCoinAward: UILabel!
    private var lWorkCount: UILabel!
    private var lCoinCount: UILabel!
    private var lPointCount: UILabel!
    
    // var
    private static var heightMap: [Int: CGFloat] = [Int: CGFloat]()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // title
        lTitle = ViewHelper.getLabelBold(width: MoreMatchPeriodCell.CARD_CONTENT_WIDTH, height: 0, text: "-", size: ViewHelper.FONT_SIZE_BIG, color: ThemeHelper.getColorPrimary(), lines: 0, align: .center)
        lTitle.frame.origin = CGPoint(x: MoreMatchPeriodCell.ITEM_MARGIN, y: MoreMatchPeriodCell.ITEM_MARGIN_BIG)
        
        // period
        lPeriod = ViewHelper.getLabelPrimarySmall(width: MoreMatchPeriodCell.CARD_CONTENT_WIDTH, text: "-", lines: 1, align: .center, mode: .byTruncatingMiddle)
        lPeriod.frame.origin = CGPoint(x: MoreMatchPeriodCell.ITEM_MARGIN, y: lTitle.frame.origin.y + lTitle.frame.size.height + MoreMatchPeriodCell.ITEM_MARGIN)
        
        // award
        lCoinAward = ViewHelper.getLabelBold(width: MoreMatchPeriodCell.CARD_CONTENT_WIDTH, text: "-", size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontWhite(), lines: 1, align: .center, mode: .byTruncatingMiddle)
        lCoinAward.frame.origin = CGPoint(x: MoreMatchPeriodCell.ITEM_MARGIN, y: MoreMatchPeriodCell.ITEM_MARGIN_BIG)
        
        // right
        let countWidth = (MoreMatchPeriodCell.CARD_CONTENT_WIDTH - MoreMatchPeriodCell.ITEM_MARGIN * 2) / 3
        let countY = lCoinAward.frame.origin.y + lCoinAward.frame.size.height + MoreMatchPeriodCell.ITEM_MARGIN_BIG
        lWorkCount = ViewHelper.getLabelBold(width: countWidth, text: "-", size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontWhite(), lines: 1, align: .center, mode: .byTruncatingMiddle)
        lWorkCount.frame.origin = CGPoint(x: MoreMatchPeriodCell.ITEM_MARGIN, y: countY)
        
        lCoinCount = ViewHelper.getLabelBold(width: countWidth, text: "-", size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontWhite(), lines: 1, align: .center, mode: .byTruncatingMiddle)
        lCoinCount.frame.origin = CGPoint(x: lWorkCount.frame.origin.x + lWorkCount.frame.size.width + MoreMatchPeriodCell.ITEM_MARGIN, y: countY)
        
        lPointCount = ViewHelper.getLabelBold(width: countWidth, text: "-", size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontWhite(), lines: 1, align: .center, mode: .byTruncatingMiddle)
        lPointCount.frame.origin = CGPoint(x: lCoinCount.frame.origin.x + lCoinCount.frame.size.width + MoreMatchPeriodCell.ITEM_MARGIN, y: countY)
        
        // bottom
        vBottom = UIView(frame: CGRect(x: 0, y: lPeriod.frame.origin.y + lPeriod.frame.size.height + MoreMatchPeriodCell.ITEM_MARGIN_BIG, width: MoreMatchPeriodCell.CARD_WIDTH, height: lWorkCount.frame.origin.y + lWorkCount.frame.size.height + MoreMatchPeriodCell.ITEM_MARGIN))
        vBottom.backgroundColor = ThemeHelper.getColorPrimary()
        ViewUtils.setViewCorner(vBottom, corner: ViewHelper.RADIUS_BIG, round: [.bottomLeft, .bottomRight])
        
        vBottom.addSubview(lCoinAward)
        vBottom.addSubview(lWorkCount)
        vBottom.addSubview(lCoinCount)
        vBottom.addSubview(lPointCount)
        
        // card
        vCard = UIView(frame: CGRect(x: MoreMatchPeriodCell.ITEM_MARGIN, y: MoreMatchPeriodCell.ITEM_MARGIN, width: MoreMatchPeriodCell.CARD_WIDTH, height: vBottom.frame.origin.y + vBottom.frame.size.height))
        vCard.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCard, radius: ViewHelper.RADIUS_BIG)
        ViewUtils.setViewShadow(vCard, offset: ViewHelper.SHADOW_BIG)
        
        vCard.addSubview(lTitle)
        vCard.addSubview(lPeriod)
        vCard.addSubview(vBottom)
        
        // view
        self.contentView.addSubview(vCard)
    }
    
    public static func getCellHeight(view: UITableView, indexPath: IndexPath, dataList: [MatchPeriod]?) -> CGFloat {
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
        let period = dataList![row]
        return getHeightByData(period: period)
    }
    
    public static func refreshHeightMap(refresh: Bool, start: Int, dataList: [MatchPeriod]?) {
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
        for (index, period) in dataList!.enumerated() {
            let height = getHeightByData(period: period)
            heightMap[index + startIndex] = height
        }
    }
    
    public static func getHeightByData(margin: CGFloat = ITEM_MARGIN, period: MatchPeriod) -> CGFloat {
        // const
        if totalHeight == nil || contentFont == nil {
            let cell = MoreMatchPeriodCell(style: .default, reuseIdentifier: MoreMatchPeriodCell.ID)
            totalHeight = cell.vCard.frame.origin.y + cell.vCard.frame.size.height + margin
            contentFont = cell.lTitle.font
        }
        // offset
        let height = ViewUtils.getFontHeight(font: contentFont, width: CARD_CONTENT_WIDTH, text: period.title)
        return totalHeight! + height
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [MatchPeriod]?, heightMap: Bool = true) -> MoreMatchPeriodCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? MoreMatchPeriodCell
        if cell == nil {
            cell = MoreMatchPeriodCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= cell!.tag {
            return cell!
        }
        let period = dataList![cell!.tag]
        let periodShow = StringUtils.getString("the_holder_period", arguments: [period.period])
        let time = StringUtils.getString("holder_space_to_space_holder", arguments: [DateUtils.getStr(period.startAt, DateUtils.FORMAT_LINE_M_D), DateUtils.getStr(period.endAt, DateUtils.FORMAT_LINE_M_D)])
        // view
        cell?.lTitle.text = period.title
        cell?.lPeriod.text = StringUtils.getString("holder_space_space_holder", arguments: [periodShow, time])
        cell?.lCoinAward.text = StringUtils.getString("go_in_award_colon_holder_coin", arguments: [period.coinChange])
        cell?.lWorkCount.text = StringUtils.getString("total_works_count_colon_holder", arguments: [ShowHelper.getShowCount2Thousand(period.worksCount)])
        cell?.lCoinCount.text = StringUtils.getString("total_coin_count_colon_holder", arguments: [ShowHelper.getShowCount2Thousand(period.coinCount)])
        cell?.lPointCount.text = StringUtils.getString("total_point_count_colon_holder", arguments: [ShowHelper.getShowCount2Thousand(period.pointCount)])
        
        // size
        AppDelegate.runOnMainAsync {
            let cellHeight = heightMap ? getCellHeight(view: view, indexPath: indexPath, dataList: dataList) : getHeightByData(period: period)
            let vCardHeight = cellHeight - ITEM_MARGIN * 2
            if (cell?.vCard.frame.size.height ?? 0) != vCardHeight {
                cell?.vCard.frame.size.height = vCardHeight
            }
            ViewUtils.setViewShadow(cell?.vCard, offset: ViewHelper.SHADOW_BIG)
            let lContentHeight = cellHeight - (totalHeight ?? 0)
            if (cell?.lTitle.frame.size.height ?? 0) != lContentHeight {
                cell?.lTitle.frame.size.height = lContentHeight
            }
            let periodY = (cell?.lTitle.frame.origin.y ?? 0) + (cell?.lTitle.frame.size.height ?? 0) + ITEM_MARGIN
            if (cell?.lPeriod.frame.origin.y ?? 0) != periodY {
                cell?.lPeriod.frame.origin.y = periodY
            }
            let bottomY = (cell?.lPeriod.frame.origin.y ?? 0) + (cell?.lPeriod.frame.size.height ?? 0) + ITEM_MARGIN_BIG
            if (cell?.vBottom.frame.origin.y ?? 0) != bottomY {
                cell?.vBottom.frame.origin.y = bottomY
            }
        }
        return cell!
    }
    
    public static func goWorkList(view: UITableView, indexPath: IndexPath, dataList: [MatchPeriod]?) {
        if dataList == nil || dataList!.count <= indexPath.row {
            return
        }
        let period = dataList![indexPath.row]
        if period.kind == MatchPeriod.MATCH_KIND_WIFE_PICTURE { // 照片墙
            MoreMatchWifeListVC.pushVC(pid: period.id, showNew: false)
        } else if period.kind == MatchPeriod.MATCH_KIND_LETTER_SHOW { // 情话集
            MoreMatchLetterListVC.pushVC(pid: period.id, showNew: false)
        }
    }
    
}
