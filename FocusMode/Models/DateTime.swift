//
//  DateTime.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import UIKit


// MARK: - Date

struct DT {
    var year: Int
    var month: Int
    var day: Int
    
    init(_ year: Int, _ month: Int, _ day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }
    
    init(_ datePicker: UIDatePicker) {
        let dtStr = dateStr(datePicker)
        let date = parseDate(dtStr)
        
        self.year = date.year
        self.month = date.month
        self.day = date.day
    }
}

extension DT: Comparable {
    static func < (lhs: DT, rhs: DT) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        } else if lhs.month != rhs.month {
            return lhs.month < rhs.month
        } else {
            return lhs.day < rhs.day
        }
    }
}

// MARK: - Time

struct TM {
    var hour: Int
    var minute: Int
    var amPm: String
    
    init(_ datePicker: UIDatePicker) {
        let dtStr = dateStr(datePicker)
        let time = parseTime(dtStr)
        
        self.hour = time.hour
        self.minute = time.minute
        self.amPm = time.amPm
    }
    
    init(_ hour: Int, _ minute: Int, _ amPm: String) {
        self.hour = hour
        self.minute = minute
        self.amPm = amPm
    }
}

extension TM: Comparable {
    static func < (lhs: TM, rhs: TM) -> Bool {
        if lhs.amPm != rhs.amPm {
            return lhs.amPm == "AM"
        } else if lhs.hour != rhs.hour {
            return lhs.hour < rhs.hour
        } else {
            return lhs.minute < rhs.minute
        }
    }
}

// MARK: - Date and Time

struct DTM {
    let year: Int
    let month: Int
    let day: Int
    let hour: Int
    let minute: Int
    let amPm: String
    
    init(_ year: Int, _ month: Int, _ day: Int,
         _ hour: Int, _ minute: Int, _ amPm: String) {
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        self.amPm = amPm
    }
    
    init(_ datePicker: UIDatePicker) {
        let dt = DT(datePicker)
        let tm = TM(datePicker)
        
        self.year = dt.year
        self.month = dt.month
        self.day = dt.day
        self.hour = tm.hour
        self.minute = tm.minute
        self.amPm = tm.amPm
    }
}

extension DTM: Comparable {
    static func < (lhs: DTM, rhs: DTM) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        } else if lhs.month != rhs.month {
            return lhs.month < rhs.month
        } else if lhs.day != rhs.day {
            return lhs.day < rhs.day
        } else if lhs.amPm != rhs.amPm {
            return lhs.amPm == "AM"
        } else if lhs.hour != rhs.hour {
            return lhs.hour < rhs.hour
        } else {
            return lhs.minute < rhs.minute
        }
    }
}

// MARK: - Private Functions

private func dateStr(_ datePicker: UIDatePicker) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.short
    dateFormatter.timeStyle = DateFormatter.Style.short
    
    return dateFormatter.string(from: datePicker.date)
}

private func parseDate(_ dateStr: String) -> DT {
    var dateArr = dateStr.components(separatedBy: ",")
    dateArr = dateArr[0].components(separatedBy: "/")
    let month = Int(dateArr[0])!
    let day = Int(dateArr[1])!
    let year = Int(dateArr[2])!
    return DT(year, month, day)
}

private func parseTime(_ dateStr: String) -> TM {
    var timeArr = dateStr.components(separatedBy: " ")
    var amPm: String
    
    if timeArr.count == 3 {
        amPm = timeArr[2]
        timeArr = timeArr[1].components(separatedBy: ":")
    } else {
        amPm = timeArr[1]
        timeArr = timeArr[0].components(separatedBy: ":")
    }
    
    let minute = Int(timeArr[1])!
    let hour = Int(timeArr[0])!
    return TM(hour, minute, amPm)
}
