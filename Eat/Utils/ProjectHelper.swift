//
//  ProjectHelper.swift
//  Eat
//
//  Created by 谢艳 on 2017/7/11.
//  Copyright © 2017年 谢艳. All rights reserved.
//

import Foundation
import UIKit
final class ProjectHelper {
    static let shareInstance = ProjectHelper()
    func colorWithRGB(red:Float, green:Float,blue:Float,alpha:Float) -> UIColor {
        return UIColor.init(red: CGFloat(red / 255), green: CGFloat(green / 255), blue: CGFloat(blue / 255), alpha: 1.0)
    }
    
    func weekDayOfDate(date:Date) -> NSInteger {
        let calendar = self.calendar()
        let dateComponet:DateComponents = calendar.components(NSCalendar.Unit.weekday, from: date as Date)
        
        return dateComponet.weekday!
    }
    
    func date(year:NSInteger,month:NSInteger,day:NSInteger) -> Date {
        let dateComponent:DateComponents = self.dateComponents(year: year, month: month, day: day)
        return self.calendar().date(from: dateComponent)!
    }
    func calendar() -> NSCalendar {
        return NSCalendar.init(identifier: NSCalendar.Identifier.gregorian)!
    }
    
    func dateComponents(year:NSInteger,month:NSInteger,day:NSInteger) -> DateComponents {
        var dateComponents:DateComponents = DateComponents.init()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return dateComponents
    }
    
    func numberOfDays(year:NSInteger, month:NSInteger) -> NSInteger {
        let dateComponent = self.dateComponents(year: year, month: month, day: 1)
        let calendar = self.calendar()
        
        let range = calendar.range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: calendar.date(from: dateComponent)!)
        
        return range.length
    }
    
    func currentYear() -> NSInteger {
        return self.calendar().component(NSCalendar.Unit.year, from: Date.init())
    }
    
    func currentMonth() -> NSInteger {
        return self.calendar().component(NSCalendar.Unit.month, from: Date.init())
    }

    func currentDay() -> NSInteger {
        return self.calendar().component(NSCalendar.Unit.day, from: Date.init())
    }
    
    func numberOfDays(startDate:Date ,endDate:Date) -> NSInteger? {
        var fromDate:Date? = nil
        var toDate:Date? = nil
        let calendar = self.calendar()
       
        fromDate = calendar.startOfDay(for: startDate)
        toDate = calendar.startOfDay(for: endDate)
        
        let components:DateComponents = calendar.components([.day], from: fromDate!, to: toDate!, options: NSCalendar.Options(rawValue: NSCalendar.Options.RawValue(0)))
        return components.day
    }

    func stringFromDate(date:Date, format:String) -> String {
        let formatter:DateFormatter = DateFormatter.init()
        formatter.formatterBehavior = DateFormatter.Behavior.behavior10_4
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func baseGrayColor() -> UIColor {
        return self.colorWithRGB(red: 248, green: 248, blue: 248, alpha: 1)
    }
    
    func startAndEndOfDate(date:Date) -> (Date,Date) {
        // Get today's beginning & end
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let dateFrom = calendar.startOfDay(for:date) // eg. 2016-10-10 00:00:00
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute],from: dateFrom)
        components.day! += 1
        let dateTo = calendar.date(from: components)! // eg. 2016-10-11 00:00:00
        
        return(dateFrom,dateTo)
    }
}
