//
//  VideoPlayVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/30.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import AVKit

class VideoPlayVC: BaseVC {
    
    // view
    private var playerVC: AVPlayerViewController!
    
    // var
    lazy var barTitle: String = ""
    lazy var ossKey: String = ""
    
    public static func pushVC(title: String = "", ossKey: String) {
        if StringUtils.isEmpty(ossKey) {
            return
        }
        AppDelegate.runOnMainAsync {
            let vc = VideoPlayVC(nibName: nil, bundle: nil)
            vc.barTitle = title
            vc.ossKey = ossKey
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: self.barTitle)
        
        // AVPlayer
        let player = PlayerHelper.getPlayer(ossKey: self.ossKey)
        // AVPlayerViewController
        playerVC = AVPlayerViewController()
        playerVC.player = player
        playerVC.view.frame = self.view.bounds
        playerVC.showsPlaybackControls = true
        if #available(iOS 11.0, *) {
            playerVC.entersFullScreenWhenPlaybackBegins = true
        }
        // view
        self.addChild(playerVC)
        self.view.addSubview(playerVC.view)
        playerVC.didMove(toParent: self)
    }
    
    override func initData() {
        // autoPlay
        PlayerHelper.play(player: playerVC.player)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        PlayerHelper.pause(player: playerVC.player)
    }
    
}
