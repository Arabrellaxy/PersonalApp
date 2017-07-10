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
UITableViewController,UICollectionViewDelegate,UICollectionViewDataSource  {
    let tableViewDataSource:NSArray = [
        "口味",
        "类型",
        "自制"
    ]
    let collectionViewDataSource:NSArray = [
       FoodTaste.allValues,
       MealType.allValues,
       SelfMade.allValues
    ]

    override func awakeFromNib() {
        self.tableView.estimatedRowHeight = 60
        var frame:CGRect = CGRect.zero
        frame.size.height = 1
        self.tableView.tableHeaderView = UIView.init(frame: frame)
        let button : UIButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
        button.backgroundColor = UIColor.orange
        button.setTitle("🎲", for: UIControlState.normal)
        button.addTarget(self, action: #selector(startChooseFood), for: UIControlEvents.touchUpInside)
        self.tableView.tableFooterView = button
        self.tableView.isScrollEnabled = false
    }
    
    override func viewDidLoad() {
        
    }
    
//    Table View Delegate & DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewDataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ChooseFoodTableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as! ChooseFoodTableViewCell
        cell.collectionView.delegate = self;
        cell.collectionView.dataSource = self;
        if let layout = cell.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize.init(width: 60, height: 40)
            layout.sectionInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0)
            layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        }
        cell.collectionView.tag = indexPath.section;
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableViewDataSource.object(at: section) as? String
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if view.isKind(of: UITableViewHeaderFooterView.self) {
            (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.lightGray
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    //    Collection View Delegate & DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (collectionViewDataSource.object(at: collectionView.tag) as! NSArray).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ChooseFoodCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! ChooseFoodCollectionCell
        var title:String
        if collectionView.tag == 0 {
            let allTypes : [FoodTaste] = (collectionViewDataSource.object(at: collectionView.tag)) as! [FoodTaste]
            title = allTypes[indexPath.row].description
            
        } else if collectionView.tag == 1 {
            let allTypes : [MealType] = (collectionViewDataSource.object(at: collectionView.tag)) as! [MealType]
            title = allTypes[indexPath.row].description

        } else {
            let allTypes : [SelfMade] = (collectionViewDataSource.object(at: collectionView.tag)) as! [SelfMade]
            title = allTypes[indexPath.row].description
        }
        cell.optionButton.setTitle(title, for: UIControlState.normal)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func startChooseFood(sender:UIButton){
        
    }
    
}

class ChooseFoodCollectionCell: UICollectionViewCell {
    @IBOutlet weak var optionButton: UIButton!
    
    @IBAction func optionButtonClicked(_ sender: Any) {
        
    }
}

class ChooseFoodTableViewCell : UITableViewCell{
    
    @IBOutlet weak var collectionView: UICollectionView!
}
