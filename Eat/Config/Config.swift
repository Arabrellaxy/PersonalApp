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

}

enum MealType {
    case breakFast
    case lunch
    case dinner
    
    static let allValues = [breakFast,lunch,dinner]
}
