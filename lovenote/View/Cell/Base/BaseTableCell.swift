//
//  BaseTableCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/21.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class BaseTableCell: UITableViewCell {
    
    public static let ID = "cell"
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCell.SelectionStyle.none
        
        self.contentView.backgroundColor = ColorHelper.getTrans()
        self.backgroundColor = ColorHelper.getTrans()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
