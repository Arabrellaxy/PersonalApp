//
//  DayEventCollectionView.swift
//  Eat
//
//  Created by 谢艳 on 2017/11/7.
//  Copyright © 2017年 谢艳. All rights reserved.
//

import UIKit

class DayEventCollectionView: UICollectionView,UICollectionViewDataSource {
     public var  daysNode:NSArray? {
        didSet{
           startDate = (daysNode?.object(at: 0) as! XYDayNode).date
        }
    }
    private(set) public var  startDate:Date?
    private(set) public var  dayEvents:NSMutableArray?
    var  today:XYDayNode?

    override func awakeFromNib() {
        self.dataSource = self
        self.isPagingEnabled = true
    }
    // MARK: UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (daysNode?.count) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:DayEventCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! DayEventCollectionViewCell
        cell.day = daysNode?.object(at: indexPath.row) as? XYDayNode
        return cell
    }
    //    MARK:public methods
    public func scrollTo(day:XYDayNode) -> Void {
        let index = self.daysNode?.index(of: day)
        let indexPath = IndexPath.init(item: index!, section: 0)
        self.reloadItems(at: [indexPath])
        self.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: true)
    }
}



class DayEventCollectionViewCell:UICollectionViewCell {
    var day:XYDayNode?{
        didSet{
                CoreDataManager.shareInstance.foodRecordsOfDay(date: (self.day?.date)!, completion: { (foodRecords) in
//                    if foodRecords?.count ?? 0 > 0 {
                    self.tableView.records = foodRecords
//                        }
                })
        }
    }
    @IBOutlet weak var tableView: DayEventTableView!
    
}
