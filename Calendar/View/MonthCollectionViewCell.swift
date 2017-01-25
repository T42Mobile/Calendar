//
//  MonthCollectionViewCell.swift
//  Calendar
//
//  Created by Thirumal on 11/01/17.
//  Copyright © 2017 Think42labs. All rights reserved.
//

import UIKit

class MonthCollectionViewCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate
{
    
    //MARK:- Variables
    //MARK:-- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:-- Class
    var monthDetail : MonthDataModel = MonthDataModel()
    
    //MARK:- Table view Data source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return monthDetail.listOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return self.tableView.frame.height / CGFloat(monthDetail.listOfWeek.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.WeekTableViewCell, for: indexPath) as! WeekTableViewCell
        cell.setWeekDetail(weekDetail: monthDetail.listOfWeek[indexPath.row])
        
        return cell
    }
    
    //MARK:- Functions
    
    func setMonthDetail(monthDetail : MonthDataModel)
    {
        self.monthDetail = monthDetail
        self.tableView.reloadData()
    }
}
