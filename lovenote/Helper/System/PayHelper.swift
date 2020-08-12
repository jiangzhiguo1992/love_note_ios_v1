//
//  PayHelper.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/27.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import SwiftyStoreKit

class PayHelper {
    
    // 全局通知
    public static func onNotice() {
        SwiftyStoreKit.completeTransactions(atomically: false) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    // 同步服务器
                    if purchase.needsFinishTransaction {
                        billCheck(loading: false, purchase: purchase)
                    }
                case .failed, .purchasing, .deferred:
                    break
                default:
                    break
                }
            }
        }
    }
    
    // 获取商品信息 可以不用
    //    public static func getProductsInfo(productID: String, onsuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void) {
    //        let sets = Set(arrayLiteral: productID)
    //        SwiftyStoreKit.retrieveProductsInfo(sets) { result in
    //            if let product = result.retrievedProducts.first {
    //                onsuccess(product.productIdentifier)
    //            } else if result.invalidProductIDs.first != nil {
    //                onFailure(productID)
    //            } else {
    //                onFailure(productID)
    //            }
    //        }
    //    }
    
    // 购买商品
    public static func purchase(productID: String, onsuccess: @escaping (PurchaseDetails) -> Void, onFailure: @escaping () -> Void) {
        SwiftyStoreKit.purchaseProduct(productID, quantity: 1, atomically: false) { result in
            switch result {
            case .success(let purchase):
                AppDelegate.runOnMainAsync {
                    onsuccess(purchase)
                }
            case .error(let error):
                switch error.code {
                case .paymentCancelled:
                    break
                case .clientInvalid,
                     .paymentNotAllowed,
                     .cloudServicePermissionDenied,
                     .cloudServiceRevoked:
                    ToastUtils.show(StringUtils.getString("please_open_pay_services"))
                    break
                case .paymentInvalid,
                     .storeProductNotAvailable:
                    ToastUtils.show(StringUtils.getString("goods_no_exist"))
                    break
                case .cloudServiceNetworkConnectionFailed,
                     .unknown:
                    ToastUtils.show(StringUtils.getString("pay_error"))
                    break
                default: LogUtils.e(tag: "PayHelper", method: "purchase", (error as NSError).localizedDescription)
                }
                onFailure()
            }
        }
    }
    
    // 恢复购买
    public static func restorePurchase() {
        let indicator = AlertHelper.showIndicator(canCancel: false)
        SwiftyStoreKit.restorePurchases(atomically: false) { result in
            AlertHelper.diss(indicator)
            if result.restoredPurchases.count > 0 {
                for purchases in result.restoredPurchases {
                    billCheck(purchase: purchases)
                }
            }
        }
    }
    
    // 订单同步
    public static func billCheck(loading: Bool = true, purchaseDetails: PurchaseDetails? = nil, purchase: Purchase? = nil) {
        let indicator = AlertHelper.getIndicator(canCancel: false)
        if loading { AlertHelper.show(indicator) }
        // 开始获取本地收据(不要verify了，留给后台去做)
        SwiftyStoreKit.fetchReceipt(forceRefresh: true) { result in
            switch result {
            case .success(let receiptData): // 收据获取成功
                if loading { AlertHelper.diss(indicator) }
                let order = AppleOrder()
                order.productId = purchaseDetails != nil ? purchaseDetails!.productId : (purchase != nil ? purchase!.productId : "")
                order.transactionId = (purchaseDetails != nil ? purchaseDetails!.transaction.transactionIdentifier : (purchase != nil ? purchase!.transaction.transactionIdentifier : "")) ?? ""
                order.receipt = receiptData.base64EncodedString(options: [])
                // 同步服务器
                _ = Api.request(.morePayAfterCheck(order: order.toJSON()),
                                loading: loading, cancel: false, success: { (_, _, _) in
                                    // 完成支付
                                    if purchaseDetails != nil {
                                        finishTransaction(purchase: purchaseDetails!)
                                    }
                                    if purchase != nil {
                                        finishTransaction(purchase: purchase!)
                                    }
                                    // 通知
                                    NotifyHelper.post(NotifyHelper.TAG_VIP_INFO_REFRESH, obj: Vip())
                                    NotifyHelper.post(NotifyHelper.TAG_COIN_INFO_REFRESH, obj: Coin())
                }, failure: nil)
            case .error(let error): // 收据获取失败
                LogUtils.e(tag: "PayHelper", method: "billCheck", error)
                if loading {
                    AlertHelper.diss(indicator)
                    ToastUtils.show(StringUtils.getString("pay_error"))
                }
            }
        }
    }
    
    // 结束订单
    public static func finishTransaction(purchase: PurchaseDetails) {
        if purchase.needsFinishTransaction {
            SwiftyStoreKit.finishTransaction(purchase.transaction)
        }
    }
    
    // 结束订单
    public static func finishTransaction(purchase: Purchase) {
        if purchase.needsFinishTransaction {
            SwiftyStoreKit.finishTransaction(purchase.transaction)
        }
    }
    
}
