//
//  DateStructure.swift
//  SHCalendar
//
//  Created by 임수현 on 19/05/2019.
//  Copyright © 2019 limsuhyun. All rights reserved.
//

import Foundation

// MARK: - 전역변수
let months: [Int] = [31,28,31,30,31,30,31,31,30,31,30,31]   // 달마다 날짜 수
enum Days: Int {    // 요일
    case SUN = 0
    case MON = 1
    case TUE = 2
    case WED = 3
    case THU = 4
    case FRI = 5
    case SAT = 6
}

let cal = Calendar.current
let today = DateInfo(
    year: cal.component(.year, from: Date()),
    month: cal.component(.month, from: Date()) - 1,
    date: cal.component(.day, from: Date()))

var isYoon = getMonthInfo(year: today.year, month: today.month).isYoonYear
var startDay = getMonthInfo(year: today.year, month: today.month).startDay

// MARK: - 날짜 정보 구조체
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
    
    var getNextDate: DateInfo {
        var year = self.year
        var month = self.month
        var date = self.date
        var newInfo: DateInfo = DateInfo(year: year, month: month, date: date)
        
        if self.isYoon && month == 1 && date == 29 {
            newInfo = DateInfo(year: year+1, month: month+1, date: 1)
            return newInfo
        } else if date >= months[month] {
            if month == 12 {
                year += 1
                month = 0
                date = 1
            } else {
                month += 1
                date = 1
            }
            
        } else { date += 1 }
        
        newInfo = DateInfo(year: year, month: month, date: date)
        return newInfo
    }
    
    var getBackDate: DateInfo{
        var year = self.year
        var month = self.month
        var date = self.date
        
        if date <= 1 {
            if month <= 0 {
                year -= 1
                month = 11
                date = 31
            } else {
                month -= 1
                if month == 1 && self.isYoon {
                    date = 29
                } else { date = months[month] }
            }
        } else { date -= 1 }
        
        return DateInfo(year: year, month: month, date: date)
    }
}

// MARK: - 날짜 정보 가져오는 함수들
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


