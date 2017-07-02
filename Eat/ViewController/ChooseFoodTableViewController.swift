//
//  ChooseFoodTableViewController.swift
//  Eat
//
//  Created by 谢艳 on 2017/6/30.
//  Copyright © 2017年 谢艳. All rights reserved.
//

import Foundation
import UIKit


class ChooseFoodTableViewController:
UITableViewController,ChooseFoodTableViewCellDelegate {
    let tableViewDataSource:NSArray = [
        "口味",
        "类型",
        "自制"
    ]
    let collectionViewDataSource:NSArray = [
       FoodTaste.allValues,
       MealType.allValues,
       [false,true]
    ]

    override func awakeFromNib() {
        self.tableView.estimatedRowHeight = 100
    }
    
    override func viewDidLoad() {
        
    }
    
    func numberOfItemsInCollectionView(cell: ChooseFoodTableViewCell) -> NSInteger {
        let index : NSInteger = (tableView.indexPath(for: cell)?.row)!
        return (self.collectionViewDataSource.object(at: index) as! NSArray).count
    }
    func itemAtIndexPath(cell: ChooseFoodTableViewCell,index:NSInteger) -> NSString {
        let index : NSInteger = (tableView.indexPath(for: cell)?.row)!
        return (self.collectionViewDataSource.object(at: index) as! NSArray).object(at: index) as! NSString
    }
    
//    Table View Delegate & DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewDataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ChooseFoodTableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! ChooseFoodTableViewCell
        cell.delegate = self
        return cell;
    }
    
    
}

class ChooseFoodCollectionCell: UICollectionViewCell {
    @IBOutlet weak var optionButton: UIButton!
    
    @IBAction func optionButtonClicked(_ sender: Any) {
    }
}

class ChooseFoodTableViewCell : UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var delegate: ChooseFoodTableViewCellDelegate?
    //    Collection View Delegate & DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return (delegate?.numberOfItemsInCollectionView(cell: self))!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ChooseFoodCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! ChooseFoodCollectionCell
        let title : NSString = (delegate?.itemAtIndexPath(cell: self, index: indexPath.row))!
            cell.optionButton.setTitle(title as String, for: UIControlState.normal)
        return cell
    }
}

protocol ChooseFoodTableViewCellDelegate {
    func numberOfItemsInCollectionView(cell:ChooseFoodTableViewCell) ->NSInteger
    func itemAtIndexPath(cell:ChooseFoodTableViewCell,index:NSInteger) ->NSString
}
