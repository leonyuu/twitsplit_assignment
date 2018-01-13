//
//  Utils.swift
//  twitsplit
//
//  Created by Leon Yuu on 1/13/18.
//  Copyright © 2018 Leon Yuu. All rights reserved.
//

import UIKit

class Utils: NSObject {

    public static func getCurrentTime() -> Double{
        let date = Date.init()
        return date.timeIntervalSince1970 // Get Current Time Stamp from 1970
    }
    
    public static func convertTimefromTimeStamp(_ timeStamp:Double) -> String {
        
        // Get Current Date
        let currentDate = Date.init()
        
        // Get Date init from Time Stamp
        let date = Date.init(timeIntervalSince1970: timeStamp)
        
        // Make Date Formatter with 
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        
        let currentDateString = dateFormatter.string(from: currentDate)
        var dateString = dateFormatter.string(from: date)
        if (dateString == currentDateString) { // Same Date >> will Change to 'Today', if not will keep as ever
            dateString = "Today"
        }
        
        dateFormatter.dateFormat = "hh:mm a"
        let timeString = dateFormatter.string(from: date)
        
        return dateString + ", " + timeString
    }
    
}
