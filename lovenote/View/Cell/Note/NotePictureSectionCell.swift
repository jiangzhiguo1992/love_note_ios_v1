//
//  NotePictureSectionCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/9.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NotePictureSectionCell: BaseSectionCell {
    
    // const
    private static let MARGIN = ScreenUtils.widthFit(5)
    
    // view
    public var lHappenAt: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let maxWidth = self.frame.size.width
        let maxHeight = self.frame.size.height
        
        // happen
        lHappenAt = ViewHelper.getLabelGreySmall(text: "  xxxx-xx-xx  ", lines: 1, align: .center, mode: .byTruncatingMiddle)
        lHappenAt.center.x = maxWidth / 2
        lHappenAt.center.y = maxHeight / 2
        
        // line
        let vLineLeft = ViewHelper.getViewLine(width: (maxWidth - lHappenAt.frame.size.width - NotePictureSectionCell.MARGIN * 6) / 2)
        vLineLeft.frame.origin.x = NotePictureSectionCell.MARGIN
        vLineLeft.center.y = lHappenAt.center.y
        
        let vLineRight = ViewHelper.getViewLine(width: (maxWidth - lHappenAt.frame.size.width - NotePictureSectionCell.MARGIN * 6) / 2)
        vLineRight.frame.origin.x = lHappenAt.frame.origin.x + lHappenAt.frame.size.width + NotePictureSectionCell.MARGIN * 2
        vLineRight.center.y = lHappenAt.center.y
        
        self.addSubview(lHappenAt)
        self.addSubview(vLineLeft)
        self.addSubview(vLineRight)
    }
    
}
