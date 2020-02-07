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

// MARK: - Time

struct TM {
    var hour: Int
    var minute: Int
    var second: Int
    
    init(_ datePicker: UIDatePicker) {
        let dtStr = dateStr(datePicker)
        let time = parseTime(dtStr)
        
        self.hour = time.hour
        self.minute = time.minute
        self.second = time.second
    }
    
    init(_ hour: Int, _ minute: Int, _ second: Int) {
        self.hour = hour
        self.minute = minute
        self.second = second
    }
}

// MARK: - Date and Time

struct DTM {
    let year: Int
    let month: Int
    let day: Int
    let hour: Int
    let minute: Int
    let second: Int
    
    init(_ year: Int, _ month: Int, _ day: Int,
         _ hour: Int, _ minute: Int, _ second: Int) {
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = second
    }
    
    init(_ datePicker: UIDatePicker) {
        let dt = DT(datePicker)
        let tm = TM(datePicker)
        
        self.year = dt.year
        self.month = dt.month
        self.day = dt.day
        self.hour = tm.hour
        self.minute = tm.minute
        self.second = tm.second
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
    
    return DT(0, 0, 0)
}

private func parseTime(_ dateStr: String) -> TM {
    return TM(0, 0, 0)
}
