//
//  MarqueeView.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/15.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation

class MarqueeView: UIView {
    
    // var
    private var marginH: CGFloat!
    private var mark1: CGRect!
    private var mark2: CGRect!
    private var labArr = [UILabel]()
    
    private var isStop = false
    
    convenience init(frame: CGRect, title: String, font: UIFont, textColor: UIColor, align: NSTextAlignment = .left) {
        self.init(frame: frame)
        
        // label
        let lab1 = UILabel()
        lab1.font = font
        lab1.textColor = textColor
        lab1.numberOfLines = 1
        lab1.textAlignment = align
        
        let lab2 = UILabel()
        lab2.font = font
        lab2.textColor = textColor
        lab2.numberOfLines = 1
        lab2.textAlignment = align
        
        labArr.append(lab1)
        labArr.append(lab2)
        
        // view
        self.clipsToBounds = true
        self.addSubview(lab1)
        self.addSubview(lab2)
        
        // title
        marginH = frame.size.width / 5
        setTitle(title: title)
    }
    
    func setTitle(title: String) {
        isStop = true
        self.layer.removeAllAnimations()
        
        // title
        labArr[0].text = title
        labArr[1].text = title
        
        // label宽度大于view的宽度时，开始动画
        if initFrame() {
            isStop = false
            self.labAnimation()
        }
    }
    
    // 计算textLab的大小 + 位置
    func initFrame() -> Bool {
        let sizeOfText = labArr[0].sizeThatFits(CGSize.zero)
        let needAnim = sizeOfText.width > self.bounds.size.width
        
        mark1 = CGRect(x: 0, y: 0, width: needAnim ? sizeOfText.width : self.bounds.size.width, height: self.bounds.size.height)
        mark2 = CGRect(x: mark1.origin.x + mark1.size.width + marginH, y: 0, width: sizeOfText.width, height: self.bounds.size.height)
        labArr[0].frame = mark1
        labArr[1].frame = mark2
        
        labArr[1].isHidden = !needAnim
        
        return needAnim
    }
    
    //跑马灯动画
    func labAnimation() {
        if (!isStop) {
            // speed
            let timeInterval1 = TimeInterval((labArr[0].text?.lengthOfBytes(using: String.Encoding.utf8))! / 5)
            
            UIView.transition(with: self, duration: timeInterval1, options: .repeat, animations: {
                self.labArr[0].frame.origin = CGPoint(x: -(self.labArr[0].frame.size.width + self.marginH), y: 0)
                self.labArr[1].frame.origin = CGPoint(x: self.labArr[0].frame.origin.x + self.labArr[0].frame.size.width + self.marginH, y: 0)
            }, completion: { finished in
                if finished && !self.isStop && self.initFrame() { self.labAnimation() }
            })
        } else {
            labArr[1].isHidden = true
            self.layer.removeAllAnimations()
        }
    }
    
    //    // 强制动画
    //    func start() {
    //        isStop = false
    //        let lbindex0 = labArr[0]
    //        let lbindex1 = labArr[1]
    //
    //        lbindex0.frame = mark2;
    //        lbindex1.frame = mark1;
    //        self.labArr[0] = lbindex1
    //        self.labArr[1] = lbindex0
    //        self.labAnimation()
    //
    //    }
    //
    //    // 强制停止
    //    func stop() {
    //        isStop = true
    //        self.labAnimation()
    //    }
}
