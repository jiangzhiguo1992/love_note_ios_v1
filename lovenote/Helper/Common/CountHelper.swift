//
//  CountHelper.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/27.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation

class CountHelper {
    
    public static func getMax(_ a: Int, _ b: Int) -> Int {
        if a > b {
            return a
        } else {
            return b
        }
    }
    
    public static func getMax(_ a: Int64, _ b: Int64) -> Int64 {
        if a > b {
            return a
        } else {
            return b
        }
    }
    
    public static func getMax(_ a: CGFloat, _ b: CGFloat) -> CGFloat {
        if a > b {
            return a
        } else {
            return b
        }
    }
    
    public static func getMin(_ a: Int, _ b: Int) -> Int {
        if a < b {
            return a
        } else {
            return b
        }
    }
    
    public static func getMin(_ a: Int64, _ b: Int64) -> Int64 {
        if a < b {
            return a
        } else {
            return b
        }
    }
    
    public static func getMin(_ a: CGFloat, _ b: CGFloat) -> CGFloat {
        if a < b {
            return a
        } else {
            return b
        }
    }
    
}
