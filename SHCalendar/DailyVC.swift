//
//  DailyVC.swift
//  SHCalendar
//
//  Created by 임수현 on 19/05/2019.
//  Copyright © 2019 limsuhyun. All rights reserved.
//

import UIKit

class DailyVC: UIViewController {
    var dateInfo: DateInfo = today
    var schedules: [Schedule] = []
    
    let cellidentifier: String = "dailyCell"
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dailyCalendarView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "DailyTableViewCell", bundle: nil)
        dailyCalendarView.register(nibName, forCellReuseIdentifier: cellidentifier)
        
        setDateLabel()
        
        schedules = AddScheduleTaskCreator().readSchedule(date: dateInfo)
        dailyCalendarView.reloadData()
    }
    
    func setDateLabel(){
        var yoil:String = ""
        switch dateInfo.day {
        case .SUN: yoil = "일요일"
        case .MON: yoil = "월요일"
        case .TUE: yoil = "화요일"
        case .WED: yoil = "수요일"
        case .THU: yoil = "목요일"
        case .FRI: yoil = "금요일"
        case .SAT: yoil = "토요일"
        }
        
        dateLabel.text = "\(dateInfo.year)년 \(dateInfo.month+1)월 \(dateInfo.date)일 \(yoil) "
    }
    
    @IBAction func backDate(_ sender: Any) {
        var year = dateInfo.year
        var month = dateInfo.month
        var date = dateInfo.date
        
        if date <= 1 {
            if month <= 0 {
                year -= 1
                month = 11
                date = 31
            } else {
                month -= 1
                if month == 1 && dateInfo.isYoon {
                    date = 29
                } else { date = months[month] }
            }
        } else { date -= 1 }
        
        dateInfo = DateInfo(year: year, month: month, date: date)
        setDateLabel()
        
        schedules = AddScheduleTaskCreator().readSchedule(date: dateInfo)
        dailyCalendarView.reloadData()
    }
    
    @IBAction func nextDate(_ sender: Any) {
        var year = dateInfo.year
        var month = dateInfo.month
        var date = dateInfo.date
        
        if dateInfo.isYoon && month == 1 && date == 29 {
            dateInfo = DateInfo(year: year+1, month: month+1, date: 1)
            setDateLabel()
            return
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
        
        dateInfo = DateInfo(year: year, month: month, date: date)
        setDateLabel()
        
        schedules = AddScheduleTaskCreator().readSchedule(date: dateInfo)
        dailyCalendarView.reloadData()
    }
}

extension DailyVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DailyTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellidentifier, for: indexPath) as! DailyTableViewCell
        
        switch indexPath.section {
        case 0:
            cell.contentLabel.text = schedules[indexPath.row].content
        default:
            break
        }
        
        return cell
    }
    
    
}
