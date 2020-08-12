//
//  MoreCoinCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/23.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class MoreCoinCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    
    private static let MARGIN = ScreenUtils.widthFit(10)
    private static let MAX_WIDTH = ScreenUtils.getScreenWidth() - MARGIN * 2
    private static let AVATAR_WIDTH = ScreenUtils.widthFit(20)
    private static let LAWEL_WIDTH = (MAX_WIDTH - MARGIN * 4) / 3
    
    // view
    private var vRoot: UIView!
    private var ivAvatarLeft: UIImageView!
    private var ivAvatarRight: UIImageView!
    private var lTime: UILabel!
    private var lKind: UILabel!
    private var lChange: UILabel!
    private var lCount: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // avatar
        ivAvatarLeft = ViewHelper.getImageViewAvatar(width: MoreCoinCell.AVATAR_WIDTH, height: MoreCoinCell.AVATAR_WIDTH)
        ivAvatarLeft.frame.origin = CGPoint(x: MoreCoinCell.MARGIN, y: MoreCoinCell.MARGIN)
        
        ivAvatarRight = ViewHelper.getImageViewAvatar(width: MoreCoinCell.AVATAR_WIDTH, height: MoreCoinCell.AVATAR_WIDTH)
        ivAvatarRight.frame.origin = CGPoint(x: MoreCoinCell.MAX_WIDTH - MoreCoinCell.MARGIN - MoreCoinCell.AVATAR_WIDTH, y: MoreCoinCell.MARGIN)
        
        // time
        lTime = ViewHelper.getLabelGreyNormal(text: "-", lines: 1, align: .center)
        lTime.center.x = MoreCoinCell.MAX_WIDTH / 2
        lTime.center.y = ivAvatarLeft.center.y
        
        // line
        let vLine = ViewHelper.getViewLine(width: MoreCoinCell.MAX_WIDTH - MoreCoinCell.MARGIN * 2)
        vLine.frame.origin = CGPoint(x: MoreCoinCell.MARGIN, y: ivAvatarLeft.frame.origin.y + ivAvatarLeft.frame.size.height + MoreCoinCell.MARGIN)
        
        // expire
        lKind = ViewHelper.getLabelBlackNormal(width: MoreCoinCell.LAWEL_WIDTH, text: "-", lines: 1, align: .center, mode: .byTruncatingMiddle)
        lKind.frame.origin = CGPoint(x: MoreCoinCell.MARGIN, y: vLine.frame.origin.y + vLine.frame.size.height + MoreCoinCell.MARGIN)
        
        lChange = ViewHelper.getLabelBlackNormal(width: MoreCoinCell.LAWEL_WIDTH, text: "-", lines: 1, align: .center, mode: .byTruncatingMiddle)
        lChange.frame.origin = CGPoint(x: lKind.frame.origin.x + lKind.frame.size.width + MoreCoinCell.MARGIN, y: vLine.frame.origin.y + vLine.frame.size.height + MoreCoinCell.MARGIN)
        
        lCount = ViewHelper.getLabelBlackNormal(width: MoreCoinCell.LAWEL_WIDTH, text: "-", lines: 1, align: .center, mode: .byTruncatingMiddle)
        lCount.frame.origin = CGPoint(x: lChange.frame.origin.x + lChange.frame.size.width + MoreCoinCell.MARGIN, y: vLine.frame.origin.y + vLine.frame.size.height + MoreCoinCell.MARGIN)
        
        // root
        vRoot = UIView(frame: CGRect(x: MoreCoinCell.MARGIN, y: MoreCoinCell.MARGIN / 2, width: MoreCoinCell.MAX_WIDTH, height: lKind.frame.origin.y + lKind.frame.size.height + MoreCoinCell.MARGIN))
        vRoot.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vRoot, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vRoot, offset: ViewHelper.SHADOW_NORMAL)
        
        vRoot.addSubview(ivAvatarLeft)
        vRoot.addSubview(ivAvatarRight)
        vRoot.addSubview(lTime)
        vRoot.addSubview(vLine)
        vRoot.addSubview(lKind)
        vRoot.addSubview(lChange)
        vRoot.addSubview(lCount)
        
        // view
        self.contentView.addSubview(vRoot)
    }
    
    public static func getCellHeight(view: UITableView, indexPath: IndexPath) -> CGFloat {
        if totalHeight == nil {
            let cell = MoreCoinCell(style: .default, reuseIdentifier: MoreCoinCell.ID)
            totalHeight = cell.vRoot.frame.origin.y * 2 + cell.vRoot.frame.size.height
        }
        return totalHeight!
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Coin]?) -> MoreCoinCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? MoreCoinCell
        if cell == nil {
            cell = MoreCoinCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= indexPath.row {
            return cell!
        }
        let coin = dataList![indexPath.row]
        let me = UDHelper.getMe()
        let isMe = coin.userId == me?.id
        let avatar = UserHelper.getAvatar(couple: me?.couple, uid: coin.userId)
        
        // view
        if isMe {
            cell?.ivAvatarLeft.isHidden = true
            cell?.ivAvatarRight.isHidden = false
            KFHelper.setImgAvatarUrl(iv: cell?.ivAvatarRight, objKey: avatar, user: me)
        } else {
            cell?.ivAvatarLeft.isHidden = false
            cell?.ivAvatarRight.isHidden = true
            KFHelper.setImgAvatarUrl(iv: cell?.ivAvatarLeft, objKey: avatar, uid: coin.userId)
        }
        cell?.lTime.text = TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(coin.createAt)
        cell?.lKind.text = getCoinKindShow(form: coin.kind)
        cell?.lChange.text = (coin.change >= 0) ? "+ \(coin.change)" : "\(coin.change)"
        cell?.lCount.text = "= \(coin.count)"
        
        // size
        let oldWidth = cell!.lTime.frame.size.width
        cell!.lTime.sizeToFit()
        let widthOffset = cell!.lTime.frame.size.width - oldWidth
        cell!.lTime.center.x -= widthOffset / 2
        
        return cell!
    }
    
    private static func getCoinKindShow(form: Int) -> String {
        switch form {
        case Coin.KIND_ADD_BY_SYS:
            return StringUtils.getString("sys_change")
        case Coin.KIND_ADD_BY_PLAY_PAY:
            return StringUtils.getString("pay")
        case Coin.KIND_ADD_BY_SIGN_DAY:
            return StringUtils.getString("sign")
        case Coin.KIND_ADD_BY_AD_WATCH:
            return StringUtils.getString("ad_watch")
        case Coin.KIND_ADD_BY_AD_CLICK:
            return StringUtils.getString("ad_click")
        case Coin.KIND_ADD_BY_MATCH_POST:
            return StringUtils.getString("nav_match")
        case Coin.KIND_SUB_BY_MATCH_UP:
            return StringUtils.getString("nav_match")
        case Coin.KIND_SUB_BY_WISH_UP:
            return StringUtils.getString("nav_wish")
        case Coin.KIND_SUB_BY_CARD_UP:
            return StringUtils.getString("nav_postcard")
        default:
            return StringUtils.getString("unknown_kind")
        }
    }
    
}
