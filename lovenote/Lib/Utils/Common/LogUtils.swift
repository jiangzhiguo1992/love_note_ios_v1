//
// Created by 蒋治国 on 2018/12/6.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation

class LogUtils {

    private static var DEBUG = true

    public static func initApp(debug: Bool) {
        DEBUG = debug
    }

    public static func d(tag: String = AppUtils.getAppDisplayName(), method: String = "", _ items: Any...) {
        if !DEBUG {
            return
        }
        let name = AppUtils.getAppDisplayName()
        print("\(name) - \(tag) - \(method)\n", "->", items, "\n")
    }

    public static func i(tag: String = AppUtils.getAppDisplayName(), method: String = "", _ items: Any...) {
        if !DEBUG {
            return
        }
        let name = AppUtils.getAppDisplayName()
        print("\(name) - \(tag) - \(method)\n", "->", items, "\n")
    }

    public static func w(tag: String = AppUtils.getAppDisplayName(), method: String = "", _ items: Any...) {
        if !DEBUG {
            return
        }
        let name = AppUtils.getAppDisplayName()
        print("\(name) - \(tag) - \(method)\n", "->", items, "\n")
    }

    public static func e(tag: String = AppUtils.getAppDisplayName(), method: String = "", _ items: Any...) {
        let name = AppUtils.getAppDisplayName()
        print("\(name) - \(tag) - \(method)\n", "->", items, "\n")
    }

}
