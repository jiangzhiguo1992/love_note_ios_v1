//
//  WallPaperLoop.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/20.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class WallPaperLoop: UIView {
    
    // var
    private var timer: Timer?
    private var imageList: [UIImageView]?
    lazy var position = 0
    lazy var imgIndex = 0
    
    public func refreshViewWithData() {
        // clear
        stopLoop()
        imageList?.removeAll()
        for view in self.subviews {
            view.removeFromSuperview()
        }
        // 无图
        var dataList = UDHelper.getWallPaper().contentImageList
        if dataList.count <= 0 {
            return
        }
        // 单图
        if dataList.count <= 1 {
            // view
            let iv = ViewHelper.getImageViewUrl(width: self.frame.size.width, height: self.frame.size.height, indicator: false, radius: 0)
            iv.frame.origin = CGPoint(x: 0, y: 0)
            self.addSubview(iv)
            // data
            KFHelper.setImgUrl(iv: iv, objKey: dataList[0], resize: false)
            return
        }
        // 多图
        dataList.shuffle()
        if imageList == nil {
            imageList = [UIImageView]()
        }
        for index in 0...1 {
            // view
            let iv = ViewHelper.getImageViewUrl(width: self.frame.size.width, height: self.frame.size.height, indicator: false, radius: 0)
            iv.frame.origin = CGPoint(x: 0, y: 0)
            iv.tag = index
            self.addSubview(iv)
            imageList?.append(iv)
            // data
            KFHelper.setImgUrl(iv: iv, objKey: dataList[getNextImgIndex(max: dataList.count)], resize: false)
        }
        // 开始轮序
        startLoop()
    }
    
    public func startLoop() {
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(10), repeats: true, block: { (_) in
            // 需要隐藏的
            let lastView = self.imageList?[self.position]
            lastView?.isHidden = true
            let dataList = UDHelper.getWallPaper().contentImageList
            let index = self.getNextImgIndex(max: dataList.count)
            if index >= dataList.count {
                return
            }
            KFHelper.setImgUrl(iv: lastView, objKey: dataList[index], resize: false)
            lastView?.stopAnimating()
            // 需要显示的
            self.position = self.position == 0 ? 1 : 0
            let nextView = self.imageList?[self.position]
            nextView?.isHidden = false
            // 开始动画
            nextView?.alpha = 0.7
            let oldCenter = nextView?.center
            let oldWidth = nextView?.frame.size.width
            let oldHeight = nextView?.frame.size.height
            UIView.animate(withDuration: 5, animations: {
                nextView?.alpha = 1
            })
            UIView.animate(withDuration: 10, animations: {
                if oldWidth != nil {
                    nextView?.frame.size.width = oldWidth! * 1.2
                }
                if oldHeight != nil {
                    nextView?.frame.size.height = oldHeight! * 1.2
                }
                if oldCenter != nil {
                    nextView?.center = oldCenter!
                }
            }, completion: { (finish) in
                if oldWidth != nil {
                    nextView?.frame.size.width = oldWidth!
                }
                if oldHeight != nil {
                    nextView?.frame.size.height = oldHeight!
                }
                if oldCenter != nil {
                    nextView?.center = oldCenter!
                }
            })
        })
        timer?.fire()
    }
    
    public func stopLoop() {
        timer?.invalidate()
        timer = nil
    }
    
    private func getNextImgIndex(max: Int) -> Int {
        if max <= 1 {
            imgIndex = 0
            return imgIndex
        }
        var newIndex = Int.random(in: Range(0...(max - 1)))
        while imgIndex == newIndex {
            newIndex = Int.random(in: Range(0...(max - 1)))
        }
        imgIndex = newIndex
        return imgIndex
    }
    
}
