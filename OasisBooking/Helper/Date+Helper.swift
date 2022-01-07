

import Foundation

extension NSCalendar {
    class func gregorianCalendar() -> NSCalendar {
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        return gregorian!
    }
    
    func defaultComponentsFromDate(date: Date) -> NSDateComponents {
        return self.components([.year, .quarter, .month, .weekOfYear, .weekday, .day, .hour, .minute], from: date) as NSDateComponents
    }
}

//let fullFormatDateStyle = "MMM dd,yyyy HH:mm 'AM IST' a ZZZZZ"
let fullFormatDateStyle = "MMM dd,yyyy HH:mm a 'IST (GMT +5.30 Hrs)'"
extension Date {
    
    /// Returns a DateComponent value with number of days away from a specified date
    var daysSinceNow: DateComponents {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "MMMM dd, yyyy"
        return Calendar.current.dateComponents([.day], from: self, to: now)
    }
    
    func daySuffix() -> String {
        let calendar = NSCalendar.current
        let dayOfMonth = calendar.component(.day, from: self)
        switch dayOfMonth {
        case 1: fallthrough
        case 21: fallthrough
        case 31: return "st"
        case 2: fallthrough
        case 22: return "nd"
        case 3: fallthrough
        case 23: return "rd"
        default: return "th"
        }
    }
    
    
    func dayOfMonth() -> Int {
        let calendar = NSCalendar.current
        let dayOfMonth = calendar.component(.day, from: self)
        return dayOfMonth
    }
    
    
    func dayOfTheWeek() -> Int {
        let calendar = Calendar.current
        return calendar.component(.weekday, from: self)
    }
    
    func dateToLowest15Minutes() -> Date {
        var dateComponents = NSCalendar.gregorianCalendar().components([.hour, .minute], from: self)
        dateComponents.minute = (dateComponents.minute! / 15) * 15
        dateComponents.second = 0
        let newDate = Calendar.current.date(from: dateComponents)
        return newDate!
    }
    
    static var lastDayOfYear: Date {
        var components = NSCalendar.current.dateComponents([.year], from: Date())
        components.month = 12
        components.day = 31
        return NSCalendar.current.date(from: components)!
    }
    
    func isSameDate(date: Date) -> Bool {
        if ComparisonResult.orderedSame == Calendar.current.compare(self, to: date, toGranularity: .day) {
            return true
        }
        return false
    }
    
    func getMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    
    func getDayName() -> String {
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: self)
        switch day {
        case 1:
            return "Monday"
        case 2:
            return "Tuesday"
        case 3:
            return "Wednesday"
        case 4:
            return "Thursday"
        case 5:
            return "Friday"
        case 6:
            return "Saturday"
        default:
            return "Sunday"
        }
    }
    
}

public struct DateHelper {
    private static var internalJSONDateFormatter: DateFormatter?
    private static var defaultDateFormatter: DateFormatter?
    
    static var customDateFormatter: DateFormatter {
        guard let formatter = defaultDateFormatter else {
            let formatter = DateFormatter()
            defaultDateFormatter = formatter
            return formatter
        }
        return formatter
    }
    
    static var jsonDateFormatter: DateFormatter {
        guard let formatter = internalJSONDateFormatter else {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            internalJSONDateFormatter = formatter
            return formatter
        }
        return formatter
    }
    
    public static func stringFromDate(date: Date, formatStyle: DateFormatter.Style) -> String {
        customDateFormatter.dateStyle = formatStyle
        let dateString = customDateFormatter.string(from: date)
        return dateString
    }
    
    public static func stringFromDate(date: Date, format: String) -> String {
        customDateFormatter.dateFormat = format
        let dateString = customDateFormatter.string(from: date)
        return dateString
    }
    
    public static func dateFromTimestampString(timeStampString: String) -> Date {
        if let timestamp = TimeInterval(timeStampString) {
            return Date(timeIntervalSince1970: timestamp)
        }
        return Date()
    }
    
    public static func dateFromString(dateString: String, format: String) -> Date? {
        customDateFormatter.dateFormat = format
        let date = customDateFormatter.date(from: dateString)
        return date
    }
    
    public static func defaultDisplayStringForDate(date: Date) -> String {
        let daySuffix = date.daySuffix()
        let calendar = NSCalendar.current
        let dayOfMonth = calendar.component(.day, from: date)
        if dayOfMonth >= 1 && dayOfMonth <= 9 {
            customDateFormatter.dateFormat = String(format:"MMMM d'%@'", daySuffix)
        } else {
            customDateFormatter.dateFormat = String(format:"MMMM dd'%@'", daySuffix)
        }
        return customDateFormatter.string(from: date)
    }
    
    public static func defaultDisplayStringForHomeDate(date: Date) -> String {
        let daySuffix = date.daySuffix()
        let calendar = NSCalendar.current
        customDateFormatter.dateFormat = String(format:"MMM dd yyyy")
        return customDateFormatter.string(from: date)
    }
    
    public static func defaultDisplayStringForMonthYear(date: Date) -> String {
        let daySuffix = date.daySuffix()
        let calendar = NSCalendar.current
        customDateFormatter.dateFormat = String(format:"MMM yyyy")
        return customDateFormatter.string(from: date)
    }
    
    
    public static func defaultDisplayStringDayMonth(date: Date) -> String {
        let daySuffix = date.daySuffix()
        let calendar = NSCalendar.current
        customDateFormatter.dateFormat = String(format:"d MMM")
        return customDateFormatter.string(from: date)
    }
    
    
    public static func defaultDisplayTime(date: Date) -> String {
        let daySuffix = date.daySuffix()
        let calendar = NSCalendar.current
        customDateFormatter.dateFormat = String(format:"HH:mm a")
        return customDateFormatter.string(from: date)
    }
    
    
    public static func timeAgoDisplayStringForDate(date: Date) -> String {
        let form = DateComponentsFormatter()
        form.maximumUnitCount = 3
        form.unitsStyle = .full
        form.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute]
        guard let timeString = form.string(from: date, to: Date()) else { return ""}
        
        if timeString.contains("year") {
            form.allowedUnits = [.year, .month, .weekOfMonth]
        } else if timeString.contains("month") {
            form.allowedUnits = [.month, .weekOfMonth, .day]
        } else if timeString.contains("week") {
            form.allowedUnits = [.weekOfMonth, .day, .hour]
        } else if timeString.contains("day") {
            form.allowedUnits = [.day, .hour]
        } else if timeString.contains("hour") {
            form.allowedUnits = [.hour, .minute]
        }
        
        let timeStamp = form.string(from: date, to: Date())?.replacingOccurrences(of: ",", with: "")
        return timeStamp ?? ""
    }
    
}

