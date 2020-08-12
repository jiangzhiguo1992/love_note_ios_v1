//
//  NoteShyCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/16.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteShyCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    
    private static let MARGIN = ScreenUtils.widthFit(10)
    private static let MAX_WIDTH = (ScreenUtils.getScreenWidth() - MARGIN * 3) / 2
    
    // view
    private var vRoot: UIView!
    private var lTime: UILabel!
    private var ivAvatar: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // time
        lTime = ViewHelper.getLabelBold(text: "00：00", size: ViewHelper.FONT_SIZE_NORMAL, color: ColorHelper.getFontWhite(), lines: 1, align: .center, mode: .byTruncatingMiddle)
        lTime.frame.origin.y = NoteShyCell.MARGIN / 2
        
        // avatar
        ivAvatar = ViewHelper.getImageViewAvatar(width: lTime.frame.size.height, height: lTime.frame.size.height)
        ivAvatar.frame.origin.y = NoteShyCell.MARGIN / 2
        
        let width = lTime.frame.size.width + NoteShyCell.MARGIN + ivAvatar.frame.size.height
        ivAvatar.frame.origin.x = (NoteShyCell.MAX_WIDTH - width) / 2
        lTime.frame.origin.x = ivAvatar.frame.origin.x + ivAvatar.frame.size.width + NoteShyCell.MARGIN
        
        // root
        vRoot = UIView(frame: CGRect(x: 0, y: 0, width: NoteShyCell.MAX_WIDTH, height: lTime.frame.size.height + NoteShyCell.MARGIN))
        vRoot.addSubview(ivAvatar)
        vRoot.addSubview(lTime)
        
        // view
        self.contentView.addSubview(vRoot)
    }
    
    public static func getCellHeight() -> CGFloat {
        if totalHeight == nil {
            let cell = NoteShyCell(style: .default, reuseIdentifier: NoteShyCell.ID)
            totalHeight = cell.vRoot.frame.size.height
        }
        return totalHeight!
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Shy]?, target: Any?, action: Selector) -> NoteShyCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? NoteShyCell
        if cell == nil {
            cell = NoteShyCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= indexPath.row {
            return cell!
        }
        let shy = dataList![indexPath.row]
        let avatar = UserHelper.getAvatar(user: UDHelper.getMe(), uid: shy.userId)
        let create = DateUtils.getStr(shy.happenAt, DateUtils.FORMAT_H_M)
        
        // view
        KFHelper.setImgAvatarUrl(iv: cell?.ivAvatar, objKey: avatar, uid: shy.userId)
        cell?.lTime.text = create
        
        // target
        ViewUtils.addViewTapTarget(target: target, view: cell?.vRoot, action: action)
        
        return cell!
    }
    
}
