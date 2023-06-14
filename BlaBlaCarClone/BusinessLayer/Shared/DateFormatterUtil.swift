//
//  DateFormatterUtility.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 07/06/23.
//

import Foundation

class DateFormatterUtil {
 
    static let shared = DateFormatterUtil()
    private init() {}
    
    func formatDate(date: Date, format: String = DateTimeFormat.yearMonthDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func datetimeFormat(dateTime: String, format: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateTimeFormat.dateTime
        
        let myTime = dateFormatter.date(from: dateTime)
        
        guard let time = myTime else {
            return ""
        }
        
        dateFormatter.dateFormat = format
        let tme = dateFormatter.string(from: time)
        return tme
    }
    
    func dateFromString(date: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        let myDate = dateFormatter.date(from: date)
        
        return myDate
    }
    
    /// To calculate age( in years) of user from dob
    /// - Parameter dob: String, format of date which is changed into Date format inside function
    /// - Returns: Int, age in years
    func calculateAge(dob: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateTimeFormat.yearMonthDate
        
        guard let date = dateFormatter.date(from: dob) else {
            return 0
        }
        
        var years = 0
        var months = 0
        
        let cal = Calendar.current
        years = cal.component(.year, from: Date()) - cal.component(.year, from: date)
        
        let currMonth = cal.component(.month, from: Date())
        let birthMonth = cal.component(.month, from: date)
        
        // get difference between current month and birthMonth
        months = currMonth - birthMonth
        
        // if month difference is in negative then reduce years by one
        if months < 0 {
            years -= 1
            
        } else if months == 0 && cal.component(.day, from: Date()) < cal.component(.day, from: date) {
            // if month difference is 0 but present date < date of birth reduce year by 1
            years -= 1
        }
        
        return years
    }
}
