//
//  XYYearNode.swift
//  Eat
//
//  Created by 谢艳 on 2017/11/2.
//  Copyright © 2017年 谢艳. All rights reserved.
//

import UIKit

class XYYearNode: NSObject {
    public private(set) var year: NSInteger = 0
    public private(set) var monthsNode: NSArray?
    public private(set) var daysNode: NSArray?
    public private(set) var dayCount: NSInteger = 0
    public private(set) var weekdayOfFirstDay: NSInteger = 0

    init(year:NSInteger) {
        super.init()
        self.year = year
        weekdayOfFirstDay = ProjectHelper.shareInstance.weekDayOfDate(date: ProjectHelper.shareInstance.date(year: year, month: 1, day: 1)) - 1
        
        let tempMonths :NSMutableArray = NSMutableArray.init(capacity: 12)
        let tempDays: NSMutableArray = NSMutableArray.init(capacity: 365)
        
        for i in 0 ... 12 {
            let weekDayOfFirstDayOfMonth = (weekdayOfFirstDay + dayCount) % 7
            let monthNode:XYMonthNode = XYMonthNode.init(year: year, month: i+1, weekDayOffirstDay: weekDayOfFirstDayOfMonth)
            
            tempMonths.add(monthNode)
            tempDays.addObjects(from: monthNode.dayNodes as! [Any])
            
            dayCount += monthNode.dayCount
        }
        
        monthsNode = tempMonths
        daysNode = tempDays
    }
}
