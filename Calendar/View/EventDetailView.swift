//
//  EventDetailView.swift
//  Calendar
//
//  Created by Thirumal on 13/01/17.
//  Copyright © 2017 Think42labs. All rights reserved.
//

import UIKit

protocol EventSwipeDelegate
{
    func eventSwipedLeft()
    func eventSwipedRight()
}

class EventDetailView: UIView
{
    var delegate : EventSwipeDelegate?
    var pangesture : UIPanGestureRecognizer = UIPanGestureRecognizer()
    var eventTitleLabel : UILabel = UILabel()
    var originalPoint : CGPoint = CGPoint.zero
    let Action_Margin : CGFloat = 120
    let scale_Strength : CGFloat = 4
    let scale_Max : CGFloat = 0.93
    let Rotation_Max : CGFloat = 1.0
    let Rotation_Strength : CGFloat = 320.0
    let Rotation_Angle  = CGFloat(M_PI/8)
    var eventDetail : EventDetailModel = EventDetailModel()
    
    var xFromCentre : CGFloat = 0
    var yFromCentre : CGFloat = 0
    
    override func layoutSubviews()
    {
        
    }
    
    func setDetail()
    {
        pangesture = UIPanGestureRecognizer(target: self, action: #selector(EventDetailView.beingDragged(gesture:)))
        
        self.eventTitleLabel.frame = self.frame
        
        self.addSubview(self.eventTitleLabel)
        self.addGestureRecognizer(pangesture)
        self.layer.cornerRadius = 4
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    func beingDragged(gesture : UIPanGestureRecognizer)
    {
        xFromCentre = gesture.translation(in: self).x
        yFromCentre = gesture.translation(in: self).y
        
        switch (gesture.state) {
        case UIGestureRecognizerState.began:
            self.originalPoint = self.center
            break;
            
        case UIGestureRecognizerState.changed:
            
            let rotation_strength = min( xFromCentre / Rotation_Strength, Rotation_Max)
            let rotationAngel = Rotation_Angle * rotation_strength
            
            let fab = 1 - fabs(rotation_strength) / scale_Strength
            let scale = max(fab, scale_Max)
            
            self.center = CGPoint(x: self.originalPoint.x + xFromCentre, y: self.originalPoint.y + yFromCentre)
            let transform = CGAffineTransform(rotationAngle: rotationAngel)
            let scaleTransform = transform.scaledBy(x: scale, y: scale)
            self.transform = scaleTransform
            //self.updateOverLay(distance: <#T##CGFloat#>)
            
            break;
            
        case UIGestureRecognizerState.ended:
            self.afterSwipeAction()
            break;
            
        default:
            break;
        }
    }
    
    func setEventDetail(eventDetail : EventDetailModel)
    {
        self.eventTitleLabel.text = eventDetail.eventTitle
        self.eventDetail = eventDetail
    }
    
//    func updateOverLay(distance : CGFloat)
//    {
//        if distance > 0
//        {
//            
//        }
//        else
//        {
//            
//        }
//        
//        let fab = fabs(distance) / 100
//       // let alpha = min(fab, 0.4)
//        
//    }
    
    func afterSwipeAction()
    {
        if xFromCentre > Action_Margin
        {
            
        }
        else if xFromCentre < -Action_Margin
        {
            
        }
        else
        {
            UIView.animate(withDuration: 0.3, animations: { 
                self.center = self.originalPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
                //let alpha = 0
            })
        }
    }
    
    func rightAction()
    {
        let finishPoint = CGPoint(x: 500, y: (2 * yFromCentre + self.originalPoint.y ))
        UIView.animate(withDuration: 0.3, animations: {
            self.center = finishPoint
        }, completion: {
            (value: Bool) in
            self.removeFromSuperview()
        })
        self.delegate?.eventSwipedRight()
    }
    
    func leftAction()
    {
        let finishPoint = CGPoint(x: -500, y: (2 * yFromCentre + self.originalPoint.y ))
        UIView.animate(withDuration: 0.3, animations: {
            self.center = finishPoint
        }, completion: {
            (value: Bool) in
            self.removeFromSuperview()
        })
        self.delegate?.eventSwipedLeft()
    }
}
