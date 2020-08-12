//
//  AppDelegate.swift
//  lovenote
//
//  Created by 蒋治国 on 2018/11/16.
//  Copyright © 2018年 蒋治国. All rights reserved.
//
// 打包流程
// 1.version 2.info 3.clean 4.scheme 5.device-target 6.断点+僵尸
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // 获取主窗口
    public static func getAppWindow() -> UIWindow {
        let app = UIApplication.shared.delegate as! AppDelegate
        return app.window!
    }
    
    // 获取主队列
    public static func getQueueMain() -> DispatchQueue {
        return DispatchQueue.main
    }
    
    // 主线程运行
    public static func runOnMainAsync(_ execute: @escaping (()-> Void)) {
        if !Thread.isMainThread {
            getQueueMain().async(execute: execute)
        } else {
            execute()
        }
    }
    
    public static func getQueueGlobal() -> DispatchQueue {
        return DispatchQueue.global()
    }
    
    // 程序加载完毕
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 支付，处理其他异常订单
        PayHelper.onNotice()
        // 阿里推送
        PushHelper.initAliPush(app: self, launchOptions: launchOptions)
        // 高德地图
        AmapHelper.initApp()
        // KingFisher图片加载框架
        KFHelper.initApp()
        // player
        PlayerHelper.initApp()
        return true
    }
    
    // 程序进入前台
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        // 作为从后台到活动状态的转换的一部分调用；在这里可以撤消在进入后台时所做的许多更改。
        OssHelper.startRefreshTimer(app: true)
    }
    
    // 程序被激活
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // 重新启动应用程序不活动时暂停（或尚未启动）的任何任务。如果应用程序以前位于后台，则可选地刷新用户界面。
    }
    
    // 程序取消激活状态
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        // 当应用程序即将从活动状态转移到非活动状态时发送。这可以发生在某些类型的临时中断（例如来电或SMS消息）或当用户退出应用程序并开始转换到后台状态时。
        // 使用此方法可以暂停正在进行的任务，禁用计时器，并使图形呈现回调无效。游戏应该用这个方法暂停游戏。
    }
    
    // 程序进入后台
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        // 使用此方法释放共享资源、保存用户数据、使定时器无效，并存储足够的应用程序状态信息，以便在以后终止应用程序时将应用程序恢复到当前状态。
        // 如果应用程序支持后台执行，则当用户退出时调用此方法而不是applicationWillTerminate。
        OssHelper.stopRefreshTimer()
    }
    
    // 内存不够将要终止
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
    }
    
    // 程序将要退出结束
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // 当应用程序即将终止时调用。保存数据，如果合适的话。参见applicationDidEnterBackground:.
    }
    
}

