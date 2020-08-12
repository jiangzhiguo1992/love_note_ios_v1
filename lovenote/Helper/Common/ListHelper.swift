//
// Created by 蒋治国 on 2018-12-16.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation

class ListHelper {
    
    public static func findIndexByIdInList(list: [Any?]?, obj: Any?) -> Int {
        if list == nil || list!.count <= 0 {
            return -1
        }
        if obj == nil {
            return -1
        }
        if let baseObj = obj as? BaseObj {
            if baseObj.id == 0 {
                return -1
            }
            for (i, o) in list!.enumerated() {
                if o == nil {
                    continue
                }
                if let baseO = o as? BaseObj {
                    if baseO.id == baseObj.id {
                        return i
                    }
                }
            }
        }
        return -1
    }
    
    //    public static func removeObjInTable(tableView: UITableView?, list: inout [Any?]?, obj: Any?) {
    //        let index = ListHelper.findIndexByIdInList(list: list, obj: obj)
    //        if list == nil || list!.count <= index { return }
    //        list?.remove(at: index)
    //        tableView?.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    //    }
    //
    //    public static func refreshObjInTable(tableView: UITableView?, list: inout [Any?]?, obj: Any?) {
    //        let index = ListHelper.findIndexByIdInList(list: list, obj: obj)
    //        if list == nil || list!.count <= index { return }
    //        list?[index] = obj
    //        tableView?.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    //    }
    
    /**
     * **************************************suggest转换**************************************
     */
    public static func getSuggestInfo() -> SuggestInfo {
        let suggestInfo = SuggestInfo()
        // status
        let statusReplyNo = SuggestStatus()
        statusReplyNo.status = Suggest.STATUS_REPLY_NO
        statusReplyNo.show = StringUtils.getString("no_reply")
        suggestInfo.statusList.append(statusReplyNo)
        let statusReplyYes = SuggestStatus()
        statusReplyYes.status = Suggest.STATUS_REPLY_YES
        statusReplyYes.show = StringUtils.getString("already_reply")
        suggestInfo.statusList.append(statusReplyYes)
        let statusAcceptNo = SuggestStatus()
        statusAcceptNo.status = Suggest.STATUS_ACCEPT_NO
        statusAcceptNo.show = StringUtils.getString("no_accept")
        suggestInfo.statusList.append(statusAcceptNo)
        let statusAcceptYes = SuggestStatus()
        statusAcceptYes.status = Suggest.STATUS_ACCEPT_YES
        statusAcceptYes.show = StringUtils.getString("already_accept")
        suggestInfo.statusList.append(statusAcceptYes)
        let statusHandling = SuggestStatus()
        statusHandling.status = Suggest.STATUS_HANDLE_ING
        statusHandling.show = StringUtils.getString("handle_ing")
        suggestInfo.statusList.append(statusHandling)
        let statusHandleNo = SuggestStatus()
        statusHandleNo.status = Suggest.STATUS_HANDLE_OVER
        statusHandleNo.show = StringUtils.getString("handle_over")
        suggestInfo.statusList.append(statusHandleNo)
        // kind
        let kindError = SuggestKind()
        kindError.kind = Suggest.KIND_ERROR
        kindError.show = StringUtils.getString("program_error")
        suggestInfo.kindList.append(kindError)
        let kindFunc = SuggestKind()
        kindFunc.kind = Suggest.KIND_FUNCTION
        kindFunc.show = StringUtils.getString("function_add")
        suggestInfo.kindList.append(kindFunc)
        let kindOpt = SuggestKind()
        kindOpt.kind = Suggest.KIND_OPTIMIZE
        kindOpt.show = StringUtils.getString("experience_optimize")
        suggestInfo.kindList.append(kindOpt)
        let kindBug = SuggestKind()
        kindBug.kind = Suggest.KIND_DEBUNK
        kindBug.show = StringUtils.getString("just_debunk")
        suggestInfo.kindList.append(kindBug)
        return suggestInfo
    }
    
    public static func getSuggestStatusShow(status: Int) -> String {
        let info = getSuggestInfo()
        let statusList = info.statusList
        for suggestStatus in statusList {
            if suggestStatus.status == status {
                return suggestStatus.show
            }
        }
        return ""
    }
    
    public static func getSuggestKindShow(kind: Int) -> String {
        let info = getSuggestInfo()
        let kindList = info.kindList
        for suggestKind in kindList {
            if suggestKind.kind == kind {
                return suggestKind.show
            }
        }
        return ""
    }
    
    /**
     * **************************************travel转换**************************************
     */
    // place
    public static func getPlaceListByTravel(travelPlaceList: [TravelPlace]?, checkStatus: Bool) -> [TravelPlace] {
        var placeList = [TravelPlace]()
        if travelPlaceList == nil || travelPlaceList!.count <= 0 {
            return placeList
        }
        for travelPlace in travelPlaceList! {
            if checkStatus && travelPlace.isDelete() {
                continue
            }
            placeList.append(travelPlace)
        }
        return placeList
    }
    
    // album
    public static func getAlbumListByTravel(travelAlbumList: [TravelAlbum]?, checkStatus: Bool) -> [Album] {
        var albumList = [Album]()
        if travelAlbumList == nil || travelAlbumList!.count <= 0 {
            return albumList
        }
        for travelAlbum in travelAlbumList! {
            if travelAlbum.album == nil || travelAlbum.album!.id <= 0 {
                // 所有的album都是已经已存在的，必须有id
                continue
            }
            if checkStatus && travelAlbum.isDelete() {
                continue
            }
            albumList.append(travelAlbum.album!)
        }
        return albumList
    }
    
    // video
    public static func getVideoListByTravel(travelVideoList: [TravelVideo]?, checkStatus: Bool) -> [Video] {
        var videoList = [Video]()
        if travelVideoList == nil || travelVideoList!.count <= 0 {
            return videoList
        }
        for travelVideo in travelVideoList! {
            if travelVideo.video == nil || travelVideo.video!.id <= 0 {
                // 所有的video都是已经已存在的，必须有id
                continue
            }
            if checkStatus && travelVideo.isDelete() {
                continue
            }
            videoList.append(travelVideo.video!)
        }
        return videoList
    }
    
    // food
    public static func getFoodListByTravel(travelFoodList: [TravelFood]?, checkStatus: Bool) -> [Food] {
        var foodList = [Food]()
        if travelFoodList == nil || travelFoodList!.count <= 0 {
            return foodList
        }
        for travelFood in travelFoodList! {
            if travelFood.food == nil || travelFood.food!.id <= 0 {
                // 所有的food都是已经已存在的，必须有id
                continue
            }
            if checkStatus && travelFood.isDelete() {
                continue
            }
            foodList.append(travelFood.food!)
        }
        return foodList
    }
    
    // movie
    public static func getMovieListByTravel(travelMovieList: [TravelMovie]?, checkStatus: Bool) -> [Movie] {
        var movieList = [Movie]()
        if travelMovieList == nil || travelMovieList!.count <= 0 {
            return movieList
        }
        for travelMovie in travelMovieList! {
            if travelMovie.movie == nil || travelMovie.movie!.id <= 0 {
                // 所有的movie都是已经已存在的，必须有id
                continue
            }
            if checkStatus && travelMovie.isDelete() {
                continue
            }
            movieList.append(travelMovie.movie!)
        }
        return movieList
    }
    
    // diary
    public static func getDiaryListByTravel(travelDiaryList: [TravelDiary]?, checkStatus: Bool) -> [Diary] {
        var diaryList = [Diary]()
        if travelDiaryList == nil || travelDiaryList!.count <= 0 {
            return diaryList
        }
        for travelDiary in travelDiaryList! {
            if travelDiary.diary == nil || travelDiary.diary!.id <= 0 {
                // 所有的diary都是已经已存在的，必须有id
                continue
            }
            if checkStatus && travelDiary.isDelete() {
                continue
            }
            diaryList.append(travelDiary.diary!)
        }
        return diaryList
    }
    
    /**
     * **************************************souvenir转换**************************************
     */
    // travel
    public static func getSouvenirTravelListByYear(souvenirTravelList: [SouvenirTravel]?, year: Int) -> [SouvenirTravel] {
        var returnList = [SouvenirTravel]()
        if souvenirTravelList == nil || souvenirTravelList!.count <= 0 {
            return returnList
        }
        for souvenirTravel in souvenirTravelList! {
            if year == souvenirTravel.year {
                returnList.append(souvenirTravel)
            }
        }
        return returnList
    }
    
    public static func getTravelListBySouvenir(souvenirTravelList: [SouvenirTravel]?, checkStatus: Bool) -> [Travel] {
        var travelList = [Travel]()
        if souvenirTravelList == nil || souvenirTravelList!.count <= 0 {
            return travelList
        }
        for souvenirTravel in souvenirTravelList! {
            if souvenirTravel.travel == nil || souvenirTravel.travel!.id <= 0 {
                // 所有的travel都是已经已存在的，必须有id
                continue
            }
            if checkStatus && souvenirTravel.isDelete() {
                continue
            }
            travelList.append(souvenirTravel.travel!)
        }
        return travelList
    }
    
    // gift
    public static func getSouvenirGiftListByYear(souvenirGiftList: [SouvenirGift]?, year: Int) -> [SouvenirGift] {
        var returnList = [SouvenirGift]()
        if souvenirGiftList == nil || souvenirGiftList!.count <= 0 {
            return returnList
        }
        for souvenirGift in souvenirGiftList! {
            if year == souvenirGift.year {
                returnList.append(souvenirGift)
            }
        }
        return returnList
    }
    
    public static func getGiftListBySouvenir(souvenirGiftList: [SouvenirGift]?, checkStatus: Bool) -> [Gift] {
        var giftList = [Gift]()
        if souvenirGiftList == nil || souvenirGiftList!.count <= 0 {
            return giftList
        }
        for souvenirGift in souvenirGiftList! {
            if souvenirGift.gift == nil || souvenirGift.gift!.id <= 0 {
                // 所有的gift都是已经已存在的，必须有id
                continue
            }
            if checkStatus && souvenirGift.isDelete() {
                continue
            }
            giftList.append(souvenirGift.gift!)
        }
        return giftList
    }
    
    // album
    public static func getSouvenirAlbumListByYear(souvenirAlbumList: [SouvenirAlbum]?, year: Int) -> [SouvenirAlbum] {
        var returnList = [SouvenirAlbum]()
        if souvenirAlbumList == nil || souvenirAlbumList!.count <= 0 {
            return returnList
        }
        for souvenirAlbum in souvenirAlbumList! {
            if year == souvenirAlbum.year {
                returnList.append(souvenirAlbum)
            }
        }
        return returnList
    }
    
    public static func getAlbumListBySouvenir(souvenirAlbumList: [SouvenirAlbum]?, checkStatus: Bool) -> [Album] {
        var albumList = [Album]()
        if souvenirAlbumList == nil || souvenirAlbumList!.count <= 0 {
            return albumList
        }
        for souvenirAlbum in souvenirAlbumList! {
            if souvenirAlbum.album == nil || souvenirAlbum.album!.id <= 0 {
                // 所有的album都是已经已存在的，必须有id
                continue
            }
            if checkStatus && souvenirAlbum.isDelete() {
                continue
            }
            albumList.append(souvenirAlbum.album!)
        }
        return albumList
    }
    
    // video
    public static func getSouvenirVideoListByYear(souvenirVideoList: [SouvenirVideo]?, year: Int) -> [SouvenirVideo] {
        var returnList = [SouvenirVideo]()
        if souvenirVideoList == nil || souvenirVideoList!.count <= 0 {
            return returnList
        }
        for souvenirVideo in souvenirVideoList! {
            if year == souvenirVideo.year {
                returnList.append(souvenirVideo)
            }
        }
        return returnList
    }
    
    public static func getVideoListBySouvenir(souvenirVideoList: [SouvenirVideo]?, checkStatus: Bool) -> [Video] {
        var videoList = [Video]()
        if souvenirVideoList == nil || souvenirVideoList!.count <= 0 {
            return videoList
        }
        for souvenirVideo in souvenirVideoList! {
            if souvenirVideo.video == nil || souvenirVideo.video!.id <= 0 {
                // 所有的video都是已经已存在的，必须有id
                continue
            }
            if checkStatus && souvenirVideo.isDelete() {
                continue
            }
            videoList.append(souvenirVideo.video!)
        }
        return videoList
    }
    
    // food
    public static func getSouvenirFoodListByYear(souvenirFoodList: [SouvenirFood]?, year: Int) -> [SouvenirFood] {
        var returnList = [SouvenirFood]()
        if souvenirFoodList == nil || souvenirFoodList!.count <= 0 {
            return returnList
        }
        for souvenirFood in souvenirFoodList! {
            if year == souvenirFood.year {
                returnList.append(souvenirFood)
            }
        }
        return returnList
    }
    
    public static func getFoodListBySouvenir(souvenirFoodList: [SouvenirFood]?, checkStatus: Bool) -> [Food] {
        var foodList = [Food]()
        if souvenirFoodList == nil || souvenirFoodList!.count <= 0 {
            return foodList
        }
        for souvenirFood in souvenirFoodList! {
            if souvenirFood.food == nil || souvenirFood.food!.id <= 0 {
                // 所有的food都是已经已存在的，必须有id
                continue
            }
            if checkStatus && souvenirFood.isDelete() {
                continue
            }
            foodList.append(souvenirFood.food!)
        }
        return foodList
    }
    
    // movie
    public static func getSouvenirMovieListByYear(souvenirMovieList: [SouvenirMovie]?, year: Int) -> [SouvenirMovie] {
        var returnList = [SouvenirMovie]()
        if souvenirMovieList == nil || souvenirMovieList!.count <= 0 {
            return returnList
        }
        for souvenirMovie in souvenirMovieList! {
            if year == souvenirMovie.year {
                returnList.append(souvenirMovie)
            }
        }
        return returnList
    }
    
    public static func getMovieListBySouvenir(souvenirMovieList: [SouvenirMovie]?, checkStatus: Bool) -> [Movie] {
        var movieList = [Movie]()
        if souvenirMovieList == nil || souvenirMovieList!.count <= 0 {
            return movieList
        }
        for souvenirMovie in souvenirMovieList! {
            if souvenirMovie.movie == nil || souvenirMovie.movie!.id <= 0 {
                // 所有的movie都是已经已存在的，必须有id
                continue
            }
            if checkStatus && souvenirMovie.isDelete() {
                continue
            }
            movieList.append(souvenirMovie.movie!)
        }
        return movieList
    }
    
    // diary
    public static func getSouvenirDiaryListByYear(souvenirDiaryList: [SouvenirDiary]?, year: Int) -> [SouvenirDiary] {
        var returnList = [SouvenirDiary]()
        if souvenirDiaryList == nil || souvenirDiaryList!.count <= 0 {
            return returnList
        }
        for souvenirDiary in souvenirDiaryList! {
            if year == souvenirDiary.year {
                returnList.append(souvenirDiary)
            }
        }
        return returnList
    }
    
    public static func getDiaryListBySouvenir(souvenirDiaryList: [SouvenirDiary]?, checkStatus: Bool) -> [Diary] {
        var diaryList = [Diary]()
        if souvenirDiaryList == nil || souvenirDiaryList!.count <= 0 {
            return diaryList
        }
        for souvenirDiary in souvenirDiaryList! {
            if souvenirDiary.diary == nil || souvenirDiary.diary!.id <= 0 {
                // 所有的diary都是已经已存在的，必须有id
                continue
            }
            if checkStatus && souvenirDiary.isDelete() {
                continue
            }
            diaryList.append(souvenirDiary.diary!)
        }
        return diaryList
    }
    
    /**
     * **************************************topic转换**************************************
     */
    public static func getPostKindInfoListEnable() -> [PostKindInfo] {
        var returnList = [PostKindInfo]()
        let kindList = TopicVC.getPostKindInfoList()
        if kindList.count <= 0 {
            return returnList
        }
        for kindInfo in kindList {
            if kindInfo.enable {
                var returnSubList = [PostSubKindInfo]()
                let subKindInfoList = kindInfo.postSubKindInfoList
                if subKindInfoList.count > 0 {
                    for subKindInfo in subKindInfoList {
                        if subKindInfo.enable {
                            returnSubList.append(subKindInfo)
                        }
                    }
                }
                kindInfo.postSubKindInfoList = returnSubList
                returnList.append(kindInfo)
            }
        }
        return returnList
    }
    
    public static func getPostSubKindInfoListPush(kindInfo: PostKindInfo?) -> [PostSubKindInfo] {
        var returnList = [PostSubKindInfo]()
        if kindInfo == nil || kindInfo!.postSubKindInfoList.count <= 0 {
            return returnList
        }
        let subKindInfoList = kindInfo!.postSubKindInfoList
        for subKindInfo in subKindInfoList {
            if subKindInfo.push {
                returnList.append(subKindInfo)
            }
        }
        return returnList
    }
    
    public static func getPostKindInfo(kind: Int) -> PostKindInfo? {
        let kindList = getPostKindInfoListEnable()
        if kindList.count <= 0 {
            return nil
        }
        for info in kindList {
            if info.kind == kind {
                return info
            }
        }
        return nil
    }
    
    public static func getPostSubKindInfo(kindInfo: PostKindInfo?, subKind: Int) -> PostSubKindInfo? {
        if kindInfo == nil || kindInfo!.postSubKindInfoList.count <= 0 {
            return nil
        }
        for info in kindInfo!.postSubKindInfoList {
            if info.kind == subKind {
                return info
            }
        }
        return nil
    }
    
    public static func getIndexInPostKindInfoListEnable(kind: Int) -> Int {
        let kindList = getPostKindInfoListEnable()
        if kindList.count <= 0 {
            return -1
        }
        for (index, info) in kindList.enumerated() {
            if info.kind == kind {
                return index
            }
        }
        return -1
    }
    
    public static func getIndexInPostSubKindInfoListPush(kindInfo: PostKindInfo?, subKind: Int) -> Int {
        let pushList = getPostSubKindInfoListPush(kindInfo: kindInfo)
        if pushList.count <= 0 {
            return -1
        }
        for (index, info) in pushList.enumerated() {
            if info.kind == subKind {
                return index
            }
        }
        return -1
    }
    
    public static func getPostKindInfoListEnableShow() -> [String] {
        var returnList = [String]()
        let kindList = getPostKindInfoListEnable()
        if kindList.count <= 0 {
            return returnList
        }
        for info in kindList {
            returnList.append(info.name)
        }
        return returnList
    }
    
    public static func getPostSubKindInfoListPushShow(kindInfo: PostKindInfo?) -> [String] {
        var returnList = [String]()
        let pushList = getPostSubKindInfoListPush(kindInfo: kindInfo)
        if pushList.count <= 0 {
            return returnList
        }
        for info in pushList {
            if info.push {
                returnList.append(info.name)
            }
        }
        return returnList
    }
    
    
}
