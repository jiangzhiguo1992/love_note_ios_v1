//
//  MapSelectCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/17.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import AMapSearchKit

class MapSelectCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    private static var addressWidth: CGFloat?
    private static var addressHeight: CGFloat?
    private static var addressFont: UIFont?
    
    private static let MARGIN = ScreenUtils.widthFit(10)
    private static let MAX_WIDTH = ScreenUtils.getScreenWidth() - MARGIN * 2
    private static let DISTANCE_WIDTH = ScreenUtils.widthFit(100)
    
    // view
    private var lAddress: UILabel!
    private var lLocation: UILabel!
    private var lDistance: UILabel!
    
    // var
    private static var heightMap: [Int: CGFloat] = [Int: CGFloat]()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // line
        let vLine = ViewHelper.getViewLine(width: ScreenUtils.getScreenWidth())
        vLine.frame.origin = CGPoint(x: 0, y: 0)
        
        // address
        lAddress = ViewHelper.getLabelBlackNormal(width: MapSelectCell.MAX_WIDTH, text: "-", lines: 0, align: .left)
        lAddress.frame.origin = CGPoint(x: MapSelectCell.MARGIN, y: MapSelectCell.MARGIN)
        
        // location
        lLocation = ViewHelper.getLabelGreySmall(width: MapSelectCell.MAX_WIDTH - MapSelectCell.DISTANCE_WIDTH - MapSelectCell.MARGIN, text: "-", lines: 1, align: .left, mode: .byTruncatingMiddle)
        lLocation.frame.origin = CGPoint(x: MapSelectCell.MARGIN, y: lAddress.frame.origin.y + lAddress.frame.size.height + MapSelectCell.MARGIN)
        
        // distance
        lDistance = ViewHelper.getLabelGreySmall(width: MapSelectCell.DISTANCE_WIDTH, text: "-", lines: 1, align: .right, mode: .byTruncatingTail)
        lDistance.frame.origin = CGPoint(x: lLocation.frame.origin.x + lLocation.frame.size.width + MapSelectCell.MARGIN, y: lAddress.frame.origin.y + lAddress.frame.size.height + MapSelectCell.MARGIN)
        
        // view
        self.contentView.addSubview(vLine)
        self.contentView.addSubview(lAddress)
        self.contentView.addSubview(lLocation)
        self.contentView.addSubview(lDistance)
    }
    
    public static func getCellHeight(view: UITableView, indexPath: IndexPath, dataList: [AMapPOI]?) -> CGFloat {
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
        let poi = dataList![row]
        return getHeightByData(poi: poi)
    }
    
    public static func refreshHeightMap(refresh: Bool, start: Int, dataList: [AMapPOI]?) {
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
        for (index, poi) in dataList!.enumerated() {
            let height = getHeightByData(poi: poi)
            heightMap[index + startIndex] = height
        }
    }
    
    private static func getHeightByData(poi: AMapPOI) -> CGFloat {
        // const
        if totalHeight == nil || addressHeight == nil {
            let cell = MapSelectCell(style: .default, reuseIdentifier: MapSelectCell.ID)
            totalHeight = cell.lLocation.frame.origin.y + cell.lLocation.frame.size.height + cell.lAddress.frame.origin.y
            addressWidth = cell.lAddress.frame.size.width
            addressHeight = cell.lAddress.frame.size.height
            addressFont = cell.lAddress.font
        }
        // offset
        let height = ViewUtils.getFontHeight(font: addressFont, width: addressWidth, text: poi.name)
        let heightOffset = height - addressHeight!
        return totalHeight! + heightOffset
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [AMapPOI]?, select: Bool = false) -> MapSelectCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? MapSelectCell
        if cell == nil {
            cell = MapSelectCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        // data
        if dataList == nil || dataList!.count <= cell!.tag {
            return cell!
        }
        let poi = dataList![cell!.tag]
        
        // view
        cell?.lAddress.text = poi.name
        cell?.lLocation.text = poi.address
        cell?.lDistance.text = StringUtils.getString("distance_colon_space_holder", arguments: [poi.distance])
        
        cell?.setSelectState(select: select)
        
        // size
        AppDelegate.runOnMainAsync {
            let cellHeight = getCellHeight(view: view, indexPath: indexPath, dataList: dataList)
            let lAddressHeight = cellHeight - (totalHeight ?? 0) + (addressHeight ?? 0)
            let heightOffset = lAddressHeight - (cell?.lAddress.frame.size.height ?? lAddressHeight)
            if (cell?.lAddress.frame.size.height ?? 0) != lAddressHeight {
                cell?.lAddress.frame.size.height = lAddressHeight
                
                cell?.lLocation.frame.origin.y += heightOffset
                cell?.lDistance.frame.origin.y += heightOffset
            }
        }
        return cell!
    }
    
    public func setSelectState(select: Bool = false) {
        if !select {
            self.backgroundColor = ColorHelper.getBackground()
            self.lAddress.textColor = ColorHelper.getFontBlack()
            self.lLocation.textColor = ColorHelper.getFontGrey()
            self.lDistance.textColor = ColorHelper.getFontGrey()
        } else {
            self.backgroundColor = ThemeHelper.getColorPrimary()
            self.lAddress.textColor = ColorHelper.getFontWhite()
            self.lLocation.textColor = ColorHelper.getFontWhite()
            self.lDistance.textColor = ColorHelper.getFontWhite()
        }
    }
    
}
