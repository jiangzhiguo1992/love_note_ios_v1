//
//  NoteWordCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/2/23.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteWordCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    private static var contentFont: UIFont?
    
    private static let ITEM_MARGIN = ScreenUtils.widthFit(10)
    private static let LINE_CIRCLE_WIDTH = ScreenUtils.widthFit(40)
    private static let MAX_CARD_WIDTH = ScreenUtils.getScreenWidth() - LINE_CIRCLE_WIDTH * 2 - ITEM_MARGIN
    private static let MAX_CARD_LABEL_WIDTH = MAX_CARD_WIDTH - ITEM_MARGIN * 2
    
    // view
    private var lContentLeft: UILabel!
    private var vContentLeft: UIView!
    private var lTimeLeft: UILabel!
    private var ivLeftCircle: UIImageView!
    private var lineLeftLeft: UIView!
    private var lineLeftRight: UIView!
    private var btnLeftDel: UIButton!
    
    private var lContentRight: UILabel!
    private var vContentRight: UIView!
    private var lTimeRight: UILabel!
    private var ivRightCircle: UIImageView!
    private var lineRightLeft: UIView!
    private var lineRightRight: UIView!
    private var btnRightDel: UIButton!
    
    // var
    private static var heightMap: [Int: CGFloat] = [Int: CGFloat]()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // ---------------------------left---------------------------
        // content
        lContentLeft = ViewHelper.getLabelBlackNormal(height: CGFloat(0), text: "-", lines: 0, align: .left)
        lContentLeft.frame.size.width = CountHelper.getMin(lContentLeft.frame.size.width, NoteWordCell.MAX_CARD_LABEL_WIDTH)
        lContentLeft.frame.origin = CGPoint(x: NoteWordCell.ITEM_MARGIN, y: NoteWordCell.ITEM_MARGIN)
        
        vContentLeft = UIView()
        vContentLeft.frame.size.width = CountHelper.getMin(lContentLeft.frame.size.width + NoteWordCell.ITEM_MARGIN * 2, NoteWordCell.MAX_CARD_WIDTH)
        vContentLeft.frame.size.height = lContentLeft.frame.size.height + NoteWordCell.ITEM_MARGIN * 2
        vContentLeft.frame.origin = CGPoint(x: NoteWordCell.LINE_CIRCLE_WIDTH + NoteWordCell.ITEM_MARGIN / 2, y: NoteWordCell.ITEM_MARGIN)
        vContentLeft.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vContentLeft, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vContentLeft, offset: ViewHelper.SHADOW_NORMAL)
        vContentLeft.addSubview(lContentLeft)
        
        // time
        lTimeLeft = ViewHelper.getLabelGreySmall(width: NoteWordCell.MAX_CARD_WIDTH, text: "-", lines: 1, align: .left)
        lTimeLeft.frame.origin = CGPoint(x: NoteWordCell.LINE_CIRCLE_WIDTH + NoteWordCell.ITEM_MARGIN / 2, y: vContentLeft.frame.origin.y + vContentLeft.frame.size.height + NoteWordCell.ITEM_MARGIN / 2)
        
        // line
        ivLeftCircle = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_brightness_1_grey_24dp"), color: ThemeHelper.getColorDark()), width: ScreenUtils.widthFit(20), height: ScreenUtils.widthFit(20))
        ivLeftCircle.center.x = NoteWordCell.LINE_CIRCLE_WIDTH / 2
        ivLeftCircle.center.y = vContentLeft.center.y
        
        btnLeftDel = ViewHelper.getBtnImgFit(width: ivLeftCircle.frame.size.width, height: ivLeftCircle.frame.size.height, bgImg: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_remove_circle_white_24dp"), color: ColorHelper.getRedDark()))
        btnLeftDel.frame.origin = ivLeftCircle.frame.origin
        
        let lineLeftTopLeft = ViewHelper.getViewLine(width: 1, height: ivLeftCircle.frame.origin.y, color: ThemeHelper.getColorDark())
        lineLeftTopLeft.center.x = NoteWordCell.LINE_CIRCLE_WIDTH / 2
        lineLeftTopLeft.frame.origin.y = 0
        
        lineLeftLeft = ViewHelper.getViewLine(width: 1, height: lTimeLeft.frame.origin.y + lTimeLeft.frame.size.height + NoteWordCell.ITEM_MARGIN / 2, color: ThemeHelper.getColorDark())
        lineLeftLeft.center.x = NoteWordCell.LINE_CIRCLE_WIDTH / 2
        lineLeftLeft.frame.origin.y = 0
        
        lineLeftRight = ViewHelper.getViewLine(width: 1, height: lTimeLeft.frame.origin.y + lTimeLeft.frame.size.height + NoteWordCell.ITEM_MARGIN / 2, color: ThemeHelper.getColorDark())
        lineLeftRight.center.x = ScreenUtils.getScreenWidth() - NoteWordCell.LINE_CIRCLE_WIDTH / 2
        lineLeftRight.frame.origin.y = 0
        
        // ---------------------------Right---------------------------
        // content
        lContentRight = ViewHelper.getLabelBlackNormal(height: CGFloat(0), text: "-", lines: 0, align: .left)
        lContentRight.frame.size.width = CountHelper.getMin(lContentRight.frame.size.width, NoteWordCell.MAX_CARD_LABEL_WIDTH)
        lContentRight.frame.origin = CGPoint(x: NoteWordCell.ITEM_MARGIN, y: NoteWordCell.ITEM_MARGIN)
        
        vContentRight = UIView()
        vContentRight.frame.size.width = CountHelper.getMin(lContentRight.frame.size.width + NoteWordCell.ITEM_MARGIN * 2, NoteWordCell.MAX_CARD_WIDTH)
        vContentRight.frame.size.height = lContentRight.frame.size.height + NoteWordCell.ITEM_MARGIN * 2
        vContentRight.frame.origin = CGPoint(x: ScreenUtils.getScreenWidth() - NoteWordCell.LINE_CIRCLE_WIDTH - NoteWordCell.ITEM_MARGIN / 2 - vContentRight.frame.size.width, y: NoteWordCell.ITEM_MARGIN)
        vContentRight.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vContentRight, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vContentRight, offset: ViewHelper.SHADOW_NORMAL)
        vContentRight.addSubview(lContentRight)
        
        // time
        lTimeRight = ViewHelper.getLabelGreySmall(width: NoteWordCell.MAX_CARD_WIDTH, text: "-", lines: 1, align: .right)
        lTimeRight.frame.origin = CGPoint(x: NoteWordCell.LINE_CIRCLE_WIDTH + NoteWordCell.ITEM_MARGIN / 2, y: vContentRight.frame.origin.y + vContentRight.frame.size.height + NoteWordCell.ITEM_MARGIN / 2)
        
        // line
        ivRightCircle = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_brightness_1_grey_24dp"), color: ThemeHelper.getColorDark()), width: ScreenUtils.widthFit(20), height: ScreenUtils.widthFit(20))
        ivRightCircle.center.x = ScreenUtils.getScreenWidth() - NoteWordCell.LINE_CIRCLE_WIDTH / 2
        ivRightCircle.center.y = vContentRight.center.y
        
        btnRightDel = ViewHelper.getBtnImgFit(width: ivRightCircle.frame.size.width, height: ivRightCircle.frame.size.height, bgImg: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_remove_circle_white_24dp"), color: ColorHelper.getRedDark()))
        btnRightDel.frame.origin = ivRightCircle.frame.origin
        
        lineRightLeft = ViewHelper.getViewLine(width: 1, height: lTimeRight.frame.origin.y + lTimeRight.frame.size.height + NoteWordCell.ITEM_MARGIN / 2, color: ThemeHelper.getColorDark())
        lineRightLeft.center.x = NoteWordCell.LINE_CIRCLE_WIDTH / 2
        lineRightLeft.frame.origin.y = 0
        
        lineRightRight = ViewHelper.getViewLine(width: 1, height: lTimeRight.frame.origin.y + lTimeRight.frame.size.height + NoteWordCell.ITEM_MARGIN / 2, color: ThemeHelper.getColorDark())
        lineRightRight.center.x = ScreenUtils.getScreenWidth() - NoteWordCell.LINE_CIRCLE_WIDTH / 2
        lineRightRight.frame.origin.y = 0
        
        // view
        self.contentView.addSubview(vContentLeft)
        self.contentView.addSubview(lTimeLeft)
        self.contentView.addSubview(ivLeftCircle)
        self.contentView.addSubview(btnLeftDel)
        self.contentView.addSubview(lineLeftLeft)
        self.contentView.addSubview(lineLeftRight)
        self.contentView.addSubview(vContentRight)
        self.contentView.addSubview(lTimeRight)
        self.contentView.addSubview(ivRightCircle)
        self.contentView.addSubview(btnRightDel)
        self.contentView.addSubview(lineRightLeft)
        self.contentView.addSubview(lineRightRight)
        
        // hiden
        vContentLeft.isHidden = true
        lTimeLeft.isHidden = true
        ivLeftCircle.isHidden = true
        btnLeftDel.isHidden = true
        lineLeftLeft.isHidden = true
        lineLeftRight.isHidden = true
        vContentRight.isHidden = true
        lTimeRight.isHidden = true
        ivRightCircle.isHidden = true
        btnRightDel.isHidden = true
        lineRightLeft.isHidden = true
        lineRightRight.isHidden = true
    }
    
    public static func getCellHeight(view: UITableView, indexPath: IndexPath, dataList: [Word]?) -> CGFloat {
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
        let word = dataList![row]
        return getHeightByData(word: word)
    }
    
    public static func refreshHeightMap(refresh: Bool, start: Int, dataList: [Word]?) {
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
        for (index, word) in dataList!.enumerated() {
            let height = getHeightByData(word: word)
            heightMap[index + startIndex] = height
        }
    }
    
    private static func getHeightByData(word: Word) -> CGFloat {
        // const
        if totalHeight == nil || contentFont == nil {
            let cell = NoteWordCell(style: .default, reuseIdentifier: NoteWordCell.ID)
            totalHeight = cell.lineLeftLeft.frame.size.height
            contentFont = cell.lContentLeft.font
        }
        // offset
        let labelHeight = ViewUtils.getFontHeight(font: contentFont, width: NoteWordCell.MAX_CARD_LABEL_WIDTH, text: word.contentText)
        return totalHeight! + labelHeight
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Word]?, del: Bool, target: Any?, action: Selector) -> NoteWordCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? NoteWordCell
        if cell == nil {
            cell = NoteWordCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        // data
        if dataList == nil || dataList!.count <= cell!.tag {
            return cell!
        }
        let word = dataList![cell!.tag]
        let isMe = word.userId == UDHelper.getMe()?.id
        // view
        if cell?.vContentLeft.isHidden != isMe {
            cell?.vContentLeft.isHidden = isMe
        }
        if cell?.lTimeLeft.isHidden != isMe {
            cell?.lTimeLeft.isHidden = isMe
        }
        if cell?.vContentRight.isHidden == isMe {
            cell?.vContentRight.isHidden = !isMe
        }
        if cell?.lTimeRight.isHidden == isMe {
            cell?.lTimeRight.isHidden = !isMe
        }
        
        if isMe {
            cell?.lContentRight.text = word.contentText
            cell?.lTimeRight.text = TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(word.createAt)
            // size
            AppDelegate.runOnMainAsync {
                // width
                let oldWidth = cell!.lContentRight.frame.size.width
                let newWidth = CountHelper.getMin(ViewUtils.getFontWidth(font: cell!.lContentRight.font, text: cell!.lContentRight.text), NoteWordCell.MAX_CARD_LABEL_WIDTH)
                let widthOffset = newWidth - oldWidth
                if widthOffset != 0 {
                    cell!.lContentRight.frame.size.width += widthOffset
                    cell!.vContentRight.frame.size.width += widthOffset
                    cell!.vContentRight.frame.origin.x -= widthOffset
                }
                
                // height
                let cellHeight = getCellHeight(view: view, indexPath: indexPath, dataList: dataList)
                let lContentHeight = cellHeight - (totalHeight ?? 0)
                let heightOffset = lContentHeight - (cell?.lContentRight.frame.size.height ?? lContentHeight)
                if (cell?.lContentRight.frame.size.height ?? 0) != lContentHeight {
                    cell?.lContentRight.frame.size.height = lContentHeight
                    
                    cell!.vContentRight.frame.size.height += heightOffset
                    cell!.lTimeRight.frame.origin.y += heightOffset
                    cell!.ivRightCircle.frame.origin.y += heightOffset / 2
                    cell!.btnRightDel.frame.origin.y += heightOffset / 2
                    cell!.lineRightLeft.frame.size.height += heightOffset
                    cell!.lineRightRight.frame.size.height += heightOffset
                }
                ViewUtils.setViewShadow(cell?.vContentRight, offset: ViewHelper.SHADOW_NORMAL)
            }
        } else {
            cell?.lContentLeft.text = word.contentText
            cell?.lTimeLeft.text = TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(word.createAt)
            // size
            AppDelegate.runOnMainAsync {
                // width
                let oldWidth = cell!.lContentLeft.frame.size.width
                let newWidth = CountHelper.getMin(ViewUtils.getFontWidth(font: cell!.lContentLeft.font, text: cell!.lContentLeft.text), NoteWordCell.MAX_CARD_LABEL_WIDTH)
                let widthOffset = newWidth - oldWidth
                if widthOffset != 0 {
                    cell!.lContentLeft.frame.size.width += widthOffset
                    cell!.vContentLeft.frame.size.width += widthOffset
                }
                // height
                let cellHeight = getCellHeight(view: view, indexPath: indexPath, dataList: dataList)
                let lContentHeight = cellHeight - (totalHeight ?? 0)
                let heightOffset = lContentHeight - (cell?.lContentLeft.frame.size.height ?? lContentHeight)
                if (cell?.lContentLeft.frame.size.height ?? 0) != lContentHeight {
                    cell?.lContentLeft.frame.size.height = lContentHeight
                    
                    cell!.vContentLeft.frame.size.height += heightOffset
                    cell!.lTimeLeft.frame.origin.y += heightOffset
                    cell!.ivLeftCircle.frame.origin.y += heightOffset / 2
                    cell!.btnLeftDel.frame.origin.y += heightOffset / 2
                    cell!.lineLeftLeft.frame.size.height += heightOffset
                    cell!.lineLeftRight.frame.size.height += heightOffset
                }
                ViewUtils.setViewShadow(cell?.vContentLeft, offset: ViewHelper.SHADOW_NORMAL)
            }
        }
        // del
        cell?.setEdit(del: del)
        cell?.btnRightDel.addTarget(target, action: action, for: .touchUpInside)
        cell?.btnLeftDel.addTarget(target, action: action, for: .touchUpInside)
        return cell!
    }
    
    public func setEdit(del: Bool = false) {
        if !self.vContentLeft.isHidden {
            self.btnLeftDel.isHidden = true
            self.ivLeftCircle.isHidden = false
            self.lineLeftLeft.isHidden = false
            self.lineLeftRight.isHidden = del
            
            self.btnRightDel.isHidden = true
            self.ivRightCircle.isHidden = true
            self.lineRightLeft.isHidden = true
            self.lineRightRight.isHidden = true
        } else if !self.vContentRight.isHidden {
            self.btnRightDel.isHidden = !del
            self.ivRightCircle.isHidden = del
            self.lineRightLeft.isHidden = false
            self.lineRightRight.isHidden = del
            
            self.btnLeftDel.isHidden = true
            self.ivLeftCircle.isHidden = true
            self.lineLeftLeft.isHidden = true
            self.lineLeftRight.isHidden = true
        }
    }
    
    public static func toggleModel(view: UITableView?, count: Int = 0, del: Bool) {
        if view == nil || count <= 0 { return }
        for index in 0...(count - 1) {
            if let cell = view!.cellForRow(at: IndexPath(row: index, section: 0)) as? NoteWordCell {
                cell.setEdit(del: del)
            }
        }
    }
    
}
