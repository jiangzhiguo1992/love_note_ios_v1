//
// Created by 蒋治国 on 2018-12-16.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation

class AppUtils {

    public static func getInfoDictionary() -> [String: Any] {
        return Bundle.main.infoDictionary ?? [:]
    }

    public static func getInfoString(key: String?) -> String {
        if key == nil {
            return ""
        }
        return (getInfoDictionary()[key!] as? String) ?? ""
    }

    public static func getInfoInt(key: String?) -> Int {
        if key == nil {
            return 0
        }
        return (getInfoDictionary()[key!] as? Int) ?? 0
    }

    public static func getInfoBool(key: String?) -> Bool {
        if key == nil {
            return false
        }
        return (getInfoDictionary()[key!] as? Bool) ?? false
    }

    public static func getAppDisplayName() -> String {
        let dict = getInfoDictionary()
        let name = dict["CFBundleDisplayName"] as? String
        return name ?? ""
    }

    public static func exit() {
        abort()
    }

    public static func getAppIcon() -> String {
        return "AppIcon"
    }

    public static func getBundleID() -> String {
        let dict = getInfoDictionary()
        return Bundle.main.bundleIdentifier ?? dict["CFBundleIdentifier"] as? String ?? ""
    }

    public static func getAppVersion() -> String {
        let dict = getInfoDictionary()
        let version = dict["CFBundleShortVersionString"] as? String
        return (version ?? "").trimmingCharacters(in: .whitespaces)
    }

    public static func getBuildVersion() -> String {
        let dict = getInfoDictionary()
        let build = dict["CFBundleVersion"] as? String
        return (build ?? "").trimmingCharacters(in: .whitespaces)
    }

    public static func getAppStoreVersion(_ handle: ((_ vesion: String) -> Void)? = nil) {
        let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(getBundleID())")
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                LogUtils.e(tag: "AppUtils", method: "getAppStoreVersion", error as Any)
            }
            if data == nil {
                return
            }
            if response == nil {
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
            if json == nil {
                return
            }
            let dict = json as? NSDictionary
            if dict == nil {
                return
            }
            let results = dict!["results"]
            if results == nil {
                return
            }
            let resultsDict = results as? [NSDictionary]
            if resultsDict == nil || resultsDict!.count <= 0 {
                return
            }
            let result = resultsDict![0]
            let version = (result["version"] as? String) ?? ""
            handle?(version.trimmingCharacters(in: .whitespaces))
        }
        task.resume()
    }

}
