//
// Created by 蒋治国 on 2018-12-09.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import AMapLocationKit
import AMapSearchKit

class CoupleVC: BaseVC, AMapLocationManagerDelegate, AMapSearchDelegate {
    
    // const
    lazy var statusHeight = ScreenUtils.getTopStatusHeight()
    lazy var maxWidth = self.view.frame.width
    lazy var maxHeight = self.view.frame.height - self.tabBarController!.tabBar.frame.size.height
    lazy var marginH = ScreenUtils.heightFit(10)
    lazy var marginV = ScreenUtils.widthFit(10)
    lazy var coupleInfoWidth = maxWidth - marginH * 2
    lazy var coupleInfoHeight = ScreenUtils.heightFit(50)
    lazy var placeWeatherWidth = maxWidth - marginH * 2
    lazy var placeWeatherHeight = ScreenUtils.heightFit(35)
    lazy var placeWeatherMarginH = ScreenUtils.widthFit(5)
    
    // view
    private var gradientTop: CAGradientLayer!
    private var vPlaceWeatherLine: UIView!
    
    private var scroll: UIScrollView!
    private var vTopFill: UIView!
    private var vCenter: UIView!
    private var ivBG: UIImageView!
    private var btnPair: UIButton!
    private var lAddWallPaper: UILabel!
    private var lCoupleCountDown: UILabel!
    private var loopWall: WallPaperLoop!
    private var vBottom: UIView!
    private var vBottomFill: UIView!
    
    private var ivAvatarLeft: UIImageView!
    private var ivAvatarRight: UIImageView!
    private var lTogetherLeft: UILabel!
    private var lTogether: UILabel!
    
    private var lPlaceDistance: UILabel!
    private var mvPlaceLeft: MarqueeView!
    private var mvPlaceRight: MarqueeView!
    
    private var lWeatherDiffer: UILabel!
    private var vWeatherLeftRoot: UIView!
    private var vWeatherLeft: UIView!
    private var ivWeatherLeft: UIImageView!
    private var lWeatherLeft: UILabel!
    private var vWeatherRightRoot: UIView!
    private var vWeatherRight: UIView!
    private var ivWeatherRight: UIImageView!
    private var lWeatherRight: UILabel!
    
    // var
    private var myPlace: Place?
    private var taPlace: Place?
    private var myWeatherToday: WeatherToday?
    private var taWeatherToday: WeatherToday?
    
    lazy var model = UDHelper.getModelShow()
    lazy var locationManager = AMapLocationManager()
    lazy var searchAPI = AMapSearchAPI()
    private var breakTimer: Timer?
    
    static func get() -> CoupleVC {
        return CoupleVC(nibName: nil, bundle: nil)
    }
    
    override func initView() {
        // navigationBar 无操作
        
        // center 中部操作条(充当背景层)
        vCenter = UIView()
        vCenter.frame.size = CGSize(width: maxWidth, height: maxHeight)
        vCenter.backgroundColor = ColorHelper.getBackground()
        
        ivBG = ViewHelper.getImageView(img: UIImage(named: "bg_couple_home_1"), width: maxWidth, height: maxHeight, mode: .scaleAspectFill)
        
        btnPair = ViewHelper.getBtnBGWhite(width: maxWidth - ScreenUtils.widthFit(30) * 2, paddingV: ScreenUtils.heightFit(7.5), title: StringUtils.getString("quick_pair_deblock_more_posture"), titleColor: ThemeHelper.getColorPrimary(), circle: true, shadow: true)
        btnPair.center.x = vCenter.frame.size.width / 2
        btnPair.frame.origin.y = ScreenUtils.heightFit(150)
        
        lAddWallPaper = ViewHelper.getLabelBold(text: StringUtils.getString("click_right_top_add_wall_paper"), size: ViewHelper.FONT_SIZE_HUGE, color: ColorHelper.getFontWhite(), lines: 1, align: .center)
        lAddWallPaper.center.x = vCenter.frame.size.width / 2
        lAddWallPaper.frame.origin.y = ScreenUtils.heightFit(150)
        ViewUtils.setViewShadow(lAddWallPaper, offset: ViewHelper.SHADOW_BIG, opacity: 0.1)
        
        lCoupleCountDown = ViewHelper.getLabelBold(text: "-", size: ScreenUtils.fontFit(50), color: ThemeHelper.getColorPrimary(), lines: 1, align: .center)
        lCoupleCountDown.center = CGPoint(x: vCenter.frame.size.width / 2, y: vCenter.frame.size.height / 2)
        
        // WallPaper
        loopWall = WallPaperLoop()
        loopWall.frame.size.width = maxWidth
        loopWall.frame.size.height = maxHeight
        
        // top 顶部操作条
        let ivHelp = ViewHelper.getImageView(img: UIImage(named: "ic_help_outline_white_24dp"))
        ivHelp.frame.size.width += marginH * 2
        ivHelp.frame.size.height += marginV * 2
        ivHelp.frame.origin = CGPoint(x: 0, y: statusHeight)
        ivHelp.alpha = 0.9
        let ivWall = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_vip_wall_24dp"), color: ColorHelper.getWhite()))
        ivWall.frame.size.width += marginH * 2
        ivWall.frame.size.height += marginV * 2
        ivWall.frame.origin = CGPoint(x: maxWidth - ivWall.frame.size.width, y: statusHeight)
        ivWall.alpha = 0.9
        vTopFill = UIView()
        vTopFill.frame.size = CGSize(width: maxWidth, height: 1000)
        vTopFill.frame.origin = CGPoint(x: 0, y: -vTopFill.frame.size.height)
        vTopFill.backgroundColor = ThemeHelper.getColorPrimary()
        let vTopHeight = statusHeight + CountHelper.getMax(ivHelp.frame.size.height, ivWall.frame.size.height)
        let vTop = UIView(frame: CGRect(x: 0, y: 0, width: maxWidth, height: vTopHeight))
        gradientTop = ViewHelper.getGradientPrimaryTrans(frame: vTop.bounds)
        vTop.layer.insertSublayer(gradientTop, at: 0)
        vTop.addSubview(ivHelp)
        vTop.addSubview(ivWall)
        vTop.addSubview(vTopFill) // 填充层
        
        // coupleInfo
        ivAvatarLeft = ViewHelper.getImageViewAvatar(width: coupleInfoHeight, height: coupleInfoHeight)
        ivAvatarLeft.frame.origin = CGPoint(x: 0, y: 0)
        let shadowLeft = ViewUtils.getViewShadow(ivAvatarLeft, bgColor: ColorHelper.getWhite(), offset: ViewHelper.SHADOW_NORMAL)
        ivAvatarRight = ViewHelper.getImageViewAvatar(width: coupleInfoHeight, height: coupleInfoHeight)
        ivAvatarRight.frame.origin = CGPoint(x: ivAvatarLeft.frame.origin.x + coupleInfoHeight + marginH, y: 0)
        let shadowRight = ViewUtils.getViewShadow(ivAvatarRight, bgColor: ColorHelper.getWhite(), offset: ViewHelper.SHADOW_NORMAL)
        
        let lTogetherRight = ViewHelper.getLabelBold(text: StringUtils.getString("dayT"), size: ViewHelper.FONT_SIZE_NORMAL, color: ColorHelper.getFontWhite())
        lTogetherRight.frame.origin = CGPoint(x: coupleInfoWidth - lTogetherRight.frame.size.width, y: coupleInfoHeight - lTogetherRight.frame.size.height)
        ViewUtils.setViewShadow(lTogetherRight, offset: ViewHelper.SHADOW_BIG, opacity: 0.1)
        lTogether = ViewHelper.getLabelBold(text: "-", size: ScreenUtils.fontFit(35), color: ColorHelper.getFontWhite(), lines: 1)
        lTogether.frame.origin = CGPoint(x: lTogetherRight.frame.origin.x - ScreenUtils.widthFit(5) - lTogether.frame.size.width, y: coupleInfoHeight - lTogether.frame.size.height + ScreenUtils.heightFit(5))
        ViewUtils.setViewShadow(lTogether, offset: ViewHelper.SHADOW_BIG, opacity: 0.1)
        lTogetherLeft = ViewHelper.getLabelBold(text: StringUtils.getString("in_together"), size: ViewHelper.FONT_SIZE_NORMAL, color: ColorHelper.getFontWhite())
        lTogetherLeft.frame.origin = CGPoint(x: lTogether.frame.origin.x - ScreenUtils.widthFit(5) - lTogetherLeft.frame.size.width, y: coupleInfoHeight - lTogetherLeft.frame.size.height)
        ViewUtils.setViewShadow(lTogetherLeft, offset: ViewHelper.SHADOW_BIG, opacity: 0.1)
        
        let vCoupleInfo = UIView()
        vCoupleInfo.frame.size = CGSize(width: coupleInfoWidth, height: coupleInfoHeight)
        vCoupleInfo.frame.origin = CGPoint(x: marginH, y: 0)
        vCoupleInfo.addSubview(shadowLeft)
        vCoupleInfo.addSubview(shadowRight)
        vCoupleInfo.addSubview(ivAvatarLeft)
        vCoupleInfo.addSubview(ivAvatarRight)
        vCoupleInfo.addSubview(lTogetherRight)
        vCoupleInfo.addSubview(lTogether)
        vCoupleInfo.addSubview(lTogetherLeft)
        
        // place
        lPlaceDistance = ViewHelper.getLabelBlackSmall(text: "-", lines: 1, align: .center)
        lPlaceDistance.center = CGPoint(x: placeWeatherWidth / 2, y: placeWeatherHeight / 2)
        let placeWidth = (placeWeatherWidth - lPlaceDistance.frame.size.width) / 2 - placeWeatherMarginH * 2
        let framePlaceLeft = CGRect(x: placeWeatherMarginH, y: 0, width: placeWidth, height: placeWeatherHeight)
        mvPlaceLeft = MarqueeView(frame: framePlaceLeft, title: "-", font: ViewUtils.getFont(size: ViewHelper.FONT_SIZE_SMALL), textColor: ColorHelper.getFontGrey(), align: .center)
        let framePlaceRight = CGRect(x: lPlaceDistance.frame.origin.x + lPlaceDistance.frame.size.width + placeWeatherMarginH, y: 0, width: placeWidth, height: placeWeatherHeight)
        mvPlaceRight = MarqueeView(frame: framePlaceRight, title: "-", font: ViewUtils.getFont(size: ViewHelper.FONT_SIZE_SMALL), textColor: ColorHelper.getFontGrey(), align: .center)
        
        let vPlace = UIView()
        vPlace.frame.size = CGSize(width: placeWeatherWidth, height: placeWeatherHeight)
        vPlace.frame.origin = CGPoint(x: 0, y: 0)
        vPlace.addSubview(lPlaceDistance)
        vPlace.addSubview(mvPlaceLeft)
        vPlace.addSubview(mvPlaceRight)
        
        // line
        vPlaceWeatherLine = ViewHelper.getViewLine(width: maxWidth - marginH * 2, color: ThemeHelper.getColorAccent())
        vPlaceWeatherLine.frame.origin = CGPoint(x: 0, y: placeWeatherHeight)
        
        // weather
        lWeatherDiffer = ViewHelper.getLabelBlackSmall(text: "-", lines: 1, align: .center)
        lWeatherDiffer.center = CGPoint(x: placeWeatherWidth / 2, y: placeWeatherHeight / 2)
        
        lWeatherLeft = ViewHelper.getLabelGreySmall(text: "-", lines: 1)
        ivWeatherLeft = ViewHelper.getImageView(img: nil, width: lWeatherLeft.frame.size.height, height: lWeatherLeft.frame.size.height, mode: .scaleAspectFit)
        ivWeatherLeft.frame.origin = CGPoint(x: 0, y: 0)
        lWeatherLeft.frame.origin = CGPoint(x: 0, y: 0)
        vWeatherLeft = UIView()
        vWeatherLeft.frame.size = CGSize(width: lWeatherLeft.frame.origin.x + lWeatherLeft.frame.size.width, height: lWeatherLeft.frame.size.height)
        vWeatherLeft.addSubview(ivWeatherLeft)
        vWeatherLeft.addSubview(lWeatherLeft)
        
        lWeatherRight = ViewHelper.getLabelGreySmall(text: "-", lines: 1)
        ivWeatherRight = ViewHelper.getImageView(img: nil, width: lWeatherRight.frame.size.height, height: lWeatherRight.frame.size.height, mode: .scaleAspectFit)
        ivWeatherRight.frame.origin = CGPoint(x: 0, y: 0)
        lWeatherRight.frame.origin = CGPoint(x: 0, y: 0)
        vWeatherRight = UIView()
        vWeatherRight.frame.size = CGSize(width: lWeatherRight.frame.origin.x + lWeatherRight.frame.size.width, height: lWeatherRight.frame.size.height)
        vWeatherRight.addSubview(ivWeatherRight)
        vWeatherRight.addSubview(lWeatherRight)
        
        let weatherRootWidth = (placeWeatherWidth - lWeatherDiffer.frame.size.width) / 2 - placeWeatherMarginH * 2
        vWeatherLeftRoot = UIView()
        vWeatherLeftRoot.frame.size = CGSize(width: weatherRootWidth, height: lWeatherDiffer.frame.size.height)
        vWeatherLeftRoot.frame.origin.x = placeWeatherMarginH
        vWeatherLeftRoot.center.y = placeWeatherHeight / 2
        vWeatherRightRoot = UIView()
        vWeatherRightRoot.frame.size = CGSize(width: weatherRootWidth, height: lWeatherDiffer.frame.size.height)
        vWeatherRightRoot.frame.origin.x = lWeatherDiffer.frame.origin.x + lWeatherDiffer.frame.size.width + placeWeatherMarginH
        vWeatherRightRoot.center.y = placeWeatherHeight / 2
        vWeatherLeft.center = CGPoint(x: vWeatherLeftRoot.frame.size.width / 2, y: vWeatherLeftRoot.frame.size.height / 2)
        vWeatherLeftRoot.addSubview(vWeatherLeft)
        vWeatherRight.center = CGPoint(x: vWeatherRightRoot.frame.size.width / 2, y: vWeatherRightRoot.frame.size.height / 2)
        vWeatherRightRoot.addSubview(vWeatherRight)
        
        let vWeather = UIView()
        vWeather.frame.size = CGSize(width: placeWeatherWidth, height: placeWeatherHeight)
        vWeather.frame.origin = CGPoint(x: 0, y: model.couplePlace ? placeWeatherHeight + vPlaceWeatherLine.frame.size.height : 0)
        vWeather.addSubview(lWeatherDiffer)
        vWeather.addSubview(vWeatherLeftRoot)
        vWeather.addSubview(vWeatherRightRoot)
        
        // PlaceWeather
        let vPlaceWeather = UIView()
        var vPlaceWeatherHeight = CGFloat(0)
        if model.couplePlace {
            vPlaceWeatherHeight += placeWeatherHeight
        }
        if model.coupleWeather {
            vPlaceWeatherHeight += placeWeatherHeight
        }
        if model.couplePlace && model.coupleWeather {
            vPlaceWeatherHeight += vPlaceWeatherLine.frame.size.height
        }
        vPlaceWeather.frame.size = CGSize(width: placeWeatherWidth, height: vPlaceWeatherHeight)
        vPlaceWeather.frame.origin = CGPoint(x: marginH, y: CountHelper.getMax(ivAvatarLeft.frame.size.height, lTogether.frame.size.height) + marginV)
        vPlaceWeather.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vPlaceWeather, radius: ViewHelper.RADIUS_BIG)
        ViewUtils.setViewShadow(vPlaceWeather, offset: ViewHelper.SHADOW_BIG)
        if model.couplePlace {
            vPlaceWeather.addSubview(vPlace)
        }
        if model.coupleWeather {
            vPlaceWeather.addSubview(vWeather)
        }
        if model.couplePlace && model.coupleWeather {
            vPlaceWeather.addSubview(vPlaceWeatherLine)
        }
        
        // bottom
        vBottom = UIView()
        var vBottomHeight = CountHelper.getMax(ivAvatarLeft.frame.size.height, lTogether.frame.size.height) + marginV
        if model.couplePlace || model.coupleWeather {
            vBottomHeight += vPlaceWeather.frame.size.height + marginV
        }
        vBottom.frame.size = CGSize(width: maxWidth, height: vBottomHeight)
        vBottom.frame.origin = CGPoint(x: 0, y: maxHeight - vBottom.frame.size.height)
        vBottom.addSubview(vCoupleInfo)
        if model.couplePlace || model.coupleWeather {
            vBottom.addSubview(vPlaceWeather)
        }
        
        vBottomFill = UIView()
        vBottomFill.frame.size = CGSize(width: maxWidth, height: 1000)
        vBottomFill.frame.origin = CGPoint(x: 0, y: vBottom.frame.size.height)
        vBottomFill.backgroundColor = ThemeHelper.getColorPrimary()
        vBottom.addSubview(vBottomFill)
        
        // scroll
        let scrollHeight = self.view.frame.height - (self.tabBarController?.tabBar.frame.size.height ?? 0) + statusHeight
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: nil)
        scroll.frame.origin = CGPoint(x: 0, y: -statusHeight)
        scroll.backgroundColor = ThemeHelper.getColorPrimary()
        scroll.refreshControl = UIRefreshControl()
        scroll.refreshControl?.tintColor = ColorHelper.getWhite()
        
        scroll.addSubview(vCenter) // 先添加这个，作为背景层
        //        scroll.addSubview(loopWall) 动态控制
        scroll.addSubview(vTop)
        //        scroll.addSubview(vBottom) 动态控制
        
        scroll.sendSubviewToBack(vTop) // 为了让refreshControl在顶层
        scroll.sendSubviewToBack(vCenter) // 为了让refreshControl在顶层
        
        // view
        self.view.addSubview(scroll)
        
        // target
        scroll.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        ViewUtils.addViewTapTarget(target: self, view: ivHelp, action: #selector(targetGoHelp))
        ViewUtils.addViewTapTarget(target: self, view: ivWall, action: #selector(targetGoWallPaper))
        btnPair.addTarget(self, action: #selector(targetGoCouplePair), for: .touchUpInside)
        ViewUtils.addViewTapTarget(target: self, view: vCoupleInfo, action: #selector(targetGoCoupleInfo))
        ViewUtils.addViewTapTarget(target: self, view: vPlace, action: #selector(targetGoCouplePlace))
        ViewUtils.addViewTapTarget(target: self, view: vWeather, action: #selector(targetGoCoupleWeather))
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(refreshData), name: NotifyHelper.TAG_COUPLE_REFRESH)
        NotifyHelper.addObserver(self, selector: #selector(refreshWallPaperView), name: NotifyHelper.TAG_WALL_PAPER_REFRESH)
        // amap
        locationManager.delegate = self
        searchAPI?.delegate = self
        // data
        refreshData()
    }
    
    override func onReview(_ animated: Bool) {
        // 刷新loopWall状态
        if loopWall.superview != nil {
            loopWall.refreshViewWithData()
        }
    }
    
    override func onDestroy() {
        stopBreakTimer()
    }
    
    override func onThemeUpdate(theme: Int?) {
        scroll.backgroundColor = ThemeHelper.getColorPrimary()
        gradientTop.colors = [ThemeHelper.getColorPrimary().cgColor, ColorHelper.getTrans().cgColor]
        vTopFill.backgroundColor = ThemeHelper.getColorPrimary()
        vBottomFill.backgroundColor = ThemeHelper.getColorPrimary()
        btnPair.setTitleColor(ThemeHelper.getColorPrimary(), for: .normal)
        lCoupleCountDown?.textColor = ThemeHelper.getColorPrimary()
        ivWeatherLeft.image = ViewUtils.getImageWithTintColor(img: ivWeatherLeft.image, color: ThemeHelper.getColorPrimary())
        ivWeatherRight.image = ViewUtils.getImageWithTintColor(img: ivWeatherRight.image, color: ThemeHelper.getColorPrimary())
        vPlaceWeatherLine?.backgroundColor = ThemeHelper.getColorAccent()
    }
    
    @objc private func refreshData() {
        ViewUtils.beginScrollRefresh(scroll)
        // oss 最好是刷新一次，防止状态变化 oss不同步
        ApiHelper.ossInfoUpdate()
        // api
        let api = Api.request(.coupleHomeGet,
                              success: { (_, _, data) in
                                ViewUtils.endScrollRefresh(self.scroll)
                                UDHelper.setMe(data.user)
                                UDHelper.setTa(data.ta)
                                UDHelper.setWallPaper(data.wallPaper)
                                self.refreshView()
                                // 刷新地址
                                self.refreshPlaceDate()
        }, failure: { (_, _, _) in
            ViewUtils.endScrollRefresh(self.scroll)
        })
        self.pushApi(api)
    }
    
    // 获取自己的位置并上传
    private func refreshPlaceDate() {
        if UserHelper.isCoupleBreak(couple: UDHelper.getCouple()) {
            return // 还是要检查的，防止后台返回错误
        }
        if !LocationUtils.isLocationEnable() {
            return // 没同意不要弹
        }
        _ = AmapHelper.startLocationOnce(manager: locationManager) { (info) in
            if info.longitude == 0 && info.latitude == 0 {
                return
            }
            // 设备位置信息获取成功
            let body = Place()
            body.longitude = info.longitude!
            body.latitude = info.latitude!
            body.country = info.country
            body.province = info.province
            body.city = info.city
            body.district = info.district
            body.street = info.street
            body.cityId = info.cityId
            body.address = info.address
            // api
            let api = Api.request(.couplePlacePush(place: body.toJSON()),
                                  success: { (_, _, data) in
                                    self.myPlace = data.placeMe
                                    self.taPlace = data.placeTa
                                    self.refreshPlaceView()
                                    // self.myWeatherToday = data.weatherTodayMe
                                    // self.taWeatherToday = data.weatherTodayTa
                                    // self.refreshWeatherView()
                                    self.refreshWeatherData()
            })
            self.pushApi(api)
        }
    }
    
    // 刷新天气数据
    func refreshWeatherData() {
        if myPlace != nil {
            searchAPI?.aMapWeatherSearch(AmapHelper.getWeatherToday(city: myPlace!.city))
        }
        if taPlace != nil {
            searchAPI?.aMapWeatherSearch(AmapHelper.getWeatherToday(city: taPlace!.city))
        }
    }
    
    func onWeatherSearchDone(_ request: AMapWeatherSearchRequest!, response: AMapWeatherSearchResponse!) {
        let lives = response?.lives
        if lives != nil && lives!.count > 0 {
            let live = lives![0]
            let weather = WeatherToday()
            weather.condition = live.weather
            weather.icon = WeatherHelper.getIconByAMap(show: live.weather)
            weather.temp = live.temperature
            weather.windDir = live.windDirection
            weather.windLevel = live.windPower
            weather.humidity = live.humidity
            // weather.updateAt
            // my
            if live.adcode == myPlace?.cityId || live.city == myPlace?.city {
                myWeatherToday = weather
            }
            // ta
            if live.adcode == taPlace?.cityId || live.city == taPlace?.city {
                taWeatherToday = weather
            }
            refreshWeatherView()
        }
    }
    
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
    }
    
    private func refreshView() {
        ivBG.removeFromSuperview()
        loopWall.removeFromSuperview()
        btnPair.removeFromSuperview()
        lAddWallPaper.removeFromSuperview()
        lCoupleCountDown.removeFromSuperview()
        vBottom.removeFromSuperview()
        // 开始判断
        let couple = UDHelper.getCouple()
        if UserHelper.isCoupleBreak(couple: couple) {
            // 已经分手，或者没有开始过
            vCenter.addSubview(ivBG)
            vCenter.addSubview(btnPair)
            vCenter.sendSubviewToBack(ivBG)
        } else {
            // 已经配对
            scroll.addSubview(vBottom)
            if UserHelper.isCoupleBreaking(couple: couple) {
                // 正在分手
                vCenter.addSubview(lCoupleCountDown)
                startBreakTimer()
            } else {
                // 在一起
                self.refreshWallPaperView()
            }
            // 暂无 头像文件刷新
            // 头像 + 名称
            let me = UDHelper.getMe()
            let ta = UDHelper.getTa()
            let myAvatar = UserHelper.getMyAvatar(user: me)
            let taAvatar = UserHelper.getTaAvatar(user: me)
            let togethetDay = UserHelper.getCoupleTogetherDay(couple: couple)
            KFHelper.setImgAvatarUrl(iv: ivAvatarLeft, objKey: taAvatar, user: ta)
            KFHelper.setImgAvatarUrl(iv: ivAvatarRight, objKey: myAvatar, user: me)
            refreshCoupleTogetherDay(day: togethetDay)
            // 刷新位置+天气
            refreshPlaceView()
            refreshWeatherView()
        }
    }
    
    // 刷新天数
    private func refreshCoupleTogetherDay(day: Int) {
        lTogether.text = String(day)
        let oldWidth = lTogether.frame.size.width
        lTogether.sizeToFit()
        let newWidth = lTogether.frame.size.width
        lTogether.frame.origin = CGPoint(x: lTogether.frame.origin.x + oldWidth - newWidth, y: lTogether.frame.origin.y)
        lTogetherLeft.frame.origin = CGPoint(x: lTogetherLeft.frame.origin.x + oldWidth - newWidth, y: lTogetherLeft.frame.origin.y)
        // shadow
        ViewUtils.setViewShadow(lTogether, offset: ViewHelper.SHADOW_BIG, opacity: 0.1)
    }
    
    @objc private func refreshWallPaperView() {
        let imageList = UDHelper.getWallPaper().contentImageList
        // 无图显示
        if imageList.count <= 0 {
            vCenter.addSubview(ivBG)
            vCenter.sendSubviewToBack(ivBG)
            scroll.addSubview(lAddWallPaper)
            loopWall.removeFromSuperview()
            loopWall.stopLoop()
            // 暂无 删除本地文件
            return
        }
        // 有图显示
        ivBG.removeFromSuperview()
        lAddWallPaper.removeFromSuperview()
        scroll.addSubview(loopWall)
        scroll.sendSubviewToBack(loopWall)
        scroll.sendSubviewToBack(vCenter)
        // 暂无 本地文件刷新
        loopWall.refreshViewWithData()
    }
    
    private func refreshPlaceView() {
        // distance
        var distance: Double = 0
        if myPlace != nil && taPlace != nil {
            distance = AmapHelper.distance(lon1: myPlace!.longitude, lat1: myPlace!.latitude, lon2: taPlace!.longitude, lat2: taPlace!.latitude)
        }
        lPlaceDistance.text = StringUtils.getString("distance_space_holder", arguments: [ShowHelper.getShowDistance(distance)])
        let oldDistanceWidth = lPlaceDistance.frame.size.width
        lPlaceDistance.sizeToFit()
        let offset = (oldDistanceWidth - lPlaceDistance.frame.size.width) / 2
        lPlaceDistance.center.x += offset
        // address
        let addressDef = StringUtils.getString("now_no_address_info")
        mvPlaceLeft.frame.size.width += offset // 必须放前面，先设置同步label的frame，在设置text
        mvPlaceLeft.setTitle(title: StringUtils.isEmpty(taPlace?.address) ? addressDef : (taPlace?.address ?? ""))
        mvPlaceRight.frame.size.width += offset // 必须放前面，先设置同步label的frame，在设置text
        mvPlaceRight.frame.origin.x -= offset
        mvPlaceRight.setTitle(title: StringUtils.isEmpty(myPlace?.address) ? addressDef : (myPlace?.address ?? ""))
    }
    
    private func refreshWeatherView() {
        let weatherDef = StringUtils.getString("now_no_weather_info")
        // myWeather
        var myIcon = ""
        var myTemp = 520
        var myWeatherShow = weatherDef
        if myWeatherToday != nil && !StringUtils.isEmpty(myWeatherToday?.temp) {
            myIcon = WeatherHelper.getIcon(id: myWeatherToday!.icon)
            myTemp = Int(myWeatherToday!.temp) ?? 520
            myWeatherShow = myWeatherToday!.temp + "℃ " + myWeatherToday!.condition
        }
        // taWeather
        var taIcon = ""
        var taTemp = 520
        var taWeatherShow = weatherDef
        if taWeatherToday != nil && !StringUtils.isEmpty(taWeatherToday?.temp) {
            taIcon = WeatherHelper.getIcon(id: taWeatherToday!.icon)
            taTemp = Int(taWeatherToday!.temp) ?? 520
            taWeatherShow = taWeatherToday!.temp + "℃ " + taWeatherToday!.condition
        }
        // diff
        if myTemp == 520 || taTemp == 520 {
            lWeatherDiffer.text = StringUtils.getString("differ_space_holder", arguments: ["-℃"])
        } else {
            let diffAbs = String(abs(myTemp - taTemp)) + "℃"
            lWeatherDiffer.text = StringUtils.getString("differ_space_holder", arguments: [diffAbs])
        }
        let oldDiffWidth = lWeatherDiffer.frame.size.width
        lWeatherDiffer.sizeToFit()
        let diffOffset = (oldDiffWidth - lWeatherDiffer.frame.size.width) / 2
        lWeatherDiffer.center.x += diffOffset
        
        // weatherView-size
        if StringUtils.isEmpty(taIcon) {
            lWeatherLeft.frame.origin.x = 0
        } else {
            lWeatherLeft.frame.origin.x = ivWeatherLeft.frame.size.width + placeWeatherMarginH
        }
        if StringUtils.isEmpty(myIcon) {
            lWeatherRight.frame.origin.x = 0
        } else {
            lWeatherRight.frame.origin.x = ivWeatherRight.frame.size.width + placeWeatherMarginH
        }
        vWeatherLeft.frame.size.width = lWeatherLeft.frame.origin.x + lWeatherLeft.frame.size.width
        vWeatherRight.frame.size.width = lWeatherRight.frame.origin.x + lWeatherRight.frame.size.width
        
        // weatherView-ta
        ivWeatherLeft.image = ViewUtils.getImageWithTintColor(img: UIImage(named: taIcon), color: ThemeHelper.getColorPrimary())
        lWeatherLeft.text = taWeatherShow
        let oldLeftWidth = lWeatherLeft.frame.size.width
        lWeatherLeft.sizeToFit()
        vWeatherLeftRoot.frame.size.width += diffOffset
        vWeatherLeft.frame.size.width += lWeatherLeft.frame.size.width - oldLeftWidth
        vWeatherLeft.center.x = vWeatherLeftRoot.frame.size.width / 2
        
        // weatherView-me
        ivWeatherRight.image = ViewUtils.getImageWithTintColor(img: UIImage(named: myIcon), color: ThemeHelper.getColorPrimary())
        lWeatherRight.text = myWeatherShow
        let oldRightWidth = lWeatherRight.frame.size.width
        lWeatherRight.sizeToFit()
        vWeatherRightRoot.frame.size.width += diffOffset
        vWeatherRightRoot.frame.origin.x -= diffOffset
        vWeatherRight.frame.size.width += lWeatherRight.frame.size.width - oldRightWidth
        vWeatherRight.center.x = vWeatherRightRoot.frame.size.width / 2
    }
    
    private func startBreakTimer() {
        // 先停止，避免重复
        stopBreakTimer()
        // 创建任务，会先执行一次
        breakTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: true, block: { (_) in
            let couple = UDHelper.getCouple()
            let breakCountDown = UserHelper.getCoupleBreakCountDown(couple: couple)
            if breakCountDown <= 0 {
                self.stopBreakTimer()
                NotifyHelper.post(NotifyHelper.TAG_COUPLE_REFRESH, obj: couple)
            } else {
                self.lCoupleCountDown.text = self.getBreakCountDownShow(breakCountDown: breakCountDown)
                self.lCoupleCountDown.sizeToFit()
                self.lCoupleCountDown.center.x = self.view.center.x
            }
        })
        // 立刻启动
        breakTimer?.fire()
    }
    
    private func stopBreakTimer() {
        breakTimer?.invalidate()
        breakTimer = nil
    }
    
    private func getBreakCountDownShow(breakCountDown: Int64) -> String {
        let hour = breakCountDown / DateUtils.UNIT_HOUR
        let hourF = hour >= 10 ? "" : "0"
        let min = (breakCountDown - hour * DateUtils.UNIT_HOUR) / DateUtils.UNIT_MIN
        let minF = min >= 10 ? ":" : ":0"
        let sec = breakCountDown - hour * DateUtils.UNIT_HOUR - min * DateUtils.UNIT_MIN
        let secF = sec >= 10 ? ":" : ":0"
        return hourF + String(hour) + minF + String(min) + secF + String(sec)
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_COUPLE_HOME)
    }
    
    @objc private func targetGoCouplePair() {
        CouplePairVC.pushVC()
    }
    
    @objc private func targetGoCoupleInfo() {
        CoupleInfoVC.pushVC()
    }
    
    @objc private func targetGoWallPaper() {
        CoupleWallPaperVC.pushVC()
    }
    
    @objc private func targetGoCouplePlace() {
        CouplePlaceVC.pushVC()
    }
    
    @objc private func targetGoCoupleWeather() {
        CoupleWeatherVC.pushVC(myPlace: myPlace, taPlace: taPlace)
    }
    
}
