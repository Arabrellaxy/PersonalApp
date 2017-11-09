//
//  DayCollectionView.swift
//  Eat
//
//  Created by 谢艳 on 2017/11/2.
//  Copyright © 2017年 谢艳. All rights reserved.
//

import UIKit

class DayCollectionView: UICollectionView,UICollectionViewDataSource {
    override func awakeFromNib() {
        self.dataSource = self
        self.collectionViewLayout = DayCollectionViewFlowLayout.init()
        self.isPagingEnabled = true
        self.allowsMultipleSelection = false
    }
    
    private(set) public var  daysNode:NSArray?
    private(set) public var  startDate:Date?

    override func didMoveToSuperview() {
        let yearNode:XYYearNode = XYYearNode.init(year: ProjectHelper.shareInstance.currentYear())
        self.daysNode = yearNode.daysNode
        self.startDate = (self.daysNode![0] as! XYDayNode).date
        self.reloadData()
    }
    
    // MARK: UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.daysNode?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:DayCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! DayCollectionViewCell
        let dayNode:XYDayNode? = self.daysNode?[indexPath.row] as? XYDayNode
        cell.dayLabel.text =  dayNode != nil ? String.init(format: "%d", (dayNode?.day)!) : ""
        cell.day = dayNode
        return cell
    }
    
    func updateLayoutForBounds(bounds:CGRect)  {
        (self.collectionViewLayout as! DayCollectionViewFlowLayout).updateLayoutForBounds(bounds: bounds)
    }
}

class DayCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    override func awakeFromNib() {
        self.selectedBackgroundView = _SelectedBackgroundView.init()
    }
    override var isSelected: Bool {
        didSet {
            self.dayLabel.textColor = self.isSelected ? UIColor.white : UIColor.black
        }
    }
    var day:XYDayNode?
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

class _SelectedBackgroundView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        var circleRect = CGRect(x:0,y:0,width:31.0,height:31.0)
        circleRect.origin.x = (rect.size.width - circleRect.size.width) / 2
        circleRect.origin.y = (rect.size.height - circleRect.size.height) / 2
        let context :CGContext = UIGraphicsGetCurrentContext()!
        context.saveGState()
        context.addEllipse(in: circleRect)
        context.setFillColor(UIColor.orange.cgColor)
        context.fillPath()
        
        context.restoreGState()
        super.draw(rect)
    }
}

class DayCollectionViewFlowLayout: UICollectionViewFlowLayout {
    func updateLayoutForBounds(bounds:CGRect)  {
        self.itemSize = CGSize(width:bounds.size.width / 7, height:43.0);
    }
    override func prepare() {
        self.scrollDirection = UICollectionViewScrollDirection.horizontal
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}
