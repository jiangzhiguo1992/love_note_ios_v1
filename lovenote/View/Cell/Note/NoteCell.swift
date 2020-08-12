//
//  NoteCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/2/22.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteCell: BaseCollectCell {
    
    // const
    //public static let SOUVENIR = 1;
    public static let SHY = 2;
    public static let MENSES = 3;
    public static let SLEEP = 4;
    public static let WORD = 5;
    public static let WHISPER = 6;
    public static let DIARY = 7;
    public static let AWARD = 8;
    public static let DREAM = 9;
    public static let MOVIE = 10;
    public static let FOOD = 11;
    public static let TRAVEL = 12;
    public static let ANGRY = 13;
    public static let GIFT = 14;
    public static let PROMISE = 15;
    public static let AUDIO = 16;
    public static let VIDEO = 17;
    public static let ALBUM = 18;
    public static let TOTAL = 19;
    public static let TRENDS = 20;
    public static let CUSTOM = 21;
    
    private static let MARGIN = ScreenUtils.widthFit(5)
    private static let CELL_MARGIN = ScreenUtils.widthFit(5)
    private static let ICON_MARGIN = ScreenUtils.widthFit(5)
    private static var CELL_WIDTH: CGFloat = 0
    private static var CELL_HEIGHT: CGFloat = 0
    
    // view
    private var ivIcon: UIImageView!
    private var lTitle: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // icon
        ivIcon = ViewHelper.getImageView(img: UIImage(named: "ic_note_souvenir_24dp"))
        ivIcon.frame.size.width = NoteCell.CELL_WIDTH
        ivIcon.contentMode = .center
        ivIcon.frame.origin = CGPoint(x: 0, y: NoteCell.MARGIN * 2)
        
        // title
        lTitle = ViewHelper.getLabelGreyNormal(width: NoteCell.CELL_WIDTH, text: "-", lines: 1, align: .center)
        lTitle.frame.origin = CGPoint(x: 0, y: ivIcon.frame.origin.y + ivIcon.frame.size.height + NoteCell.MARGIN)
        
        // view
        self.addSubview(ivIcon)
        self.addSubview(lTitle)
    }
    
    public static func getLayout(itemMargin: CGFloat = CELL_MARGIN, iconMargin: CGFloat = ICON_MARGIN) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = getItemSize(itemMargin: itemMargin, iconMargin: iconMargin)
        // collect间隙的margin
        layout.minimumLineSpacing = itemMargin
        layout.minimumInteritemSpacing = itemMargin
        // collect本身的margin
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }
    
    private static func getItemSize(maxWidth: CGFloat = (ScreenUtils.getScreenWidth() - ScreenUtils.widthFit(10) * 2), itemMargin: CGFloat = CELL_MARGIN, iconMargin: CGFloat = ICON_MARGIN) -> CGSize {
        if NoteCell.CELL_WIDTH <= 0 {
            NoteCell.CELL_WIDTH = (maxWidth - itemMargin * CGFloat(NoteCell.SPAN_COUNT_4 - 1)) / CGFloat(NoteCell.SPAN_COUNT_4)
        }
        if NoteCell.CELL_HEIGHT <= 0 {
            let ivIcon = ViewHelper.getImageView(img: UIImage(named: "ic_note_souvenir_24dp"))
            let lTitle = ViewHelper.getLabelGreyNormal(text: "-", lines: 1)
            NoteCell.CELL_HEIGHT = ivIcon.frame.size.height + lTitle.frame.size.height + iconMargin * 5
        }
        return CGSize(width: NoteCell.CELL_WIDTH, height: NoteCell.CELL_HEIGHT)
    }
    
    public static func getCellWithData(view: UICollectionView, indexPath: IndexPath, dataList: [Int]?) -> NoteCell {
        let cell = view.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath) as! NoteCell
        cell.tag = indexPath.item
        // data
        if dataList == nil || dataList!.count <= cell.tag {
            return cell
        }
        let itemData = dataList![cell.tag]
        // view
        switch itemData {
        case NoteCell.SHY:
            cell.ivIcon.image = UIImage(named: "ic_note_shy_24dp")
            cell.lTitle.text = StringUtils.getString("shy")
            break
        case NoteCell.MENSES:
            cell.ivIcon.image = UIImage(named: "ic_note_menses_24dp")
            cell.lTitle.text = StringUtils.getString("menses")
            break
        case NoteCell.SLEEP:
            cell.ivIcon.image = UIImage(named: "ic_note_sleep_24dp")
            cell.lTitle.text = StringUtils.getString("sleep")
            break
        case NoteCell.WORD:
            cell.ivIcon.image = UIImage(named: "ic_note_word_24dp")
            cell.lTitle.text = StringUtils.getString("word")
        case NoteCell.SHY:
            cell.ivIcon.image = UIImage(named: "ic_note_shy_24dp")
            cell.lTitle.text = StringUtils.getString("shy")
            break
        case NoteCell.WHISPER:
            cell.ivIcon.image = UIImage(named: "ic_note_whisper_24dp")
            cell.lTitle.text = StringUtils.getString("whisper")
            break
        case NoteCell.DIARY:
            cell.ivIcon.image = UIImage(named: "ic_note_diary_24dp")
            cell.lTitle.text = StringUtils.getString("diary")
            break
        case NoteCell.AWARD:
            cell.ivIcon.image = UIImage(named: "ic_note_award_24dp")
            cell.lTitle.text = StringUtils.getString("award")
            break
        case NoteCell.DREAM:
            cell.ivIcon.image = UIImage(named: "ic_note_dream_24dp")
            cell.lTitle.text = StringUtils.getString("dream")
            break
        case NoteCell.MOVIE:
            cell.ivIcon.image = UIImage(named: "ic_note_movie_24dp")
            cell.lTitle.text = StringUtils.getString("movie")
            break
        case NoteCell.FOOD:
            cell.ivIcon.image = UIImage(named: "ic_note_food_24dp")
            cell.lTitle.text = StringUtils.getString("food")
            break
        case NoteCell.TRAVEL:
            cell.ivIcon.image = UIImage(named: "ic_note_travel_24dp")
            cell.lTitle.text = StringUtils.getString("travel")
            break
        case NoteCell.ANGRY:
            cell.ivIcon.image = UIImage(named: "ic_note_angry_24dp")
            cell.lTitle.text = StringUtils.getString("angry")
            break
        case NoteCell.GIFT:
            cell.ivIcon.image = UIImage(named: "ic_note_gift_24dp")
            cell.lTitle.text = StringUtils.getString("gift")
            break
        case NoteCell.PROMISE:
            cell.ivIcon.image = UIImage(named: "ic_note_promise_24dp")
            cell.lTitle.text = StringUtils.getString("promise")
            break
        case NoteCell.AUDIO:
            cell.ivIcon.image = UIImage(named: "ic_note_audio_24dp")
            cell.lTitle.text = StringUtils.getString("audio")
            break
        case NoteCell.VIDEO:
            cell.ivIcon.image = UIImage(named: "ic_note_video_24dp")
            cell.lTitle.text = StringUtils.getString("video")
            break
        case NoteCell.ALBUM:
            cell.ivIcon.image = UIImage(named: "ic_note_album_24dp")
            cell.lTitle.text = StringUtils.getString("album")
            break
        case NoteCell.TOTAL:
            cell.ivIcon.image = UIImage(named: "ic_note_total_24dp")
            cell.lTitle.text = StringUtils.getString("statistics")
            break
        case NoteCell.TRENDS:
            cell.ivIcon.image = UIImage(named: "ic_note_trends_24dp")
            cell.lTitle.text = StringUtils.getString("trends")
            break
        case NoteCell.CUSTOM:
            cell.ivIcon.image = UIImage(named: "ic_note_custom_24dp")
            cell.lTitle.text = StringUtils.getString("func_custom")
            break
        default: break
        }
        return cell
    }
    
}
