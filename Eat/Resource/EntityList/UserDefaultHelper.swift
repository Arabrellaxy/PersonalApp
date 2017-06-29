//
//  UserDefaultHelper.swift
//  Eat
//
//  Created by 谢艳 on 2017/6/29.
//  Copyright © 2017年 谢艳. All rights reserved.
//

import Foundation

final class UserDefaultHelper {
    static let shareInstance = UserDefaultHelper()

    var firstTimeLaunch : Bool {
        get {
            let firstTime  = UserDefaults.standard.value(forKey: AppConfigConstants.firstTimeLaunch)
            
            return firstTime != nil ? false : true
        }
        set(newValue) {
           UserDefaults.standard.set(newValue, forKey: AppConfigConstants.firstTimeLaunch)
        }
    }
    
}
