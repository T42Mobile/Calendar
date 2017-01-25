//
//  MonthViewController.swift
//  Calendar
//
//  Created by Thirumal on 11/01/17.
//  Copyright © 2017 Think42labs. All rights reserved.
//

import UIKit

class MonthViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    //MARK:- Variables
    //MARK:-- Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var calendarSegmentControl: UISegmentedControl!
    @IBOutlet weak var monthLabel: UILabel!
    
    //MARK:-- Class
    
    var collectionViewDataList : [MonthDataModel] = []
    var currentEventList : [EventDetailModel] = []
    
    //MARK:- View life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.collectionViewDataList = CalendarBL.shared.monthDataList
        CalendarBL.shared.monthViewController = self
        self.calendarSegmentControl.selectedSegmentIndex = 0
        self.segmentControlValueChanged(self.calendarSegmentControl)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.getTotalEventList()
    }
    
    //MARK:- Collection View Datasource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return collectionViewDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionViewCellIdentifier.MonthCollectionViewCell, for: indexPath) as! MonthCollectionViewCell
        cell.setMonthDetail(monthDetail: collectionViewDataList[indexPath.item])
        
        return cell
    }
    
    //MARK:- Collection View flow layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return  collectionView.frame.size
        
    }
    
    //MARK:- EventButtonAction
    
    public func eventClickedForButton(button : EventButton)
    {        
        let main_SB = UIStoryboard(name: Constants.StoryBoardIdentifiers.Main, bundle: nil)        
        let eventDetail_VC = main_SB.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.EventDetailViewController) as! EventDetailViewController
        eventDetail_VC.eventDetail = button.eventDetail
        self.present(eventDetail_VC, animated: true, completion: nil)
    }
    
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl)
    {
        var calendarType : CalendarType = CalendarType.AllCalendar
        if calendarSegmentControl.selectedSegmentIndex == 1
        {
            calendarType = CalendarType.Calendar1
        }
        else if calendarSegmentControl.selectedSegmentIndex == 2
        {
            calendarType = CalendarType.Calendar2
        }
        
        self.collectionViewDataList = CalendarBL.shared.changeCurrentEventList(calendarType: calendarType)
        self.collectionView.reloadData()
        self.scrollViewDidScroll(self.collectionView)
    }
    
    func getListOfCalendar()
    {
        CustomActivityIndicator.shared.showProgressView()
        ServiceHelper.sharedInstance.getListOfCalendarEvent { (dict, error) -> Void in
            CustomActivityIndicator.shared.hideProgressView()
            if let dictionary = dict
            {
                CalendarBL.shared.convertListOfEventFromDict(detailDict: dictionary)
                self.segmentControlValueChanged(self.calendarSegmentControl)
            }
            else
            {
               _ = CustomAlertController.alert(title: "Alert", message: error!.localizedDescription)
            }
        }
    }
    
    func getTotalEventList()
    {
        CustomActivityIndicator.shared.showProgressView()
        ServiceHelper.sharedInstance.getListOfEvents { (dict, error) -> Void in
            CustomActivityIndicator.shared.hideProgressView()
            if let dictionary = dict
            {
                CalendarBL.shared.convertListOfEventDetailIntoModel(detailDict: dictionary)
                self.getListOfCalendar()
            }
            else
            {
                _ = CustomAlertController.alert(title: "Alert", message: error!.localizedDescription)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        self.setCurrentMonth()
    }
    
    func setCurrentMonth()
    {
        let collectionSize = self.collectionView.frame.size
        let centreX = self.collectionView.contentOffset.x + collectionSize.width / 2
        let centreY = collectionSize.height / 2
        let centrePoint = CGPoint(x: centreX, y: centreY)
        
        if let firstIndex = self.collectionView.indexPathForItem(at: centrePoint)
        {
            let monthDetail = collectionViewDataList[firstIndex.item]
            self.monthLabel.text = monthDetail.monthName
        }
    }
    
    func scrollToCurrentDate()
    {
        let currentMonthIndex = CalendarBL.shared.getCurrentDateIndexPath()
        self.collectionView.scrollToItem(at: IndexPath(item: currentMonthIndex, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        let monthDetail = collectionViewDataList[currentMonthIndex]
        self.monthLabel.text = monthDetail.monthName

    }
}
