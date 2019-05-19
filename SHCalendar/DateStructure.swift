//
//  DateStructure.swift
//  SHCalendar
//
//  Created by 임수현 on 19/05/2019.
//  Copyright © 2019 limsuhyun. All rights reserved.
//

import Foundation

let cal = Calendar.current
let todayYear = cal.component(.year, from: Date())
let todayMonth = cal.component(.month, from: Date()) - 1
let today = cal.component(.day, from: Date())

var year = todayYear
var month = todayMonth
var isYoon = getMonthInfo(year: year, month: month).isYoonYear
var startDay = getMonthInfo(year: year, month: month).startDay

struct MonthInfo {
    let isYoonYear: Bool
    let startDay: Days
}

enum Days: Int {
    case SUN = 0
    case MON
    case TUE
    case WED
    case THU
    case FRI
    case SAT
}

func getMonthInfo (year: Int, month: Int) -> MonthInfo {
    let months: [Int] = [31,28,31,30,31,30,31,31,30,31,30,31]
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
