//
//  TabbarController.swift
//  Eat
//
//  Created by 谢艳 on 2017/6/30.
//  Copyright © 2017年 谢艳. All rights reserved.
//

import Foundation
import UIKit

class TabbarController:UITabBarController {
    var chooseFoodVC:ChooseFoodTableViewController! = nil
    var chooseFoodVCShown:Bool = false
    var indicatorView:XYIndicatorView?
    
    override func awakeFromNib() {
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white], for: UIControlState.normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.orange], for: UIControlState.normal)
        self.view.backgroundColor = UIColor.white
        UIApplication.shared.applicationSupportsShakeToEdit = true
        self.becomeFirstResponder()
        
        var gesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(touchEvent))
        gesture.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(gesture)
        
        gesture = UISwipeGestureRecognizer.init(target: self, action: #selector(touchEvent))
        gesture.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(gesture)
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if chooseFoodVC == nil {
            chooseFoodVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChooseFoodTableViewController") as! ChooseFoodTableViewController
        }
    }
    override func motionCancelled(_ motion: UIEventSubtype, with event: UIEvent?) {
        
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if chooseFoodVCShown {
            self.removeChooseFoodVC()
        } else {
            self.showChooseFoodVC()
        }
    }
    
    func removeChooseFoodVC() -> Void {
        self.chooseFoodVC.view .removeFromSuperview()
        chooseFoodVCShown = false
        self.tabBar.isHidden = false
    }
    
    func showChooseFoodVC() -> Void {
        self.tabBar.isHidden = true
        chooseFoodVCShown = true
        if chooseFoodVC == nil {
            chooseFoodVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChooseFoodTableViewController") as! ChooseFoodTableViewController
            chooseFoodVC.searchBlock = { [weak self]
                (predicate:NSPredicate) -> Void  in
                guard let `self` = self else { return }
                self.removeChooseFoodVC()
                self.showAnimation()
                self.filterResultWithPredicate(predicate: predicate)
            }
        }
        self.chooseFoodVC.view.frame = CGRect.init(x: 0, y: self.view.frame.height+100, width:self.view.frame.width, height:self.view.frame.height-100)
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.chooseFoodVC.view.frame = CGRect.init(x: 0, y: self.view.frame.height-262-44+30, width:self.view.frame.width, height:262+44)
        }) { (bool ) in
            
        }
        self.view.addSubview(self.chooseFoodVC.view)
    }
    
    func touchEvent(gesture:UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.down {
            if chooseFoodVCShown {
                self.removeChooseFoodVC()
            }
        } else if (gesture.direction == UISwipeGestureRecognizerDirection.up){
            if chooseFoodVCShown == false {
                self.showChooseFoodVC()
            }
        }
    }
    
    func showAnimation() {
        let view:UIView = UIApplication.shared.keyWindow!
        if indicatorView == nil {
            indicatorView = XYIndicatorView.init(frame: view.frame, type: .pacman, color: nil)
        }
        view.addSubview(indicatorView!)
        indicatorView!.startAnimating()
    }
    func hideAnimation() {
        if (indicatorView != nil) && ((indicatorView?.superview) != nil) {
            indicatorView?.stopAnimating()
            indicatorView?.removeFromSuperview()
        }
    }
    
    private func filterResultWithPredicate(predicate:NSPredicate) {
        
        CoreDataManager.shareInstance.chooseFoodByPredicate(predicate: predicate) { (food) in
            DispatchQueue.main.async {
                self.hideAnimation()
                let tempFood = food ?? nil
                let message = food == nil ? "哦豁，啥都没得" : tempFood!.name
                let alertVC:UIAlertController = UIAlertController.init(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction:UIAlertAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
                let confirmAction:UIAlertAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler:{(action:UIAlertAction!) -> Void in
                    
                })
                let oneMoreAction:UIAlertAction = UIAlertAction.init(title: "再来一次", style: UIAlertActionStyle.default, handler:{(action:UIAlertAction!) -> Void in
                    self.showChooseFoodVC()
                })
                if food != nil {
                    print(food?.name ??  "hi")
                    alertVC.addAction(confirmAction)
                }
                alertVC.addAction(cancelAction)
                alertVC.addAction(oneMoreAction)

                self.present(alertVC, animated: true, completion: nil)
            }
            
        }
        
    }
}
