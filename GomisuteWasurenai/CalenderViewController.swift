//
//  CalenderViewController.swift
//  GomisuteWasurenai
//
//  Created by yusukeyokota on 2023/12/07.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic

class CalenderViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    @IBOutlet weak var calendarView: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // デリゲートの設定
        self.calendarView.dataSource = self
        self.calendarView.delegate = self
        calendarView.register(FSCalendarCell.self, forCellReuseIdentifier: "CELL")
        self.calendarView.calendarWeekdayView.weekdayLabels[0].text = "日"
        self.calendarView.calendarWeekdayView.weekdayLabels[1].text = "月"
        self.calendarView.calendarWeekdayView.weekdayLabels[2].text = "火"
        self.calendarView.calendarWeekdayView.weekdayLabels[3].text = "水"
        self.calendarView.calendarWeekdayView.weekdayLabels[4].text = "木"
        self.calendarView.calendarWeekdayView.weekdayLabels[5].text = "金"
        self.calendarView.calendarWeekdayView.weekdayLabels[6].text = "土"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    // 祝日判定を行い結果を返すメソッド(True:祝日)
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)

        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)

        // CalculateCalendarLogic()：祝日判定のインスタンスの生成
        let holiday = CalculateCalendarLogic()

        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    // date型 -> 年月日をIntで取得
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }

    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }

    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする（祝日は赤色で表示する）
        if self.judgeHoliday(date){
            return UIColor.red
        }

        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {   //日曜日
            return UIColor.red
        }
        else if weekday == 7 {  //土曜日
            return UIColor.blue
        }
        return nil
    }
    
    // 曜日に画像を入れる
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let weekday = self.getWeekIdx(date)
        let dayOfMonth = Calendar.current.component(.day, from: date)
        
        if weekday == 2 {  // 月曜日
            // 土曜日に表示するイメージの名前を返す
            let perfect = UIImage(named: "PET_bottles")
            let Resize:CGSize = CGSize.init(width: 25, height: 25) // サイズ指定
            let perfectResize = perfect?.resize(size: Resize)
            return perfectResize
        }
        else if weekday == 3 { // 火曜日
                // 土曜日に表示するイメージの名前を返す
                let perfect = UIImage(named: "burnable_garbage")
                let Resize:CGSize = CGSize.init(width: 15, height: 15) // サイズ指定
                let perfectResize = perfect?.resize(size: Resize)
                return perfectResize
        }
        else if weekday == 4 && dayOfMonth >= 15 && dayOfMonth <= 21 { // 第3水曜日
                // 第3水曜日に表示するイメージの名前を返す
                return UIImage(named: "bulky_garbage")?.resize(size: CGSize(width: 27, height: 27))
        }
        else if weekday == 4 && dayOfMonth >= 22 && dayOfMonth <= 28 { // 第4水曜日
                // 第4水曜日に表示するイメージの名前を返す
                return UIImage(named: "Non-burnable_garbage")?.resize(size: CGSize(width: 27, height: 27))
        }
        else if weekday == 4 { // 水曜日
                // 土曜日に表示するイメージの名前を返す
                let perfect = UIImage(named: "battery")
                let Resize:CGSize = CGSize.init(width: 15, height: 15) // サイズ指定
                let perfectResize = perfect?.resize(size: Resize)
                return perfectResize
        }
        else if weekday == 6 { // 金曜日
                // 土曜日に表示するイメージの名前を返す
                let perfect = UIImage(named: "burnable_garbage")
                let Resize:CGSize = CGSize.init(width: 15, height: 15) // サイズ指定
                let perfectResize = perfect?.resize(size: Resize)
                return perfectResize
        }
        return nil
    }
    
    // 枠線をつける
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        _ = self.getWeekIdx(date)
            let cell = calendar.dequeueReusableCell(withIdentifier: "CELL", for: date, at: position)
//          cell.layer.cornerRadius = 8
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 0.4
            return cell
    }
    
}

extension UIImage {
    func resize(size _size: CGSize) -> UIImage? {
        let widthRatio = _size.width / size.width
        let heightRatio = _size.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio

        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0) // 変更
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
}
