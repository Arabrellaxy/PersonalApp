//
//  MenuTableViewCell.swift
//  Eat
//
//  Created by 谢艳 on 2017/10/19.
//  Copyright © 2017年 谢艳. All rights reserved.
//

import UIKit

protocol MenuTableViewCellDelegate {
    func menuTableViewCell(cell:MenuTableViewCell, uploadImage:Any)
}

class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var minPriceLabel: UILabel!
    @IBOutlet weak var maxPriceLabel: UILabel!
    @IBOutlet weak var mealTypeLabel: UILabel!
    var delegate:MenuTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showFood(food:Foods) -> Void {
        if food.imagePath.count != 0 {
            self.foodImageView.image = FileHelper.shareInstance.imageWithPath(imageName: food.imagePath)
        }        
        foodNameLabel.text = food.name
        minPriceLabel.text = "\(food.minPrice)"
        maxPriceLabel.text = "\(food.maxPrice)"
        if let taste = FoodTaste(rawValue: Int(food.taste)) {
            mealTypeLabel.text = taste.description
        }
    }
    
    @IBAction func uploadMenuImage(_ sender: Any) {
       delegate?.menuTableViewCell(cell: self, uploadImage: sender)
    }
    
}

