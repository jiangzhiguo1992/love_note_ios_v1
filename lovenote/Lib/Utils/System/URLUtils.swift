//
//  URLUtils.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/6.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit


class URLUtils {
    
    public static func openSettings() {
        if Thread.isMainThread {
            let url = URL(string: UIApplication.openSettingsURLString)
            openURL(url!)
        } else {
            DispatchQueue.main.async {
                let url = URL(string: UIApplication.openSettingsURLString)
                openURL(url!)
            }
        }
    }
    
    public static func openDial(phone: String?) {
        let url = URL(string: "tel://\(phone ?? "")")
        openURL(url!)
    }
    
    public static func openAPPStore(id: String?) {
        if StringUtils.isEmpty(id) {
            return
        }
        let url = URL(string: "itms-apps://itunes.apple.com/app/id\(id!)")
        openURL(url!)
    }
    
    public static func openURL(_ url: URL?) {
        if url == nil {
            return
        }
        if Thread.isMainThread {
            if UIApplication.shared.canOpenURL(url!) {
                //根据iOS系统版本，分别处理
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url!)
                } else {
                    UIApplication.shared.openURL(url!)
                }
            }
        } else {
            DispatchQueue.main.async {
                if UIApplication.shared.canOpenURL(url!) {
                    //根据iOS系统版本，分别处理
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url!)
                    } else {
                        UIApplication.shared.openURL(url!)
                    }
                }
            }
        }
    }
}
