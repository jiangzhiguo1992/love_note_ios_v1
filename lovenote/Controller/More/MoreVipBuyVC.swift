//
//  VipBuyVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/23.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import SwiftyStoreKit

class MoreVipBuyVC: BaseVC {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var maxWidth = self.view.frame.size.width
    
    // view
    private var scVip: UISegmentedControl!
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(MoreVipBuyVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "vip_buy")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_help_outline_white_24dp"), style: .plain, target: self, action: #selector(targetGoHelp))
        
        // limit
        let limit = UDHelper.getLimit()
        let goods1 = StringUtils.getString("pay_vip_goods_format", arguments: [limit.payVipGoods1Title, limit.payVipGoods1Days, limit.payVipGoods1Amount])
        let goods2 = StringUtils.getString("pay_vip_goods_format", arguments: [limit.payVipGoods2Title, limit.payVipGoods2Days, limit.payVipGoods2Amount])
        let goods3 = StringUtils.getString("pay_vip_goods_format", arguments: [limit.payVipGoods3Title, limit.payVipGoods3Days, limit.payVipGoods3Amount])
        let items = [goods1, goods2, goods3]
        
        // goods
        let height = ViewUtils.getFontHeight(font: ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL), width: (maxWidth - margin * 2) / 3 - margin, text: goods1) + margin * 2
        scVip = ViewHelper.getSegmentedControl(width: maxWidth - margin * 2, height: height, items: items, multiLine: true)
        scVip.frame.origin = CGPoint(x: margin, y: ScreenUtils.heightFit(30))
        
        // btn
        let btnPay = ViewHelper.getBtnBGPrimary(width: maxWidth - margin * 2, paddingV: ScreenUtils.heightFit(7.5), title: StringUtils.getString("apple_pay"), titleSize: ViewHelper.FONT_SIZE_BIG, titleColor: ColorHelper.getFontWhite(), circle: true, shadow: true)
        btnPay.frame.origin = CGPoint(x: margin, y: scVip.frame.origin.y + scVip.frame.size.height + ScreenUtils.heightFit(50))
        
        let btnBillCheck = ViewHelper.getBtnTextPrimary(title: StringUtils.getString("pay_success_but_nothing"), titleSize: ViewHelper.FONT_SIZE_SMALL, circle: false, shadow: false)
        btnBillCheck.center.x = maxWidth / 2
        btnBillCheck.frame.origin.y = btnPay.frame.origin.y + btnPay.frame.size.height + ScreenUtils.heightFit(20)
        
        // view
        self.view.addSubview(scVip)
        self.view.addSubview(btnPay)
        self.view.addSubview(btnBillCheck)
        
        // target
        btnPay.addTarget(self, action: #selector(payBefore), for: .touchUpInside)
        btnBillCheck.addTarget(self, action: #selector(targetBillCheck), for: .touchUpInside)
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_MORE_BILL)
    }
    
    @objc private func payBefore(sender: UIButton) {
        var goods = Bill.GOODS_VIP_1
        if scVip.selectedSegmentIndex == 1 {
            goods = Bill.GOODS_VIP_2
        } else if scVip.selectedSegmentIndex == 2 {
            goods = Bill.GOODS_VIP_3
        }
        // api
        let api = Api.request(.morePayBeforeGet(payPlatform: Bill.PAY_PLATFORM_APPLE, goods: goods), loading: true, cancel: true, success: { (_, _, data) in
            let indicator = AlertHelper.showIndicator(canCancel: false)
            // 返回商品信息
            let order = data.orderBefore?.appleOrder
            let prodectID = StringUtils.isEmpty(order?.productId) ? String(goods).trimmingCharacters(in: .whitespaces) : order!.productId
            // 开始购买
            PayHelper.purchase(productID: prodectID, onsuccess: { purchase in
                AlertHelper.diss(indicator)
                // 购买成功，同步服务器
                PayHelper.billCheck(purchaseDetails: purchase)
            }, onFailure: { () in
                AlertHelper.diss(indicator)
            })
        }, failure: nil)
        pushApi(api)
    }
    
    @objc private func targetBillCheck() {
        PayHelper.restorePurchase()
    }
}
