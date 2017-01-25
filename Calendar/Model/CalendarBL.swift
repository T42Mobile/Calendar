//
//  CalendarBL.swift
//  Calendar
//
//  Created by Thirumal on 11/01/17.
//  Copyright © 2017 Think42labs. All rights reserved.
//

import UIKit

class CalendarBL: NSObject
{
    //MARK:- Variables
    
    var monthDataList : [MonthDataModel] = []
    var currentEventList : [EventDetailModel] = []
    var monthViewController : MonthViewController = MonthViewController()
    
    var totalEventList : [EventDetailModel] = []
    var eventList : [EventDetailModel] = []
    
    lazy var gregorian : Calendar =
        {
            var cal = Calendar(identifier: Calendar.Identifier.gregorian)
            cal.timeZone = TimeZone(secondsFromGMT: 0)!
            
            return cal
    }()
    
    let screenSize : CGSize =
        {
            return getMainScreenFrame().size
    }()
    
    public class var shared: CalendarBL
    {
        struct Static
        {
            static let instance: CalendarBL = CalendarBL()
        }
        return Static.instance
    }
    
    //MARK:- Public function
    
    func getListOfWeekfromYear(fromDate : Date, numberOfYears : Int)
    {
//        let originalString = "tel://+918760890398"
//        
////        if let string = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
////        {
//            if let url = URL(string: originalString)
//            {
//                print(url)
//            }
//            print(originalString)
////        }
        
        if let url = URL(string:"tel://+9187- 60890398"), UIApplication.shared.canOpenURL(url)
        {
            print(url)
            UIApplication.shared.openURL(url)
        }
        else
        {
            print("unable to call")
        }
        
        var firstDayOfStartMonth = self.gregorian.dateComponents( [.era, .year, .month], from: fromDate)
        firstDayOfStartMonth.day = 1
        var totalDateList : [Date] = []
        var monthFirstDateList : [Date] = []
        var monthLastDateList : [Date] = []
        
        if let startDateOfMonth = self.gregorian.date(from: firstDayOfStartMonth)
        {
            let components = self.gregorian.dateComponents([Calendar.Component.weekOfYear, Calendar.Component.yearForWeekOfYear], from: startDateOfMonth)
            
            if let weekDay = self.gregorian.date(from: components)
            {
                if let dateInterval = self.gregorian.dateComponents([Calendar.Component.day], from: weekDay, to: startDateOfMonth).day
                {
                    if dateInterval > 0
                    {
                        for week : Int in 0 ..< dateInterval
                        {
                            if let date = self.gregorian.date(byAdding: Calendar.Component.day, value: week, to: weekDay)
                            {
                                totalDateList.append(date)
                            }
                        }
                    }
                }
            }
            
            let totalMonth = (numberOfYears * 12)
            for index : Int in 0 ..< totalMonth
            {
                if let firstDay = self.gregorian.date(byAdding: Calendar.Component.month, value: index, to: startDateOfMonth)
                {
                    if let numberOfDay = self.gregorian.range(of: Calendar.Component.day, in: Calendar.Component.month, for: firstDay)
                    {
                        for dateIndex : Int in 0 ..< numberOfDay.count
                        {
                            if let date = self.gregorian.date(byAdding: Calendar.Component.day, value: dateIndex, to: firstDay)
                            {
                                totalDateList.append(date)
                            }
                        }
                    }
                    monthFirstDateList.append(firstDay)
                    monthLastDateList.append(totalDateList.last!)
                }
            }
            
            if let lastDate = totalDateList.last
            {
                let components = self.gregorian.dateComponents([Calendar.Component.weekOfYear, Calendar.Component.yearForWeekOfYear], from: lastDate)
                if let weekDay = self.gregorian.date(from: components)
                {
                    if let dateInterval = self.gregorian.dateComponents([Calendar.Component.day], from: weekDay, to: lastDate).day
                    {
                        if dateInterval < 6
                        {
                            for week : Int in 0 ..< 6 - dateInterval
                            {
                                if let date = self.gregorian.date(byAdding: Calendar.Component.day, value: (week + 1), to: lastDate)
                                {
                                    totalDateList.append(date)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        var weekList : [WeekDataModel] = []
        let totalWeek = totalDateList.count / 7
        for index : Int in 0 ..< totalWeek
        {
            var weekDataModel : WeekDataModel = WeekDataModel()
            let rangeStart = (7 * index)
            let dateList = Array(totalDateList[rangeStart ... (rangeStart + 6)])
            weekDataModel.listOfDate = dateList
            weekList.append(weekDataModel)
        }
        
        var monthList : [MonthDataModel] = []
        for index : Int in 0 ..< monthFirstDateList.count
        {
            let monthStartDate = monthFirstDateList[index]
            let startIndex = getIndexOfDate(weekList: weekList, containsDate: monthStartDate)
            let endIndex = getIndexOfDate(weekList: weekList, containsDate: monthLastDateList[index])
            var monthData : MonthDataModel = MonthDataModel()
            monthData.monthName = getMonthNameFromDate(date: monthStartDate)
            monthData.monthIndex = index
            monthData.listOfWeek =  getWeekDisplayDateList(weekList: Array(weekList[startIndex ... endIndex]), monthStartDate: monthStartDate)
            monthList.append(monthData)
        }
        self.monthDataList = monthList
    }
    
    func getWeekDisplayDateList(weekList : [WeekDataModel], monthStartDate : Date) -> [WeekDataModel]
    {
        let monthComponent = self.gregorian.dateComponents([Calendar.Component.month], from: monthStartDate).month!
        
        var newWeekList : [WeekDataModel] = []
        
        for weekDetail in weekList
        {
            var newWeekDetail = weekDetail
            var displayList : [NSAttributedString] = []
            let count = newWeekDetail.listOfDate.count
            for index : Int in 0  ..< count
            {
                let date = newWeekDetail.listOfDate[index]
                let components = self.gregorian.dateComponents([Calendar.Component.day, Calendar.Component.month], from: date)
                
                var alpha : CGFloat = 0.5
                if components.month == monthComponent
                {
                    alpha = 1.0
                }
                
                let textColor : UIColor!
                if index == 0
                {
                    textColor = getUIColorForRGB(255, green: 0, blue: 0, alpha: alpha)
                }
                else if index == count - 1
                {
                    textColor = getUIColorForRGB(0, green: 0, blue: 255, alpha: alpha)
                }
                else
                {
                    textColor = getUIColorForRGB(85, green: 85, blue: 85, alpha: alpha)
                }
                
                let attributedString = NSAttributedString(string: "\(components.day!)", attributes: [NSForegroundColorAttributeName: textColor , NSFontAttributeName: UIFont.systemFont(ofSize: 12)])
                displayList.append(attributedString)
            }
            newWeekDetail.displayDate = displayList
            newWeekList.append(newWeekDetail)
        }
        return newWeekList
    }
    
    func isGivenDateIsToday(date : Date) -> Bool
    {
        return self.gregorian.isDateInToday(date)
    }
    
    func getIndexOfDate(weekList : [WeekDataModel] , containsDate : Date) -> Int
    {
       let index = weekList.index { (obj1) -> Bool in
            return obj1.listOfDate.contains(containsDate)
        }
        return index!
    }
    
    func getDateInCommonFormat(date : Date) -> Date
    {
        let components = self.gregorian.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day], from: date)
        
        if let currentDate = self.gregorian.date(from: components)
        {
            return currentDate
        }
        return date
    }
    
    func getCurrentDate() -> Date
    {
        let defaultDate = Date()
        let components = self.gregorian.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day], from: defaultDate)
        
        if let currentDate = self.gregorian.date(from: components)
        {
            return currentDate
        }
        return defaultDate
    }
    
    
    func getEventForCalendar(calendarType : CalendarType ) -> [EventDetailModel]
    {
        if calendarType == CalendarType.AllCalendar
        {
            return self.totalEventList
        }
        else if calendarType == CalendarType.Calendar1
        {
            return self.totalEventList.filter({ (eventDetail) -> Bool in
                eventDetail.calendarType == "CAL001"
            })
        }
        else if calendarType == CalendarType.Calendar2
        {
            return self.totalEventList.filter({ (eventDetail) -> Bool in
                eventDetail.calendarType == "CAL002"
            })
        }
        return []
    }
    
    func getEventDetailForId(eventId : String) -> [EventDetailModel]
    {
       return eventList.filter { (eventDetail) -> Bool in
            eventDetail.eventId == eventId
        }
    }
    
    func changeCurrentEventList(calendarType : CalendarType) -> [MonthDataModel]
    {
        self.currentEventList = getEventForCalendar(calendarType: calendarType)
        return updateEventToCalendarList(eventList: self.currentEventList)
    }
    
    func updateEventToCalendarList(eventList : [EventDetailModel]) -> [MonthDataModel]
    {
        var updateMonthList : [MonthDataModel] = []
        for var monthDetail in monthDataList
        {
            var updateWeekList : [WeekDataModel] = []
            
            for var weekDetail in monthDetail.listOfWeek
            {
                var buttonList : [EventButton] = []
                
                for index : Int in 0 ..< weekDetail.listOfDate.count
                {
                    let date = weekDetail.listOfDate[index]
                    let eventCurrentList = getEventInDate(eventDate: date, eventList : eventList)
                    let width = self.screenSize.width / 7.0
                    let height : CGFloat = 20.0
                    for eventIndex : Int in 0 ..< eventCurrentList.count
                    {
                        let eventDetail = eventCurrentList[eventIndex]
                        let originX = width * CGFloat(index)
                        let originY = height * CGFloat(eventIndex)
                        let buttonFrame = CGRect(x: originX , y: originY, width: width, height: height)
                        let eventButton = EventButton(frame: buttonFrame)
                        eventButton.setTitle(eventDetail.eventId, for: UIControlState.normal)
                        
                        
                        
                        eventButton.backgroundColor = UIColor.blue
                        eventButton.setTitleColor(UIColor.white, for: UIControlState.normal)
                        eventButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                        eventButton.eventDetail = eventDetail
                        eventButton.addTarget(monthViewController, action: #selector(monthViewController.eventClickedForButton(button:)), for: UIControlEvents.touchUpInside)
                        buttonList.append(eventButton)
                    }
                }
                weekDetail.listOfButton = buttonList
                updateWeekList.append(weekDetail)
            }
            monthDetail.listOfWeek = updateWeekList
            updateMonthList.append(monthDetail)
        }
        
        return updateMonthList
    }
    
    func getEventInDate(eventDate : Date , eventList : [EventDetailModel]) -> [EventDetailModel]
    {
        return eventList.filter { (eventModel) -> Bool in
            eventModel.startDateWithOutTime.compare(eventDate) == ComparisonResult.orderedSame
        }
    }
    
    func convertListOfEventFromDict(detailDict : NSDictionary)
    {
        var eventDetailList : [EventDetailModel] = []
        for (key,value) in detailDict
        {
            if let eventDict = (value as? NSDictionary)?.object(forKey: "events") as? NSDictionary
            {
                for eventId in eventDict.allKeys as! [String]
                {
                    var eventDetail = getEventDetailForId(eventId: eventId)[0]
                    eventDetail.calendarType = key as! String
                    eventDetailList.append(eventDetail)
                }
            }
        }
        self.totalEventList = eventDetailList
    }
    
    func convertListOfEventDetailIntoModel(detailDict : NSDictionary)
    {
        var eventDetailList : [EventDetailModel] = []
        for (key,value) in detailDict
        {
            let eventDetailDict = value as! NSDictionary
            let eventStartTime = eventDetailDict.object(forKey: "eventdtstart") as! String
            let eventStartDate = convertServerDateIntoDate(dateString: eventStartTime)
            var eventDetail = EventDetailModel()
            eventDetail.eventId = key as! String
            eventDetail.eventTitle = eventDetailDict.object(forKey: "description") as! String
            eventDetail.startDateWithOutTime = getDateInCommonFormat(date: eventStartDate)
            eventDetail.startDate = eventStartDate
            eventDetail.endDate = convertServerDateIntoDate(dateString: eventDetailDict.object(forKey: "eventdtend") as! String)
            eventDetailList.append(eventDetail)
        }
        
        self.eventList = eventDetailList
    }
    
    func convertServerDateIntoDate(dateString : String) -> Date
    {
        let dateFormat = getDateFormatterInFormat(formatString: Constants.DateConstants.DateFormatFromServer)
        
        let dateStringArray = dateString.replacingOccurrences(of: "T", with: " ").components(separatedBy: ".")
        let convertedDateString = dateStringArray[0]
        
        if let date = dateFormat.date(from: convertedDateString)
        {
            return date
        }
        return getCurrentDate()
    }
        
    func getDateFormatterInFormat(formatString : String) ->DateFormatter
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        dateFormatter.timeZone = Constants.DateConstants.CommonTimeZone
        return dateFormatter
    }
    
    func getMonthNameFromDate(date : Date) -> String
    {
        let dateFormat = getDateFormatterInFormat(formatString: Constants.DateConstants.MonthFormat)
        return dateFormat.string(from :date)
    }
    
    func getCurrentDateIndexPath() -> Int
    {
        let monthName = self.getMonthNameFromDate(date: Date())
        
        let filteredArray = self.monthDataList.filter { (monthDetail) -> Bool in
            monthDetail.monthName == monthName
        }
        return filteredArray[0].monthIndex
    }
}
