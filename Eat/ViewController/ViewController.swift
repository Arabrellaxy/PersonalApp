//
//  ViewController.swift
//  Eat
//
//  Created by 谢艳 on 2017/6/27.
//  Copyright © 2017年 谢艳. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var dayCollectionView: DayCollectionView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dayEventCollectionView: DayEventCollectionView!
    var todayNode:XYDayNode?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "😍我们的营养餐😍"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.backgroundColor = ProjectHelper.shareInstance.colorWithRGB(red: 248, green: 248, blue: 248, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        
        let weekdayOfFirstDay:NSInteger = ProjectHelper.shareInstance.weekDayOfDate(date: ProjectHelper.shareInstance.date(year: ProjectHelper.shareInstance.currentYear(), month: ProjectHelper.shareInstance.currentMonth(), day: 1)) - 1
        
        todayNode = XYDayNode.init(year: ProjectHelper.shareInstance.currentYear(),
                                   month: ProjectHelper.shareInstance.currentMonth(),
                                   day: ProjectHelper.shareInstance.currentDay(),
                                   weekDay:  (weekdayOfFirstDay + (ProjectHelper.shareInstance.currentDay()-1) % 7)%7)
        self.loadData()

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.shadowImage = nil
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func loadData() -> Void {
        dayCollectionView.updateLayoutForBounds(bounds: self.dayCollectionView.bounds)
        self.dayEventCollectionView.daysNode = dayCollectionView.daysNode
        self.dayCollectionView.reloadData()
        self.scrollDayCollectionViewToDay()
        self.selectDayInDayCollectionView()
        self.scrollDayEventCollectionView()
        self.loadDayLable()
    }
    
    func scrollDayCollectionViewToDay() -> Void {
        let layout:UICollectionViewFlowLayout = self.dayCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        var row:NSInteger = ProjectHelper.shareInstance.numberOfDays(startDate: dayCollectionView.startDate!, endDate: (todayNode?.date)!)!
        row = row - row % 7;
        dayCollectionView.contentOffset = CGPoint(x:CGFloat(row) * layout.itemSize.width,y: 0)
    }
    
    func selectDayInDayCollectionView() -> Void {
        let  row:NSInteger = ProjectHelper.shareInstance.numberOfDays(startDate: dayCollectionView.startDate!, endDate: (todayNode?.date)!)!
        let indexPath:IndexPath = IndexPath.init(row: row, section: 0)
        dayCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.centeredVertically)
    }
    
    func loadDayLable() -> Void {
        self.dayLabel.text = ProjectHelper.shareInstance.stringFromDate(date: (todayNode?.date)!, format: "EEEE yyyy年MM月dd日")
    }
    
    func scrollDayEventCollectionView() -> Void {
        dayEventCollectionView.scrollTo(day: todayNode!)
    }
    //    MARK:UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == dayCollectionView {
            return (dayCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        }
        return dayEventCollectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dayCollectionView {
            let cell:DayCollectionViewCell = collectionView.cellForItem(at: indexPath) as! DayCollectionViewCell
            self.todayNode = cell.day
            self.scrollDayEventCollectionView()
            self.loadDayLable()
        }
    }
    
    //  MARK:  UIScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == dayCollectionView {
            let layout:DayCollectionViewFlowLayout = dayCollectionView.collectionViewLayout as! DayCollectionViewFlowLayout
            let index = Int(dayCollectionView.contentOffset.x / layout.itemSize.width)
            let weekDayIndex = todayNode?.weekDay
            self.todayNode = dayCollectionView.daysNode?.object(at: Int(index+weekDayIndex!)) as? XYDayNode
            self.scrollDayEventCollectionView()
            self.selectDayInDayCollectionView()
            self.loadDayLable()
        } else if(scrollView == dayEventCollectionView){
            let index:NSInteger =  NSInteger(dayEventCollectionView.contentOffset.x / dayEventCollectionView.bounds.size.width)
            let day:XYDayNode = dayEventCollectionView.daysNode?.object(at: index) as! XYDayNode
            self.todayNode = day
            dayEventCollectionView.scrollTo(day: day)
            self.scrollDayCollectionViewToDay()
            self.selectDayInDayCollectionView()
            self.loadDayLable()

        }
    }
}

