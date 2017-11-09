//
//  XYMonthNode.swift
//  Eat
//
//  Created by 谢艳 on 2017/11/2.
//  Copyright © 2017年 谢艳. All rights reserved.
//

import UIKit

class XYMonthNode: NSObject {
    public private(set) var month: NSInteger = 0
    public private(set) var weekDayOffirstDay: NSInteger = 0
    public private(set) var dayCount: NSInteger = 0
    public private(set) var dayNodes: NSArray?

    init(year:NSInteger, month:NSInteger, weekDayOffirstDay:NSInteger) {
        self.month = month
        self.weekDayOffirstDay = weekDayOffirstDay
        self.dayCount = ProjectHelper.shareInstance.numberOfDays(year: year, month: month)
        
        let tempDayNodeArray = NSMutableArray.init(capacity: dayCount)
        
        for index in 0..<dayCount {
            let dayNode:XYDayNode = XYDayNode.init(year: year, month: month, day: index+1, weekDay: (weekDayOffirstDay + index % 7) % 7)
            tempDayNodeArray.add(dayNode)
        }
        dayNodes = tempDayNodeArray
    }
}
