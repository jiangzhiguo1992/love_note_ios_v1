//
//  NoteSouvenirCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/6.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteSouvenirCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    
    private static let ITEM_MARGIN = ScreenUtils.widthFit(10)
    private static let CARD_WIDTH = ScreenUtils.getScreenWidth() - ITEM_MARGIN * 2
    private static let CARD_CONTENT_WIDTH = CARD_WIDTH - ITEM_MARGIN * 2
    
    // view
    private var vCard: UIView!
    private var lTitle: UILabel!
    private var lHappenAt: UILabel!
    private var lDayCount: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // dayCount
        lDayCount = ViewHelper.getLabelBold(text: "-", size: ScreenUtils.fontFit(40), color: ThemeHelper.getColorPrimary(), lines: 1, align: .right, mode: .byTruncatingMiddle)
        lDayCount.frame.origin.x = NoteSouvenirCell.CARD_WIDTH - lDayCount.frame.size.width - NoteSouvenirCell.ITEM_MARGIN
        lDayCount.frame.origin.y = NoteSouvenirCell.ITEM_MARGIN
        
        // title
        let titleWidth = NoteSouvenirCell.CARD_CONTENT_WIDTH - NoteSouvenirCell.ITEM_MARGIN - lDayCount.frame.size.width
        lTitle = ViewHelper.getLabelBold(width: titleWidth, text: "-", size: ViewHelper.FONT_SIZE_HUGE, color: ColorHelper.getFontBlack(), lines: 1, align: .left, mode: .byTruncatingTail)
        lTitle.frame.origin.x = NoteSouvenirCell.ITEM_MARGIN
        lTitle.frame.origin.y = NoteSouvenirCell.ITEM_MARGIN
        
        // happen
        lHappenAt = ViewHelper.getLabelGreyNormal(width: titleWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lHappenAt.frame.origin.x = NoteSouvenirCell.ITEM_MARGIN
        lHappenAt.frame.origin.y = lDayCount.frame.origin.y + lDayCount.frame.size.height - lHappenAt.frame.size.height
        
        // card
        vCard = UIView(frame: CGRect(x: NoteSouvenirCell.ITEM_MARGIN, y: NoteSouvenirCell.ITEM_MARGIN / 2, width: NoteSouvenirCell.CARD_WIDTH, height: lDayCount.frame.origin.y + lDayCount.frame.size.height + NoteSouvenirCell.ITEM_MARGIN))
        vCard.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCard, radius: ViewHelper.RADIUS_BIG)
        ViewUtils.setViewShadow(vCard, offset: ViewHelper.SHADOW_NORMAL)
        
        vCard.addSubview(lTitle)
        vCard.addSubview(lHappenAt)
        vCard.addSubview(lDayCount)
        
        // view
        self.contentView.addSubview(vCard)
    }
    
    public static func getCellHeight(view: UITableView, indexPath: IndexPath) -> CGFloat {
        if totalHeight == nil {
            let cell = NoteSouvenirCell(style: .default, reuseIdentifier: NoteSouvenirCell.ID)
            totalHeight = cell.vCard.frame.origin.y * 2 + cell.vCard.frame.size.height
        }
        return totalHeight!
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Souvenir]?) -> NoteSouvenirCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? NoteSouvenirCell
        if cell == nil {
            cell = NoteSouvenirCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= cell!.tag {
            return cell!
        }
        let souvenir = dataList![cell!.tag]
        
        // view
        cell?.lTitle.text = souvenir.title
        cell?.lHappenAt.text = DateUtils.getStr(souvenir.happenAt, DateUtils.FORMAT_LINE_Y_M_D_H_M)
        if DateUtils.getCurrentInt64() > souvenir.happenAt {
            cell?.lDayCount.text = StringUtils.getString("add_holder", arguments: [(DateUtils.getCurrentInt64() - souvenir.happenAt) / DateUtils.UNIT_DAY])
        } else {
            cell?.lDayCount.text = StringUtils.getString("sub_holder", arguments: [(souvenir.happenAt - DateUtils.getCurrentInt64()) / DateUtils.UNIT_DAY])
        }
        
        // size
        AppDelegate.runOnMainAsync {
            cell?.lDayCount.frame.size.width = ViewUtils.getFontWidth(font: cell?.lDayCount.font, text: cell?.lDayCount.text)
            cell?.lDayCount.frame.origin.x = NoteSouvenirCell.CARD_WIDTH - (cell?.lDayCount.frame.size.width ?? 0) - NoteSouvenirCell.ITEM_MARGIN
            let titleWidth = NoteSouvenirCell.CARD_CONTENT_WIDTH - NoteSouvenirCell.ITEM_MARGIN - (cell?.lDayCount.frame.size.width ?? 0)
            cell?.lTitle.frame.size.width = titleWidth
            cell?.lHappenAt.frame.size.width = titleWidth
        }
        
        return cell!
    }
    
    public static func goSouvenirDetail(view: UITableView, indexPath: IndexPath, dataList: [Souvenir]?) {
        if dataList == nil || dataList!.count <= indexPath.row {
            return
        }
        let souvenir = dataList![indexPath.row]
        if souvenir.done {
            NoteSouvenirDetailDoneVC.pushVC(souvenir: souvenir)
        } else {
            NoteSouvenirDetailWishVC.pushVC(souvenir: souvenir)
        }
    }
    
}
