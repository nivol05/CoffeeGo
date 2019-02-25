import Foundation

extension Date {
    
    var tomorrow: Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
}

func getCurrentDate() -> String{
    let today = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    return formatter.string(from: today)
}

func getTimeNow() -> String{
    let today = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "HH : mm"
    return formatter.string(from: today)
}

func getTomorrowDate() -> String{
    let tomorrow = Date().tomorrow!
    let formatter = DateFormatter()
    
    formatter.dateFormat = "dd.MM.yyyy"
    return formatter.string(from: tomorrow)
}

func getDate(dateString: String) -> Date{
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    return formatter.date(from: dateString)!
}

func compareMins(first: Int, second: Int) -> Int{
    if first > second{
        return 1
    } else if first < second{
        return -1
    } else {
        return 0
    }
}

func toMins(time : String) -> Int{
    let minsMas = time.components(separatedBy: " : ")
    let hours = Int(minsMas[0])
    let minutes = Int(minsMas[1])
    return hours! * 60 + minutes!
}

func isToday(date: String) -> Bool{
    let checkingDate = getDate(dateString: date)
    let today = getDate(dateString: getCurrentDate())
    return checkingDate == today
}

func isBeforeToday(date: String) -> Bool{
    let checkingDate = getDate(dateString: date)
    let today = getDate(dateString: getCurrentDate())
    return checkingDate <= today
}



func timeInRange(time: String, startRange: String, endRange: String) -> Bool{
    let mins = toMins(time: time)
    let start = toMins(time: startRange)
    let end = toMins(time: endRange)
    return compareMins(first: mins, second: start) == 1 && compareMins(first: mins, second: end) == -1
}

func getTime(minutes: Int) -> String{
    var hour = minutes / 60
    hour = hour % 24
    let mins = minutes % 60
    
    var orderTime = ""
    if hour < 10 {
        orderTime.append("0")
    }
    orderTime.append("\(hour) : ")
    if mins < 10 {
        orderTime.append("0")
    }
    orderTime.append("\(mins)")
    return orderTime
}


