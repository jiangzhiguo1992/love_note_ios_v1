//
//  BaseSectionCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/9.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class BaseSectionCell: UICollectionReusableView {
    
    public static let ID_HEAD = "head"
    public static let ID_FOOT = "foot"
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = ColorHelper.getTrans()
    }
    
}
