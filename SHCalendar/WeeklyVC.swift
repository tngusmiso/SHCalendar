//
//  WeaklyVC.swift
//  SHCalendar
//
//  Created by 임수현 on 19/05/2019.
//  Copyright © 2019 limsuhyun. All rights reserved.
//

import UIKit

class WeeklyVC: UIViewController {
    let cellidentifier = "weaklyCell"
    var weekInfo: WeekInfo?

    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var weeklyCalendarView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weekInfo = WeekInfo(startDate: getFirstDay(), endDate: getLastDay())
        
        let nibName = UINib(nibName: "WeeklyTableViewCell", bundle: nil)
        weeklyCalendarView.register(nibName, forCellReuseIdentifier: cellidentifier)
        setLabels()
    }
    
    func setLabels(){
        yearLabel.text = "\(weekInfo!.endDate.year)"
        weekLabel.text = "\(weekInfo!.startDate.month+1).\(weekInfo!.startDate.date) ~ \(weekInfo!.endDate.month+1).\(weekInfo!.endDate.date)."
    }
    
    func getFirstDay() -> DateInfo {
        var year: Int = today.year
        var month: Int = today.month
        var date: Int = today.date
        
        if today.date - 1 < today.day.rawValue { // 저번 달 포함
            if today.month == 0  {  // 저번 해 포함
                year -= 1
                month = 11
                date += 31 - today.day.rawValue
            } else {
                month -= 1
                date += months[today.month-1] - today.day.rawValue
                if today.month == 2 && today.isYoon {   // 운달 포함
                    date += 1
        }}}
        else {
            date -= today.day.rawValue
        }
        return DateInfo(year: year, month: month, date: date)
    }
    
    func getLastDay() -> DateInfo {
        var year: Int = today.year
        var month: Int = today.month
        var date: Int = today.date
        
        if today.date + (6-today.day.rawValue) > months[today.month] {
            if today.month == 11 {
                year += 1
                month = 0
                date += (6 - today.day.rawValue) - 31
            } else if today.month == 1 && today.isYoon {
                month += 1
                date += (6 - today.day.rawValue) - 29
            } else {
                month += 1
                date += (6 - today.day.rawValue) - months[today.month]
            }
        } else {
            date += 6 - today.day.rawValue
        }
        
        return DateInfo(year: year, month: month, date: date)
    }

    func findWeekBefore(info: DateInfo) -> DateInfo {
        var year: Int = info.year
        var month: Int = info.month
        var date: Int = info.date
        
        if date < 8 {
            if month == 0 {
                year -= 1
                month = 11
                date -= 7 - 31
            } else if month == 2 && info.isYoon {
                month -= 1
                date -= 7 - 29
            } else {
                month -= 1
                date -= 7 - months[month]
            }
        } else {
            date -= 7
        }
        return DateInfo(year: year, month: month, date: date)
    }
    
    func findWeekNext(info: DateInfo) -> DateInfo {
        var year: Int = info.year
        var month: Int = info.month
        var date: Int = info.date
        
        if date + 7 > months[month] {
            if month == 11 {
                year += 1
                month = 0
                date += 7 - 31
            } else if month == 1 && info.isYoon {
                if date+7 > 29 {
                    month += 1
                    date += 7 - 29
                } else {
                    date += 7
                }
            } else {
                month += 1
                date += 7 - months[month-1]
            }
        } else {
            date += 7
        }
        return DateInfo(year: year, month: month, date: date)
    }
    
    @IBAction func backWeek(_ sender: Any) {
        weekInfo = WeekInfo(
            startDate: findWeekBefore(info: weekInfo?.startDate ?? DateInfo(year: 0, month: 0, date: 0)),
            endDate: findWeekBefore(info: weekInfo?.endDate ?? DateInfo(year: 0, month: 0, date: 0)))
        setLabels()
    }
    
    @IBAction func nextWeek(_ sender: Any) {
        weekInfo = WeekInfo(
            startDate: findWeekNext(info: weekInfo?.startDate ?? DateInfo(year: 0, month: 0, date: 0)),
            endDate: findWeekNext(info: weekInfo?.endDate ?? DateInfo(year: 0, month: 0, date: 0)))
        setLabels()
        
    }
    
}

extension WeeklyVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WeeklyTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellidentifier, for: indexPath) as! WeeklyTableViewCell
        
        switch indexPath.section {
        case 0:
            cell.dateLabel.text = "05.06."
            cell.contentLabel.text = "내용"
        default:
            break
        }
        
        return cell
    }
    
    
}
