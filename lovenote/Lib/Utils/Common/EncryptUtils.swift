//
// Created by 蒋治国 on 2018-12-16.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation
import CommonCrypto.CommonDigest
import CommonCrypto.CommonCryptor

class EncryptUtils {

    public static func md5String(_ str: String?) -> String {
        if str == nil {
            return ""
        }
        let cStr = str!.cString(using: String.Encoding.utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!, (CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0..<16 {
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }

}
