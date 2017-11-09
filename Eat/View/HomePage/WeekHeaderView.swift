//
//  WeekHeaderView.swift
//  Eat
//
//  Created by 谢艳 on 2017/11/2.
//  Copyright © 2017年 谢艳. All rights reserved.
//

import UIKit
import Foundation
class WeekHeaderView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let dateFormatter:DateFormatter = DateFormatter.init()
        let weekDays:[NSString] = dateFormatter.veryShortWeekdaySymbols! as [NSString]
        
        for (index,element) in weekDays.enumerated() {
            var frame = self.frame
            frame.size.width = frame.size.width / CGFloat(weekDays.count)
            frame.origin.x = CGFloat(index) * frame.size.width
            
            let label = UILabel.init(frame: frame)
            label.backgroundColor = UIColor.clear
            label.textAlignment = NSTextAlignment.center
            label.font = UIFont.systemFont(ofSize: 10)
            label.text = element as String
            
            self.addSubview(label)
        }
    }
}
