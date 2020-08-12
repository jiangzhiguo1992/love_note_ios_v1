//
//  HelpSubCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/2/12.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class HelpSubCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    
    private static let MARGIN = ScreenUtils.widthFit(10)
    private static let MAX_WIDTH = ScreenUtils.getScreenWidth() - MARGIN * 2
    
    // view
    private var vRoot: UIView!
    private var lTitle: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // img
        let ivHelp = ViewHelper.getImageView(img: UIImage(named: "ic_help_outline_grey_24dp"))
        ivHelp.frame.origin = CGPoint(x: HelpSubCell.MARGIN, y: HelpSubCell.MARGIN)
        
        // title
        lTitle = ViewHelper.getLabelGreyNormal(width: HelpSubCell.MAX_WIDTH - ivHelp.frame.origin.x - ivHelp.frame.size.width - HelpSubCell.MARGIN, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lTitle.frame.origin = CGPoint(x: ivHelp.frame.origin.x + ivHelp.frame.size.width + HelpSubCell.MARGIN, y: HelpSubCell.MARGIN)
        
        // root
        vRoot = UIView(frame: CGRect(x: HelpSubCell.MARGIN, y: HelpSubCell.MARGIN / 2, width: HelpSubCell.MAX_WIDTH, height: CountHelper.getMax(ivHelp.frame.size.height, lTitle.frame.size.height) + HelpSubCell.MARGIN * 2))
        vRoot.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vRoot, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vRoot, offset: ViewHelper.SHADOW_NORMAL)
        
        ivHelp.center.y = vRoot.frame.size.height / 2
        lTitle.center.y = vRoot.frame.size.height / 2
        
        vRoot.addSubview(ivHelp)
        vRoot.addSubview(lTitle)
        
        // view
        self.contentView.addSubview(vRoot)
    }
    
    public static func getCellHeight(view: UITableView, indexPath: IndexPath) -> CGFloat {
        if totalHeight == nil {
            let cell = HelpSubCell(style: .default, reuseIdentifier: HelpSubCell.ID)
            totalHeight = cell.vRoot.frame.size.height + cell.vRoot.frame.origin.y * 2
        }
        return totalHeight!
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Help]?) -> HelpSubCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? HelpSubCell
        if cell == nil {
            cell = HelpSubCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= indexPath.row {
            return cell!
        }
        let help = dataList![indexPath.row]
        
        // view
        cell?.lTitle.text = help.title
        
        return cell!
    }
    
}
