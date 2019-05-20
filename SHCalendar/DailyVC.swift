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
        
        schedules = ScheduleTaskCreator().readSchedule(date: dateInfo)
        dailyCalendarView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        schedules = ScheduleTaskCreator().readSchedule(date: dateInfo)
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
        dateInfo = dateInfo.getBackDate
        setDateLabel()
        
        schedules = ScheduleTaskCreator().readSchedule(date: dateInfo)
        dailyCalendarView.reloadData()
    }
    
    @IBAction func nextDate(_ sender: Any) {
        dateInfo = dateInfo.getNextDate
        setDateLabel()
        
        schedules = ScheduleTaskCreator().readSchedule(date: dateInfo)
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
