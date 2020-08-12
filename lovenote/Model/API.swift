//
// Created by 蒋治国 on 2018/12/5.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import LGAlertView

class ApiRuquest {
    var request: Cancellable
    
    init(request: Cancellable) {
        self.request = request
    }
    
    func calcel() {
        if !request.isCancelled {
            request.cancel()
        }
    }
}

let ApiProvider = MoyaProvider<Api>()

public enum Api {
    // user
    case smsSend(sms: [String: Any]?)
    case entryPush(entry: [String: Any]?)
    case ossGet
    case userRegister(code: String?, user: [String: Any]?)
    case userLogin(type: Int, code: String?, user: [String: Any]?)
    case userModify(type: Int, code: String?, oldPwd: String?, user: [String: Any]?)
    // set
    case setNoticeListGet(page: Int)
    case setNoticeRead(nid: Int64)
    case setSuggestAdd(suggest: [String: Any]?)
    case setSuggestDel(sid: Int64)
    case setSuggestGet(sid: Int64)
    case setSuggestListGet(status: Int, kind: Int, page: Int)
    case setSuggestListMineGet(page: Int)
    case setSuggestListFollowGet(page: Int)
    case setSuggestCommentAdd(suggestComment: [String: Any]?)
    case setSuggestCommentDel(scid: Int64)
    case setSuggestCommentListGet(sid: Int64, page: Int)
    case setSuggestFollowToggle(suggestFollow: [String: Any]?)
    // couple
    case coupleHomeGet
    case coupleInvitee(user: [String: Any]?)
    case coupleUpdate(type: Int, couple: [String: Any]?)
    case coupleGet(uid: Int64)
    case coupleSelfGet
    case coupleWallPaperUpdate(wallPaper: [String: Any]?)
    case coupleWallPaperGet
    case couplePlacePush(place: [String: Any]?)
    case couplePlaceListGet(page: Int)
    //case coupleWeatherForecastListGet
    // note
    case noteHomeGet(near: Int64)
    case noteLockAdd(lock: [String: Any]?)
    case noteLockUpdatePwd(code: String?, lock: [String: Any]?)
    case noteLockToggle(lock: [String: Any]?)
    case noteLockGet
    case noteTrendsListGet(create: Int64, page: Int)
    case noteTrendsTotalGet
    case noteSouvenirListGet(done: Bool, page: Int)
    case noteSouvenirGet(sid: Int64)
    case noteSouvenirAdd(souvenir: [String: Any]?)
    case noteSouvenirDel(sid: Int64)
    case noteSouvenirUpdateBody(souvenir: [String: Any]?)
    case noteSouvenirUpdateForeign(year: Int, souvenir: [String: Any]?)
    case noteMensesInfoGet
    case noteMensesInfoUpdate(mensesInfo: [String: Any]?)
    case noteMenses2ListGetByDate(mine: Bool, year: Int, month: Int)
    case noteMenses2Add(menses: [String: Any]?)
    case noteMensesDayAdd(mensesDay: [String: Any]?)
    case noteShyListGetByDate(year: Int, month: Int)
    case noteShyAdd(shy: [String: Any]?)
    case noteShyDel(sid: Int64)
    case noteSleepListGetByDate(year: Int, month: Int)
    case noteSleepLatestGet
    case noteSleepAdd(sleep: [String: Any]?)
    case noteSleepDel(sid: Int64)
    case noteWordListGet(page: Int)
    case noteWordAdd(word: [String: Any]?)
    case noteWordDel(wid: Int64)
    case noteWhisperListGet(channel: String?, page: Int)
    case noteWhisperAdd(whisper: [String: Any]?)
    case noteDiaryListGet(who: Int, page: Int)
    case noteDiaryGet(did: Int64)
    case noteDiaryAdd(diary: [String: Any]?)
    case noteDiaryDel(did: Int64)
    case noteDiaryUpdate(diary: [String: Any]?)
    case noteAlbumListGet(page: Int)
    case noteAlbumGet(aid: Int64)
    case noteAlbumAdd(album: [String: Any]?)
    case noteAlbumDel(aid: Int64)
    case noteAlbumUpdate(Album: [String: Any]?)
    case notePictureListGet(aid: Int64, page: Int)
    case notePictureListAdd(album: [String: Any]?)
    case notePictureDel(pid: Int64)
    case notePictureUpdate(picture: [String: Any]?)
    case noteAudioListGet(page: Int)
    case noteAudioAdd(audio: [String: Any]?)
    case noteAudioDel(aid: Int64)
    case noteVideoListGet(page: Int)
    case noteVideoAdd(video: [String: Any]?)
    case noteVideoDel(vid: Int64)
    case noteFoodListGet(page: Int)
    case noteFoodAdd(food: [String: Any]?)
    case noteFoodDel(fid: Int64)
    case noteFoodUpdate(food: [String: Any]?)
    case noteTravelListGet(page: Int)
    case noteTravelGet(tid: Int64)
    case noteTravelAdd(travel: [String: Any]?)
    case noteTravelDel(tid: Int64)
    case noteTravelUpdate(travel: [String: Any]?)
    case noteGiftListGet(who: Int, page: Int)
    case noteGiftAdd(gift: [String: Any]?)
    case noteGiftDel(gid: Int64)
    case noteGiftUpdate(gift: [String: Any]?)
    case notePromiseListGet(who: Int, page: Int)
    case notePromiseGet(pid: Int64)
    case notePromiseAdd(promise: [String: Any]?)
    case notePromiseDel(pid: Int64)
    case notePromiseUpdate(promise: [String: Any]?)
    case notePromiseBreakListGet(pid: Int64, page: Int)
    case notePromiseBreakAdd(promiseBreak: [String: Any]?)
    case notePromiseBreakDel(pbid: Int64)
    case noteAngryListGet(who: Int, page: Int)
    case noteAngryGet(aid: Int64)
    case noteAngryAdd(angry: [String: Any]?)
    case noteAngryDel(aid: Int64)
    case noteAngryUpdate(angry: [String: Any]?)
    case noteDreamListGet(who: Int, page: Int)
    case noteDreamGet(did: Int64)
    case noteDreamAdd(dream: [String: Any]?)
    case noteDreamDel(did: Int64)
    case noteDreamUpdate(dream: [String: Any]?)
    case noteAwardListGet(who: Int, page: Int)
    case noteAwardScoreGet
    case noteAwardAdd(award: [String: Any]?)
    case noteAwardDel(aid: Int64)
    case noteAwardRuleListGet(page: Int)
    case noteAwardRuleAdd(awardRule: [String: Any]?)
    case noteAwardRuleDel(arid: Int64)
    case noteMovieListGet(page: Int)
    case noteMovieAdd(movie: [String: Any]?)
    case noteMovieDel(mid: Int64)
    case noteMovieUpdate(movie: [String: Any]?)
    // topic
    case topicHomeGet
    case topicMessageListGet(kind: Int, page: Int)
    case topicPostAdd(post: [String: Any]?)
    case topicPostDel(pid: Int64)
    case topicPostListSearchGet(search: String, page: Int)
    case topicPostListHomeGet(create: Int64, page: Int)
    case topicPostListGet(create: Int64, kind: Int, subKind: Int, official: Bool, well: Bool, page: Int)
    case topicPostCollectListGet(me: Bool, page: Int)
    case topicPostMineListGet(page: Int)
    case topicPostGet(pid: Int64)
    case topicPostRead(pid: Int64)
    case topicPostReportAdd(postReport: [String: Any]?)
    case topicPostPointToggle(postPoint: [String: Any]?)
    case topicPostCollectToggle(postCollect: [String: Any]?)
    case topicPostCommentAdd(postComment: [String: Any]?)
    case topicPostCommentDel(pcid: Int64)
    case topicPostCommentListGet(pid: Int64, order: Int, page: Int)
    case topicPostCommentSubListGet(pid: Int64, tcid: Int64, order: Int, page: Int)
    case topicPostCommentUserListGet(pid: Int64, uid: Int64, order: Int, page: Int)
    case topicPostCommentGet(pcid: Int64)
    case topicPostCommentReportAdd(postCommentReport: [String: Any]?)
    case topicPostCommentPointToggle(postCommentPoint: [String: Any]?)
    // more
    case moreHomeGet
    case morePayBeforeGet(payPlatform: Int, goods: Int)
    case morePayAfterCheck(order: [String: Any]?)
    case moreVipHomeGet
    case moreVipListGet(page: Int)
    case moreCoinHomeGet
    //case moreCoinAdd(coin: [String: Any]?)
    case moreCoinListGet(page: Int)
    case moreSignDateGet(year: Int, month: Int)
    case moreSignAdd
    case moreMatchPeriodListGet(kind: Int, page: Int)
    case moreMatchWorkAdd(matchWork: [String: Any]?)
    case moreMatchWorkDel(mwid: Int64)
    case moreMatchWorkListGet(mpid: Int64, order: Int, page: Int)
    case moreMatchWorkOurListGet(kind: Int, page: Int)
    case moreMatchReportAdd(matchReport: [String: Any]?)
    case moreMatchPointAdd(matchPoint: [String: Any]?)
    case moreMatchCoinAdd(matchCoin: [String: Any]?)
}

extension Api: TargetType {
    
    static func request(_ target: Api, loading: Bool = false, cancel: Bool = true,
                        success successCallback: ((Int, String, ApiData) -> Void)? = nil,
                        failure failureCallback: ((Int, String, ApiData) -> Void)? = nil) -> ApiRuquest {
        // indicator
        let indicator = AlertHelper.getIndicator(canCancel: cancel, cancelHandler: nil)
        if loading {
            AlertHelper.show(indicator)
        }
        // 开始请求
        let cancellable = ApiProvider.request(target, completion: { result in
            // indicator
            if indicator.isShowing {
                AlertHelper.diss(indicator)
            }
            // 返回数据
            switch result {
            case let .success(response): // success
                // status
                let status = response.statusCode
                // 获取result
                let mapJson = ((try? response.mapJSON() as? [String: Any]) as [String : Any]??)
                var apiResult: ApiResult!
                if mapJson == nil || mapJson! == nil {
                    apiResult = ApiResult()
                    apiResult.code = ApiResult.CODE_TOAST
                    apiResult.message = StringUtils.getString("err_data_null")
                } else {
                    apiResult = ApiResult(JSON: mapJson!!)
                }
                if apiResult == nil {
                    apiResult = ApiResult()
                    apiResult.code = ApiResult.CODE_TOAST
                    apiResult.message = StringUtils.getString("err_data_parse")
                }
                // log
                LogUtils.i(tag: "Api", method: "request-success", mapJson as Any)
                // 设置数据
                let code = apiResult!.code
                let message = apiResult!.message
                let data = apiResult!.data ?? ApiData()
                // status处理 status基本为统一处理的逻辑 code为私有处理逻辑
                switch status {
                case 200: // 成功
                    ToastUtils.show(message)
                    break
                case 401: // 用户验证失败
                    SplashVC.pushVC()
                    break
                case 408: // 请求超时
                    _ = AlertHelper.showAlert(title: StringUtils.getString("http_error_time_maybe_setting_wrong"),
                                              confirms: [StringUtils.getString("go_to_setting")],
                                              cancel: StringUtils.getString("i_know"),
                                              actionHandler: { (_, _, _) in
                                                URLUtils.openSettings()
                    }, cancelHandler: nil)
                    break
                case 409: // 用户版本过低,提示用户升级
                    AlertHelper.showVersionCheckAlert()
                    break
                case 417: // 逻辑错误，必须返回错误信息
                    if code == ApiResult.CODE_TOAST {
                        ToastUtils.show(message)
                    } else if code == ApiResult.CODE_DIALOG {
                        _ = AlertHelper.showAlert(title: message, cancel: StringUtils.getString("i_know"))
                    } else if code == ApiResult.CODE_NO_USER_INFO {
                        ToastUtils.show(message)
                        UserInfoVC.pushVC(user: data.user)
                    } else if code == ApiResult.CODE_NO_CP {
                        ToastUtils.show(message)
                        CouplePairVC.pushVC()
                    }
                    break
                case 500: // 服务器异常
                    _ = AlertHelper.showAlert(title: StringUtils.getString("server_error"),
                                              confirms: [StringUtils.getString("i_know")],
                                              canCancel: false,
                                              actionHandler: { (_, _, _) in
                                                AppUtils.exit()
                    }, cancelHandler: { (_) in
                        AppUtils.exit()
                    })
                    break
                case 503: // 服务器维护
                    _ = AlertHelper.showAlert(title: message + "\n" + UDHelper.getCommonConst().officialGroup,
                                              confirms: [StringUtils.getString("i_know")],
                                              canCancel: false,
                                              actionHandler: { (_, _, _) in
                                                AppUtils.exit()
                    }, cancelHandler: { (_) in
                        AppUtils.exit()
                    })
                    break
                default: // 其他错误
                    // 403 禁止访问,key错误
                    // 404 url不存在
                    // 405 method错误
                    // 406 用户被禁用,应该退出应用
                    _ = AlertHelper.showAlert(title: message,
                                              confirms: [StringUtils.getString("i_want_feedback")],
                                              cancel: StringUtils.getString("i_know"),
                                              actionHandler: { (_, _, _) in
                                                SuggestAddVC.pushVC()
                    }, cancelHandler: nil)
                    break
                }
                // 回调
                if status == 200 {
                    successCallback?(code, message, data)
                } else {
                    failureCallback?(code, message, data)
                }
            case let .failure(error): // failure
                let failureShow = StringUtils.getString("http_error_request")
                let errMsg = error.errorDescription ?? error.failureReason ?? failureShow
                LogUtils.w(tag: "API", method: "request-failure", errMsg)
                ToastUtils.show(failureShow)
                failureCallback?(-1, errMsg, ApiData())
                break
            }
        })
        let api = ApiRuquest(request: cancellable)
        if loading {
            indicator.cancelHandler = { (_) in
                api.calcel()
            }
        }
        return api
    }
    
    // url
    public var baseURL: URL {
        return URL(string: AppUtils.getInfoString(key: "API_BASE_URL_RELEASE"))!
    }
    
    // head
    public var headers: [String: String]? {
        return [
            "Accept": "application/json",
            "Content-Type": "application/json;charset=utf-8",
            "accessToken": UDHelper.getMe()?.userToken ?? "",
            "appKey": AppUtils.getInfoString(key: "API_APP_KEY"),
            "platform": "ios",
            "language": DeviceUtils.getDeviceLanguage(),
        ]
    }
    
    // 路径
    public var path: String {
        switch self {
        // user
        case .smsSend:      return "/sms"
        case .entryPush:    return "/entry"
        case .ossGet:       return "/oss"
        case .userRegister: return "/user"
        case .userLogin:    return "/user/login"
        case .userModify:   return "/user"
        // set
        case .setNoticeListGet: return "/set/notice"
        case .setNoticeRead:    return "/set/notice"
        case .setSuggestAdd:    return "/set/suggest"
        case .setSuggestDel:    return "/set/suggest"
        case .setSuggestGet:    return "/set/suggest"
        case .setSuggestListGet:        return "/set/suggest"
        case .setSuggestListMineGet:    return "/set/suggest"
        case .setSuggestListFollowGet:  return "/set/suggest"
        case .setSuggestCommentAdd:     return "/set/suggest/comment"
        case .setSuggestCommentDel:     return "/set/suggest/comment"
        case .setSuggestCommentListGet: return "/set/suggest/comment"
        case .setSuggestFollowToggle:   return "/set/suggest/follow"
        // couple
        case .coupleHomeGet:            return "/couple/home"
        case .coupleInvitee:            return "/couple"
        case .coupleUpdate:             return "/couple"
        case .coupleGet:                return "/couple"
        case .coupleSelfGet:            return "/couple"
        case .coupleWallPaperUpdate:    return "/couple/wallPaper"
        case .coupleWallPaperGet:       return "/couple/wallPaper"
        case .couplePlacePush:          return "/couple/place"
        case .couplePlaceListGet:       return "/couple/place"
            //case .coupleWeatherForecastListGet: return "/couple/weather"
        // note
        case .noteHomeGet:          return "/note/home"
        case .noteLockAdd:          return "/note/lock"
        case .noteLockUpdatePwd:    return "/note/lock"
        case .noteLockToggle:       return "/note/lock"
        case .noteLockGet:          return "/note/lock"
        case .noteTrendsListGet:    return "/note/trends"
        case .noteTrendsTotalGet:   return "/note/trends"
        case .noteSouvenirListGet:  return "/note/souvenir"
        case .noteSouvenirGet:      return "/note/souvenir"
        case .noteSouvenirAdd:      return "/note/souvenir"
        case .noteSouvenirDel:      return "/note/souvenir"
        case .noteSouvenirUpdateBody:   return "/note/souvenir"
        case .noteSouvenirUpdateForeign:return "/note/souvenir"
        case .noteMensesInfoGet:        return "note/mensesInfo"
        case .noteMensesInfoUpdate:     return "note/mensesInfo"
        case .noteMenses2ListGetByDate: return "note/menses2"
        case .noteMenses2Add:           return "note/menses2"
        case .noteMensesDayAdd:        return "note/mensesDay"
        case .noteShyListGetByDate: return "/note/shy"
        case .noteShyAdd:           return "/note/shy"
        case .noteShyDel:           return "/note/shy"
        case .noteSleepListGetByDate:   return "/note/sleep"
        case .noteSleepLatestGet:   return "/note/sleep"
        case .noteSleepAdd:         return "/note/sleep"
        case .noteSleepDel:         return "/note/sleep"
        case .noteWordListGet:      return "/note/word"
        case .noteWordAdd:          return "/note/word"
        case .noteWordDel:          return "/note/word"
        case .noteWhisperListGet:   return "/note/whisper"
        case .noteWhisperAdd:       return "/note/whisper"
        case .noteDiaryListGet:     return "/note/diary"
        case .noteDiaryGet:         return "/note/diary"
        case .noteDiaryAdd:         return "/note/diary"
        case .noteDiaryDel:         return "/note/diary"
        case .noteDiaryUpdate:      return "/note/diary"
        case .noteAlbumListGet:     return "/note/album"
        case .noteAlbumGet:         return "/note/album"
        case .noteAlbumAdd:         return "/note/album"
        case .noteAlbumDel:         return "/note/album"
        case .noteAlbumUpdate:      return "/note/album"
        case .notePictureListGet:   return "/note/picture"
        case .notePictureListAdd:   return "/note/picture"
        case .notePictureDel:       return "/note/picture"
        case .notePictureUpdate:    return "/note/picture"
        case .noteAudioListGet:     return "/note/audio"
        case .noteAudioAdd:         return "/note/audio"
        case .noteAudioDel:         return "/note/audio"
        case .noteVideoListGet:     return "/note/video"
        case .noteVideoAdd:         return "/note/video"
        case .noteVideoDel:         return "/note/video"
        case .noteFoodListGet:      return "/note/food"
        case .noteFoodAdd:          return "/note/food"
        case .noteFoodDel:          return "/note/food"
        case .noteFoodUpdate:       return "/note/food"
        case .noteTravelListGet:    return "/note/travel"
        case .noteTravelGet:        return "/note/travel"
        case .noteTravelAdd:        return "/note/travel"
        case .noteTravelDel:        return "/note/travel"
        case .noteTravelUpdate:     return "/note/travel"
        case .noteGiftListGet:      return "/note/gift"
        case .noteGiftAdd:          return "/note/gift"
        case .noteGiftDel:          return "/note/gift"
        case .noteGiftUpdate:       return "/note/gift"
        case .notePromiseListGet:   return "/note/promise"
        case .notePromiseGet:       return "/note/promise"
        case .notePromiseAdd:       return "/note/promise"
        case .notePromiseDel:       return "/note/promise"
        case .notePromiseUpdate:    return "/note/promise"
        case .notePromiseBreakListGet:  return "/note/promise/break"
        case .notePromiseBreakAdd:  return "/note/promise/break"
        case .notePromiseBreakDel:  return "/note/promise/break"
        case .noteAngryListGet:     return "/note/angry"
        case .noteAngryGet:         return "/note/angry"
        case .noteAngryAdd:         return "/note/angry"
        case .noteAngryDel:         return "/note/angry"
        case .noteAngryUpdate:      return "/note/angry"
        case .noteDreamListGet:     return "/note/dream"
        case .noteDreamGet:         return "/note/dream"
        case .noteDreamAdd:         return "/note/dream"
        case .noteDreamDel:         return "/note/dream"
        case .noteDreamUpdate:      return "/note/dream"
        case .noteAwardListGet:     return "/note/award"
        case .noteAwardScoreGet:    return "/note/award"
        case .noteAwardAdd:         return "/note/award"
        case .noteAwardDel:         return "/note/award"
        case .noteAwardRuleListGet: return "/note/award/rule"
        case .noteAwardRuleAdd:     return "/note/award/rule"
        case .noteAwardRuleDel:     return "/note/award/rule"
        case .noteMovieListGet:     return "/note/movie"
        case .noteMovieAdd:         return "/note/movie"
        case .noteMovieDel:         return "/note/movie"
        case .noteMovieUpdate:      return "/note/movie"
        // topic
        case .topicHomeGet:         return "topic/home"
        case .topicMessageListGet:  return "topic/message"
        case .topicPostAdd:         return "topic/post"
        case .topicPostDel:         return "topic/post"
        case .topicPostListSearchGet:   return "topic/post"
        case .topicPostListHomeGet:     return "topic/post"
        case .topicPostListGet:         return "topic/post"
        case .topicPostCollectListGet:  return "topic/post"
        case .topicPostMineListGet: return "topic/post"
        case .topicPostGet:         return "topic/post"
        case .topicPostRead:        return "topic/post/read"
        case .topicPostReportAdd:   return "topic/post/report"
        case .topicPostPointToggle: return "topic/post/point"
        case .topicPostCollectToggle:   return "topic/post/collect"
        case .topicPostCommentAdd:      return "topic/post/comment"
        case .topicPostCommentDel:      return "topic/post/comment"
        case .topicPostCommentListGet:  return "topic/post/comment"
        case .topicPostCommentSubListGet:   return "topic/post/comment"
        case .topicPostCommentUserListGet:  return "topic/post/comment"
        case .topicPostCommentGet:          return "topic/post/comment"
        case .topicPostCommentReportAdd:    return "topic/post/comment/report"
        case .topicPostCommentPointToggle:  return "topic/post/comment/point"
        // more
        case .moreHomeGet:          return "/more/home"
        case .morePayBeforeGet:     return "/more/bill"
        case .morePayAfterCheck:    return "/more/bill"
        case .moreVipHomeGet:       return "/more/vip"
        case .moreVipListGet:       return "/more/vip"
        case .moreCoinHomeGet:      return "/more/coin"
        //case .moreCoinAdd:          return "/more/coin"
        case .moreCoinListGet:      return "/more/coin"
        case .moreSignDateGet:      return "/more/sign"
        case .moreSignAdd:          return "/more/sign"
        case .moreMatchPeriodListGet:   return "/more/match/period"
        case .moreMatchWorkAdd:         return "/more/match/work"
        case .moreMatchWorkDel:         return "/more/match/work"
        case .moreMatchWorkListGet:     return "/more/match/work"
        case .moreMatchWorkOurListGet:  return "/more/match/work"
        case .moreMatchReportAdd:       return "/more/match/report"
        case .moreMatchPointAdd:        return "/more/match/point"
        case .moreMatchCoinAdd:         return "/more/match/coin"
        }
    }
    
    // 方法
    public var method: Moya.Method {
        switch self {
        // user
        case .smsSend:      return .post
        case .entryPush:    return .post
        case .ossGet:       return .get
        case .userRegister: return .post
        case .userLogin:    return .post
        case .userModify:   return .put
        // set
        case .setNoticeListGet: return .get
        case .setNoticeRead:    return .put
        case .setSuggestAdd:    return .post
        case .setSuggestDel:    return .delete
        case .setSuggestGet:    return .get
        case .setSuggestListGet:        return .get
        case .setSuggestListMineGet:    return .get
        case .setSuggestListFollowGet:  return .get
        case .setSuggestCommentAdd:     return .post
        case .setSuggestCommentDel:     return .delete
        case .setSuggestCommentListGet: return .get
        case .setSuggestFollowToggle:   return .post
        // couple
        case .coupleHomeGet:            return .get
        case .coupleInvitee:            return .post
        case .coupleUpdate:             return .put
        case .coupleGet:                return .get
        case .coupleSelfGet:            return .get
        case .coupleWallPaperUpdate:    return .post
        case .coupleWallPaperGet:       return .get
        case .couplePlacePush:          return .post
        case .couplePlaceListGet:       return .get
            //case .coupleWeatherForecastListGet: return .get
        // note
        case .noteHomeGet:          return .get
        case .noteLockAdd:          return .post
        case .noteLockUpdatePwd:    return .put
        case .noteLockToggle:       return .put
        case .noteLockGet:          return .get
        case .noteTrendsListGet:    return .get
        case .noteTrendsTotalGet:   return .get
        case .noteSouvenirListGet:  return .get
        case .noteSouvenirGet:      return .get
        case .noteSouvenirAdd:      return .post
        case .noteSouvenirDel:      return .delete
        case .noteSouvenirUpdateBody:   return .put
        case .noteSouvenirUpdateForeign:return .put
        case .noteMensesInfoGet:        return .get
        case .noteMensesInfoUpdate:     return .put
        case .noteMenses2ListGetByDate: return .get
        case .noteMenses2Add:       return .post
        case .noteMensesDayAdd:     return .post
        case .noteShyListGetByDate: return .get
        case .noteShyAdd:           return .post
        case .noteShyDel:           return .delete
        case .noteSleepListGetByDate:   return .get
        case .noteSleepLatestGet:   return .get
        case .noteSleepAdd:         return .post
        case .noteSleepDel:         return .delete
        case .noteWordListGet:      return .get
        case .noteWordAdd:          return .post
        case .noteWordDel:          return .delete
        case .noteWhisperListGet:   return .get
        case .noteWhisperAdd:       return .post
        case .noteDiaryListGet:     return .get
        case .noteDiaryGet:         return .get
        case .noteDiaryAdd:         return .post
        case .noteDiaryDel:         return .delete
        case .noteDiaryUpdate:      return .put
        case .noteAlbumListGet:     return .get
        case .noteAlbumGet:         return .get
        case .noteAlbumAdd:         return .post
        case .noteAlbumDel:         return .delete
        case .noteAlbumUpdate:      return .put
        case .notePictureListGet:   return .get
        case .notePictureListAdd:   return .post
        case .notePictureDel:       return .delete
        case .notePictureUpdate:    return .put
        case .noteAudioListGet:     return .get
        case .noteAudioAdd:         return .post
        case .noteAudioDel:         return .delete
        case .noteVideoListGet:     return .get
        case .noteVideoAdd:         return .post
        case .noteVideoDel:         return .delete
        case .noteFoodListGet:      return .get
        case .noteFoodAdd:          return .post
        case .noteFoodDel:          return .delete
        case .noteFoodUpdate:       return .put
        case .noteTravelListGet:    return .get
        case .noteTravelGet:        return .get
        case .noteTravelAdd:        return .post
        case .noteTravelDel:        return .delete
        case .noteTravelUpdate:     return .put
        case .noteGiftListGet:      return .get
        case .noteGiftAdd:          return .post
        case .noteGiftDel:          return .delete
        case .noteGiftUpdate:       return .put
        case .notePromiseListGet:   return .get
        case .notePromiseGet:       return .get
        case .notePromiseAdd:       return .post
        case .notePromiseDel:       return .delete
        case .notePromiseUpdate:    return .put
        case .notePromiseBreakListGet:  return .get
        case .notePromiseBreakAdd:  return .post
        case .notePromiseBreakDel:  return .delete
        case .noteAngryListGet:     return .get
        case .noteAngryGet:         return .get
        case .noteAngryAdd:         return .post
        case .noteAngryDel:         return .delete
        case .noteAngryUpdate:      return .put
        case .noteDreamListGet:     return .get
        case .noteDreamGet:         return .get
        case .noteDreamAdd:         return .post
        case .noteDreamDel:         return .delete
        case .noteDreamUpdate:      return .put
        case .noteAwardListGet:     return .get
        case .noteAwardScoreGet:    return .get
        case .noteAwardAdd:         return .post
        case .noteAwardDel:         return .delete
        case .noteAwardRuleListGet: return .get
        case .noteAwardRuleAdd:     return .post
        case .noteAwardRuleDel:     return .delete
        case .noteMovieListGet:     return .get
        case .noteMovieAdd:         return .post
        case .noteMovieDel:         return .delete
        case .noteMovieUpdate:      return .put
        // topic
        case .topicHomeGet:         return .get
        case .topicMessageListGet:  return .get
        case .topicPostAdd:         return .post
        case .topicPostDel:         return .delete
        case .topicPostListSearchGet:   return .get
        case .topicPostListHomeGet:     return .get
        case .topicPostListGet:         return .get
        case .topicPostCollectListGet:  return .get
        case .topicPostMineListGet:     return .get
        case .topicPostGet:             return .get
        case .topicPostRead:            return .post
        case .topicPostReportAdd:       return .post
        case .topicPostPointToggle:     return .post
        case .topicPostCollectToggle:   return .post
        case .topicPostCommentAdd:      return .post
        case .topicPostCommentDel:      return .delete
        case .topicPostCommentListGet:  return .get
        case .topicPostCommentSubListGet:   return .get
        case .topicPostCommentUserListGet:  return .get
        case .topicPostCommentGet:          return .get
        case .topicPostCommentReportAdd:    return .post
        case .topicPostCommentPointToggle:  return .post
        // more
        case .moreHomeGet:          return .get
        case .morePayBeforeGet:     return .get
        case .morePayAfterCheck:    return .post
        case .moreVipHomeGet:       return .get
        case .moreVipListGet:       return .get
        case .moreCoinHomeGet:      return .get
        //case .moreCoinAdd:          return .post
        case .moreCoinListGet:      return .get
        case .moreSignDateGet:      return .get
        case .moreSignAdd:          return .post
        case .moreMatchPeriodListGet:   return .get
        case .moreMatchWorkAdd:         return .post
        case .moreMatchWorkDel:         return .delete
        case .moreMatchWorkListGet:     return .get
        case .moreMatchWorkOurListGet:  return .get
        case .moreMatchReportAdd:       return .post
        case .moreMatchPointAdd:        return .post
        case .moreMatchCoinAdd:         return .post
        }
    }
    
    // 任务
    public var task: Task {
        var params: [String: Any] = [:]
        var bodyDic: Dictionary<String, Any>?
        // 开始判断
        switch self {
        // user
        case .smsSend(let sms):
            bodyDic = sms
            break
        case .entryPush(let entry):
            bodyDic = entry
            break
        case .ossGet:
            break
        case .userRegister(let code, let user):
            params["code"] = code
            bodyDic = user
            break
        case .userLogin(let type, let code, let user):
            params["type"] = type
            params["code"] = code
            bodyDic = user
            break
        case .userModify(let type, let code, let oldPwd, let user):
            params["type"] = type
            params["code"] = code
            params["old_pwd"] = oldPwd
            bodyDic = user
            break
        // set
        case .setNoticeListGet(let page):
            params["list"] = 1
            params["page"] = page
            break
        case .setNoticeRead(let nid):
            params["nid"] = nid
            bodyDic = [String: Any]()
            break
        case .setSuggestAdd(let suggest):
            bodyDic = suggest
            break
        case .setSuggestDel(let sid):
            params["sid"] = sid
            break
        case .setSuggestGet(let sid):
            params["sid"] = sid
            break
        case .setSuggestListGet(let status, let kind, let page):
            params["list"] = 1
            params["status"] = status
            params["kind"] = kind
            params["page"] = page
            break
        case .setSuggestListMineGet(let page):
            params["mine"] = 1
            params["page"] = page
            break
        case .setSuggestListFollowGet(let page):
            params["follow"] = 1
            params["page"] = page
            break
        case .setSuggestCommentAdd(let suggestComment):
            bodyDic = suggestComment
            break
        case .setSuggestCommentDel(let scid):
            params["scid"] = scid
            break
        case .setSuggestCommentListGet(let sid, let page):
            params["sid"] = sid
            params["page"] = page
            break
        case .setSuggestFollowToggle(let suggestFollow):
            bodyDic = suggestFollow
            break
        // couple
        case .coupleHomeGet:
            break
        case .coupleInvitee(let user):
            bodyDic = user
            break
        case .coupleUpdate(let type, let couple):
            params["type"] = type
            bodyDic = couple
            break
        case .coupleGet(let uid):
            params["self"] = 0
            params["uid"] = uid
            break
        case .coupleSelfGet:
            params["self"] = 1
            break
        case .coupleWallPaperUpdate(let wallPaper):
            bodyDic = wallPaper
            break
        case .coupleWallPaperGet:
            break
        case .couplePlacePush(let place):
            bodyDic = place
            break
        case .couplePlaceListGet(let page):
            params["list"] = 1
            params["page"] = page
            break
            //case .coupleWeatherForecastListGet:
            //    params["forecast"] = 1
            //    break
        // note
        case .noteHomeGet(let near):
            params["near"] = near
            break
        case .noteLockAdd(let lock):
            bodyDic = lock
            break
        case .noteLockUpdatePwd(let code, let lock):
            params["modify"] = 1
            params["code"] = code
            bodyDic = lock
            break
        case .noteLockToggle(let lock):
            params["toggle"] = 1
            bodyDic = lock
            break
        case .noteLockGet:
            break
        case .noteTrendsListGet(let create, let page):
            params["list"] = 1
            params["create"] = create
            params["page"] = page
            break
        case .noteTrendsTotalGet:
            params["total"] = 1
            break
        case .noteSouvenirListGet(let done, let page):
            params["list"] = 1
            params["done"] = done
            params["page"] = page
            break
        case .noteSouvenirGet(let sid):
            params["sid"] = sid
            break
        case .noteSouvenirAdd(let souvenir):
            bodyDic = souvenir
            break
        case .noteSouvenirDel(let sid):
            params["sid"] = sid
            break
        case .noteSouvenirUpdateBody(let souvenir):
            bodyDic = souvenir
            break
        case .noteSouvenirUpdateForeign(let year, let souvenir):
            params["year"] = year
            bodyDic = souvenir
            break
        case .noteMensesInfoGet:
            break
        case .noteMensesInfoUpdate(let mensesInfo):
            bodyDic = mensesInfo
            break
        case .noteMenses2ListGetByDate(let mine, let year, let month):
            params["date"] = 1
            params["mine"] = mine
            params["year"] = year
            params["month"] = month
            break
        case .noteMenses2Add(let menses):
            bodyDic = menses
            break
        case .noteMensesDayAdd(let mensesDay):
            bodyDic = mensesDay
            break
        case .noteShyListGetByDate(let year, let month):
            params["date"] = 1
            params["year"] = year
            params["month"] = month
            break
        case .noteShyAdd(let shy):
            bodyDic = shy
            break
        case .noteShyDel(let sid):
            params["sid"] = sid
            break
        case .noteSleepListGetByDate(let year, let month):
            params["date"] = 1
            params["year"] = year
            params["month"] = month
            break
        case .noteSleepLatestGet:
            params["latest"] = 1
            break
        case .noteSleepAdd(let sleep):
            bodyDic = sleep
            break
        case .noteSleepDel(let sid):
            params["sid"] = sid
            break
        case .noteWordListGet(let page):
            params["list"] = 1
            params["page"] = page
            break
        case .noteWordAdd(let word):
            bodyDic = word
            break
        case .noteWordDel(let wid):
            params["wid"] = wid
            break
        case .noteWhisperListGet(let channel, let page):
            params["list"] = 1
            params["channel"] = channel
            params["page"] = page
            break
        case .noteWhisperAdd(let whisper):
            bodyDic = whisper
            break
        case .noteDiaryListGet(let who, let page):
            params["list"] = 1
            params["who"] = who
            params["page"] = page
            break
        case .noteDiaryGet(let did):
            params["did"] = did
            break
        case .noteDiaryAdd(let diary):
            bodyDic = diary
            break
        case .noteDiaryDel(let did):
            params["did"] = did
            break
        case .noteDiaryUpdate(let diary):
            bodyDic = diary
            break
        case .noteAlbumListGet(let page):
            params["list"] = 1
            params["page"] = page
            break
        case .noteAlbumGet(let aid):
            params["aid"] = aid
            break
        case .noteAlbumAdd(let album):
            bodyDic = album
            break
        case .noteAlbumDel(let aid):
            params["aid"] = aid
            break
        case .noteAlbumUpdate(let album):
            bodyDic = album
            break
        case .notePictureListGet(let aid, let page):
            params["aid"] = aid
            params["page"] = page
            break
        case .notePictureListAdd(let album):
            bodyDic = album
            break
        case .notePictureDel(let pid):
            params["pid"] = pid
            break
        case .notePictureUpdate(let picture):
            bodyDic = picture
            break
        case .noteAudioListGet(let page):
            params["list"] = 1
            params["page"] = page
            break
        case .noteAudioAdd(let audio):
            bodyDic = audio
            break
        case .noteAudioDel(let aid):
            params["aid"] = aid
            break
        case .noteVideoListGet(let page):
            params["list"] = 1
            params["page"] = page
            break
        case .noteVideoAdd(let video):
            bodyDic = video
            break
        case .noteVideoDel(let vid):
            params["vid"] = vid
            break
        case .noteFoodListGet(let page):
            params["list"] = 1
            params["page"] = page
            break
        case .noteFoodAdd(let food):
            bodyDic = food
            break
        case .noteFoodDel(let fid):
            params["fid"] = fid
            break
        case .noteFoodUpdate(let food):
            bodyDic = food
            break
        case .noteTravelListGet(let page):
            params["list"] = 1
            params["page"] = page
            break
        case .noteTravelGet(let tid):
            params["tid"] = tid
            break
        case .noteTravelAdd(let travel):
            bodyDic = travel
            break
        case .noteTravelDel(let tid):
            params["tid"] = tid
            break
        case .noteTravelUpdate(let travel):
            bodyDic = travel
            break
        case .noteGiftListGet(let who, let page):
            params["list"] = 1
            params["who"] = who
            params["page"] = page
            break
        case .noteGiftAdd(let gift):
            bodyDic = gift
            break
        case .noteGiftDel(let gid):
            params["gid"] = gid
            break
        case .noteGiftUpdate(let gift):
            bodyDic = gift
            break
        case .notePromiseListGet(let who, let page):
            params["list"] = 1
            params["who"] = who
            params["page"] = page
            break
        case .notePromiseGet(let pid):
            params["pid"] = pid
            break
        case .notePromiseAdd(let promise):
            bodyDic = promise
            break
        case .notePromiseDel(let pid):
            params["pid"] = pid
            break
        case .notePromiseUpdate(let promise):
            bodyDic = promise
            break
        case .notePromiseBreakListGet(let pid, let page):
            params["pid"] = pid
            params["page"] = page
            break
        case .notePromiseBreakAdd(let promiseBreak):
            bodyDic = promiseBreak
            break
        case .notePromiseBreakDel(let pbid):
            params["pbid"] = pbid
            break
        case .noteAngryListGet(let who, let page):
            params["list"] = 1
            params["who"] = who
            params["page"] = page
            break
        case .noteAngryGet(let aid):
            params["aid"] = aid
            break
        case .noteAngryAdd(let angry):
            bodyDic = angry
            break
        case .noteAngryDel(let aid):
            params["aid"] = aid
            break
        case .noteAngryUpdate(let angry):
            bodyDic = angry
            break
        case .noteDreamListGet(let who, let page):
            params["list"] = 1
            params["who"] = who
            params["page"] = page
            break
        case .noteDreamGet(let did):
            params["did"] = did
            break
        case .noteDreamAdd(let dream):
            bodyDic = dream
            break
        case .noteDreamDel(let did):
            params["did"] = did
            break
        case .noteDreamUpdate(let dream):
            bodyDic = dream
            break
        case .noteAwardListGet(let who, let page):
            params["list"] = 1
            params["who"] = who
            params["page"] = page
            break
        case .noteAwardScoreGet:
            params["score"] = 1
            break
        case .noteAwardAdd(let award):
            bodyDic = award
            break
        case .noteAwardDel(let aid):
            params["aid"] = aid
            break
        case .noteAwardRuleListGet(let page):
            params["list"] = 1
            params["page"] = page
            break
        case .noteAwardRuleAdd(let awardRule):
            bodyDic = awardRule
            break
        case .noteAwardRuleDel(let arid):
            params["arid"] = arid
            break
        case .noteMovieListGet(let page):
            params["list"] = 1
            params["page"] = page
            break
        case .noteMovieAdd(let movie):
            bodyDic = movie
            break
        case .noteMovieDel(let mid):
            params["mid"] = mid
            break
        case .noteMovieUpdate(let movie):
            bodyDic = movie
            break
        // topic
        case .topicHomeGet:
            break
        case .topicMessageListGet(let kind, let page):
            params["mine"] = 1
            params["kind"] = kind
            params["page"] = page
            break
        case .topicPostAdd(let post):
            bodyDic = post
            break
        case .topicPostDel(let pid):
            params["pid"] = pid
            break
        case .topicPostListSearchGet(let search, let page):
            params["list"] = 1
            params["create"] = 0
            params["kind"] = 0
            params["sub_kind"] = 0
            params["search"] = search
            params["page"] = page
            break
        case .topicPostListHomeGet(let create, let page):
            params["list"] = 1
            params["kind"] = 0
            params["sub_kind"] = 0
            params["create"] = create
            params["page"] = page
            break
        case .topicPostListGet(let create, let kind, let subKind, let official, let well, let page):
            params["list"] = 1
            params["create"] = create
            params["kind"] = kind
            params["sub_kind"] = subKind
            params["official"] = official
            params["well"] = well
            params["page"] = page
            break
        case .topicPostCollectListGet(let me, let page):
            params["collect"] = 1
            params["me"] = me
            params["page"] = page
            break
        case .topicPostMineListGet(let page):
            params["mine"] = 1
            params["page"] = page
            break
        case .topicPostGet(let pid):
            params["pid"] = pid
            break
        case .topicPostRead(let pid):
            params["pid"] = pid
            bodyDic = BaseObj().toJSON() // post必须带这个！
            break
        case .topicPostReportAdd(let postReport):
            bodyDic = postReport
            break
        case .topicPostPointToggle(let postPoint):
            bodyDic = postPoint
            break
        case .topicPostCollectToggle(let postCollect):
            bodyDic = postCollect
            break
        case .topicPostCommentAdd(let postComment):
            bodyDic = postComment
            break
        case .topicPostCommentDel(let pcid):
            params["pcid"] = pcid
            break
        case .topicPostCommentListGet(let pid, let order, let page):
            params["list"] = 1
            params["pid"] = pid
            params["order"] = order
            params["page"] = page
            break
        case .topicPostCommentSubListGet(let pid, let tcid, let order, let page):
            params["sub_list"] = 1
            params["pid"] = pid
            params["tcid"] = tcid
            params["order"] = order
            params["page"] = page
            break
        case .topicPostCommentUserListGet(let pid, let uid, let order, let page):
            params["pid"] = pid
            params["uid"] = uid
            params["order"] = order
            params["page"] = page
            break
        case .topicPostCommentGet(let pcid):
            params["pcid"] = pcid
            break
        case .topicPostCommentReportAdd(let postCommentReport):
            bodyDic = postCommentReport
            break
        case .topicPostCommentPointToggle(let postCommentPoint):
            bodyDic = postCommentPoint
            break
        // more
        case .moreHomeGet:
            break
        case .morePayBeforeGet(let payPlatform, let goods):
            params["before"] = 1
            params["pay_platform"] = payPlatform
            params["goods"] = goods
            break
        case .morePayAfterCheck(let order):
            params["check"] = 1
            bodyDic = order
            break
        case .moreVipHomeGet:
            params["home"] = 1
            break
        case .moreVipListGet(let page):
            params["list"] = 1
            params["page"] = page
            break
        case .moreCoinHomeGet:
            params["home"] = 1
            break
            // case .moreCoinAdd(let coin):
            //     bodyDic = coin
        //     break
        case .moreCoinListGet(let page):
            params["list"] = 1
            params["page"] = page
            break
        case .moreSignDateGet(let year, let month):
            params["date"] = 1
            params["year"] = year
            params["month"] = month
            break
        case .moreSignAdd:
            break
        case .moreMatchPeriodListGet(let kind, let page):
            params["list"] = 1
            params["kind"] = kind
            params["page"] = page
            break
        case .moreMatchWorkAdd(let matchWork):
            bodyDic = matchWork
            break
        case .moreMatchWorkDel(let mwid):
            params["mwid"] = mwid
            break
        case .moreMatchWorkListGet(let mpid, let order, let page):
            params["mpid"] = mpid
            params["order"] = order
            params["page"] = page
            break
        case .moreMatchWorkOurListGet(let kind, let page):
            params["our"] = 1
            params["kind"] = kind
            params["page"] = page
            break
        case .moreMatchReportAdd(let matchReport):
            bodyDic = matchReport
            break
        case .moreMatchPointAdd(let matchPoint):
            bodyDic = matchPoint
            break
        case .moreMatchCoinAdd(let matchCoin):
            bodyDic = matchCoin
            break
        }
        // 返回请求
        if bodyDic == nil {
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        } else {
            return .requestCompositeData(bodyData: jsonToData(bodyDic), urlParameters: params)
        }
    }
    
    // 测试
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    // 字典转Data
    private func jsonToData(_ jsonDic: Dictionary<String, Any>?) -> Data {
        if jsonDic == nil || !JSONSerialization.isValidJSONObject(jsonDic!) {
            LogUtils.w(tag: "api", method: "jsonToData", "不合法的json")
            return Data()
        }
        // 利用自带的json库转换成Data
        // 如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
        let data = try? JSONSerialization.data(withJSONObject: jsonDic!, options: [])
        // Data转换成String打印输出
        //        let str = String(data:data!, encoding: String.Encoding.utf8)
        //        LogUtils.i("Json Str:\(str!)")
        return data!
    }
    
}

