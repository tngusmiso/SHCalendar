//
//  AddScheduleTaskCreator.swift
//  SHCalendar
//
//  Created by 임수현 on 20/05/2019.
//  Copyright © 2019 limsuhyun. All rights reserved.
//

import Foundation
import FMDB

struct AddScheduleTaskCreator {
    
    private let fileURL = try! FileManager.default
        .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent("mySchedule.sqlite")
    
    func addSchedule(date: DateInfo, content: String) -> Bool {
        let database = FMDatabase(url: fileURL)
        guard database.open() else {
            print("Unable to open database")
            return false
        }
        
        do {
            // 테이블 생성
            try database.executeUpdate("CREATE TABLE IF NOT EXISTS SCHEDULE(year int, month int, day int, content text)", values: nil)
            
            // insert
            insert(data: Schedule(date: date, content: content), db: database)
            
            database.close()
            return true
        } catch {
            print("create failed: \(error.localizedDescription)")
        }
        database.close()
        return false
    }
    
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
            repo = select(data: date, db: database)
            database.close()
            return repo
        } catch {
            print("create failed: \(error.localizedDescription)")
        }
        database.close()
        return []
    }
    
    private func insert(data: Schedule, db: FMDatabase){
        let insertSQL = "INSERT INTO SCHEDULE (year, month, day, content) VALUES (\'\(data.date.year)\',\'\(data.date.month)\',\'\(data.date.date)\',\'\(data.content)\')"
        let result = db.executeUpdate(insertSQL, withArgumentsIn: [])
        
        if !result {
            print("insert failed")
        } else {
            print("insert success: [\(data.date.year).\(data.date.month).\(data.date.date): \(data.content)]")
        }
    }
    
    
    private func select(data: DateInfo, db: FMDatabase) -> [Schedule]{
        do {
            var repo: [Schedule] = []
//            let selectSQL = "SELECT content FROM SCHEDULE"
            let selectSQL = "SELECT content FROM SCHEDULE WHERE year = '\(data.year)' AND month = '\(data.month)'AND day = '\(data.date)'"
            let rs = try db.executeQuery(selectSQL, values: [])
            while rs.next() {
                if let c = rs.string(forColumn: "content") {
                    print("[\(data.year).\(data.month+1).\(data.date): \(c)]")
                    repo.append(Schedule(date: DateInfo(year: data.year, month: data.month, date: data.date), content: c))
                }
            }
            return repo
        } catch {
            print("select failed: \(error.localizedDescription)")
        }
        return []
        
    }
    
}
