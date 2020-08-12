//
//  CoupleWeatherVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/19.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import AMapSearchKit

class CoupleWeatherVC: BaseVC, UITableViewDataSource, UITableViewDelegate, AMapSearchDelegate {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var maxWidth = ScreenUtils.getScreenWidth() - margin * 2
    
    // view
    private var ivAvatarLeft: UIImageView!
    private var ivAvatarRight: UIImageView!
    private var vWeather: (UIView,
    (UIView, UILabel, UILabel, UIImageView, UIImageView, UILabel, UILabel),
    (UIView, UILabel, UILabel, UIImageView, UIImageView, UILabel, UILabel))!
    private var tableView: UITableView!
    
    // var
    private var myPlace: Place?
    private var taPlace: Place?
    private var forecastListLeft: [WeatherForecast]?
    private var forecastListRight: [WeatherForecast]?
    lazy var searchAPI = AMapSearchAPI()
    
    public static func pushVC(myPlace: Place? = nil, taPlace: Place? = nil) {
        if !AmapHelper.checkLocationEnable() {
            return
        }
        if UserHelper.isCoupleBreak(couple: UDHelper.getCouple()) {
            CouplePairVC.pushVC()
            return
        }
        AppDelegate.runOnMainAsync {
            let vc = CoupleWeatherVC(nibName: nil, bundle: nil)
            vc.myPlace = myPlace
            vc.taPlace = taPlace
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: DateUtils.getCurrentStr(DateUtils.FORMAT_CHINA_M_D))
        let barHelp = UIBarButtonItem(image: UIImage(named: "ic_help_outline_white_24dp"), style: .plain, target: self, action: #selector(targetGoHelp))
        self.navigationItem.rightBarButtonItems = [barHelp]
        hideNavigationBarShadow()
        
        // avatar
        ivAvatarLeft = ViewHelper.getImageViewAvatar(width: ScreenUtils.widthFit(50), height: ScreenUtils.widthFit(50))
        ivAvatarLeft.center.x = maxWidth / 4 * 1 + margin
        ivAvatarLeft.frame.origin.y = margin
        
        ivAvatarRight = ViewHelper.getImageViewAvatar(width: ScreenUtils.widthFit(50), height: ScreenUtils.widthFit(50))
        ivAvatarRight.center.x = maxWidth / 4 * 3 + margin
        ivAvatarRight.frame.origin.y = margin
        
        // weather
        vWeather = CoupleWeatherCell.getWeatherRoot(margin: margin, color: ColorHelper.getFontWhite())
        vWeather.0.frame.origin = CGPoint(x: margin, y: ivAvatarLeft.frame.origin.y + ivAvatarLeft.frame.size.height + margin)
        
        // table
        let tableRect = CGRect(x: margin, y: vWeather.0.frame.origin.y + vWeather.0.frame.size.height + ScreenUtils.heightFit(50),
                               width: maxWidth, height: self.view.frame.height - (vWeather.0.frame.origin.y * 2 + vWeather.0.frame.size.height))
        tableView = ViewUtils.getTableView(target: self, frame: tableRect, cellCls: CoupleWeatherCell.self, id: CoupleWeatherCell.ID)
        initScrollState(scroll: tableView, clipTopBar: true, canEmpty: true, emptyColor: ColorHelper.getFontWhite())
        
        // view
        let gradient = ViewHelper.getGradientPrimaryTrans(frame: self.view.bounds)
        self.view.layer.insertSublayer(gradient, at: 0)
        
        self.view.addSubview(ivAvatarLeft)
        self.view.addSubview(ivAvatarRight)
        self.view.addSubview(vWeather.0)
        self.view.addSubview(tableView)
    }
    
    override func initData() {
        // amap
        searchAPI?.delegate = self
        // avatar
        let me = UDHelper.getMe()
        let ta = UDHelper.getTa()
        let avatarLeft = UserHelper.getTaAvatar(user: me)
        let avatarRight = UserHelper.getMyAvatar(user: me)
        KFHelper.setImgAvatarUrl(iv: ivAvatarLeft, objKey: avatarLeft, user: ta)
        KFHelper.setImgAvatarUrl(iv: ivAvatarRight, objKey: avatarRight, user: me)
        // data
        refreshDate()
    }
    
    private func refreshDate() {
        // my
        if myPlace != nil {
            searchAPI?.aMapWeatherSearch(AmapHelper.getWeatherForecast(city: myPlace!.city))
        }
        // ta
        if taPlace != nil {
            searchAPI?.aMapWeatherSearch(AmapHelper.getWeatherForecast(city: taPlace!.city))
        }
        //        let api = Api.request(.coupleWeatherForecastListGet(), success: { (_, _, data) in
        //            // left
        //            let forecastLeft = data.weatherForecastTa
        //            let msgLeft = forecastLeft?.show
        //            let forecastFirstLeft = (forecastLeft?.weatherForecastList.count ?? 0) > 0 ? forecastLeft?.weatherForecastList[0] : nil
        //            CoupleWeatherCell.setWeatherItemData(item: self.vWeather.1, color: ColorHelper.getFontWhite(), msg: msgLeft, forecast: forecastFirstLeft)
        //            // right
        //            let forecastRight = data.weatherForecastMe
        //            let msgRight = forecastRight?.show
        //            let forecastFirstRight = (forecastRight?.weatherForecastList.count ?? 0) > 0 ? forecastRight?.weatherForecastList[0] : nil
        //            CoupleWeatherCell.setWeatherItemData(item: self.vWeather.2, color: ColorHelper.getFontWhite(), msg: msgRight, forecast: forecastFirstRight)
        //            // table
        //            self.forecastListLeft = forecastLeft?.weatherForecastList
        //            self.forecastListRight = forecastRight?.weatherForecastList
        //            self.endScrollDataRefresh(scroll: self.tableView, msg: data.show)
        //        }, failure: { (_, msg, _) in
        //            self.endScrollState(scroll: self.tableView, msg: msg)
        //        })
        //        pushApi(api)
    }
    
    func onWeatherSearchDone(_ request: AMapWeatherSearchRequest!, response: AMapWeatherSearchResponse!) {
        let info = WeatherForecastInfo()
        var adcode = ""
        var city = ""
        let forecasts = response?.forecasts
        if forecasts == nil || forecasts!.count <= 0 {
            info.show = StringUtils.getString("now_no_weather_info")
        } else {
            let forecast = forecasts![0]
            adcode = forecast.adcode
            city = forecast.city
            if forecast.casts.count <= 0 {
                info.show = StringUtils.getString("now_no_weather_info")
            } else {
                var weatherList = [WeatherForecast]()
                for cast in forecast.casts {
                    let weather = WeatherForecast()
                    weather.conditionDay = cast.dayWeather
                    weather.conditionNight = cast.nightWeather
                    weather.iconDay = WeatherHelper.getIconByAMap(show: cast.dayWeather)
                    weather.iconNight = WeatherHelper.getIconByAMap(show: cast.nightWeather)
                    weather.tempDay = cast.dayTemp
                    weather.tempNight = cast.nightTemp
                    weather.windDay = StringUtils.getString("holder_level_holder_wind", arguments: [cast.dayPower, cast.dayWind])
                    weather.windNight = StringUtils.getString("holder_level_holder_wind", arguments: [cast.nightPower, cast.nightWind])
                    weather.timeShow = cast.date
                    // weather.updateAt
                    // weather.timeAt
                    weatherList.append(weather)
                }
                info.weatherForecastList = weatherList
            }
        }
        // my
        if adcode == myPlace?.cityId || city == myPlace?.city {
            forecastListRight = info.weatherForecastList
            let forecastFirstRight = (forecastListRight?.count ?? 0) > 0 ? forecastListRight![0] : nil
            let msgRight = info.show
            if (forecastListRight?.count ?? 0) >= 1 {
                forecastListRight?.remove(at: 0)
            }
            CoupleWeatherCell.setWeatherItemData(item: self.vWeather.2, color: ColorHelper.getFontWhite(), msg: msgRight, forecast: forecastFirstRight)
        }
        // ta
        if adcode == taPlace?.cityId || city == taPlace?.city {
            forecastListLeft = info.weatherForecastList
            let forecastFirstLeft = (forecastListLeft?.count ?? 0) > 0 ? forecastListLeft![0] : nil
            let msgLeft = info.show
            if (forecastListLeft?.count ?? 0) >= 1 {
                forecastListLeft?.remove(at: 0)
            }
            CoupleWeatherCell.setWeatherItemData(item: self.vWeather.1, color: ColorHelper.getFontWhite(), msg: msgLeft, forecast: forecastFirstLeft)
        }
        // table
        self.endScrollDataRefresh(scroll: self.tableView, msg: info.show)
    }
    
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CountHelper.getMax(forecastListLeft?.count ?? 0, forecastListRight?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CoupleWeatherCell.getCellHeight(view: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return CoupleWeatherCell.getCellWithData(view: tableView, indexPath: indexPath, leftList: forecastListLeft, rightList: forecastListRight)
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_COUPLE_WEATHER)
    }
    
}
