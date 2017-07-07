//
//  Config.swift
//  Eat
//
//  Created by 谢艳 on 2017/6/29.
//  Copyright © 2017年 谢艳. All rights reserved.
//

import Foundation

struct AppConfigConstants {
    static let storeName = "OurRecipes.sqlite"
    static let firstTimeLaunch = "firstTimeLaunch"
    static let externalResourceName = "Foods.plist"
}

enum FoodTaste {
    case light //清淡
    case hardcore //重口
    case normal //正常
    case nutrition //营养
    
    static let allValues = [light, hardcore, normal,nutrition]

    var description : String {
        get {
            switch(self) {
            case .light:
                return "清淡"
            case .hardcore:
                return "重口"
            case .normal:
                return "正常"
            case .nutrition:
                return "营养"
            }
        }
    }
}

enum MealType {
    case breakFast
    case lunch
    case dinner
    
    static let allValues = [breakFast,lunch,dinner]
    
    var description : String {
        get {
            switch(self) {
            case .breakFast:
                return "早餐"
            case .lunch:
                return "午餐"
            case .dinner:
                return "晚餐"
            }
        }
    }
}

enum SelfMade {
    case selfMade
    case buy
    
    static let allValues = [selfMade,buy]
    
    var description : String {
        get {
            switch(self) {
            case .selfMade:
                return "自制"
            case .buy:
                return "外出"
            }
        }
    }
}
