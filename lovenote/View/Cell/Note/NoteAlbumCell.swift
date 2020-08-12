//
//  NoteAlbumCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/5.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteAlbumCell: BaseTableCell {
    
    // const
    private static let totalHeight = ScreenUtils.heightFit(180)
    
    private static let MARGIN = ScreenUtils.widthFit(5)
    private static let MAX_WIDTH = ScreenUtils.getScreenWidth() - MARGIN * 2
    private static let MAX_HEIGHT = totalHeight - MARGIN
    
    // view
    private var ivBg: UIImageView!
    private var vRoot: UIView!
    private var btnMore: UIButton!
    private var lTitle: UILabel!
    private var lTime: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // ivBG
        ivBg = ViewHelper.getImageViewUrl(width: NoteAlbumCell.MAX_WIDTH, height: NoteAlbumCell.MAX_HEIGHT, indicator: false, radius: ViewHelper.RADIUS_BIG)
        ivBg.frame.origin = CGPoint(x: NoteAlbumCell.MARGIN, y: NoteAlbumCell.MARGIN / 2)
        
        // more
        btnMore = ViewHelper.getBtnImgCenter(paddingH: NoteAlbumCell.MARGIN, paddingV: NoteAlbumCell.MARGIN, bgImg: UIImage(named: "ic_more_horiz_grey_18dp"))
        btnMore.frame.origin = CGPoint(x: NoteAlbumCell.MAX_WIDTH - btnMore.frame.size.width, y: 0)
        
        // title
        lTitle = ViewHelper.getLabelBold(width: NoteAlbumCell.MAX_WIDTH - NoteAlbumCell.MARGIN * 2, text: "-", size: ScreenUtils.fontFit(25), color: ColorHelper.getFontWhite(), lines: 1, align: .center, mode: .byTruncatingMiddle)
        lTitle.frame.origin.x = NoteAlbumCell.MARGIN
        lTitle.center.y = NoteAlbumCell.totalHeight / 2
        
        // time
        lTime = ViewHelper.getLabelWhiteNormal(width: NoteAlbumCell.MAX_WIDTH - NoteAlbumCell.MARGIN * 2, text: "-", lines: 1, align: .center, mode: .byTruncatingMiddle)
        lTime.frame.origin = CGPoint(x: NoteAlbumCell.MARGIN, y: lTitle.frame.origin.y + lTitle.frame.size.height + NoteAlbumCell.MARGIN)
        
        // root
        vRoot = UIView(frame: CGRect(x: NoteAlbumCell.MARGIN, y: NoteAlbumCell.MARGIN / 2, width: NoteAlbumCell.MAX_WIDTH, height: NoteAlbumCell.MAX_HEIGHT))
        vRoot.backgroundColor = ColorHelper.getBlack25()
        ViewUtils.setViewRadius(vRoot, radius: ViewHelper.RADIUS_BIG)
        ViewUtils.setViewShadow(vRoot, offset: ViewHelper.SHADOW_NORMAL)
        vRoot.addSubview(btnMore)
        vRoot.addSubview(lTitle)
        vRoot.addSubview(lTime)
        
        // view
        self.contentView.addSubview(ivBg)
        self.contentView.addSubview(vRoot)
        
        // hide
        btnMore.isHidden = true
    }
    
    public static func getCellHeight() -> CGFloat {
        return totalHeight
    }
    
    public static func getMuliCellHeight(dataList: [Album]?) -> CGFloat {
        if dataList == nil || dataList!.count <= 0 {
            return CGFloat(0)
        }
        var totalHeight = CGFloat(0)
        for _ in dataList! {
            totalHeight += NoteAlbumCell.totalHeight 
        }
        return totalHeight
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Album]?) -> NoteAlbumCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? NoteAlbumCell
        if cell == nil {
            cell = NoteAlbumCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= indexPath.row {
            return cell!
        }
        let album = dataList![indexPath.row]
        let startAt = album.startAt == 0 ? "" : TimeHelper.getTimeShowLocal_MD_YMD_ByGo(album.startAt)
        let endAt = album.endAt == 0 ? "" : TimeHelper.getTimeShowLocal_MD_YMD_ByGo(album.endAt)
        let time = StringUtils.getString("holder_space_line_space_holder", arguments: [startAt, endAt])
        
        // view
        cell?.lTitle.text = album.title
        cell?.lTime.text = time
        cell?.ivBg.image = nil
        if StringUtils.isEmpty(album.cover) {
            // 没有封面时，随机给个颜色
            cell?.ivBg.backgroundColor = ThemeHelper.getPrimaryRandom()
        } else {
            cell?.ivBg.backgroundColor = ColorHelper.getWhite()
            KFHelper.setImgUrl(iv: cell?.ivBg, objKey: album.cover)
        }
        return cell!
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Album]?, target: Any?, actionEdit: Selector) -> NoteAlbumCell {
        let cell = getCellWithData(view: view, indexPath: indexPath, dataList: dataList)
        cell.btnMore.isHidden = false
        cell.btnMore.addTarget(target, action: actionEdit, for: .touchUpInside)
        return cell
    }
    
    public static func goPictureList(view: UITableView, indexPath: IndexPath, dataList: [Album]?) {
        if dataList == nil || dataList!.count <= indexPath.row {
            return
        }
        let album = dataList![indexPath.row]
        NotePictureVC.pushVC(album: album)
    }
    
    public static func selectAlbum(view: UITableView, indexPath: IndexPath, dataList: [Album]?) {
        RootVC.get().popBack()
        if dataList == nil || dataList!.count <= indexPath.row {
            return
        }
        let album = dataList![indexPath.row]
        NotifyHelper.post(NotifyHelper.TAG_ALBUM_SELECT, obj: album)
    }
    
}
