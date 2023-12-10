//
//  HomeViewController.swift
//  GomisuteWasurenai
//
//  Created by yusukeyokota on 2023/12/07.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
       
    var dusts: [Dusts] = [] // ゴミの登録データ
    var dustsData: [DustsData] = [] // ゴミの種類データ
    var currentDate = Date()
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myDatePicker: UIDatePicker!
    @IBOutlet weak var dateLavel: UILabel!
    
    // 登録したゴミ
    @IBOutlet weak var entryTableView: UITableView!
    
    // テーブルの条件分岐
    var tag:Int = 0
    var cellIdentifier:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // migrationを実行
        let config = Realm.Configuration(schemaVersion: 2) // #1
        Realm.Configuration.defaultConfiguration = config // #2
        
        let realm = try! Realm()
        
        myDatePicker.datePickerMode = .date
        myDatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        myTableView.dataSource = self
        myTableView.delegate = self
        
        currentDate = Date()
        loadData(currentDate)
        
        entryTableView.dataSource = self
        entryTableView.delegate = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "(EEE)"
        let formattedDate = dateFormatter.string(from: currentDate)
        dateLavel.text = formattedDate
        
        // dustsで日付が一致するものだけを抽出
        dateFormatter.dateFormat = "yyyy/MM/dd(EEE)"
        let filterFormattedDate = dateFormatter.string(from: currentDate)
//        print("selectedDate:\(filterFormattedDate)")
//        print("dusts:\(dusts)")
        // もう一回全て取得
        dusts = Array(realm.objects(Dusts.self))
        let filteredData = dusts.filter { $0.dust_create == filterFormattedDate }
//        print("new---filteredData:\(filteredData)")
//        print("new---dusts:\(dusts)")
        dusts = Array(filteredData)
        entryTableView.reloadData()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // DatePickerの値を取得
        let selectedDate = myDatePicker.date
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "(EEE)"
        let formattedDate = dateFormatter.string(from: selectedDate)
        dateLavel.text = formattedDate
        // dustsで日付が一致するものだけを抽出
        dateFormatter.dateFormat = "yyyy/MM/dd(EEE)"
        let filterFormattedDate = dateFormatter.string(from: selectedDate)
//        print("selectedDate:\(filterFormattedDate)")
//        print("dusts:\(dusts)")
        // もう一回全て取得
        let realm = try! Realm()
        dusts = Array(realm.objects(Dusts.self))
        let filteredData = dusts.filter { $0.dust_create == filterFormattedDate }
//        print("filteredData:\(filteredData)")
        dusts = Array(filteredData)
        entryTableView.reloadData()
    }
    
    // 日付を変更した時のアクション
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        loadData(selectedDate)
        myTableView.reloadData()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "(EEE)"
        let formattedDate = dateFormatter.string(from: selectedDate)
        dateLavel.text = formattedDate
        // dustsで日付が一致するものだけを抽出
        dateFormatter.dateFormat = "yyyy/MM/dd(EEE)"
        let filterFormattedDate = dateFormatter.string(from: selectedDate)
//        print("selectedDate:\(filterFormattedDate)")
//        print("dusts:\(dusts)")
        // もう一回全て取得
        let realm = try! Realm()
        dusts = Array(realm.objects(Dusts.self))
        let filteredData = dusts.filter { $0.dust_create == filterFormattedDate }
//        print("filteredData:\(filteredData)")
        dusts = Array(filteredData)
        entryTableView.reloadData()
    }
    
    func loadData(_ date: Date) {
        //        print("date\(date)")
        currentDate = date
        dustsData = [] // 初期化
        
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: currentDate)
        
        let weekdays = ["", "日", "月", "火", "水", "木", "金", "土"]
        let todayWeekday = weekdays[weekday]
        
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        if let year = components.year, let month = components.month {
            // 第3水曜日だけ粗大ゴミ追加
            let dateComponentsThirdWednesday = DateComponents(year: year, month: month, weekday: 4, weekdayOrdinal: 3)
            if let thirdWednesday = calendar.date(from: dateComponentsThirdWednesday) {
                if calendar.isDate(currentDate, equalTo: thirdWednesday, toGranularity: .day) {
                    dustsData.append(DustsData(dust_name: "粗大ゴミ",  dust_type: "重要！",imageName: "bulky_garbage"))
                    dustsData.append(DustsData(dust_name: "電池",  imageName: "battery"))
                    return
                }
            }
            
            // 第4水曜日だけ不燃ゴミ追加
            let dateComponentsFourthWednesday = DateComponents(year: year, month: month, weekday: 4, weekdayOrdinal: 4)
            if let fourthWednesday = calendar.date(from: dateComponentsFourthWednesday) {
                if calendar.isDate(currentDate, equalTo: fourthWednesday, toGranularity: .day) {
                    dustsData.append(DustsData(dust_name: "不燃ゴミ", dust_type: "重要！", imageName: "Non-burnable_garbage"))
                    dustsData.append(DustsData(dust_name: "電池",  imageName: "battery"))
                    return
                }
            }
        }
        
        switch todayWeekday {
        case "月":
            dustsData.append(DustsData(dust_name: "ペットボトル",  imageName: "PET_bottles"))
            dustsData.append(DustsData(dust_name: "空きカン",  imageName: "empty_can"))
            dustsData.append(DustsData(dust_name: "空きビン",  imageName: "empty_bottle"))
        case "火":
            dustsData.append(DustsData(dust_name: "燃えるゴミ",  imageName: "burnable_garbage"))
        case "水":
            dustsData.append(DustsData(dust_name: "電池",  imageName: "battery"))
        case "金":
            dustsData.append(DustsData(dust_name: "燃えるゴミ",  imageName: "burnable_garbage"))
        default:
            dustsData.append(DustsData(dust_name: "今日出すゴミはありません", imageName: "info"))
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == myTableView {
            return dustsData.count
        } else if tableView == entryTableView {
            return dusts.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == myTableView {
            // 上のゴミのテーブル
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DustsTableViewCell", for: indexPath) as? DustsTableViewCell else {
                fatalError("Dequeue failed: DustsTableViewCell.")
            }
            cell.DustNameLabel.text = dustsData[indexPath.row].dust_name
            cell.DustImageView.image = UIImage(named: dustsData[indexPath.row].imageName)
            cell.DustTypeLabel.text = dustsData[indexPath.row].dust_type
            return cell
            
        } else if tableView == entryTableView {
            // 下の登録したゴミのテーブル
            let cell: CustomEntryCell = tableView.dequeueReusableCell(withIdentifier: "CustomEntryCell", for: indexPath) as! CustomEntryCell
            cell.entryNameLabel.text = "\(dusts[indexPath.row].dust_name)"
            cell.entryTypeLabel.text = "\(dusts[indexPath.row].dust_type)"
            cell.entryCreateView.text = "\(dusts[indexPath.row].dust_create)"
            // 画像を取得
            let path = dusts[indexPath.row].dust_image
            //  print("path:::\(path)")
            if FileManager.default.fileExists(atPath: path) {
                    if let imageData = UIImage(contentsOfFile: path) {
                        cell.entryImageView.image = imageData
                    }
                    else {
                        print("Failed to load the image.")
                    }
                }
                else {
                    print("Image file not found.")
                }
            return cell
        } else {
            // どちらのテーブルビューでもない場合は、空のセルを返す
            return UITableViewCell()
        }
    }
}
