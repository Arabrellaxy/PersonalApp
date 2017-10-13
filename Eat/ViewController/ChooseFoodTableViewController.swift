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
    var selectButton :UIButton!
    
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
    var searchBlock:((NSPredicate)->Void)?
    
    override func awakeFromNib() {
        self.tableView.estimatedRowHeight = 60
        var frame:CGRect = CGRect.zero
        frame.size.height = 1
        self.tableView.tableHeaderView = UIView.init(frame: frame)
        selectButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
        selectButton.backgroundColor = UIColor.orange
        selectButton.setTitle("🎲", for: UIControlState.normal)
        selectButton.addTarget(self, action: #selector(startChooseFood), for: UIControlEvents.touchUpInside)
        self.tableView.tableFooterView = selectButton
        self.tableView.isScrollEnabled = false
        self.clearsSelectionOnViewWillAppear = true

    }
    
    override func viewDidLoad() {
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        cell.titleLabel.text = title
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func startChooseFood(sender:UIButton){
        
        let sections:Int = self.tableView.numberOfSections
        let result:NSMutableArray = NSMutableArray.init()
        for section in 0..<sections {
            let indexPath:IndexPath = IndexPath.init(row: 0, section: section)
            let cell:ChooseFoodTableViewCell = tableView.cellForRow(at: indexPath) as! ChooseFoodTableViewCell
            let collectionView:UICollectionView = cell.collectionView
            let array:[IndexPath]? = collectionView.indexPathsForSelectedItems
            if array?.isEmpty == false {
                if collectionView.tag == 0 {
                    let allTypes : [FoodTaste] = (collectionViewDataSource.object(at: collectionView.tag)) as! [FoodTaste]
                    result.add(allTypes[array![0].row].rawValue)
                } else if collectionView.tag == 1 {
                    let allTypes : [MealType] = (collectionViewDataSource.object(at: collectionView.tag)) as! [MealType]
                    result.add(allTypes[array![0].row].rawValue)
                } else {
                    let allTypes : [SelfMade] = (collectionViewDataSource.object(at: collectionView.tag)) as! [SelfMade]
                    result.add(allTypes[array![0].row].rawValue)
                }
            } else {
                return
            }
        }
        if result.count == tableViewDataSource.count {
            
            //start to choose food
            let predicate:NSPredicate = NSPredicate(format: "%K = %d", "taste", result[0] as! Int)
            let predicate1:NSPredicate = NSPredicate(format: "%K = %d", "mealsType", result[1] as! Int)
            let predicate2:NSPredicate = NSPredicate(format: "%K = %d", "selfMade", result[2] as! Int )
            let andPredicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: [predicate,predicate1,predicate2])
            
            searchBlock!(andPredicate)
        } else {
            
        }
    }
    
}

class ChooseFoodCollectionCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            if newValue {
                super.isSelected = true
                self.backgroundColor = ProjectHelper.shareInstance.colorWithRGB(red: 213, green: 213, blue: 213, alpha: 1.0)
                self.titleLabel.textColor = UIColor.white
                self.layer.cornerRadius = 10.0
                self.layer.masksToBounds = true
            } else if newValue == false {
                super.isSelected = false
                self.backgroundColor = UIColor.clear
                self.titleLabel.textColor = UIColor.lightGray
            }
        }
    }
    
}

class ChooseFoodTableViewCell : UITableViewCell{
    
    @IBOutlet weak var collectionView: UICollectionView!
}
