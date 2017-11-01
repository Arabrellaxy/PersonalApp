//
//  FileHelper.swift
//  Eat
//
//  Created by 谢艳 on 2017/10/19.
//  Copyright © 2017年 谢艳. All rights reserved.
//

import UIKit

class FileHelper: NSObject {
    static let shareInstance = FileHelper()

    func imageWithPath(imageName:String) -> UIImage? {
        let fullPath:String = self.fullPathWithString(lastPath: imageName)
        let image:UIImage = UIImage.init(contentsOfFile: fullPath)!
        return image
    }
    
    func saveImageToFile(image:UIImage) -> (Bool,String) {
        let imageData :Data = UIImagePNGRepresentation(image)!
        let imageUniqueName:String = NSUUID.init().uuidString
        var succeed = true
//        let fullURL:URL = URL.init(string: self.fullPathWithString(lastPath: imageUniqueName.appending(".png")))!
        let fullURL:URL = URL(fileURLWithPath:self.fullPathWithString(lastPath: imageUniqueName.appending(".png")))

        do {
            try imageData.write(to: fullURL, options: Data.WritingOptions(rawValue: 0))
        } catch  {
            succeed = false
            print(error)
        }
        return(succeed,imageUniqueName)
    }
    
    func fullPathWithString(lastPath:String) -> String {
        let url : URL =  FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last!
        return url.appendingPathComponent(lastPath).path
        
    }
   
    
    
    
}
