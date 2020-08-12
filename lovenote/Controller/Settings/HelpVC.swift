//
//  HelpVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/11.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class HelpVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    // const
    public static let INDEX_HOME = 0
    // couple
    public static let INDEX_COUPLE_HOME = 100
    public static let INDEX_COUPLE_PAIR = 110
    public static let INDEX_COUPLE_INFO = 120
    public static let INDEX_COUPLE_PLACE = 130
    public static let INDEX_COUPLE_WEATHER = 140
    // note
    public static let INDEX_NOTE_HOME = 200
    public static let INDEX_NOTE_LOCK = 210
    public static let INDEX_NOTE_SOUVENIR = 220
    public static let INDEX_NOTE_MENSES = 221
    public static let INDEX_NOTE_SHY = 222
    public static let INDEX_NOTE_SLEEP = 223
    public static let INDEX_NOTE_AUDIO = 230
    public static let INDEX_NOTE_ALBUM = 231
    public static let INDEX_NOTE_WORD = 240
    public static let INDEX_NOTE_WHISPER = 241
    public static let INDEX_NOTE_AWARD = 242
    public static let INDEX_NOTE_DIARY = 243
    public static let INDEX_NOTE_TRAVEL = 244
    // topic
    public static let INDEX_TOPIC_HOME = 300
    // more
    public static let INDEX_MORE_HOME = 400
    public static let INDEX_MORE_VIP = 410
    public static let INDEX_MORE_COIN = 420
    public static let INDEX_MORE_BILL = 430
    public static let INDEX_MORE_SIGN = 440
    public static let INDEX_MORE_MATCH = 450
    // other
    public static let INDEX_OTHER = 500
    public static let INDEX_USER_SUGGEST = 510
    
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var maxWidth = self.view.frame.size.width - margin * 2
    
    // view
    private var tableSubView: UITableView!
    private var tableContentView: UITableView!
    private var lDesc: UILabel!
    private var vHead: UIView!
    
    // var
    lazy var index: Int = HelpVC.INDEX_HOME
    private let tableSubTag: Int = 1
    private let tableContentTag: Int = 2
    private var limit: Limit!
    
    public static func pushVC(_ index: Int = INDEX_HOME) {
        AppDelegate.runOnMainAsync {
            let vc = HelpVC(nibName: nil, bundle: nil)
            vc.index = index
            vc.limit = UDHelper.getLimit()
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "help_document")
        
        // tableView
        tableSubView = ViewUtils.getTableView(target: self, frame: self.view.bounds, cellCls: HelpSubCell.self, id: HelpSubCell.ID)
        initScrollState(scroll: tableSubView, clipTopBar: true)
        tableSubView.tag = tableSubTag
        
        // tableHead
        lDesc = ViewHelper.getLabelGreyBig(width: maxWidth, text: "-", lines: 0, align: .left)
        lDesc.frame.origin = CGPoint(x: margin, y: margin)
        
        tableContentView = ViewUtils.getTableView(target: self, frame: self.view.bounds, cellCls: HelpContentCell.self, id: HelpContentCell.ID)
        tableContentView.frame.origin = CGPoint(x: 0, y: lDesc.frame.origin.y + lDesc.frame.size.height + margin / 2)
        tableContentView.tag = tableContentTag
        
        vHead = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: tableContentView.frame.origin.y + tableContentView.contentSize.height + margin / 2))
        vHead.addSubview(lDesc)
        vHead.addSubview(tableContentView)
        tableSubView.tableHeaderView = vHead
        
        // view
        self.view.addSubview(tableSubView)
    }
    
    override func initData() {
        let help = getHelpByIndex(index: index)
        self.title = help.title
        if StringUtils.isEmpty(help.desc) {
            lDesc.isHidden = true
        } else {
            lDesc.isHidden = false
            lDesc.text = help.desc
            let oldHeight = lDesc.frame.size.height
            lDesc.sizeToFit()
            let heightOffset = lDesc.frame.size.height - oldHeight
            tableContentView.frame.origin.y += heightOffset
        }
        tableContentView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let help = getHelpByIndex(index: index)
        if tableView.tag == tableContentTag {
            return help.contentList.count
        } else {
            return help.subList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let help = getHelpByIndex(index: index)
        if tableView.tag == tableContentTag {
            return HelpContentCell.getCellHeight(view: tableView, indexPath: indexPath, dataList: help.contentList)
        } else {
            return HelpSubCell.getCellHeight(view: tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let help = getHelpByIndex(index: index)
        if tableView.tag == tableContentTag {
            return HelpContentCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: help.contentList)
        } else {
            return HelpSubCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: help.subList)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.indexPathsForVisibleRows?.last?.row {
            // 最后一个展示出来了
            let headHeight = self.tableContentView.frame.origin.y + self.tableContentView.contentSize.height + self.lDesc.frame.origin.y
            if self.vHead.frame.size.height != headHeight {
                self.vHead.frame.size.height = headHeight
                // 刷新主列表
                self.tableSubView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == tableSubTag {
            let help = getHelpByIndex(index: index)
            if help.subList.count <= indexPath.row {
                HelpVC.pushVC(index)
                return
            }
            let sub = help.subList[indexPath.row]
            HelpVC.pushVC(sub.index)
        }
    }
    
    func getHelpByIndex(index: Int) -> Help {
        switch index {
        case HelpVC.INDEX_COUPLE_HOME:
            return getHelpCoupleHome(index: index)
        case HelpVC.INDEX_COUPLE_PAIR:
            return getHelpCouplePair(index: index)
        case HelpVC.INDEX_COUPLE_INFO:
            return getHelpCoupleInfo(index: index)
        case HelpVC.INDEX_COUPLE_PLACE:
            return  getHelpCouplePlace(index: index)
        case HelpVC.INDEX_COUPLE_WEATHER:
            return  getHelpCoupleWeather(index: index)
        case HelpVC.INDEX_NOTE_HOME:
            return getHelpNoteHome(index: index)
        case HelpVC.INDEX_NOTE_LOCK:
            return getHelpNoteLock(index: index)
        case HelpVC.INDEX_NOTE_SOUVENIR:
            return getHelpNoteSouvenir(index: index)
        case HelpVC.INDEX_NOTE_MENSES:
            return getHelpNoteMenses(index: index)
        case HelpVC.INDEX_NOTE_SHY:
            return getHelpNoteShy(index: index)
        case HelpVC.INDEX_NOTE_SLEEP:
            return getHelpNoteSleep(index: index)
        case HelpVC.INDEX_NOTE_AUDIO:
            return getHelpNoteAudio(index: index)
        case HelpVC.INDEX_NOTE_ALBUM:
            return getHelpNoteAlbum(index: index)
        case HelpVC.INDEX_NOTE_WORD:
            return getHelpNoteWork(index: index)
        case HelpVC.INDEX_NOTE_WHISPER:
            return getHelpNoteWhisper(index: index)
        case HelpVC.INDEX_NOTE_AWARD:
            return getHelpNoteAward(index: index)
        case HelpVC.INDEX_NOTE_DIARY:
            return getHelpNoteDiary(index: index)
        case HelpVC.INDEX_NOTE_TRAVEL:
            return getHelpNoteTravel(index: index)
        case HelpVC.INDEX_TOPIC_HOME:
            return getHelpTopicHome(index: index)
        case HelpVC.INDEX_MORE_HOME:
            return getHelpMoreHome(index: index)
        case HelpVC.INDEX_MORE_VIP:
            return getHelpMoreVip(index: index)
        case HelpVC.INDEX_MORE_COIN:
            return getHelpMoreCoin(index: index)
        case HelpVC.INDEX_MORE_BILL:
            return getHelpMoreBill(index: index)
        case HelpVC.INDEX_MORE_SIGN:
            return getHelpMoreSign(index: index)
        case HelpVC.INDEX_MORE_MATCH:
            return getHelpMoreMatch(index: index)
        case HelpVC.INDEX_OTHER:
            return getHelpOther(index: index)
        case HelpVC.INDEX_USER_SUGGEST:
            return getHelpSuggestHome(index: index)
        default:
            return getHelpHome()
        }
    }
    
    func getHelpHome() -> Help {
        let help = Help()
        help.index = HelpVC.INDEX_HOME
        help.title = StringUtils.getString("help_document")
        help.desc = StringUtils.getString("help_home_d")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_home_c1_q")
        c1.answer = StringUtils.getString("help_home_c1_a")
        help.contentList.append(c1)
        let c2 = HelpContent()
        c2.question = StringUtils.getString("help_home_c2_q")
        c2.answer = StringUtils.getString("help_home_c2_a", arguments: [StringUtils.getString("nav_couple"), StringUtils.getString("nav_note"), StringUtils.getString("nav_topic"), StringUtils.getString("nav_more")])
        help.contentList.append(c2)
        // sub
        let s1 = Help()
        s1.index = HelpVC.INDEX_COUPLE_HOME
        s1.title = StringUtils.getString("nav_couple")
        help.subList.append(s1)
        let s2 = Help()
        s2.index = HelpVC.INDEX_NOTE_HOME
        s2.title = StringUtils.getString("nav_note")
        help.subList.append(s2)
        let s3 = Help()
        s3.index = HelpVC.INDEX_TOPIC_HOME
        s3.title = StringUtils.getString("nav_topic")
        help.subList.append(s3)
        let s4 = Help()
        s4.index = HelpVC.INDEX_MORE_HOME
        s4.title = StringUtils.getString("nav_more")
        help.subList.append(s4)
        let s5 = Help()
        s5.index = HelpVC.INDEX_OTHER
        s5.title = StringUtils.getString("other")
        help.subList.append(s5)
        return help
    }
    
    func getHelpCoupleHome(index: Int) -> Help {
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("nav_couple")
        help.desc = StringUtils.getString("help_couple_home_d")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_couple_home_c1_q")
        c1.answer = StringUtils.getString("help_couple_home_c1_a")
        help.contentList.append(c1)
        let c2 = HelpContent()
        c2.question = StringUtils.getString("help_couple_home_c2_q")
        c2.answer = StringUtils.getString("help_couple_home_c2_a")
        help.contentList.append(c2)
        // sub
        let s1 = Help()
        s1.index = HelpVC.INDEX_COUPLE_PAIR
        s1.title = StringUtils.getString("pair")
        help.subList.append(s1)
        let s2 = Help()
        s2.index = HelpVC.INDEX_COUPLE_INFO
        s2.title = StringUtils.getString("pair_info")
        help.subList.append(s2)
        let s3 = Help()
        s3.index = HelpVC.INDEX_COUPLE_PLACE
        s3.title = StringUtils.getString("place")
        help.subList.append(s3)
        let s4 = Help()
        s4.index = HelpVC.INDEX_COUPLE_WEATHER
        s4.title = StringUtils.getString("weather")
        help.subList.append(s4)
        return help
    }
    
    func getHelpCouplePair(index: Int) -> Help {
        let intervalSec = limit.coupleInviteIntervalSec
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("pair")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_couple_pair_c1_q")
        c1.answer = StringUtils.getString("help_couple_pair_c1_a")
        help.contentList.append(c1)
        let c2 = HelpContent()
        c2.question = StringUtils.getString("help_couple_pair_c2_q")
        c2.answer = StringUtils.getString("help_couple_pair_c2_a", arguments: [intervalSec])
        help.contentList.append(c2)
        let c3 = HelpContent()
        c3.question = StringUtils.getString("help_couple_pair_c3_q")
        c3.answer = StringUtils.getString("help_couple_pair_c3_a")
        help.contentList.append(c3)
        return help
    }
    
    func getHelpCoupleInfo(index: Int) -> Help {
        let breakNeedDay = limit.coupleBreakNeedSec / DateUtils.UNIT_DAY
        let breakContinueHour = limit.coupleBreakSec / DateUtils.UNIT_HOUR
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("pair_info")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_couple_info_c1_q")
        c1.answer = StringUtils.getString("help_couple_info_c1_a")
        help.contentList.append(c1)
        let c2 = HelpContent()
        c2.question = StringUtils.getString("help_couple_info_c2_q")
        c2.answer = StringUtils.getString("help_couple_info_c2_a")
        help.contentList.append(c2)
        let c3 = HelpContent()
        c3.question = StringUtils.getString("help_couple_info_c3_q")
        c3.answer = StringUtils.getString("help_couple_info_c3_a")
        help.contentList.append(c3)
        let c4 = HelpContent()
        c4.question = StringUtils.getString("help_couple_info_c4_q")
        c4.answer = StringUtils.getString("help_couple_info_c4_a", arguments: [breakNeedDay, breakNeedDay, breakContinueHour])
        help.contentList.append(c4)
        return help
    }
    
    func getHelpCouplePlace(index: Int) -> Help {
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("place")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_couple_place_c1_q")
        c1.answer = StringUtils.getString("help_couple_place_c1_a")
        help.contentList.append(c1)
        let c2 = HelpContent()
        c2.question = StringUtils.getString("help_couple_place_c2_q")
        c2.answer = StringUtils.getString("help_couple_place_c2_a")
        help.contentList.append(c2)
        let c3 = HelpContent()
        c3.question = StringUtils.getString("help_couple_place_c3_q")
        c3.answer = StringUtils.getString("help_couple_place_c3_a")
        help.contentList.append(c3)
        let c4 = HelpContent()
        c4.question = StringUtils.getString("help_couple_place_c4_q")
        c4.answer = StringUtils.getString("help_couple_place_c4_a")
        help.contentList.append(c4)
        return help
    }
    
    func getHelpCoupleWeather(index: Int) -> Help {
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("weather")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_couple_weather_c1_q")
        c1.answer = StringUtils.getString("help_couple_weather_c1_a")
        help.contentList.append(c1)
        return help
    }
    
    func getHelpNoteHome(index: Int) -> Help {
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("nav_note")
        help.desc = StringUtils.getString("help_note_home_d")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_note_home_c1_q")
        c1.answer = StringUtils.getString("help_note_home_c1_a")
        help.contentList.append(c1)
        let c2 = HelpContent()
        c2.question = StringUtils.getString("help_note_home_c2_q")
        c2.answer = StringUtils.getString("help_note_home_c2_a")
        help.contentList.append(c2)
        // sub
        let s1 = Help()
        s1.index = HelpVC.INDEX_NOTE_LOCK
        s1.title = StringUtils.getString("pwd_lock")
        help.subList.append(s1)
        let s2 = Help()
        s2.index = HelpVC.INDEX_NOTE_SOUVENIR
        s2.title = StringUtils.getString("souvenir")
        help.subList.append(s2)
        let s12 = Help()
        s12.index = HelpVC.INDEX_NOTE_MENSES
        s12.title = StringUtils.getString("menses")
        help.subList.append(s12)
        let s11 = Help()
        s11.index = HelpVC.INDEX_NOTE_SHY
        s11.title = StringUtils.getString("shy")
        help.subList.append(s11)
        let s13 = Help()
        s13.index = HelpVC.INDEX_NOTE_SLEEP
        s13.title = StringUtils.getString("sleep")
        help.subList.append(s13)
        let s14 = Help()
        s14.index = HelpVC.INDEX_NOTE_AUDIO
        s14.title = StringUtils.getString("audio")
        help.subList.append(s14)
        let s15 = Help()
        s15.index = HelpVC.INDEX_NOTE_ALBUM
        s15.title = StringUtils.getString("album")
        help.subList.append(s15)
        let s3 = Help()
        s3.index = HelpVC.INDEX_NOTE_WORD
        s3.title = StringUtils.getString("word")
        help.subList.append(s3)
        let s4 = Help()
        s4.index = HelpVC.INDEX_NOTE_WHISPER
        s4.title = StringUtils.getString("whisper")
        help.subList.append(s4)
        let s6 = Help()
        s6.index = HelpVC.INDEX_NOTE_AWARD
        s6.title = StringUtils.getString("award")
        help.subList.append(s6)
        let s8 = Help()
        s8.index = HelpVC.INDEX_NOTE_DIARY
        s8.title = StringUtils.getString("diary")
        help.subList.append(s8)
        let s7 = Help()
        s7.index = HelpVC.INDEX_NOTE_TRAVEL
        s7.title = StringUtils.getString("travel")
        help.subList.append(s7)
        return help
    }
    
    func getHelpNoteLock(index: Int) -> Help {
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("pwd_lock")
        help.desc = StringUtils.getString("help_note_lock_d")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_note_lock_c1_q")
        c1.answer = StringUtils.getString("help_note_lock_c1_a")
        help.contentList.append(c1)
        let c2 = HelpContent()
        c2.question = StringUtils.getString("help_note_lock_c2_q")
        c2.answer = StringUtils.getString("help_note_lock_c2_a")
        help.contentList.append(c2)
        return help
    }
    
    func getHelpNoteSouvenir(index: Int) -> Help {
        let souvenirForeignYearCount = limit.souvenirForeignYearCount
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("pair")
        help.desc = StringUtils.getString("help_note_souvenir_d")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_note_souvenir_c1_q")
        c1.answer = StringUtils.getString("help_note_souvenir_c1_a")
        help.contentList.append(c1)
        let c2 = HelpContent()
        c2.question = StringUtils.getString("help_note_souvenir_c2_q")
        c2.answer = StringUtils.getString("help_note_souvenir_c2_a", arguments: [souvenirForeignYearCount])
        help.contentList.append(c2)
        let c3 = HelpContent()
        c3.question = StringUtils.getString("help_note_souvenir_c3_q")
        c3.answer = StringUtils.getString("help_note_souvenir_c3_a")
        help.contentList.append(c3)
        return help
    }
    
    func getHelpNoteMenses(index: Int) -> Help {
        let maxPerDay = limit.mensesMaxPerMonth
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("menses")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_note_menses_c1_q")
        c1.answer = StringUtils.getString("help_note_menses_c1_a", arguments: [maxPerDay])
        help.contentList.append(c1)
        let c2 = HelpContent()
        c2.question = StringUtils.getString("help_note_menses_c2_q")
        c2.answer = StringUtils.getString("help_note_menses_c2_a")
        help.contentList.append(c2)
        let c3 = HelpContent()
        c3.question = StringUtils.getString("help_note_menses_c3_q")
        c3.answer = StringUtils.getString("help_note_menses_c3_a")
        help.contentList.append(c3)
        let c4 = HelpContent()
        c4.question = StringUtils.getString("help_note_menses_c4_q")
        c4.answer = StringUtils.getString("help_note_menses_c4_a")
        help.contentList.append(c4)
        return help
    }
    
    func getHelpNoteShy(index: Int) -> Help {
        let maxPerDay = limit.shyMaxPerDay
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("shy")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_note_shy_c1_q")
        c1.answer = StringUtils.getString("help_note_shy_c1_a", arguments: [maxPerDay])
        help.contentList.append(c1)
        let c2 = HelpContent()
        c2.question = StringUtils.getString("help_note_shy_c2_q")
        c2.answer = StringUtils.getString("help_note_shy_c2_a")
        help.contentList.append(c2)
        let c3 = HelpContent()
        c3.question = StringUtils.getString("help_note_shy_c3_q")
        c3.answer = StringUtils.getString("help_note_shy_c3_a")
        help.contentList.append(c3)
        return help
    }
    
    func getHelpNoteSleep(index: Int) -> Help {
        let maxPerDay = limit.sleepMaxPerDay
        let minMin = limit.noteSleepSuccessMinSec / DateUtils.UNIT_MIN
        let maxHour = limit.noteSleepSuccessMaxSec / DateUtils.UNIT_HOUR
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("sleep")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_note_sleep_c1_q")
        c1.answer = StringUtils.getString("help_note_sleep_c1_a", arguments: [maxPerDay])
        help.contentList.append(c1)
        let c2 = HelpContent()
        c2.question = StringUtils.getString("help_note_sleep_c2_q")
        c2.answer = StringUtils.getString("help_note_sleep_c2_a")
        help.contentList.append(c2)
        let c3 = HelpContent()
        c3.question = StringUtils.getString("help_note_sleep_c3_q")
        c3.answer = StringUtils.getString("help_note_sleep_c3_a", arguments: [minMin, maxHour])
        help.contentList.append(c3)
        return help
    }
    
    func getHelpNoteAudio(index: Int) -> Help {
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("audio")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_note_audio_c1_q")
        c1.answer = StringUtils.getString("help_note_audio_c1_a")
        help.contentList.append(c1)
        return help
    }
    
    func getHelpNoteAlbum(index: Int) -> Help {
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("album")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_note_album_c1_q")
        c1.answer = StringUtils.getString("help_note_album_c1_a")
        help.contentList.append(c1)
        let c2 = HelpContent()
        c2.question = StringUtils.getString("help_note_album_c2_q")
        c2.answer = StringUtils.getString("help_note_album_c2_a")
        help.contentList.append(c2)
        return help
    }
    
    func getHelpNoteWork(index: Int) -> Help {
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("word")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_note_work_c1_q")
        c1.answer = StringUtils.getString("help_note_work_c1_a")
        help.contentList.append(c1)
        return help
    }
    
    func getHelpNoteWhisper(index: Int) -> Help {
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("whisper")
        help.desc = StringUtils.getString("help_note_whisper_d")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_note_whisper_c1_q")
        c1.answer = StringUtils.getString("help_note_whisper_c1_a")
        help.contentList.append(c1)
        let c2 = HelpContent()
        c2.question = StringUtils.getString("help_note_whisper_c2_q")
        c2.answer = StringUtils.getString("help_note_whisper_c2_a")
        help.contentList.append(c2)
        let c3 = HelpContent()
        c3.question = StringUtils.getString("help_note_whisper_c3_q")
        c3.answer = StringUtils.getString("help_note_whisper_c3_a")
        help.contentList.append(c3)
        let c4 = HelpContent()
        c4.question = StringUtils.getString("help_note_whisper_c4_q")
        c4.answer = StringUtils.getString("help_note_whisper_c4_a")
        help.contentList.append(c4)
        return help
    }
    
    func getHelpNoteAward(index: Int) -> Help {
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("award")
        help.desc = StringUtils.getString("help_note_award_d")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_note_award_c1_q")
        c1.answer = StringUtils.getString("help_note_award_c1_a")
        help.contentList.append(c1)
        let c2 = HelpContent()
        c2.question = StringUtils.getString("help_note_award_c2_q")
        c2.answer = StringUtils.getString("help_note_award_c2_a")
        help.contentList.append(c2)
        let c3 = HelpContent()
        c3.question = StringUtils.getString("help_note_award_c3_q")
        c3.answer = StringUtils.getString("help_note_award_c3_a")
        help.contentList.append(c3)
        let c4 = HelpContent()
        c4.question = StringUtils.getString("help_note_award_c4_q")
        c4.answer = StringUtils.getString("help_note_award_c4_a")
        help.contentList.append(c4)
        return help
    }
    
    func getHelpNoteDiary(index: Int) -> Help {
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("diary")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_note_diary_c1_q")
        c1.answer = StringUtils.getString("help_note_diary_c1_a")
        help.contentList.append(c1)
        return help
    }
    
    func getHelpNoteTravel(index: Int) -> Help {
        let placeCount = limit.travelPlaceCount
        let albumCount = limit.travelAlbumCount
        let videoCount = limit.travelVideoCount
        let foodCount = limit.travelFoodCount
        let movieCount = limit.travelMovieCount
        let diaryCount = limit.travelDiaryCount
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("travel")
        help.desc = StringUtils.getString("help_note_travel_d")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_note_travel_c1_q")
        c1.answer = StringUtils.getString("help_note_travel_c1_a", arguments: [placeCount, albumCount, videoCount, foodCount, movieCount, diaryCount])
        help.contentList.append(c1)
        return help
    }
    
    func getHelpTopicHome(index: Int) -> Help {
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("nav_topic")
        help.desc = StringUtils.getString("help_topic_home_d")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_topic_home_c1_q")
        c1.answer = StringUtils.getString("help_topic_home_c1_a")
        help.contentList.append(c1)
        let c2 = HelpContent()
        c2.question = StringUtils.getString("help_topic_home_c2_q")
        c2.answer = StringUtils.getString("help_topic_home_c2_a")
        help.contentList.append(c2)
        let c3 = HelpContent()
        c3.question = StringUtils.getString("help_topic_home_c3_q")
        c3.answer = StringUtils.getString("help_topic_home_c3_a")
        help.contentList.append(c3)
        let c4 = HelpContent()
        c4.question = StringUtils.getString("help_topic_home_c4_q")
        c4.answer = StringUtils.getString("help_topic_home_c4_a")
        help.contentList.append(c4)
        return help
    }
    
    func getHelpMoreHome(index: Int) -> Help {
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("nav_more")
        help.desc = StringUtils.getString("help_more_home_d")
        // sub
        let s1 = Help()
        s1.index = HelpVC.INDEX_MORE_VIP
        s1.title = StringUtils.getString("vip")
        help.subList.append(s1)
        let s2 = Help()
        s2.index = HelpVC.INDEX_MORE_COIN
        s2.title = StringUtils.getString("coin")
        help.subList.append(s2)
        let s3 = Help()
        s3.index = HelpVC.INDEX_MORE_SIGN
        s3.title = StringUtils.getString("sign")
        help.subList.append(s3)
        let s4 = Help()
        s4.index = HelpVC.INDEX_MORE_MATCH
        s4.title = StringUtils.getString("nav_match")
        help.subList.append(s4)
        return help
    }
    
    func getHelpMoreVip(index: Int) -> Help {
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("vip")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_more_vip_c1_q")
        c1.answer = StringUtils.getString("help_more_vip_c1_a")
        help.contentList.append(c1)
        let c2 = HelpContent()
        c2.question = StringUtils.getString("help_more_vip_c2_q")
        c2.answer = StringUtils.getString("help_more_vip_c2_a")
        help.contentList.append(c2)
        // sub
        let s1 = Help()
        s1.index = HelpVC.INDEX_MORE_BILL
        s1.title = StringUtils.getString("pay")
        help.subList.append(s1)
        return help
    }
    
    func getHelpMoreCoin(index: Int) -> Help {
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("coin")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_more_coin_c1_q")
        c1.answer = StringUtils.getString("help_more_coin_c1_a")
        help.contentList.append(c1)
        let c2 = HelpContent()
        c2.question = StringUtils.getString("help_more_coin_c2_q")
        c2.answer = StringUtils.getString("help_more_coin_c2_a")
        help.contentList.append(c2)
        // sub
        let s1 = Help()
        s1.index = HelpVC.INDEX_MORE_BILL
        s1.title = StringUtils.getString("pay")
        help.subList.append(s1)
        return help
    }
    
    func getHelpMoreBill(index: Int) -> Help {
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("pay")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_more_bill_c1_q")
        c1.answer = StringUtils.getString("help_more_bill_c1_a")
        help.contentList.append(c1)
        let c2 = HelpContent()
        c2.question = StringUtils.getString("help_more_bill_c2_q")
        c2.answer = StringUtils.getString("help_more_bill_c2_a")
        help.contentList.append(c2)
        return help
    }
    
    func getHelpMoreSign(index: Int) -> Help {
        let minCount = limit.coinSignMinCount
        let maxCount = limit.coinSignMaxCount
        let increaseCount = limit.coinSignIncreaseCount
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("sign")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_more_sign_c1_q")
        c1.answer = StringUtils.getString("help_more_sign_c1_a")
        help.contentList.append(c1)
        let c2 = HelpContent()
        c2.question = StringUtils.getString("help_more_sign_c2_q")
        c2.answer = StringUtils.getString("help_more_sign_c2_a")
        help.contentList.append(c2)
        let c3 = HelpContent()
        c3.question = StringUtils.getString("help_more_sign_c3_q")
        c3.answer = StringUtils.getString("help_more_sign_c3_a", arguments: [minCount, increaseCount, maxCount])
        help.contentList.append(c3)
        return help
    }
    
    func getHelpMoreMatch(index: Int) -> Help {
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("nav_match")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_more_match_c1_q")
        c1.answer = StringUtils.getString("help_more_match_c1_a")
        help.contentList.append(c1)
        let c2 = HelpContent()
        c2.question = StringUtils.getString("help_more_match_c2_q")
        c2.answer = StringUtils.getString("help_more_match_c2_a")
        help.contentList.append(c2)
        let c3 = HelpContent()
        c3.question = StringUtils.getString("help_more_match_c3_q")
        c3.answer = StringUtils.getString("help_more_match_c3_a")
        help.contentList.append(c3)
        let c4 = HelpContent()
        c4.question = StringUtils.getString("help_more_match_c4_q")
        c4.answer = StringUtils.getString("help_more_match_c4_a")
        help.contentList.append(c4)
        let c5 = HelpContent()
        c5.question = StringUtils.getString("help_more_match_c5_q")
        c5.answer = StringUtils.getString("help_more_match_c5_a")
        help.contentList.append(c5)
        let c6 = HelpContent()
        c6.question = StringUtils.getString("help_more_match_c6_q")
        c6.answer = StringUtils.getString("help_more_match_c6_a")
        help.contentList.append(c6)
        return help
    }
    
    func getHelpOther(index: Int) -> Help {
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("other")
        // sub
        let s1 = Help()
        s1.index = HelpVC.INDEX_USER_SUGGEST
        s1.title = StringUtils.getString("suggest_feedback")
        help.subList.append(s1)
        return help
    }
    
    func getHelpSuggestHome(index: Int) -> Help {
        let help = Help()
        help.index = index
        help.title = StringUtils.getString("suggest_feedback")
        help.desc = StringUtils.getString("help_suggest_home_d")
        // content
        let c1 = HelpContent()
        c1.question = StringUtils.getString("help_suggest_home_c1_q")
        c1.answer = StringUtils.getString("help_suggest_home_c1_a")
        help.contentList.append(c1)
        return help
    }
    
}
