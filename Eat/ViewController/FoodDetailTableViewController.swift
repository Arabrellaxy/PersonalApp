//
//  FoodDetailTableViewController.swift
//  Eat
//
//  Created by 谢艳 on 2017/10/27.
//  Copyright © 2017年 谢艳. All rights reserved.
//

import UIKit

class FoodDetailTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var toolBar: UIToolbar!
    var food:Foods?
    var selectedType : Int32 = 0 //0 for breakfast,1 for lunch,2 for dinner
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = food?.name
        if food?.imagePath.count != 0 {
            self.foodImageView.image = FileHelper.shareInstance.imageWithPath(imageName: food!.imagePath)
        }
        let mealType:MealType = MealType(rawValue: Int(food!.mealsType))!
        var barButtonItems:[UIBarButtonItem]
        switch mealType {
        case .breakFast:
            let button:UIButton = UIButton.init(type: UIButtonType.custom)
            button.setTitle("早餐: ", for: UIControlState.normal)
            button.setTitleColor(UIColor.orange, for: UIControlState.normal)
            button.setImage(UIImage.init(named: "uncheck"), for: UIControlState.normal)
            button.setImage(UIImage.init(named: "check"), for: UIControlState.selected)
            button.sizeToFit()
            button.addTarget(self, action: #selector(chooseForBreakFast), for: UIControlEvents.touchUpInside)
            barButtonItems = [UIBarButtonItem.init(customView: button)]
            break
        case .lunch,.dinner:
            let tempArray:NSMutableArray = NSMutableArray.init()
            for  i in 0...1{
                let button:UIButton = UIButton.init(type: UIButtonType.custom)
                button.setTitle(i == 0 ? "午餐: " : "晚餐: ", for: UIControlState.normal)
                button.setTitleColor(UIColor.orange, for: UIControlState.normal)
                button.setImage(UIImage.init(named: "uncheck"), for: UIControlState.normal)
                button.setImage(UIImage.init(named: "check"), for: UIControlState.selected)
                button.sizeToFit()
                button.tag = i
                button.addTarget(self, action: #selector(chooseForDinner), for: UIControlEvents.touchUpInside)
                button.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
                tempArray.add(UIBarButtonItem.init(customView: button))
            }
            barButtonItems = tempArray as! [UIBarButtonItem]
            break
//        default:
//            break
        }
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil);
        let tempArray:NSMutableArray = NSMutableArray.init(array: barButtonItems)
        tempArray.add(flexibleSpace)
        
        let button:UIButton = UIButton.init(type: UIButtonType.custom)
        button.setTitle("确定", for: UIControlState.normal)
        button.frame = CGRect.init(x: 0, y: 0, width: self.toolBar.frame.size.width / 2 + 30, height: 44)
        button.backgroundColor = UIColor.orange
        button.addTarget(self, action: #selector(confirmChoice), for: UIControlEvents.touchUpInside)
        tempArray.add(UIBarButtonItem.init(customView: button))
        self.toolBar.items = (tempArray as! [UIBarButtonItem])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        containerHeightCons.constant = scrollView.contentInset.top;
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top);
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottomCons.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageViewHeightCons.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
    
    func chooseForBreakFast(button:UIButton) -> Void {
        button.isSelected = !button.isSelected
        selectedType = 0
    }
    func chooseForDinner(button:UIButton) -> Void {
        button.isSelected = !button.isSelected
        let tempTag = button.tag == 0 ? 1 : 0
        selectedType = button.tag == 0 ? 1 : 2
        let barItem :UIBarButtonItem =  self.toolBar.items![tempTag]
        let button:UIButton = barItem.customView as! UIButton
        button.isSelected = false
    }
    func confirmChoice(button:UIButton) -> Void {
        CoreDataManager.shareInstance.saveFoodForRecords(food: food!, mealsType: selectedType)
    }
}
