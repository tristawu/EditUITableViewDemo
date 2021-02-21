//
//  ViewController.swift
//  EditUITableViewDemo
//
//  Created by Trista on 2021/2/19.
//

import UIKit

//UITableView設置委任模式的對象:ViewController 來完善這個表格的內容，所以ViewController需遵守委任需要的協定UITableViewDelegate和UITableViewDataSource
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //建立屬性
    var myTableView :UITableView!
    //建立一個陣列屬性
    var info =
          ["林書豪","陳信安","陳偉殷","王建民","陳金鋒","林智勝"]
    //取得螢幕的尺寸
    let fullsize = UIScreen.main.bounds.size
    
    
    //ViewController遵守委任需要的協定UITableViewDelegate和UITableViewDataSource必須實作的方法
    //每一組有幾個 cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info.count
    }
    
    //ViewController遵守委任需要的協定UITableViewDelegate和UITableViewDataSource必須實作的方法
    //每個 cell 要顯示的內容
    //UITableView 委任的方法大多會有indexPath參數，這個參數有兩個屬性分別為section及row，表示目前要設置的 cell 是屬於哪一組( section )的哪一列( row )，型別都為 Int 且都是由 0 開始算起
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //使用稍前註冊的 cell 使用的辨識名稱"Cell"，告訴程式要使用哪一個 cell 來重複使用
        //取得 tableView 目前使用的 cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
                    
        //顯示的內容
        if let myLabel = cell.textLabel {
                    myLabel.text = "\(info[indexPath.row])"
                }
                      
        return cell
    }
    
    //點選 cell 後執行的動作
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        //取消 cell 的選取狀態
        tableView.deselectRow(at: indexPath, animated: true)
             
        let name = info[indexPath.row]
        print("選擇的是 \(name)")
    }
    
    //設置每筆 row 是否可以進入編輯模式，必須實作以下這個委任方法
    //各 cell 是否可以進入編輯狀態 及 左滑刪除
    //可以根據 indexPath 來讓特定的 section 的 row 不能編輯
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //必須實作以下這個委任方法，才會出現排序功能
    //編輯狀態時,拖曳切換 cell 位置後執行動作的方法
    //除了重新排序 UITableView 之外，也將info陣列重新排序
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        print("\(sourceIndexPath.row) to")
        print("\(destinationIndexPath.row)")

        var tempArr:[String] = []

        //排在後的往前移動
        if(sourceIndexPath.row > destinationIndexPath.row)
        {
            for (index, value) in info.enumerated() {
                if index < destinationIndexPath.row
                  || index > sourceIndexPath.row {
                    tempArr.append(value)
                } else if
                  index == destinationIndexPath.row {
                tempArr.append(info[sourceIndexPath.row])
                } else if index <= sourceIndexPath.row {
                    tempArr.append(info[index - 1])
                }
            }
        }
        //排在前的往後移動
       else if (sourceIndexPath.row <
          destinationIndexPath.row) {
            for (index, value) in info.enumerated() {
                if index < sourceIndexPath.row
                || index > destinationIndexPath.row {
                    tempArr.append(value)
                } else if
                index < destinationIndexPath.row {
                    tempArr.append(info[index + 1])
                } else if
                index == destinationIndexPath.row {
                tempArr.append(info[sourceIndexPath.row])
                }
            }
        }
       else {
            tempArr = info
        }

        info = tempArr
        print(info)
        
    }
    
    //必須實作這個方法才會出現左滑刪除功能
    //編輯狀態時,按下刪除 cell 後執行動作的方法
    //除了刪除 UITableView 的資料外，也刪除info陣列所屬的值
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
        let name = info[indexPath.row]

        if editingStyle == .delete {
            info.remove(at: indexPath.row)
            
            //在 UITableView 的兩個方法beginUpdates()與endUpdates()中間使用方法func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) 刪除一筆資料
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()

            print("刪除的是 \(name)")
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //基本設定
        self.view.backgroundColor = UIColor.white
        self.title = "編輯模式"
        
        
        //導覽列是否半透明
        //需要在導覽列沒有設置底色時才有這個效果。
        //還影響到內部視圖的原點位置，true則原點與導覽列的原點一樣，都是整個畫面的左上角，false則內部視圖的原點則會被設在導覽列下方
        self.navigationController?.navigationBar.isTranslucent =
          false
        
        
        //建立 UITableView 並設置原點及尺寸
        myTableView = UITableView(frame: CGRect(
          x: 0, y: 0,
          width: fullsize.width,
          height: fullsize.height - 64),
                                  style: .plain)
        
        //當 cell 數量超過一個畫面可顯示時，目前存在的 cell 只有畫面上的這些，當上下滑動時，會隨顯示畫面的不同同時移出並加入 cell，這個動作不是一直建立新的 cell 而是會重複使用( reuse )，所以必須先註冊這個 reuse 的 cell ，辨識名稱設為"Cell"，來讓後續顯示時可以使用
        //註冊 cell
        myTableView.register(
          UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        //設置委任對象
        myTableView.delegate = self
        myTableView.dataSource = self
        
        //是否可以點選 cell
        myTableView.allowsSelection = true
        
        //加入到畫面中
        self.view.addSubview(myTableView)
        
        //根據 UITableView 的屬性editing來判斷目前是否處於編輯模式，使用方法setEditing(_:animated:)來切換。
        //func setEditing(_ editing: Bool, animated: Bool)
        //editing：true to enter editing mode
        //animate：false to make the transition immediate
        myTableView.setEditing(true, animated: false)
        
        //編輯模式切換的同時也一併設置導覽列左邊及右邊按鈕: 編輯 & 新增，只有非編輯模式時才有新增的按鈕
        self.editBtnAction()
        
    }
    
    
    // 按下新增按鈕時執行動作的方法
    @objc func addBtnAction() {
        print("新增一筆資料")
        info.insert("new row", at: 0)

        //陣列新增一筆資料
        //在 UITableView 的兩個方法beginUpdates()與endUpdates()中間使用方法func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) 新增一筆資料
        myTableView.beginUpdates()
        myTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        myTableView.endUpdates()
    }
    
    
    //按下編輯按鈕時執行動作的方法
    @objc func editBtnAction() {
        
        //func setEditing(_ editing: Bool, animated: Bool)
        //animate：true to animate the transition to editing mode
        myTableView.setEditing(!myTableView.isEditing, animated: true)
        
        //editing：false to leave editing mode
        if (!myTableView.isEditing)
        {
            //顯示編輯按鈕
            //導覽列按鈕設置為系統內建樣式的按鈕
            //導覽列左邊按鈕-編輯
            self.navigationItem.leftBarButtonItem =
                UIBarButtonItem(barButtonSystemItem: .edit,
              target: self,
              action:
                #selector(ViewController.editBtnAction))

            //非編輯模式時才有新增的按鈕
            //導覽列按鈕設置為系統內建樣式的按鈕
            //導覽列右邊按鈕-新增
            self.navigationItem.rightBarButtonItem =
                UIBarButtonItem(barButtonSystemItem: .add,
              target: self,
              action:
                #selector(ViewController.addBtnAction))
        }
        //editing：true to enter editing mode
        else
        {
            //顯示編輯完成按鈕
            //導覽列設置為系統內建樣式的按鈕
            self.navigationItem.leftBarButtonItem =
                UIBarButtonItem(barButtonSystemItem: .done,
                target: self,
                action:
                  #selector(ViewController.editBtnAction))

            //編輯模式時隱藏新增按鈕
            self.navigationItem.rightBarButtonItem = nil
        }
        
    }


}

