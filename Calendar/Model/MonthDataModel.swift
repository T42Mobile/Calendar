//
//  MonthDataModel.swift
//  Calendar
//
//  Created by Thirumal on 11/01/17.
//  Copyright © 2017 Think42labs. All rights reserved.
//

import Foundation
import UIKit

struct MonthDataModel
{
    var monthName : String = ""
    var year : String = ""
    var monthIndex : Int = 0
    var listOfWeek : [WeekDataModel] = []
}

struct WeekDataModel
{
    var weekOfYear : Int = 0
    var listOfDate : [Date] = []
    var startDate : Date = Date()
    var endDate : Date = Date()
    var listOfButton : [EventButton] = []
    var buttonView : UIView = UIView()
    var displayDate : [NSAttributedString] = []
}

struct EventDetailModel
{
    var eventId : String = ""
    var startDateWithOutTime : Date = Date()
    var startDate : Date = Date()
    var endDate : Date = Date()
    var eventTitle : String = ""
    var calendarType : String = ""
}
