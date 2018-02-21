
import Foundation

extension Date {
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    var relativeTime: String {
        let now = Date()
        if now.years(from: self)   > 0 {
            return now.years(from: self).description  + " year"  + { return now.years(from: self)   > 1 ? "s" : "" }() + " ago"
        }
        if now.months(from: self)  > 0 {
            return now.months(from: self).description + " month" + { return now.months(from: self)  > 1 ? "s" : "" }() + " ago"
        }
        if now.weeks(from:self)   > 0 {
            return now.weeks(from: self).description  + " week"  + { return now.weeks(from: self)   > 1 ? "s" : "" }() + " ago"
        }
        if now.days(from: self)    > 0 {
            if now.days(from:self) == 1 { return "Yesterday" }
            return now.days(from: self).description + " days ago"
        }
        if now.hours(from: self)   > 0 {
            return "\(now.hours(from: self)) hour"     + { return now.hours(from: self)   > 1 ? "s" : "" }() + " ago"
        }
        if now.minutes(from: self) > 0 {
            return "\(now.minutes(from: self)) minute" + { return now.minutes(from: self) > 1 ? "s" : "" }() + " ago"
        }
        if now.seconds(from: self) > 0 {
            if now.seconds(from: self) < 15 { return "Just now"  }
            return "\(now.seconds(from: self)) second" + { return now.seconds(from: self) > 1 ? "s" : "" }() + " ago"
        }
        return ""
    }
    
    func getDaysInMonth() -> Int {
        let calendar = Calendar.current
        
        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        return numDays
    }
    
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    static func getStringFromDate(date: Date, withFormat format: String) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        return dateformatter.string(from: date)
    }
    
    static func getDateFromString(dateString: String, withFormat format: String) -> Date {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        return dateformatter.date(from: dateString)!
    }
    
    static func getTimeToAMPmFormat(timeString: String) -> String {
        let dateAsString = timeString
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: dateAsString)
        
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date!)
    }
    
    static func getTimeStampFromDate(date: Date) -> Double {
        return date.timeIntervalSince1970
    }
    
    static func getUTCStringFromDate(date: Date, withFormat format: String) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        dateformatter.timeZone = TimeZone(secondsFromGMT:0)
        return dateformatter.string(from: date)
    }
    
    static func getDateFromTimeStamp(timestamp: NSNumber) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(timestamp))
    }
    
    static func convertDateToStandardFormat(date: Date) -> String {
        // Day
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
        
        // Formate
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "MMM, yyyy"
        let newDate = dateFormate.string(from: date)
        
        var day  = "\(anchorComponents.day!)"
        switch day {
        case "1", "21", "31":
            day.append("st")
        case "2", "22":
            day.append("nd")
        case "3", "23":
            day.append("rd")
        default:
            day.append("th")
        }
        return day + " " + newDate
    }

    static func getUTCStringFromTimeStamp(timestamp: NSNumber, withFormat format: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return Date.getUTCStringFromDate(date: date, withFormat: format)
    }

    static func getRelativeTimeFrom(dateString: String, withFormat format: String) -> String {
        let dateString = dateString
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        let postDate: Date = dateformatter.date(from: dateString)!
        return postDate.relativeTime
    }
    
    static func getColonSeparatedTimeInHHMMFormat(timeInHHMMSSFormat: String) -> String {
        var fromTime = timeInHHMMSSFormat
        _ = fromTime.removeLast() // remove last 0
        _ = fromTime.removeLast() // remove last 0
        fromTime.insert(":", at: (fromTime.index(fromTime.startIndex, offsetBy: 2)))
        return fromTime
    }
}
