//
//  HelpContentCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/2/12.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class HelpContentCell: BaseTableCell {
    
    // const
    private static let MARGIN = ScreenUtils.widthFit(10)
    private static let MAX_WIDTH = ScreenUtils.getScreenWidth() - MARGIN * 2
    
    // view
    private var vRoot: UIView!
    private var lTop: UILabel!
    private var lBottom: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // top
        lTop = ViewHelper.getLabelBold(width: HelpContentCell.MAX_WIDTH, text: "-", color: ColorHelper.getFontBlack(), lines: 0, align: .left)
        lTop.frame.origin = CGPoint(x: HelpContentCell.MARGIN, y: 0)
        
        // bottom
        lBottom = ViewHelper.getLabelGreyNormal(width: HelpContentCell.MAX_WIDTH, text: "-", lines: 0, align: .left)
        lBottom.frame.origin = CGPoint(x: HelpContentCell.MARGIN, y: lTop.frame.origin.y + lTop.frame.size.height + HelpContentCell.MARGIN / 2)
        
        // root
        vRoot = UIView(frame: CGRect(x: 0, y: HelpContentCell.MARGIN / 2, width: HelpContentCell.MAX_WIDTH, height: lBottom.frame.origin.y + lBottom.frame.size.height + HelpContentCell.MARGIN / 2))
        
        vRoot.addSubview(lTop)
        vRoot.addSubview(lBottom)
        
        // view
        self.contentView.addSubview(vRoot)
    }
    
    public static func getCellHeight(view: UITableView, indexPath: IndexPath, dataList: [HelpContent]?) -> CGFloat {
        let cell = HelpContentCell(style: .default, reuseIdentifier: HelpContentCell.ID)
        // data
        if dataList == nil || dataList!.count <= indexPath.row {
            return CGFloat(0)
        }
        let help = dataList![indexPath.row]
        // height
        let marginHeight = cell.vRoot.frame.origin.y * 3
        let topHeight = ViewUtils.getFontHeight(font: cell.lTop.font, width: cell.lTop.frame.size.width, text: help.question)
        let bottomHeight = ViewUtils.getFontHeight(font: cell.lBottom.font, width: cell.lBottom.frame.size.width, text: help.answer)
        return topHeight + bottomHeight + marginHeight
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [HelpContent]?) -> HelpContentCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? HelpContentCell
        if cell == nil {
            cell = HelpContentCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= indexPath.row {
            return cell!
        }
        let helpContent = dataList![indexPath.row]
        
        // view
        cell?.lTop.text = helpContent.question
        cell?.lBottom.text = helpContent.answer
        
        // size
        let oldTopHeight = cell!.lTop.frame.size.height
        cell!.lTop.sizeToFit()
        let topHeightOffset = cell!.lTop.frame.size.height - oldTopHeight
        cell!.lBottom.frame.origin.y += topHeightOffset
        
        cell!.lBottom.sizeToFit()
        
        return cell!
    }
    
}
