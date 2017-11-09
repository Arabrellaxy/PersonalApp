//
//  DayEventTableView.swift
//  Eat
//
//  Created by 谢艳 on 2017/11/7.
//  Copyright © 2017年 谢艳. All rights reserved.
//

import UIKit

class DayEventTableView: UITableView,UITableViewDelegate,UITableViewDataSource {

    override func awakeFromNib() {
        self.dataSource = self
        self.delegate = self
        self.rowHeight = 100
    }
    var records:[FoodRecords]?{
        didSet{
            self.reloadData()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DayEventTableViewCell = tableView.dequeueReusableCell(withIdentifier: "eventtablecell", for: indexPath) as! DayEventTableViewCell
        let food:FoodRecords? = self.records?.filter({ (record:FoodRecords) -> Bool in
            return Int(record.mealType) == indexPath.row
        }).first
        cell.loadFood(foodRecord: food)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

class DayEventTableViewCell: UITableViewCell {
    @IBOutlet weak var bgView: DayEventTableViewCellBackgroundView!
    @IBOutlet weak var foodNameLabel: UILabel!
    override func awakeFromNib() {
        self.bgView.showDashedLine = true
    }
    
    func loadFood(foodRecord:FoodRecords?) -> Void {
        self.bgView.showDashedLine = foodRecord == nil ? true : false
        self.foodNameLabel.text = foodRecord?.food?.name
    }
}

class DayEventTableViewCellBackgroundView: UIView {
    var showDashedLine:Bool = false {
        didSet{
            guard self.layer.sublayers == nil else {
                for layer in self.layer.sublayers! {
                    layer.removeFromSuperlayer()
                }
                return
            }
            
            if !showDashedLine == true {
                self.setGradientBackground()
            }
            self.setNeedsDisplay()
        }
    }
    override func awakeFromNib() {
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    override func draw(_ rect: CGRect) {
        if showDashedLine {
            let yourViewBorder = CAShapeLayer()
            yourViewBorder.strokeColor = UIColor.black.cgColor
            yourViewBorder.lineDashPattern = [8, 8]
            yourViewBorder.frame = self.bounds
            yourViewBorder.fillColor = ProjectHelper.shareInstance.baseGrayColor().cgColor
            yourViewBorder.path = UIBezierPath(rect: self.bounds).cgPath
            self.layer.addSublayer(yourViewBorder)
        } else {
            super.draw(rect)
        }
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = self.bounds
        
        self.layer.addSublayer(gradientLayer)
    }
}
