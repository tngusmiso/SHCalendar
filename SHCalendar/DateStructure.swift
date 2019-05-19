//
//  DateStructure.swift
//  SHCalendar
//
//  Created by 임수현 on 19/05/2019.
//  Copyright © 2019 limsuhyun. All rights reserved.
//

import Foundation


let months: [Int] = [31,28,31,30,31,30,31,31,30,31,30,31]

let cal = Calendar.current
let today = DateInfo(
    year: cal.component(.year, from: Date()),
    month: cal.component(.month, from: Date()) - 1,
    date: cal.component(.day, from: Date()))

var isYoon = getMonthInfo(year: today.year, month: today.month).isYoonYear
var startDay = getMonthInfo(year: today.year, month: today.month).startDay


struct MonthInfo {
    let isYoonYear: Bool
    let startDay: Days
}

struct WeekInfo {
    let startDate: DateInfo
    let endDate: DateInfo
}

struct DateInfo {
    let year: Int
    let month: Int
    let date: Int
    
    var day: Days {
        return getDay(year: year, month: month, date: date)
    }
    
    var isYoon: Bool {
        return (year % 4 == 0 && year % 100 != 0 ) || year % 400 == 0
    }
}

enum Days: Int {
    case SUN = 0
    case MON = 1
    case TUE
    case WED
    case THU
    case FRI
    case SAT
}

func getMonthInfo (year: Int, month: Int) -> MonthInfo {
    var isYoon: Bool = false
    var startDay: Days = .SUN
    
    var allday: Int
    
    if ( year % 4 == 0 && year % 100 != 0 ) || year % 400 == 0 {
        isYoon = true
    }
    
    // 작년까지 총 날짜 수
    allday = ((year-1) + (year-1)/4 - (year-1)/100 + (year-1)/400);
    // 지난달 까지 총 날짜 수
    for i in 0..<month {
        allday += months[i]
    }
    if isYoon && month > 1 {
        allday += 1
    }
    
    startDay = Days(rawValue: (allday + 1) % 7) ?? .SUN
    return MonthInfo(isYoonYear: isYoon, startDay: startDay)    
}

func getDay (year: Int, month: Int, date: Int) -> Days{
    let startDay = getMonthInfo(year: year ,month: month).startDay
    let value = (date % 7 + startDay.rawValue - 1) % 7
    return Days(rawValue: value)!
}
