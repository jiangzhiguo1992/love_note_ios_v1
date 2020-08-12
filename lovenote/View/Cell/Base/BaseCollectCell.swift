//
//  BaseCollectionViewCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/19.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class BaseCollectCell: UICollectionViewCell {
    
    public static let ID = "cell"
    
    public static let SPAN_COUNT_2 = 2
    public static let SPAN_COUNT_3 = 3
    public static let SPAN_COUNT_4 = 4
    public static let SPAN_COUNT_5 = 5
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = ColorHelper.getTrans()
        self.backgroundColor = ColorHelper.getTrans()
    }
    
}
