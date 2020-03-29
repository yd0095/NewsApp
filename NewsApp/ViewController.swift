//
//  ViewController.swift
//  NewsApp
//
//  Created by iamport on 27/03/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit
import Kanna

class ViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    var titles = [String]()
    var images = [UIImage]()
    var contents = [String]()
    
    var keywords = [Int : String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        fetch()
        findKeyword()
    }
    
    func fetch() {
        
        let urlString = "https://news.google.com/rss?hl=ko&gl=KR&ceid=KR:ko"
        guard let url = URL(string: urlString) else {return}
        
        if let doc = try? XML(url: url, encoding: .utf8) {
            for item in doc.xpath("//item/title") {
                titles.append(item.text!)
                
            }
            for item in doc.xpath("//item/link") {
               let link = URL(string: item.text!)
               if let loadedHTML = try? HTML(url: link!, encoding: .utf8) {
                   for contentFromHTML in loadedHTML.xpath("//meta[@property='og:image']") {
                       let imageUrlString = contentFromHTML["content"]
                       guard let imageUrl:URL = URL(string: imageUrlString!) else { return }
                       //for debug
                       print(imageUrl)
       
                       do {
                           let data = try Data(contentsOf: imageUrl)
                           let image = UIImage(data: data)
                           images.append(image!)
                           
                       } catch let err {
                           print("Error : \(err.localizedDescription)")
                       }
                    //file download assurance TODO!!
                       
                   }
                   for contentFromHTML in loadedHTML.xpath("//meta[@property='og:description']") {
                       let target = contentFromHTML["content"]
                       self.contents.append(target!)
                   }
               }
            }
            
        }
    }

    
    func findKeyword() {
        
        var i = 0
        
        for content in self.contents {
            let arr = content.components(separatedBy: " ")
            var dic = [String : Int]()
            for i in arr {
                if i.count > 1 {
                    if let val = dic[i] {
                        dic[i] = val+1
                    } else {
                        dic[i] = 1
                    }
                }
                else {
                    continue
                }
            }

            let sortedDic = dic.sorted(by: {($1.value, $0.key) < ($0.value, $1.key)})
            for index in sortedDic {
                if self.keywords[i] != nil{
                    self.keywords[i] = self.keywords[i]! + " " + index.key
                }
                else {
                    self.keywords[i] = index.key
                }
            }
            
            i+=1
            
        }
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsCell
        
        cell.imageFromRSS.image = self.images[indexPath.row]
        cell.titleFromRSS.text = self.titles[indexPath.row]
        cell.contentFromRSS.text = self.contents[indexPath.row]
        
        
        let arr = keywords[indexPath.row]?.components(separatedBy: " ")
        
        print(arr)
        
        cell.keyWord1.adjustsFontSizeToFitWidth = true
        cell.keyWord1.minimumScaleFactor = 0.2
        
        cell.keyWord2.adjustsFontSizeToFitWidth = true
        cell.keyWord2.minimumScaleFactor = 0.2
        
        cell.keyWord3.adjustsFontSizeToFitWidth = true
        cell.keyWord3.minimumScaleFactor = 0.2
        
        cell.keyWord1.text = arr![0].trimmingCharacters(in: ["\"","“","'","‘",","])
        cell.keyWord1.layer.borderColor = UIColor.black.cgColor
        cell.keyWord1.layer.borderWidth = 1.0
        cell.keyWord1.layer.cornerRadius = 8.0
        
        cell.keyWord2.text = arr![1].trimmingCharacters(in: ["\"","“","'","‘",","])
        cell.keyWord2.layer.borderColor = UIColor.black.cgColor
        cell.keyWord2.layer.borderWidth = 1.0
        cell.keyWord2.layer.cornerRadius = 8.0
        
        cell.keyWord3.text = arr![2].trimmingCharacters(in: ["\"","“","'","‘",","])
        cell.keyWord3.layer.borderColor = UIColor.black.cgColor
        cell.keyWord3.layer.borderWidth = 1.0
        cell.keyWord3.layer.cornerRadius = 8.0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

class NewsCell: UITableViewCell{
    
    @IBOutlet weak var imageFromRSS: UIImageView!
    @IBOutlet weak var titleFromRSS: UILabel!
    @IBOutlet weak var contentFromRSS: UILabel!
    @IBOutlet weak var keyWord1: UILabel!
    @IBOutlet weak var keyWord2: UILabel!
    @IBOutlet weak var keyWord3: UILabel!
    
}


