//
//  MainTableViewController.swift
//  FileTest
//
//  Created by ktds 29  on 2017. 8. 31..
//  Copyright © 2017년 ktds 29 . All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    var arts:[Art] = Array()
    let maxQty = 2
    let keyStr = "58557a467773756e39334e4e595254"
    var lastPageNum = 0
    
    @IBAction func getMoreData(_ sender: Any) {
            self.getData(pageNum: self.lastPageNum + 1)
            self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData(pageNum:2)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = arts[indexPath.row].title
        cell.detailTextLabel?.text = arts[indexPath.row].artist
      
        //let imgURL = arts[indexPath.row].thumbImageUrl
        cell.imageView?.image = self.getThumbImage(withURL: arts[indexPath.row].thumbImageUrl)
        
//        if let thumbImage = arts[indexPath.row].thumbImage {
//            cell.imageView?.image = thumbImage
//            
//        }else{
//            cell.imageView?.image = UIImage(named: "dummy")
//            if let thumbImageURL = arts[indexPath.row].thumbImageUrl {
//                DispatchQueue.global(qos: .userInitiated).async (execute : {
//                  self.arts[indexPath.row].thumbImage = self.getThumbImage(withURL: thumbImageURL)
//                    
//                    guard let thumbImage = self.arts[indexPath.row].thumbImage else {
//                        return
//                    }
//                    
//                    DispatchQueue.main.async {
//                        cell.imageView?.image = thumbImage
//                    }
//                    
//                    
//                    
//                })
//            }
//        }
        
        return cell
    }
    
    func getData(pageNum:Int){
        let startIdx = pageNum * maxQty
        let endIdx = startIdx * maxQty
        
        let urlStr = "http://openapi.seoul.go.kr:8088/\(keyStr)/json/SemaPsgudInfo/\(startIdx)/\(endIdx)/"
        
        let serverURL:URL! = URL(string : urlStr)
        
        let serverData = try! Data(contentsOf: serverURL)
        
        let log = NSString(data: serverData, encoding: String.Encoding.utf8.rawValue)
    
        do{
            let dict = try JSONSerialization.jsonObject(with: serverData, options: []) as! NSDictionary

            let semaPsgudInfo = dict["SemaPsgudInfo"] as! NSDictionary
            let results = semaPsgudInfo["row"] as! NSArray
            
            for result in results {
                let resultDict = result as! NSDictionary
                
                let art = Art(title: (resultDict["PRDCT_NM_KOREAN"] as? String)!,
                              artist: (resultDict["WRITR_NM"] as? String)!,
                              thumbImageUrl: (resultDict["THUMB_IMAGE"] as? String)!)
                
                arts.append(art)
                
                
            }
            
            print(dict)
            
            
        }catch{
            print("Error")
        }
        
        self.lastPageNum = pageNum
    }
    
    func getThumbImage(withURL imageURL:String) -> UIImage{
        
        let url:URL! = URL(string: imageURL)
        let imgData = try! Data(contentsOf: url)
        let image = UIImage(data: imgData)
        
        return image!
    
    
    }

}
