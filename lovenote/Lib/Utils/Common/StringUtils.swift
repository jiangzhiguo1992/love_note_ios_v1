//
// Created by 蒋治国 on 2018-12-15.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation

class StringUtils {

    public static func getString(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }

    public static func getString(_ key: String, arguments: [CVarArg]) -> String {
        let origin = getString(key)
        return String(format: origin, arguments: arguments)
    }

    public static func isEmpty(_ str: String?) -> Bool {
        if str == nil {
            return true
        }
        return str!.trimmingCharacters(in: .whitespaces).isEmpty
    }

    public static func getUUID(len: Int) -> String {
        let uuid = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        if len <= 0 {
            return uuid
        } else {
            return String(uuid.prefix(len))
        }
    }

}
