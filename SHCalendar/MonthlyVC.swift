//
//  ViewController.swift
//  SHCalendar
//
//  Created by 임수현 on 15/05/2019.
//  Copyright © 2019 limsuhyun. All rights reserved.
//

import UIKit

class MonthlyVC: UIViewController {
    let cellIdentifier: String = "datecell"
    var dates: [String] = []
    
    var year = today.year
    var month = today.month
    var date = today.date
    var monthInfo = getMonthInfo(year: today.year, month: today.month)
    
    var selectedCell: UICollectionViewCell?
    
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var calendarView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getThisMonthCal(year: today.year, month: today.month)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        calendarView.reloadData()
    }
    
    func getThisMonthCal(year: Int, month: Int) {
        startDay = getMonthInfo(year: year, month: month).startDay
        isYoon = getMonthInfo(year: year, month: month).isYoonYear
        monthYearLabel.text = "\(month+1), \(year)"
        calendarView.reloadData()
    }
    
    @IBAction func backMonth(_ sender: Any) {
        if month <= 0 { month = 11; year -= 1 }
        else { month -= 1 }
        
        getThisMonthCal(year: year, month: month)
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        if month >= 11 { month = 0; year += 1 }
        else { month += 1 }
        
        getThisMonthCal(year: year, month: month)
    }
}

extension MonthlyVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if month == 1 && isYoon{
            return 29 + startDay.rawValue
        }
        return months[month] + startDay.rawValue
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MonthlyCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MonthlyCollectionViewCell
        cell.backgroundColor = UIColor.clear
        
        if indexPath.item < startDay.rawValue{
            cell.dateLabel.text = ""
        } else {
            let date = indexPath.item - startDay.rawValue + 1
            cell.dateLabel.text = "\(date)"
            if year == today.year && month == today.month && date == today.date {
                selectedCell = cell
                selectedCell?.backgroundColor = UIColor.yellow
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell?.backgroundColor = UIColor.clear
        selectedCell = collectionView.cellForItem(at: indexPath)
        selectedCell?.backgroundColor = UIColor.yellow
    }
    
}

