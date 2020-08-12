//
//  CouplePlaceCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/21.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class CouplePlaceCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    private static var placeFont: UIFont?
    
    private static let MARGIN_H = ScreenUtils.widthFit(10)
    private static let MARGIN_V = ScreenUtils.heightFit(20)
    private static let MAX_WIDTH = ScreenUtils.getScreenWidth() - MARGIN_H * 2
    private static let MARGIN_ADDRESS = ScreenUtils.widthFit(5)
    private static let MAX_ADDRESS = CouplePlaceCell.MAX_WIDTH - MARGIN_ADDRESS * 2
    private static let AVATAR_WIDTH = ScreenUtils.widthFit(20)
    private static let MAIGIN_DISTANCE_H = ScreenUtils.widthFit(10)
    private static let MARGIN_DISTANCE_V = ScreenUtils.heightFit(4)
    
    // view
    private var vAddress: UIView!
    private var lAddress: UILabel!
    private var lProvince: UILabel!
    private var lCity: UILabel!
    private var lDistrict: UILabel!
    
    private var vDistance: UIView!
    private var lDistance: UILabel!
    private var vDistanceTop: UIView!
    private var vDistanceBottom: UIView!
    
    private var ivAvatarLeft: UIImageView!
    private var ivAvatarRight: UIImageView!
    private var lTimeLeft: UILabel!
    private var lTimeRight: UILabel!
    
    // var
    private static var heightMap: [Int: CGFloat] = [Int: CGFloat]()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // address
        lAddress = ViewHelper.getLabelBlackNormal(width: CouplePlaceCell.MAX_ADDRESS, height: CGFloat(0), text: "-", lines: 0, align: .center)
        lAddress.frame.origin = CGPoint(x: CouplePlaceCell.MARGIN_ADDRESS, y: CouplePlaceCell.MARGIN_V)
        
        lProvince = ViewHelper.getLabelGreySmall(width: CouplePlaceCell.MAX_ADDRESS / 3, text: "-", lines: 1, align: .center)
        lProvince.frame.origin = CGPoint(x: CouplePlaceCell.MARGIN_ADDRESS, y: lAddress.frame.origin.y + lAddress.frame.size.height + CouplePlaceCell.MARGIN_V)
        
        lCity = ViewHelper.getLabelGreySmall(width: CouplePlaceCell.MAX_ADDRESS / 3, text: "-", lines: 1, align: .center)
        lCity.frame.origin = CGPoint(x: lProvince.frame.origin.x + lProvince.frame.size.width + CouplePlaceCell.MARGIN_ADDRESS,
                                     y: lAddress.frame.origin.y + lAddress.frame.size.height + CouplePlaceCell.MARGIN_V)
        
        lDistrict = ViewHelper.getLabelGreySmall(width: CouplePlaceCell.MAX_ADDRESS / 3, text: "-", lines: 1, align: .center)
        lDistrict.frame.origin = CGPoint(x: lCity.frame.origin.x + lCity.frame.size.width + CouplePlaceCell.MARGIN_ADDRESS,
                                         y: lAddress.frame.origin.y + lAddress.frame.size.height + CouplePlaceCell.MARGIN_V)
        
        vAddress = UIView(frame: CGRect(x: CouplePlaceCell.MARGIN_H, y: ScreenUtils.heightFit(2),
                                        width: CouplePlaceCell.MAX_WIDTH, height: lProvince.frame.origin.y + lProvince.frame.size.height + CouplePlaceCell.MARGIN_H))
        vAddress.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vAddress, radius: ViewHelper.RADIUS_BIG)
        ViewUtils.setViewShadow(vAddress, offset: ViewHelper.SHADOW_NORMAL)
        
        vAddress.addSubview(lAddress)
        vAddress.addSubview(lProvince)
        vAddress.addSubview(lCity)
        vAddress.addSubview(lDistrict)
        
        // distance
        vDistance = UIView()
        vDistance.frame.origin.y = vAddress.frame.origin.y + vAddress.frame.size.height + ScreenUtils.heightFit(2)
        
        vDistanceTop = UIView()
        vDistanceTop.frame.origin.y = CGFloat(0)
        vDistanceTop.frame.size = CGSize(width: ScreenUtils.widthFit(1), height: ScreenUtils.heightFit(5))
        vDistanceTop.backgroundColor = ThemeHelper.getColorPrimary()
        
        lDistance = ViewHelper.getLabelBold(text: "-", size: ViewHelper.FONT_SIZE_SMALL, color: ThemeHelper.getColorPrimary(), lines: 1, align: .center)
        lDistance.frame.origin = CGPoint(x: 0, y: vDistanceTop.frame.origin.y + vDistanceTop.frame.size.height)
        lDistance.frame.size.width += CouplePlaceCell.MAIGIN_DISTANCE_H
        lDistance.frame.size.height += CouplePlaceCell.MARGIN_DISTANCE_V
        ViewUtils.setViewRadius(lDistance, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewBorder(lDistance, color: ThemeHelper.getColorPrimary())
        
        vDistanceBottom = UIView()
        vDistanceBottom.frame.origin.y = lDistance.frame.origin.y + lDistance.frame.size.height
        vDistanceBottom.frame.size = CGSize(width: ScreenUtils.widthFit(1), height: ScreenUtils.heightFit(5))
        vDistanceBottom.backgroundColor = ThemeHelper.getColorPrimary()
        
        vDistance.frame.size.width = lDistance.frame.size.width
        vDistance.frame.size.height = vDistanceTop.frame.size.height + lDistance.frame.size.height + vDistanceBottom.frame.size.height
        vDistance.center.x = ScreenUtils.getScreenWidth() / 2
        vDistanceTop.center.x = vDistance.frame.size.width / 2
        vDistanceBottom.center.x = vDistance.frame.size.width / 2
        
        vDistance.addSubview(vDistanceTop)
        vDistance.addSubview(lDistance)
        vDistance.addSubview(vDistanceBottom)
        
        // user
        ivAvatarLeft = ViewHelper.getImageViewAvatar(width: CouplePlaceCell.AVATAR_WIDTH, height: CouplePlaceCell.AVATAR_WIDTH)
        ivAvatarLeft.frame.origin.x = vAddress.frame.origin.x
        ivAvatarLeft.center.y = vDistance.center.y
        
        ivAvatarRight = ViewHelper.getImageViewAvatar(width: CouplePlaceCell.AVATAR_WIDTH, height: CouplePlaceCell.AVATAR_WIDTH)
        ivAvatarRight.frame.origin.x = vAddress.frame.origin.x + vAddress.frame.size.width - ivAvatarRight.frame.size.width
        ivAvatarRight.center.y = vDistance.center.y
        
        let timeWidthWithMargin = (CouplePlaceCell.MAX_WIDTH - vDistance.frame.size.width - ivAvatarLeft.frame.size.width * 2) / 2
        let timeWidth = timeWidthWithMargin - CouplePlaceCell.MARGIN_ADDRESS * 2
        
        lTimeLeft = ViewHelper.getLabelGreySmall(width: timeWidth, text: "-", lines: 1, align: .left)
        lTimeLeft.frame.origin.x = ivAvatarLeft.frame.origin.x + ivAvatarLeft.frame.size.width + CouplePlaceCell.MARGIN_ADDRESS
        lTimeLeft.center.y = vDistance.center.y
        
        lTimeRight = ViewHelper.getLabelGreySmall(width: timeWidth, text: "-", lines: 1, align: .right)
        lTimeRight.frame.origin.x = vDistance.frame.origin.x + vDistance.frame.size.width + CouplePlaceCell.MARGIN_ADDRESS
        lTimeRight.center.y = vDistance.center.y
        
        // view
        self.contentView.addSubview(vAddress)
        self.contentView.addSubview(vDistance)
        self.contentView.addSubview(ivAvatarLeft)
        self.contentView.addSubview(ivAvatarRight)
        self.contentView.addSubview(lTimeLeft)
        self.contentView.addSubview(lTimeRight)
    }
    
    public static func getCellHeight(view: UITableView, indexPath: IndexPath, dataList: [Place]?) -> CGFloat {
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
        let place = dataList![row]
        return getHeightByData(place: place)
    }
    
    public static func refreshHeightMap(refresh: Bool, start: Int, dataList: [Place]?) {
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
        for (index, place) in dataList!.enumerated() {
            let height = getHeightByData(place: place)
            heightMap[index + startIndex] = height
        }
    }
    
    public static func getHeightByData(place: Place) -> CGFloat {
        if totalHeight == nil || placeFont == nil {
            let cell = CouplePlaceCell(style: .default, reuseIdentifier: CouplePlaceCell.ID)
            totalHeight = cell.vDistance.frame.origin.y + cell.vDistance.frame.size.height
            placeFont = cell.lAddress.font
        }
        // offset
        let address = StringUtils.isEmpty(place.address) ? StringUtils.getString("now_no_address_info") : place.address
        let addressHeight = ViewUtils.getFontHeight(font: placeFont, width: CouplePlaceCell.MAX_ADDRESS, text: address)
        return totalHeight! + addressHeight
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Place]?) -> CouplePlaceCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? CouplePlaceCell
        if cell == nil {
            cell = CouplePlaceCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        // data
        if dataList == nil || dataList!.count <= cell!.tag {
            return cell!
        }
        let place = dataList![cell!.tag]
        let me = UDHelper.getMe()
        let ta = UDHelper.getTa()
        let isMe = place.userId == me?.id
        let avatar = UserHelper.getAvatar(couple: me?.couple, uid: place.userId)
        let time = TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(place.createAt)
        // view
        cell!.lAddress.text = StringUtils.isEmpty(place.address) ? StringUtils.getString("now_no_address_info") : place.address
        cell!.lProvince.text = StringUtils.isEmpty(place.province) ? StringUtils.getString("now_no") : place.province
        cell!.lCity.text = StringUtils.isEmpty(place.city) ? StringUtils.getString("now_no") : place.city
        cell!.lDistrict.text = StringUtils.isEmpty(place.district) ? StringUtils.getString("now_no") : place.district
        
        if dataList!.count <= indexPath.row + 1 {
            cell!.vDistance.isHidden = true
        } else {
            cell!.vDistance.isHidden = false
            let next = dataList![indexPath.row + 1]
            let distance = AmapHelper.distance(lon1: place.longitude, lat1: place.latitude, lon2: next.longitude, lat2: next.latitude)
            let distanceShow = ShowHelper.getShowDistance(distance)
            cell!.lDistance.text = StringUtils.getString("distance_space_holder", arguments: [distanceShow])
        }
        
        if isMe {
            if !cell!.ivAvatarLeft.isHidden {
                cell!.ivAvatarLeft.isHidden = true
            }
            if !cell!.lTimeLeft.isHidden {
                cell!.lTimeLeft.isHidden = true
            }
            if cell!.ivAvatarRight.isHidden {
                cell!.ivAvatarRight.isHidden = false
            }
            if cell!.lTimeRight.isHidden {
                cell!.lTimeRight.isHidden = false
            }
            KFHelper.setImgAvatarUrl(iv: cell!.ivAvatarRight, objKey: avatar, user: me)
            cell!.lTimeRight.text = time
        } else {
            if cell!.ivAvatarLeft.isHidden {
                cell!.ivAvatarLeft.isHidden = false
            }
            if cell!.lTimeLeft.isHidden {
                cell!.lTimeLeft.isHidden = false
            }
            if !cell!.ivAvatarRight.isHidden {
                cell!.ivAvatarRight.isHidden = true
            }
            if !cell!.lTimeRight.isHidden {
                cell!.lTimeRight.isHidden = true
            }
            KFHelper.setImgAvatarUrl(iv: cell!.ivAvatarLeft, objKey: avatar, user: ta)
            cell!.lTimeLeft.text = time
        }
        
        // size
        AppDelegate.runOnMainAsync {
            let cellHeight = getCellHeight(view: view, indexPath: indexPath, dataList: dataList)
            
            // distance
            let oldWidth = cell?.lDistance.frame.size.width ?? 0
            cell?.lDistance.sizeToFit()
            cell?.lDistance.frame.size.width += CouplePlaceCell.MAIGIN_DISTANCE_H
            cell?.lDistance.frame.size.height += CouplePlaceCell.MARGIN_DISTANCE_V
            
            let widthOffset = cell!.lDistance.frame.size.width - oldWidth
            if widthOffset != 0 {
                cell?.vDistance.frame.size.width += widthOffset
                cell?.vDistance.center.x = ScreenUtils.getScreenWidth() / 2
                cell?.vDistanceTop.center.x = cell!.lDistance.center.x
                cell?.vDistanceBottom.center.x = cell!.lDistance.center.x
                
                cell?.lTimeLeft.frame.size.width -= widthOffset / 2
                cell?.lTimeRight.frame.size.width -= widthOffset / 2
                cell?.lTimeRight.frame.origin.x += widthOffset / 2
            }
            
            // address
            let lAddressHeight = cellHeight - (totalHeight ?? 0)
            let heightOffset = lAddressHeight - (cell?.lAddress.frame.size.height ?? lAddressHeight)
            if (cell?.lAddress.frame.size.height ?? 0) != lAddressHeight {
                cell?.lAddress.frame.size.height = lAddressHeight
                
                cell?.lProvince.frame.origin.y += heightOffset
                cell?.lCity.frame.origin.y += heightOffset
                cell?.lDistrict.frame.origin.y += heightOffset
                cell?.vAddress.frame.size.height += heightOffset
                cell?.vDistance.frame.origin.y += heightOffset
            }
            ViewUtils.setViewShadow(cell?.vAddress, offset: ViewHelper.SHADOW_NORMAL)
            
            cell?.ivAvatarLeft.center.y = cell!.vDistance.center.y
            cell?.ivAvatarRight.center.y = cell!.vDistance.center.y
            cell?.lTimeLeft.center.y = cell!.vDistance.center.y
            cell?.lTimeRight.center.y = cell!.vDistance.center.y
        }
        return cell!
    }
    
}
