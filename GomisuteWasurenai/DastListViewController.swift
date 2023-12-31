//
//  DastListViewController.swift
//  GomisuteWasurenai
//
//  Created by yusukeyokota on 2023/12/07.
//

import UIKit
import RealmSwift

class DastListViewController: UIViewController,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    var dusts: [Dusts] = [] // ゴミの登録データ
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = try! Realm()
//        print("全てのデータ\(dustsData)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let realm = try! Realm()
        let result = realm.objects(Dusts.self)
        dusts = Array(result)
        tableView.reloadData()
    }
    
    // テーブルの行数を決定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        let dustsData = realm.objects(Dusts.self)
        return dustsData.count
    }
    
    // テーブルに表示するデータ
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell: CustomDustCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomDustCell
        let realm = try! Realm()
        let dustsData = realm.objects(Dusts.self)
        cell.dustNameLabel.text = "\(dustsData[indexPath.row].dust_name)"
        cell.dustTypeLabel.text = "\(dustsData[indexPath.row].dust_type)"
        cell.dustCreateLabel.text = "\(dustsData[indexPath.row].dust_create)"
        // 画像を取得
        let path = dustsData[indexPath.row].dust_image
        //  print("path:::\(path)")
        if FileManager.default.fileExists(atPath: path) {
                if let imageData = UIImage(contentsOfFile: path) {
                    cell.dustImageView.image = imageData
                }
                else {
                    print("Failed to load the image.")
                }
            }
            else {
                print("Image file not found.")
            }
        return cell
    }
    
    // スワイプして削除するアクション
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let targetDust = dusts[indexPath.row]
        let realm = try! Realm()
        try! realm.write {
            realm.delete(targetDust)
        }
        dusts.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
