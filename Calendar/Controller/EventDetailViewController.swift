//
//  EventDetailViewController.swift
//  Calendar
//
//  Created by Thirumal on 13/01/17.
//  Copyright © 2017 Think42labs. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController , DraggableViewDelegate
{
    @IBOutlet weak var statusLabel: UILabel!
    
    var eventDetail : EventDetailModel = EventDetailModel()
    let cardHeight : CGFloat = 386
    let cardWidth : CGFloat = 290
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.statusLabel.isHidden = true
        self.createEventDetailView()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func createEventDetailView()
    {
//        let eventView = EventDetailView()
//        
//        let originX = (self.view.frame.width - cardWidth) / 2
//        let originY = (self.view.frame.height - cardHeight ) / 2
//        eventView.frame = CGRect(x: originX, y: originY, width: cardWidth, height: cardHeight)
//        eventView.backgroundColor = UIColor.gray
//        eventView.setDetail()
//        eventView.setEventDetail(eventDetail: self.eventDetail)
//        eventView.delegate = self
//        self.view.addSubview(eventView)
        
        let originX = (self.view.frame.width - cardWidth) / 2
        let originY = (self.view.frame.height - cardHeight ) / 2
        let draggableView = DraggableView(frame: CGRect(x: originX, y: originY, width: cardWidth, height: cardHeight))
        draggableView.information.text = self.eventDetail.eventTitle
        draggableView.delegate = self
        
        self.view.addSubview(draggableView)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func cardSwipedLeft(_ card: UIView!)
    {
        if self.eventDetail.calendarType == "CAL002"
        {
            CustomActivityIndicator.shared.showProgressView()
            ServiceHelper.sharedInstance.removeEventFromCalendar(eventId: self.eventDetail.eventId, calendarName: "CAL002", completionHandler: {(status, error) -> Void
                in
                CustomActivityIndicator.shared.hideProgressView()
                if let result = status
                {
                    if result
                    {
                        self.statusLabel.isHidden = false
                        self.statusLabel.text = self.eventDetail.eventTitle + "  Successfully removed from calendar"
                    }
                    else
                    {
                        self.setAlertLabelText(text:"Please try again later")
                    }
                }
                else
                {
                    self.setAlertLabelText(text:"Please try again later")
                }
                
            })
        }
        else
        {
            self.setAlertLabelText(text: self.eventDetail.eventTitle + " is in friends calendar.")
        }
    }
    
    func cardSwipedRight(_ card: UIView!)
    {
        if self.eventDetail.calendarType == "CAL001"
        {
            CustomActivityIndicator.shared.showProgressView()
            ServiceHelper.sharedInstance.addEventToCalendar(eventId: self.eventDetail.eventId, calendarName: "CAL002", completionHandler: {(status, error) -> Void
                in
                CustomActivityIndicator.shared.hideProgressView()
                if let result = status
                {
                    if result
                    {
                        self.statusLabel.isHidden = false
                        self.statusLabel.text = self.eventDetail.eventTitle + "  Successfully added to your calendar"
                    }
                    else
                    {
                        self.setAlertLabelText(text:"Please try again later")
                    }
                }
                else
                {
                    self.setAlertLabelText(text:"Please try again later")
                }
                
            })
        }
        else
        {
            self.setAlertLabelText(text: self.eventDetail.eventTitle + " is already in your calendar.")
        }
    }
    
    func setAlertLabelText(text : String)
    {
        self.statusLabel.isHidden = false
        self.statusLabel.text = text
    }
}
