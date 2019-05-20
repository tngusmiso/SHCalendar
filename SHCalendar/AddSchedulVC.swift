//
//  AddSchedultVC.swift
//  SHCalendar
//
//  Created by 임수현 on 19/05/2019.
//  Copyright © 2019 limsuhyun. All rights reserved.
//

import UIKit

class AddSchedulVC: UIViewController {

    var selectedDate: DateInfo = today
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(changed), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "작성 종료", message: "작성을 종료하시겠습니까? 작성 중이던 내용이 사라집니다.", preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let okAction: UIAlertAction = UIAlertAction(title: "확인", style: .destructive, handler: {
            (action) in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func okButton(_ sender: Any) {
        if textView.text.isEmpty {
            let alert: UIAlertController = UIAlertController(title: "일정 등록 실패", message: "내용이 없습니다.", preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
        
        if ScheduleTaskCreator().addSchedule(data: selectedDate, content: textView.text) {
            let alert: UIAlertController = UIAlertController(title: "일정 등록 성공", message: "일정을 등록하였습니다.", preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction(title: "확인", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }) 
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func changed(){
        // Generate the format.
        let yearFormatter: DateFormatter = DateFormatter()
        let monthFormatter: DateFormatter = DateFormatter()
        let dateFormatter: DateFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        monthFormatter.dateFormat = "M"
        dateFormatter.dateFormat = "d"
        
        guard let year: Int = Int(yearFormatter.string(from: datePicker.date)) else {return}
        guard let month: Int = Int(monthFormatter.string(from: datePicker.date)) else {return}
        guard let date: Int = Int(dateFormatter.string(from: datePicker.date)) else {return}
        
        // Obtain the date according to the format.
        selectedDate = DateInfo(year: year, month: month-1, date: date)
        print ("\(year).\(month).\(date)")
    
    }
}
