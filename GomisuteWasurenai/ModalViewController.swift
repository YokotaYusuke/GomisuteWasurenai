//
//  ModalViewController.swift
//  GomisuteWasurenai
//
//  Created by yusukeyokota on 2023/12/09.
//

import UIKit
import RealmSwift

class ModalViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var dustTypes: [String] = []
    @IBOutlet weak var dustTypeTextField: UITextField!
    weak var pickerView: UIPickerView?
    @IBOutlet weak var dustNameTextField: UITextField!
    @IBOutlet weak var dustImageView: UIImageView!
    @IBOutlet weak var dustCreateDatePicker: UIDatePicker!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dustTypes.append("")
        dustTypes.append("燃えるゴミ")
        dustTypes.append("不燃ゴミ")
        dustTypes.append("粗大ゴミ")
        dustTypes.append("ペットボトル")
        dustTypes.append("空きカン")
        dustTypes.append("空きビン")
        dustTypes.append("電池")
        
        let pv = UIPickerView()
        pv.delegate = self
        pv.dataSource = self
        
        dustTypeTextField.delegate = self
        dustTypeTextField.inputAssistantItem.leadingBarButtonGroups = []
        dustTypeTextField.inputView = pv
        self.pickerView = pv
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        dustTypeTextField.placeholder = "ゴミの種類"
        dustNameTextField.placeholder = "ゴミの名前"
        
        // Realmの処理
        let dustsData = realm.objects(Dusts.self)
        print("全てのゴミのデータ\(dustsData)")
    }
    
    // fileNameを受け取り、documentDirectoryのそのファイルのURLを返す関数
    func getFileURL(fileName: String) -> URL {
        // docDirにはドキュメントディレクトリのURLが入っている
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docDir.appendingPathComponent(fileName)
    }

    // データを保存するボタンを押した時のアクション
    @IBAction func saveToPhotoLibraryTapped(_ sender: Any) {
        // 写真のユニークな名前を生成
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmssSSS"
        let timestamp = formatter.string(from: Date())
        let imageFileName = "IMG_\(timestamp).jpg"
        var fileURL = ""
        
        // 自分のiPhone限定画像を保存する -----------------
        guard let imageData = dustImageView.image?.jpegData(compressionQuality: 1.0) else {
            return
        }
        do {
            try imageData.write(to: getFileURL(fileName: imageFileName))
            print("Image saved.")
            // ここで一緒にパスを保存したい
            fileURL = getFileURL(fileName: imageFileName).path
        } catch {
            print("Failed to save the image:", error)
        }
        
        // -------------------------------
        
        let dusts = Dusts()
//        print("dust_nameは\(dustNameTextField.text!)","dust_typeは\(dustTypeTextField.text!)")
        dusts.dust_name = dustNameTextField.text!
        dusts.dust_type = dustTypeTextField.text!
        
        
//        if let NewFileURL = fileURL {
//            let urlString = fileURL.absoluteString
//            print(urlString)
//            // ここで urlString を利用できます
//        }
//        print(fileURL.absoluteString)
        dusts.dust_image = fileURL
        
//        print("filePathは\(dusts.dust_image)")
        
        // 日付のフォーマットを変更する
        let inputDate = dustCreateDatePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd(EEE)"
        let dateString = dateFormatter.string(from: inputDate)
//        print("dust_createは\(dateString)")
        dusts.dust_create = dateString
        try! realm.write {
            realm.add(dusts)
        }
        dismiss(animated: true,completion: nil)
    }
    
//    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
//        if let error = error {
//            print("Failed to save photo: \(error)")
//        } else {
//            print("Photo saved successfully.")
//        }
//    }
       
    // ゴミの写真を撮影ボタンをタップしたらカメラを起動するアクション
    @IBAction func takePhotoTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("カメラ失敗！！！！")
        }
    }
    
    // カメラを閉じて、画像を表示
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else {
            print("画像がないよ〜〜〜")
            return
        }
        dustImageView.image = image
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dustTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dustTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dustTypeTextField.text = dustTypes[row]
    }
    
    // 閉じるボタン押した時のアクション
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true,completion: nil)
    }

}
