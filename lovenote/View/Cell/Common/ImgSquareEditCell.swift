//
//  ImgSquareEditCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/1.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import MWPhotoBrowser

class ImgSquareEditCell: BaseCollectCell {
    
    // const
    private static let SCROLL_MARGIN = ScreenUtils.widthFit(10)
    private static let CELL_MARGIN = ScreenUtils.widthFit(5)
    private static let DEL_MARGIN = ScreenUtils.widthFit(5)
    private static let IMG_MARGIN = ScreenUtils.widthFit(10)
    
    // view
    private var ivBG: UIImageView!
    private var vShadow: UIView!
    private var btnAdd: UIButton!
    private var btnDel: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // bg
        ivBG = ViewHelper.getImageViewUrl(width: frame.size.width, height: frame.size.height, indicator: true)
        ivBG.frame.origin = CGPoint(x: 0, y: 0)
        vShadow = ViewUtils.getViewShadow(ivBG, bgColor: ColorHelper.getWhite(), offset: ViewHelper.SHADOW_NORMAL)
        
        // add
        btnAdd = ViewHelper.getBtnImgFit(width: frame.size.width - ImgSquareEditCell.IMG_MARGIN * 2, height: frame.size.height - ImgSquareEditCell.IMG_MARGIN * 2, paddingH: ImgSquareEditCell.IMG_MARGIN, paddingV: ImgSquareEditCell.IMG_MARGIN, bgColor: ColorHelper.getWhite(), bgImg: UIImage(named: "ic_add_grey_48dp"), shadow: true)
        btnAdd.frame.origin = CGPoint(x: 0, y: 0)
        ViewUtils.setViewRadius(btnAdd, radius: ViewHelper.RADIUS_NORMAL)
        
        // del
        let imgDel = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_remove_circle_white_24dp"), color: ColorHelper.getRedDark())
        btnDel = ViewHelper.getBtnImgCenter(paddingH: ImgSquareEditCell.DEL_MARGIN, paddingV: ImgSquareEditCell.DEL_MARGIN, bgImg: imgDel)
        btnDel.frame.origin = CGPoint(x: frame.size.width - btnDel.frame.size.width, y: 0)
        
        // view
        self.addSubview(vShadow)
        self.addSubview(ivBG)
        self.addSubview(btnAdd)
        self.addSubview(btnDel)
        
        // hide
        ivBG.isHidden = true
        btnAdd.isHidden = true
        btnDel.isHidden = true
    }
    
    public static func getLayout(maxWidth: CGFloat = (ScreenUtils.getScreenWidth() - SCROLL_MARGIN * 2), margin: CGFloat = CELL_MARGIN, spanCount: Int = SPAN_COUNT_3) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = getItemSize(maxWidth: maxWidth - 1, margin: margin, spanCount: spanCount) // 为啥要-1??
        // collect间隙的margin
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        // collect本身的margin
        layout.sectionInset = UIEdgeInsets.init(top: margin, left: margin, bottom: margin, right: margin)
        return layout
    }
    
    public static func getItemSize(maxWidth: CGFloat = (ScreenUtils.getScreenWidth() - SCROLL_MARGIN * 2), margin: CGFloat = CELL_MARGIN, spanCount: Int = SPAN_COUNT_3) -> CGSize {
        let itemWidth = spanCount > 1 ? ((maxWidth - margin * CGFloat(spanCount - 1)) / CGFloat(spanCount)) : maxWidth
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    public static func getCollectHeight(collect: UICollectionView?, oldOssKeyList: [String]?, newImgDataList: [Data], limit: Int = 0) -> CGFloat {
        if collect == nil {
            return 0
        }
        let dataCount = (oldOssKeyList?.count ?? 0) + newImgDataList.count
        let showCount = (dataCount >= limit) ? dataCount : dataCount + 1
        if showCount <= 0 {
            return collect!.frame.size.height
        }
        let fullLine = showCount / SPAN_COUNT_3
        let line = (showCount % SPAN_COUNT_3) > 0 ? fullLine + 1 : fullLine
        let layout = collect!.collectionViewLayout as! UICollectionViewFlowLayout
        return layout.sectionInset.top + layout.sectionInset.bottom + layout.itemSize.height * CGFloat(line) + layout.minimumLineSpacing * CGFloat(line - 1)
    }
    
    public static func getNumberOfItems(oldOssKeyList: [String]?, newImgDataList: [Data], limit: Int = 0) -> Int {
        let count = (oldOssKeyList?.count ?? 0) + newImgDataList.count
        return (count >= limit) ? count : count + 1
    }
    
    public static func getCellWithData(view: UICollectionView, indexPath: IndexPath, oldOssKeyList: [String]?, newImgDataList: [Data], limit: Int = 0,
                                       target: Any?, actionGoBig: Selector, actionAdd: Selector, actionDel: Selector) -> ImgSquareEditCell {
        let cell = view.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath) as! ImgSquareEditCell
        cell.tag = indexPath.item
        // data + view
        if oldOssKeyList != nil && oldOssKeyList!.count > cell.tag {
            // 旧数据oss
            cell.btnAdd.isHidden = true
            cell.ivBG.isHidden = false
            cell.vShadow.isHidden = false
            cell.btnDel.isHidden = false
            let ossKey = oldOssKeyList![cell.tag]
            KFHelper.setImgUrl(iv: cell.ivBG, objKey: ossKey)
        } else if (oldOssKeyList?.count ?? 0) + newImgDataList.count > cell.tag {
            // 新数据ossKey
            cell.btnAdd.isHidden = true
            cell.ivBG.isHidden = false
            cell.vShadow.isHidden = false
            cell.btnDel.isHidden = false
            let imgData = newImgDataList[cell.tag - (oldOssKeyList?.count ?? 0)]
            cell.ivBG.image = UIImage(data: imgData)
        } else if cell.tag + 1 <= limit {
            // 添加btn
            cell.btnAdd.isHidden = false
            cell.ivBG.isHidden = true
            cell.vShadow.isHidden = true
            cell.btnDel.isHidden = true
        } else {
            // 错误数据
            cell.btnAdd.isHidden = true
            cell.ivBG.isHidden = true
            cell.vShadow.isHidden = true
            cell.btnDel.isHidden = true
            return cell
        }
        // target
        ViewUtils.addViewTapTarget(target: target, view: cell.ivBG, action: actionGoBig)
        cell.btnAdd.addTarget(target, action: actionAdd, for: .touchUpInside)
        cell.btnDel.addTarget(target, action: actionDel, for: .touchUpInside)
        return cell
    }
    
    public static func goBigImg(view: UIView?, oldOssKeyList: [String]?, newImgDataList: [Data]) {
        if let indexPath = ViewUtils.findCollectIndexPath(view: view) {
            BrowserHelper.goBrowserImage(view: view, index: indexPath.item, ossKeyList: oldOssKeyList, dataList: newImgDataList)
        }
    }
    
    public static func goAddImg(view: UIView?, oldOssKeyList: [String]?, newImgDataList: [Data],
                                limit: Int = 0, gif: Bool = true, compress: Bool = true, crop: Bool = false,
                                dataChange: (([Data]) -> Void)? = nil, complete: (() -> Void)? = nil) {
        let maxCount = limit - (oldOssKeyList?.count ?? 0) - newImgDataList.count
        let collectView = ViewUtils.findSuperCollect(view: view)
        if collectView == nil { return }
        let target = ViewUtils.getSuperVC(view: collectView)
        if target == nil { return }
        PickerHelper.selectImage(target: target, maxCount: maxCount, gif: gif, compress: compress, crop: crop, complete: { (datas) in
            if datas.count <= 0 {
                return
            }
            // data
            let baseIndex = (oldOssKeyList?.count ?? 0) + newImgDataList.count
            var newDataList = newImgDataList
            newDataList += datas
            var indexPaths = [IndexPath]()
            let lastIndex = limit - 1
            var full = false
            for (index, _) in datas.enumerated() {
                let insertIndex = baseIndex + index
                if insertIndex >= lastIndex {
                    full = true
                } else {
                    indexPaths.append(IndexPath(item: insertIndex, section: 0))
                }
            }
            // data
            dataChange?(newDataList)
            // view
            collectView!.frame.size.height = ImgSquareEditCell.getCollectHeight(collect: collectView!, oldOssKeyList: oldOssKeyList, newImgDataList: newDataList, limit: limit)
            if indexPaths.count > 0 {
                collectView!.insertItems(at: indexPaths)
            }
            if full {
                collectView!.reloadItems(at: [IndexPath(item: lastIndex, section: 0)])
            }
            // callback
            complete?()
        })
    }
    
    public static func showDelAlert(sender: UIButton, oldOssKeyList: [String]?, newImgDataList: [Data], limit: Int = 0,
                                    dataChange: (([String], [Data]) -> Void)? = nil, complete: (() -> Void)? = nil) {
        let cell = ViewUtils.findSuperCollectCell(view: sender)
        if cell == nil { return }
        let collectView = ViewUtils.findSuperCollect(view: sender)
        if collectView == nil { return }
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_delete_this_image"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    let index = collectView!.indexPath(for: cell!)?.item ?? -1
                                    if index <= -1 { return }
                                    // data
                                    var newKeyList = oldOssKeyList
                                    var newDataList = newImgDataList
                                    if index <= (newKeyList?.count ?? 0) - 1 {
                                        newKeyList?.remove(at: index)
                                    } else if index <= (newKeyList?.count ?? 0) + newDataList.count - 1 {
                                        newDataList.remove(at: index - (newKeyList?.count ?? 0))
                                    }
                                    // data
                                    dataChange?(newKeyList ?? [String](), newDataList)
                                    // view
                                    collectView!.frame.size.height = ImgSquareEditCell.getCollectHeight(collect: collectView!, oldOssKeyList: newKeyList, newImgDataList: newDataList, limit: limit)
                                    collectView!.reloadData()
                                    // callback
                                    complete?()
        }, cancelHandler: nil)
    }
    
}
