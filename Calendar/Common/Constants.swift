//
//  Constants.swift
//
//  Created by Thirumal on 28/11/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import Foundation

struct Constants
{
    struct ViewControllerIdentifiers
    {
        static let EventDetailViewController : String = "eventDetail_VC"
    }
    
    struct StoryBoardIdentifiers
    {
        static let Main : String = "Main"
    }
    
    struct TableViewCellIdentifier
    {
        static let WeekTableViewCell : String = "weekTableViewCell"
    }
    
    struct CollectionViewCellIdentifier
    {
        static let MonthCollectionViewCell : String = "monthCollectionViewCell"
        static let DateCollectionViewCell : String = "dateCollectionViewCell"
    }
    
    struct SegueIdentifier
    {
        
    }
    
    struct Color
    {
        static let NavigetionRedColor = getUIColorForRGB(185, green: 11, blue: 30)
        static let GreenColor = getUIColorForRGB(26, green: 127, blue: 64)
    }
    
    struct UserDefaultsKey
    {
        
    }
    
    struct DateConstants
    {
        static let DateFormatFromServer : String = "yyyy-MM-dd H:m:ss"
        static let CommonDateFormat : String = "yyyy-MM-dd"
        static let CommonTimeZone : TimeZone = TimeZone.init(secondsFromGMT: 0)!
        static let MonthFormat : String = "MMM , yyyy"
    }
    
    struct ServiceApi
    {

    }
    
}

//MARK:- Enum

enum CalendarType : String
{
    case AllCalendar = "ALL"
    case Calendar1 = "CAL001"
    case Calendar2 = "CAL002"
}

