//
//  NoteTrendsCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/19.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteTrendsCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    
    private static let ITEM_MARGIN = ScreenUtils.widthFit(10)
    private static let AVATAR_WIDTH = ScreenUtils.widthFit(40)
    private static let SCREEN_WIDTH = ScreenUtils.getScreenWidth()
    private static let MAX_WIDTH = SCREEN_WIDTH - AVATAR_WIDTH - ITEM_MARGIN * 3
    
    // view
    private var ivAvatarLeft: UIImageView!
    private var lTextLeft: UILabel!
    private var ivImgLeft: UIImageView!
    private var vCardLeft: UIView!
    private var lTimeLeft: UILabel!
    
    private var ivAvatarRight: UIImageView!
    private var lTextRight: UILabel!
    private var ivImgRight: UIImageView!
    private var vCardRight: UIView!
    private var lTimeRight: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // ---------------------------left---------------------------
        // avatar
        ivAvatarLeft = ViewHelper.getImageViewAvatar(width: NoteTrendsCell.AVATAR_WIDTH, height: NoteTrendsCell.AVATAR_WIDTH)
        ivAvatarLeft.frame.origin = CGPoint(x: NoteTrendsCell.ITEM_MARGIN, y: NoteTrendsCell.ITEM_MARGIN)
        
        // card
        lTextLeft = ViewHelper.getLabelBlackNormal(text: StringUtils.getString("un_know"), lines: 0, align: .center)
        lTextLeft.frame.origin.x = NoteTrendsCell.ITEM_MARGIN
        ivImgLeft = ViewHelper.getImageView(img: UIImage(named: "ic_note_word_24dp"), mode: .center)
        ivImgLeft.frame.origin.x = lTextLeft.frame.origin.x + lTextLeft.frame.size.width + NoteTrendsCell.ITEM_MARGIN
        
        vCardLeft = UIView(frame: CGRect(x: ivAvatarLeft.frame.origin.x + ivAvatarLeft.frame.size.width + NoteTrendsCell.ITEM_MARGIN, y: NoteTrendsCell.ITEM_MARGIN, width: ivImgLeft.frame.origin.x + ivImgLeft.frame.size.width + NoteTrendsCell.ITEM_MARGIN, height: CountHelper.getMax(lTextLeft.frame.size.height, ivImgLeft.frame.size.height) + NoteTrendsCell.ITEM_MARGIN * 2))
        vCardLeft.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCardLeft, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vCardLeft, offset: ViewHelper.SHADOW_NORMAL)
        
        lTextLeft.center.y = vCardLeft.frame.size.height / 2
        ivImgLeft.center.y = vCardLeft.frame.size.height / 2
        vCardLeft.addSubview(lTextLeft)
        vCardLeft.addSubview(ivImgLeft)
        
        // time
        lTimeLeft = ViewHelper.getLabelWhiteSmall(width: NoteTrendsCell.MAX_WIDTH, text: "-", lines: 1, align: .left)
        lTimeLeft.frame.origin = CGPoint(x: vCardLeft.frame.origin.x , y: vCardLeft.frame.origin.y + vCardLeft.frame.size.height + NoteTrendsCell.ITEM_MARGIN / 2)
        
        // ---------------------------Right---------------------------
        // avatar
        ivAvatarRight = ViewHelper.getImageViewAvatar(width: NoteTrendsCell.AVATAR_WIDTH, height: NoteTrendsCell.AVATAR_WIDTH)
        ivAvatarRight.frame.origin = CGPoint(x: NoteTrendsCell.SCREEN_WIDTH - NoteTrendsCell.ITEM_MARGIN - NoteTrendsCell.AVATAR_WIDTH, y: NoteTrendsCell.ITEM_MARGIN)
        
        // card
        lTextRight = ViewHelper.getLabelBlackNormal(text: StringUtils.getString("un_know"), lines: 0, align: .center)
        lTextRight.frame.origin.x = NoteTrendsCell.ITEM_MARGIN
        ivImgRight = ViewHelper.getImageView(img: UIImage(named: "ic_note_word_24dp"), mode: .center)
        ivImgRight.frame.origin.x = lTextRight.frame.origin.x + lTextRight.frame.size.width + NoteTrendsCell.ITEM_MARGIN
        
        let cardRightWidth = ivImgRight.frame.origin.x + ivImgRight.frame.size.width + NoteTrendsCell.ITEM_MARGIN
        vCardRight = UIView(frame: CGRect(x: ivAvatarRight.frame.origin.x - NoteTrendsCell.ITEM_MARGIN - cardRightWidth, y: NoteTrendsCell.ITEM_MARGIN, width: cardRightWidth, height: CountHelper.getMax(lTextRight.frame.size.height, ivImgRight.frame.size.height) + NoteTrendsCell.ITEM_MARGIN * 2))
        vCardRight.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCardRight, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vCardRight, offset: ViewHelper.SHADOW_NORMAL)
        
        lTextRight.center.y = vCardRight.frame.size.height / 2
        ivImgRight.center.y = vCardRight.frame.size.height / 2
        vCardRight.addSubview(lTextRight)
        vCardRight.addSubview(ivImgRight)
        
        // time
        lTimeRight = ViewHelper.getLabelWhiteSmall(width: NoteTrendsCell.MAX_WIDTH, text: "-", lines: 1, align: .right)
        lTimeRight.frame.origin = CGPoint(x: ivAvatarRight.frame.origin.x - NoteTrendsCell.ITEM_MARGIN - lTimeRight.frame.size.width , y: vCardRight.frame.origin.y + vCardRight.frame.size.height + NoteTrendsCell.ITEM_MARGIN / 2)
        
        // view
        self.contentView.addSubview(ivAvatarLeft)
        self.contentView.addSubview(vCardLeft)
        self.contentView.addSubview(lTimeLeft)
        self.contentView.addSubview(ivAvatarRight)
        self.contentView.addSubview(vCardRight)
        self.contentView.addSubview(lTimeRight)
        
        // hiden
        ivAvatarLeft.isHidden = true
        vCardLeft.isHidden = true
        lTimeLeft.isHidden = true
        ivAvatarRight.isHidden = true
        vCardRight.isHidden = true
        lTimeRight.isHidden = true
    }
    
    public static func getCellHeight(view: UITableView, indexPath: IndexPath) -> CGFloat {
        if totalHeight == nil {
            let cell = NoteTrendsCell(style: .default, reuseIdentifier: NoteTrendsCell.ID)
            totalHeight = cell.lTimeLeft.frame.origin.y + cell.lTimeLeft.frame.size.height + NoteTrendsCell.ITEM_MARGIN
        }
        return totalHeight!
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Trends]?, target: Any?, action: Selector) -> NoteTrendsCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? NoteTrendsCell
        if cell == nil {
            cell = NoteTrendsCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        // data
        if dataList == nil || dataList!.count <= cell!.tag {
            return cell!
        }
        let trends = dataList![cell!.tag]
        let me = UDHelper.getMe()
        let isMe = trends.userId == me?.id
        let avatar = UserHelper.getAvatar(user: me, uid: trends.userId)
        
        // view
        if isMe {
            cell?.ivAvatarLeft.isHidden = true
            cell?.vCardLeft.isHidden = true
            cell?.lTimeLeft.isHidden = true
            cell?.ivAvatarRight.isHidden = false
            cell?.vCardRight.isHidden = false
            cell?.lTimeRight.isHidden = false
            
            KFHelper.setImgAvatarUrl(iv: cell?.ivAvatarRight, objKey: avatar, uid: trends.userId)
            cell?.lTextRight.text = getTrendsActShow(act: trends.actionType, conId: trends.contentId)
            cell?.ivImgRight.image = UIImage(named: getTrendsTypeIcon(contentType: trends.contentType))
            cell?.lTimeRight.text = TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(trends.updateAt)
        } else {
            cell?.ivAvatarLeft.isHidden = false
            cell?.vCardLeft.isHidden = false
            cell?.lTimeLeft.isHidden = false
            cell?.ivAvatarRight.isHidden = true
            cell?.vCardRight.isHidden = true
            cell?.lTimeRight.isHidden = true
            
            KFHelper.setImgAvatarUrl(iv: cell?.ivAvatarLeft, objKey: avatar, uid: trends.userId)
            cell?.lTextLeft.text = getTrendsActShow(act: trends.actionType, conId: trends.contentId)
            cell?.ivImgLeft.image = UIImage(named: getTrendsTypeIcon(contentType: trends.contentType))
            cell?.lTimeLeft.text = TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(trends.updateAt)
        }
        // target
        ViewUtils.addViewTapTarget(target: target, view: cell?.vCardLeft, action: action)
        ViewUtils.addViewTapTarget(target: target, view: cell?.vCardRight, action: action)
        return cell!
    }
    
    private static func getTrendsActShow(act: Int, conId: Int64) -> String {
        switch act {
        case Trends.TRENDS_ACT_TYPE_INSERT:
            return StringUtils.getString("add")
        case Trends.TRENDS_ACT_TYPE_DELETE:
            return StringUtils.getString("delete")
        case Trends.TRENDS_ACT_TYPE_UPDATE:
            return StringUtils.getString("modify")
        case Trends.TRENDS_ACT_TYPE_QUERY:
            if conId <= Trends.TRENDS_CON_ID_LIST {
                return StringUtils.getString("go_in")
            } else {
                return StringUtils.getString("browse")
            }
        default:
            return StringUtils.getString("un_know")
        }
    }
    
    private static func getTrendsTypeIcon(contentType: Int) -> String {
        switch contentType {
        case Trends.TRENDS_CON_TYPE_SOUVENIR: // 纪念日
            return "ic_note_souvenir_24dp"
        case Trends.TRENDS_CON_TYPE_WISH: // 愿望清单
            return "ic_note_souvenir_24dp"
        case Trends.TRENDS_CON_TYPE_MENSES: // 姨妈
            return "ic_note_menses_24dp"
        case Trends.TRENDS_CON_TYPE_SHY: // 羞羞
            return "ic_note_shy_24dp"
        case Trends.TRENDS_CON_TYPE_SLEEP: // 睡眠
            return "ic_note_sleep_24dp"
        case Trends.TRENDS_CON_TYPE_AUDIO: // 音频
            return "ic_note_audio_24dp"
        case Trends.TRENDS_CON_TYPE_VIDEO: // 视频
            return "ic_note_video_24dp"
        case Trends.TRENDS_CON_TYPE_ALBUM: // 相册
            return "ic_note_album_24dp"
        case Trends.TRENDS_CON_TYPE_WORD: // 留言
            return "ic_note_word_24dp"
        case Trends.TRENDS_CON_TYPE_WHISPER: // 耳语
            return "ic_note_whisper_24dp"
        case Trends.TRENDS_CON_TYPE_AWARD: // 打卡
            return "ic_note_award_24dp"
        case Trends.TRENDS_CON_TYPE_AWARD_RULE: // 约定
            return "ic_note_award_24dp"
        case Trends.TRENDS_CON_TYPE_DIARY: // 日记
            return "ic_note_diary_24dp"
        case Trends.TRENDS_CON_TYPE_DREAM: // 梦境
            return "ic_note_dream_24dp"
        case Trends.TRENDS_CON_TYPE_ANGRY: // 生气
            return "ic_note_angry_24dp"
        case Trends.TRENDS_CON_TYPE_GIFT: // 礼物
            return "ic_note_gift_24dp"
        case Trends.TRENDS_CON_TYPE_PROMISE: // 承诺
            return "ic_note_promise_24dp"
        case Trends.TRENDS_CON_TYPE_TRAVEL: // 游记
            return "ic_note_travel_24dp"
        case Trends.TRENDS_CON_TYPE_MOVIE: // 电影
            return "ic_note_movie_24dp"
        case Trends.TRENDS_CON_TYPE_FOOD: // 美食
            return "ic_note_food_24dp"
        default:
            return ""
        }
    }
    
    public static func go(view: UIView?, dataList: [Trends]?) {
        if let indexPath = ViewUtils.findTableIndexPath(view: view) {
            if dataList == nil || dataList!.count <= indexPath.row {
                return
            }
            let trends = dataList![indexPath.row]
            let actType =  trends.actionType
            if actType != Trends.TRENDS_ACT_TYPE_INSERT && actType != Trends.TRENDS_ACT_TYPE_UPDATE && actType != Trends.TRENDS_ACT_TYPE_QUERY{
                // 删除不能跳转
                return
            }
            let contentType = trends.contentType
            let contentId = trends.contentId
            switch contentType {
            case Trends.TRENDS_CON_TYPE_SOUVENIR: // 纪念日
                if contentId <= Trends.TRENDS_CON_ID_LIST {
                    NoteSouvenirVC.pushVC()
                } else {
                    NoteSouvenirDetailDoneVC.pushVC(sid: contentId)
                }
                break
            case Trends.TRENDS_CON_TYPE_WISH: // 愿望清单
                if contentId <= Trends.TRENDS_CON_ID_LIST {
                    NoteSouvenirVC.pushVC()
                } else {
                    NoteSouvenirDetailWishVC.pushVC(sid: contentId)
                }
                break
            case Trends.TRENDS_CON_TYPE_MENSES: // 姨妈
                NoteMensesVC.pushVC()
                break
            case Trends.TRENDS_CON_TYPE_SHY: // 羞羞
                NoteShyVC.pushVC()
                break
            case Trends.TRENDS_CON_TYPE_SLEEP: // 睡眠
                NoteSleepVC.pushVC()
                break
            case Trends.TRENDS_CON_TYPE_AUDIO: // 音频
                NoteAudioVC.pushVC()
                break
            case Trends.TRENDS_CON_TYPE_VIDEO: // 视频
                NoteVideoVC.pushVC()
                break
            case Trends.TRENDS_CON_TYPE_ALBUM: // 相册
                if contentId <= Trends.TRENDS_CON_ID_LIST {
                    NoteAlbumVC.pushVC()
                } else {
                    NotePictureVC.pushVC(aid: contentId)
                }
                break
            case Trends.TRENDS_CON_TYPE_WORD: // 留言
                NoteWordVC.pushVC()
                break
            case Trends.TRENDS_CON_TYPE_WHISPER: // 耳语
                NoteWhisperVC.pushVC()
                break
            case Trends.TRENDS_CON_TYPE_AWARD: // 打卡
                NoteAwardVC.pushVC()
                break
            case Trends.TRENDS_CON_TYPE_AWARD_RULE: // 约定
                NoteAwardRuleVC.pushVC()
                break
            case Trends.TRENDS_CON_TYPE_DIARY: // 日记
                if contentId <= Trends.TRENDS_CON_ID_LIST {
                    NoteDiaryVC.pushVC()
                } else {
                    NoteDiaryDetailVC.pushVC(did: contentId)
                }
                break
            case Trends.TRENDS_CON_TYPE_DREAM: // 梦境
                if contentId <= Trends.TRENDS_CON_ID_LIST {
                    NoteDreamVC.pushVC()
                } else {
                    NoteDreamDetailVC.pushVC(did: contentId)
                }
                break
            case Trends.TRENDS_CON_TYPE_ANGRY: // 生气
                if contentId <= Trends.TRENDS_CON_ID_LIST {
                    NoteAngryVC.pushVC()
                } else {
                    NoteAngryDetailVC.pushVC(aid: contentId)
                }
                break
            case Trends.TRENDS_CON_TYPE_GIFT: // 礼物
                NoteGiftVC.pushVC()
                break
            case Trends.TRENDS_CON_TYPE_PROMISE: // 承诺
                if contentId <= Trends.TRENDS_CON_ID_LIST {
                    NotePromiseVC.pushVC()
                } else {
                    NotePromiseDetailVC.pushVC(pid: contentId)
                }
                break
            case Trends.TRENDS_CON_TYPE_TRAVEL: // 游记
                if contentId <= Trends.TRENDS_CON_ID_LIST {
                    NoteTravelVC.pushVC()
                } else {
                    NoteTravelDetailVC.pushVC(tid: contentId)
                }
                break
            case Trends.TRENDS_CON_TYPE_MOVIE: // 电影
                NoteMovieVC.pushVC()
                break
            case Trends.TRENDS_CON_TYPE_FOOD: // 美食
                NoteFoodVC.pushVC()
                break
            default:
                break
            }
        }
    }
    
}
