//
//  MoreCoinBuyVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/23.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import SwiftyStoreKit

class MoreCoinBuyVC: BaseVC {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var maxWidth = self.view.frame.size.width
    
    // view
    private var scCoin: UISegmentedControl!
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(MoreCoinBuyVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "coin_buy")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_help_outline_white_24dp"), style: .plain, target: self, action: #selector(targetGoHelp))
        
        // limit
        let limit = UDHelper.getLimit()
        let goods1 = StringUtils.getString("pay_coin_goods_format", arguments: [limit.payCoinGoods1Title, limit.payCoinGoods1Count, limit.payCoinGoods1Amount])
        let goods2 = StringUtils.getString("pay_coin_goods_format", arguments: [limit.payCoinGoods2Title, limit.payCoinGoods2Count, limit.payCoinGoods2Amount])
        let goods3 = StringUtils.getString("pay_coin_goods_format", arguments: [limit.payCoinGoods3Title, limit.payCoinGoods3Count, limit.payCoinGoods3Amount])
        let items = [goods1, goods2, goods3]
        
        // goods
        let height = ViewUtils.getFontHeight(font: ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL), width: (maxWidth - margin * 2) / 3 - margin, text: goods1) + margin * 2
        scCoin = ViewHelper.getSegmentedControl(width: maxWidth - margin * 2, height: height, items: items, multiLine: true)
        scCoin.frame.origin = CGPoint(x: margin, y: ScreenUtils.heightFit(30))
        
        // btn
        let btnPay = ViewHelper.getBtnBGPrimary(width: maxWidth - margin * 2, paddingV: ScreenUtils.heightFit(7.5), title: StringUtils.getString("apple_pay"), titleSize: ViewHelper.FONT_SIZE_BIG, titleColor: ColorHelper.getFontWhite(), circle: true, shadow: true)
        btnPay.frame.origin = CGPoint(x: margin, y: scCoin.frame.origin.y + scCoin.frame.size.height + ScreenUtils.heightFit(50))
        
        let btnBillCheck = ViewHelper.getBtnTextPrimary(title: StringUtils.getString("pay_success_but_nothing"), titleSize: ViewHelper.FONT_SIZE_SMALL, circle: false, shadow: false)
        btnBillCheck.center.x = maxWidth / 2
        btnBillCheck.frame.origin.y = btnPay.frame.origin.y + btnPay.frame.size.height + ScreenUtils.heightFit(20)
        
        // view
        self.view.addSubview(scCoin)
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
        var goods = Bill.GOODS_COIN_1
        if scCoin.selectedSegmentIndex == 1 {
            goods = Bill.GOODS_COIN_2
        } else if scCoin.selectedSegmentIndex == 2 {
            goods = Bill.GOODS_COIN_3
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
