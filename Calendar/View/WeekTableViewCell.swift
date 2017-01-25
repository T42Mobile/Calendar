//
//  WeekTableViewCell.swift
//  Calendar
//
//  Created by Thirumal on 11/01/17.
//  Copyright © 2017 Think42labs. All rights reserved.
//

import UIKit

class WeekTableViewCell: UITableViewCell, UICollectionViewDelegate,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    //MARK:- Variable
    //MARK:-- Outlet
    @IBOutlet weak var dayCollectionView: UICollectionView!
    @IBOutlet weak var currentWeekBar: UIView!
    @IBOutlet weak var buttonView: UIView!
    
    //MARK:-- Class
    var weekDetail : WeekDataModel = WeekDataModel()
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Collection View Datasource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return weekDetail.displayDate.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionViewCellIdentifier.DateCollectionViewCell, for: indexPath) as! DateCollectionViewCell
        cell.dateLabel.attributedText = weekDetail.displayDate[indexPath.item]
        
        let weekDate = weekDetail.listOfDate[indexPath.item]
        
        if CalendarBL.shared.isGivenDateIsToday(date : weekDate)
        {
            cell.dateLabel.backgroundColor = getUIColorForRGB(240, green: 240, blue: 240)
        }
        else
        {
            cell.dateLabel.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
    //MARK:- Collection View flow layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.size.width / CGFloat( weekDetail.displayDate.count), height: collectionView.frame.size.height)
    }
    
    //MARK:- Functions
    
    func setWeekDetail(weekDetail : WeekDataModel)
    {
        self.weekDetail = weekDetail
        self.dayCollectionView.reloadData()
        
        if self.weekDetail.listOfDate.contains(CalendarBL.shared.getCurrentDate())
        {
            self.currentWeekBar.isHidden = false
        }
        else
        {
            self.currentWeekBar.isHidden = true
        }
        for view in self.buttonView.subviews
        {
            view.removeFromSuperview()
        }
        
        for button in weekDetail.listOfButton
        {
            self.buttonView.addSubview(button)
        }        
    }
}
