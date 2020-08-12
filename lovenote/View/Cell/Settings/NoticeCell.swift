//
//  NoticeCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/2/12.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoticeCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    
    private static let MARGIN = ScreenUtils.widthFit(10)
    private static let MAX_WIDTH = ScreenUtils.getScreenWidth() - MARGIN * 2
    
    // view
    private var vRoot: UIView!
    private var lTime: UILabel!
    private var lNoRead: UILabel!
    private var lTitle: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // noRead
        lNoRead = ViewHelper.getLabelPrimarySmall(text: StringUtils.getString("no_read"), lines: 1, align: .right)
        lNoRead.frame.origin = CGPoint(x: NoticeCell.MAX_WIDTH - NoticeCell.MARGIN - lNoRead.frame.size.width, y: NoticeCell.MARGIN)
        lNoRead.textColor = ColorHelper.getRedDark()
        
        // time
        lTime = ViewHelper.getLabelGreySmall(text: "-", lines: 1, align: .left)
        lTime.frame.size.width = NoticeCell.MAX_WIDTH - NoticeCell.MARGIN * 3 - lNoRead.frame.size.width
        lTime.frame.origin = CGPoint(x: NoticeCell.MARGIN, y: NoticeCell.MARGIN)
        
        // title
        lTitle = ViewHelper.getLabelBlackNormal(width: NoticeCell.MAX_WIDTH - NoticeCell.MARGIN * 2, text: "-", lines: 1, align: .left)
        lTitle.frame.origin = CGPoint(x: NoticeCell.MARGIN, y: lTime.frame.origin.y + lTime.frame.size.height + NoticeCell.MARGIN)
        
        // root
        vRoot = UIView(frame: CGRect(x: NoticeCell.MARGIN, y: NoticeCell.MARGIN / 2, width: NoticeCell.MAX_WIDTH, height: lTitle.frame.origin.y + lTitle.frame.size.height + NoticeCell.MARGIN))
        vRoot.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vRoot, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vRoot, offset: ViewHelper.SHADOW_NORMAL)
        
        vRoot.addSubview(lTime)
        vRoot.addSubview(lNoRead)
        vRoot.addSubview(lTitle)
        
        // view
        self.contentView.addSubview(vRoot)
    }
    
    public static func getCellHeight(view: UITableView, indexPath: IndexPath) -> CGFloat {
        if totalHeight == nil {
            let cell = NoticeCell(style: .default, reuseIdentifier: NoticeCell.ID)
            totalHeight = cell.vRoot.frame.origin.y * 2 + cell.vRoot.frame.size.height
        }
        return totalHeight!
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Notice]?) -> NoticeCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? NoticeCell
        if cell == nil {
            cell = NoticeCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= indexPath.row {
            return cell!
        }
        let notice = dataList![indexPath.row]
        let create = TimeHelper.getTimeShowLine_HM_MD_YMD_ByGo(notice.createAt)
        
        // view
        cell?.lTime.text = create
        cell?.lTitle.text = notice.title
        cell?.lNoRead.isHidden = notice.read
        
        return cell!
    }
    
}
