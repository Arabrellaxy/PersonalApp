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
        return UIColor.init(colorLiteralRed: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
}
