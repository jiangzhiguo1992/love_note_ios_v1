//
//  CoupleWeatherCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/22.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class CoupleWeatherCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    
    private static let MARGIN = ScreenUtils.widthFit(10)
    private static let MAX_WIDTH = ScreenUtils.getScreenWidth() - MARGIN * 2
    
    // view
    private var lTime: UILabel!
    private var vRoot: (UIView,
    (UIView, UILabel, UILabel, UIImageView, UIImageView, UILabel, UILabel),
    (UIView, UILabel, UILabel, UIImageView, UIImageView, UILabel, UILabel))!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // date
        lTime = ViewHelper.getLabel(width: CoupleWeatherCell.MAX_WIDTH, text: "-", color: ThemeHelper.getColorDark(), lines: 1, align: .center)
        lTime.frame.origin = CGPoint(x: 0, y: CoupleWeatherCell.MARGIN)
        
        // weather
        vRoot = CoupleWeatherCell.getWeatherRoot(margin: CoupleWeatherCell.MARGIN, color: ThemeHelper.getColorDark())
        vRoot.0.frame.origin = CGPoint(x: 0, y: lTime.frame.origin.y + lTime.frame.size.height + CoupleWeatherCell.MARGIN)
        //        ViewUtils.setViewRadius(vRoot.0, radius: ViewHelper.RADIUS_NORMAL)
        //        ViewUtils.setViewBorder(vRoot.0, width: CGFloat(1), color: ColorHelper.getBlack50())
        
        // view
        self.contentView.addSubview(lTime)
        self.contentView.addSubview(vRoot.0)
    }
    
    public static func getWeatherRoot(margin: CGFloat, color: UIColor) -> (UIView,
        (UIView, UILabel, UILabel, UIImageView, UIImageView, UILabel, UILabel),
        (UIView, UILabel, UILabel, UIImageView, UIImageView, UILabel, UILabel)) {
            let left = getWeatherItem(margin: margin, color: color)
            left.0.frame.origin = CGPoint(x: 0, y: 0)
            
            let vRight = getWeatherItem(margin: margin, color: color)
            vRight.0.frame.origin = CGPoint(x: left.0.frame.size.width, y: 0)
            
            let vRoot = UIView()
            vRoot.frame.size = CGSize(width: ScreenUtils.getScreenWidth() - margin * 2, height: left.0.frame.size.height)
            
            vRoot.addSubview(left.0)
            vRoot.addSubview(vRight.0)
            
            return (vRoot, left, vRight)
    }
    
    public static func getWeatherItem(margin: CGFloat, color: UIColor) -> (UIView, UILabel, UILabel, UIImageView, UIImageView, UILabel, UILabel) {
        // left
        let vItem = UIView()
        vItem.frame.size = CGSize(width: (ScreenUtils.getScreenWidth() - margin * 2) / 2, height: 0)
        vItem.frame.origin = CGPoint(x: 0, y: 0)
        
        let lEmpty = ViewHelper.getLabel(width: vItem.frame.size.width, height: 0, text: "", color: color, lines: 0, align: .center)
        lEmpty.frame.origin = CGPoint(x: 0, y: 0)
        
        let lCondition = ViewHelper.getLabelBold(text: "-", size: ViewHelper.FONT_SIZE_SMALL, color: color, lines: 1)
        lCondition.center.x = vItem.frame.size.width / 2
        lCondition.frame.origin.y = ScreenUtils.heightFit(10)
        
        let iconHeight = lCondition.frame.size.height
        let ivIconDay = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "w0"), color: color), width: iconHeight, height: iconHeight, mode: .scaleAspectFit)
        ivIconDay.frame.origin = CGPoint(x: lCondition.frame.origin.x - ScreenUtils.widthFit(5) - ivIconDay.frame.size.width, y: lCondition.frame.origin.y)
        
        let ivIconNight = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "w0"), color: color), width: iconHeight, height: iconHeight, mode: .scaleAspectFit)
        ivIconNight.frame.origin = CGPoint(x: lCondition.frame.origin.x + lCondition.frame.size.width + ScreenUtils.widthFit(5), y: lCondition.frame.origin.y)
        
        let lTemp = ViewHelper.getLabelBold(width: vItem.frame.size.width, text: "-", size: ScreenUtils.fontFit(25), color: color, lines: 1, align: .center)
        lTemp.frame.origin = CGPoint(x: 0, y: lCondition.frame.origin.y + lCondition.frame.size.height)
        
        let lWind = ViewHelper.getLabel(width: vItem.frame.size.width, text: "-", size: ViewHelper.FONT_SIZE_SMALL, color: color, lines: 1, align: .center)
        lWind.frame.origin = CGPoint(x: 0, y: lTemp.frame.origin.y + lTemp.frame.size.height)
        
        vItem.frame.size.height = lWind.frame.origin.y + lWind.frame.size.height
        lEmpty.frame.size.height = lWind.frame.origin.y + lWind.frame.size.height
        
        vItem.addSubview(lEmpty)
        vItem.addSubview(lCondition)
        vItem.addSubview(ivIconDay)
        vItem.addSubview(ivIconNight)
        vItem.addSubview(lTemp)
        vItem.addSubview(lWind)
        
        // hide
        lEmpty.isHidden = true
        
        return (vItem, lEmpty, lCondition, ivIconDay, ivIconNight, lTemp, lWind)
    }
    
    public static func getCellHeight(view: UITableView, indexPath: IndexPath) -> CGFloat {
        if totalHeight == nil {
            let cell = CoupleWeatherCell(style: .default, reuseIdentifier: CouplePlaceCell.ID)
            totalHeight = cell.lTime.frame.origin.y + cell.vRoot.0.frame.origin.y + cell.vRoot.0.frame.size.height
        }
        return totalHeight!
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, leftList: [WeatherForecast]?, rightList: [WeatherForecast]?) -> CoupleWeatherCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? CoupleWeatherCell
        if cell == nil {
            cell = CoupleWeatherCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        // data
        if (leftList == nil && rightList == nil) || ((leftList?.count ?? 0) <= indexPath.row && (rightList?.count ?? 0) <= indexPath.row) {
            return cell!
        }
        if leftList != nil && leftList!.count > indexPath.row {
            let forecast = leftList![indexPath.row]
            if forecast.timeAt != 0 {
                cell!.lTime.text = TimeHelper.getTimeShowLocal_MD_YMD_ByGo(forecast.timeAt)
            } else if !StringUtils.isEmpty(forecast.timeShow) {
                cell!.lTime.text = forecast.timeShow
            }
            setWeatherItemData(item: cell!.vRoot.1, color: ThemeHelper.getColorDark(), msg: StringUtils.getString("now_no_weather_info"), forecast: forecast)
        } else {
            setWeatherItemData(item: cell!.vRoot.1, color: ThemeHelper.getColorDark(), msg: StringUtils.getString("now_no_weather_info"), forecast: nil)
        }
        if rightList != nil && rightList!.count > indexPath.row {
            let forecast = rightList![indexPath.row]
            if forecast.timeAt != 0 {
                cell!.lTime.text = TimeHelper.getTimeShowLocal_MD_YMD_ByGo(forecast.timeAt)
            } else if !StringUtils.isEmpty(forecast.timeShow) {
                cell!.lTime.text = forecast.timeShow
            }
            setWeatherItemData(item: cell!.vRoot.2, color: ThemeHelper.getColorDark(), msg: StringUtils.getString("now_no_weather_info"), forecast: forecast)
        } else {
            setWeatherItemData(item: cell!.vRoot.2, color: ThemeHelper.getColorDark(), msg: StringUtils.getString("now_no_weather_info"), forecast: nil)
        }
        return cell!
    }
    
    public static func setWeatherItemData(item: (UIView, UILabel, UILabel, UIImageView, UIImageView, UILabel, UILabel),
                                          color: UIColor, msg: String?, forecast: WeatherForecast?) {
        if forecast == nil {
            item.1.isHidden = false
            item.1.text = msg
            item.2.isHidden = true
            item.3.isHidden = true
            item.4.isHidden = true
            item.5.isHidden = true
            item.6.isHidden = true
            return
        }
        item.1.isHidden = true
        item.2.isHidden = false
        item.3.isHidden = false
        item.4.isHidden = false
        item.5.isHidden = false
        item.6.isHidden = false
        
        item.2.text = StringUtils.getString("holder_wave_holder", arguments: [forecast!.conditionDay, forecast!.conditionNight])
        let oldCenterX = item.2.center.x
        let oldWidth = item.2.frame.size.width
        item.2.sizeToFit()
        item.2.center.x = oldCenterX
        let offsetWidth = (item.2.frame.size.width - oldWidth) / 2
        
        item.3.image = ViewUtils.getImageWithTintColor(img: UIImage(named: WeatherHelper.getIcon(id: forecast!.iconDay)), color: color)
        item.3.frame.origin.x -= offsetWidth
        
        item.4.image = ViewUtils.getImageWithTintColor(img: UIImage(named: WeatherHelper.getIcon(id: forecast!.iconNight)), color: color)
        item.4.frame.origin.x += offsetWidth
        
        item.5.text = StringUtils.getString("holder_wave_holder_c", arguments: [forecast!.tempDay, forecast!.tempNight])
        
        item.6.text = StringUtils.getString("holder_wave_holder", arguments: [forecast!.windDay, forecast!.windNight])
    }
    
}
