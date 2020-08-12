//
//  NoteSleepCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/15.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteSleepCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    
    private static let MARGIN = ScreenUtils.widthFit(10)
    private static let MAX_WIDTH = (ScreenUtils.getScreenWidth() - MARGIN * 3) / 2
    
    // view
    private var vRoot: UIView!
    private var btnTime: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // time
        btnTime = ViewHelper.getBtnBold(width: NoteSleepCell.MAX_WIDTH, paddingV: NoteSleepCell.MARGIN / 2, HAlign: .center, VAlign: .center, title: "-", titleSize: ViewHelper.FONT_SIZE_NORMAL, titleColor: ColorHelper.getFontWhite(), titleLines: 1, titleAlign: .center, titleMode: .byTruncatingMiddle)
        btnTime.frame.origin = CGPoint(x: 0, y: 0)
        
        // root
        vRoot = UIView(frame: CGRect(x: 0, y: 0, width: NoteSleepCell.MAX_WIDTH, height: btnTime.frame.size.height))
        vRoot.addSubview(btnTime)
        
        // view
        self.contentView.addSubview(vRoot)
    }
    
    public static func getCellHeight() -> CGFloat {
        if totalHeight == nil {
            let cell = NoteSleepCell(style: .default, reuseIdentifier: NoteSleepCell.ID)
            totalHeight = cell.vRoot.frame.size.height
        }
        return totalHeight!
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Sleep]?) -> NoteSleepCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? NoteSleepCell
        if cell == nil {
            cell = NoteSleepCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= indexPath.row {
            return cell!
        }
        let sleep = dataList![indexPath.row]
        let create = StringUtils.getString(sleep.isSleep ? "holder_colon_sleep" : "holder_colon_wake" , arguments: [DateUtils.getStr(sleep.createAt, DateUtils.FORMAT_H_M)])
        
        // view
        cell?.btnTime.setTitle(create, for: .normal)
        
        return cell!
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Sleep]?, target: Any?, actionDel: Selector) -> NoteSleepCell {
        let cell = getCellWithData(view: view, indexPath: indexPath, dataList: dataList)
        // target
        cell.btnTime.addTarget(target, action: actionDel, for: .touchUpInside)
        return cell
    }
    
}
