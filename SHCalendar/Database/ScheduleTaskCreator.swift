//
//  AddScheduleTaskCreator.swift
//  SHCalendar
//
//  Created by 임수현 on 20/05/2019.
//  Copyright © 2019 limsuhyun. All rights reserved.
//

import Foundation
import FMDB

struct ScheduleTaskCreator {
    
    private let fileURL = try! FileManager.default
        .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent("mySchedule.sqlite")
    
    
    func addSchedule(data: DateInfo, content: String) -> Bool {
        let database = FMDatabase(url: fileURL)
        guard database.open() else {
            print("Unable to open database")
            return false
        }
        
        do {
            // 테이블 생성
            try database.executeUpdate("CREATE TABLE IF NOT EXISTS SCHEDULE(year int, month int, day int, content text)", values: nil)
            
            // insert
            let insertSQL = "INSERT INTO SCHEDULE (year, month, day, content) VALUES (\'\(data.year)\',\'\(data.month)\',\'\(data.date)\',\'\(content)\')"
            let result = database.executeUpdate(insertSQL, withArgumentsIn: [])
            
            if !result {
                print("insert failed")
                database.close()
                return false
            } else {
                print("insert success: [\(data.year).\(data.month).\(data.date): \(content)]")
                database.close()
                return true
            }
            
        } catch {
            print("create failed: \(error.localizedDescription)")
        }
        database.close()
        return false
    }
    
    // MARK : 하루 일정
    func readSchedule(date: DateInfo) -> [Schedule]{
        var repo: [Schedule] = []
        let database = FMDatabase(url: fileURL)
        guard database.open() else {
            print("Unable to open database")
            return []
        }
        
        do {
            // 테이블 생성
            try database.executeUpdate("CREATE TABLE IF NOT EXISTS SCHEDULE(year int, month int, day int, content text)", values: nil)
            
            // select
            let selectSQL = "SELECT content FROM SCHEDULE WHERE year = '\(date.year)' AND month = '\(date.month)'AND day = '\(date.date)'"
            let rs = try database.executeQuery(selectSQL, values: [])
            while rs.next() {
                if let c = rs.string(forColumn: "content") {
                    print("[\(date.year).\(date.month+1).\(date.date): \(c)]")
                    repo.append(Schedule(date: DateInfo(year: date.year, month: date.month, date: date.date), content: c))
                }
            }
            database.close()
            return repo
        } catch {
            print("create failed: \(error.localizedDescription)")
        }
        database.close()
        return []
    }
    
    
    // MARK: 일주일 일정
    func readSchedule(weekData: WeekInfo) -> [Schedule] {
        var repo: [Schedule] = []
        let database = FMDatabase(url: fileURL)
        let dates: [DateInfo] = [
            weekData.startDate,
            weekData.startDate.getNextDate,
            weekData.startDate.getNextDate.getNextDate,
            weekData.startDate.getNextDate.getNextDate.getNextDate,
            weekData.endDate.getBackDate.getBackDate,
            weekData.endDate.getBackDate,
            weekData.endDate]
        
        guard database.open() else {
            print("Unable to open database")
            return []
        }
        
        do {
            // 테이블 생성
            try database.executeUpdate("CREATE TABLE IF NOT EXISTS SCHEDULE(year int, month int, day int, content text)", values: nil)
            
            
            // select
            for date in dates {
                let selectSQL = "SELECT content FROM SCHEDULE WHERE year = '\(date.year)' AND month = '\(date.month)'AND day = '\(date.date)'"
                
                let rs = try database.executeQuery(selectSQL, values: [])
                while rs.next() {
                    if let c = rs.string(forColumn: "content") {
                        print("[\(date.year).\(date.month+1).\(date.date): \(c)]")
                        repo.append(Schedule(date: DateInfo(year: date.year, month: date.month, date: date.date), content: c))
                    }
                }
            }
            
            database.close()
            return repo
        } catch {
            print("create failed: \(error.localizedDescription)")
        }
        database.close()
        return []
    }
    
    // MARK : 한달 일정
    func readSchedule(year: Int, month: Int) -> [String]{
        var repo: [String] = []
        let database = FMDatabase(url: fileURL)
        guard database.open() else {
            print("Unable to open database")
            return []
        }
        
        do {            
            // 테이블 생성
            try database.executeUpdate("CREATE TABLE IF NOT EXISTS SCHEDULE(year int, month int, day int, content text)", values: nil)
            
            // select
            let selectSQL = "SELECT day, content FROM SCHEDULE WHERE year = '\(year)' AND month = '\(month)'"
            let rs = try database.executeQuery(selectSQL, values: [])
            while rs.next() {
                if let d = rs.string(forColumn: "day"), let c = rs.string(forColumn: "content") {
                    print("[\(year).\(month+1).\(d): \(c)]")
                    repo.append(d)
                }
            }
            database.close()
            return repo
        } catch {
            print("create failed: \(error.localizedDescription)")
        }
        database.close()
        return []
    }
    
    
    
}
