//
//  FoodsExtension.swift
//  Eat
//
//  Created by 谢艳 on 2017/6/28.
//  Copyright © 2017年 谢艳. All rights reserved.
//

import Foundation

extension Foods {
    func foodFromDictionry(foodDic:Dictionary<String, Any>) -> Foods {
        let food : Foods = Foods()
        for (key,value) in foodDic {
            if key == "name" {
                food.name = (value as? String)!
                continue
            }
            if key == "minPrice" {
                food.minPrice = Double((value as? NSNumber)!)
                continue
            }
            if key == "maxPrice" {
                food.maxPrice = Double((value as? NSNumber)!)
                continue
            }
            if key == "selfMade" {
                food.selfMade = Int32((value as? String)!)!
                continue
            }
            
            if key == "mealsType" {
                food.mealsType = Int32((value as? String)!)!
                continue
            }
            
            if key == "taste" {
                food.taste =  Int32((value as? String)!)!
                continue
            }
            
            if key == "foodID" {
                food.foodID =  (value as? String)!
                continue
            }

        }
        return food
    }
    
    
}

