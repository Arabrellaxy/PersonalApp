//
//  ViewController.swift
//  Eat
//
//  Created by 谢艳 on 2017/6/27.
//  Copyright © 2017年 谢艳. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var chooseFoodVC:ChooseFoodTableViewController! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "😍我们的营养餐😍"
        UIApplication.shared.applicationSupportsShakeToEdit = true
        self.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if chooseFoodVC == nil {
          chooseFoodVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChooseFoodTableViewController") as! ChooseFoodTableViewController
        }
    }
    override func motionCancelled(_ motion: UIEventSubtype, with event: UIEvent?) {

    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        let tabbarVC:TabbarController = (UIApplication.shared.delegate as! AppDelegate).tabbar
        tabbarVC.tabBar.isHidden = true
        self.chooseFoodVC.view.frame = CGRect.init(x: 0, y: self.view.frame.height+100, width:self.view.frame.width, height:self.view.frame.height-100)
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.chooseFoodVC.view.frame = CGRect.init(x: 0, y: tabbarVC.view.frame.height-262-44+20, width:tabbarVC.view.frame.width, height:262+44)
        }) { (bool ) in
            
        }
        tabbarVC.view.addSubview(self.chooseFoodVC.view)
    }
}

