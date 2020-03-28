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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        fetch()

    }
    
    func fetch() {
        
        let urlString = "https://news.google.com/rss"
        guard let url = URL(string: urlString) else {return}
        
        if let doc = try? XML(url: url, encoding: .utf8) {
            for item in doc.xpath("//title") {
                titles.append(item.text!)
            }
            for item in doc.xpath("//item/link") {
                let link = URL(string: item.text!)
                if let loadedHTML = try? HTML(url: link!, encoding: .utf8) {
                    for contentFromHTML in loadedHTML.xpath("//meta[@property='og:image']") {
                        let target = contentFromHTML["content"]
                        let url = URL(string: target!)
                        do {
                            let data = try Data(contentsOf: url!)
                            let image = UIImage(data: data)
                            images.append(image!)
                        } catch let err {
                            print("Error : \(err.localizedDescription)")
                        }
                        
                        
                    }
                    
                    for contentFromHTML in loadedHTML.xpath("//meta[@property='og:description']") {
                        let target = contentFromHTML["content"]
                        contents.append(target!)
                    }
                }
            }
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
        
        
        cell.keyWord1.text = "keyword1"
        cell.keyWord1.layer.borderColor = UIColor.black.cgColor
        cell.keyWord1.layer.borderWidth = 1.0
        cell.keyWord1.layer.cornerRadius = 8.0
        
        cell.keyWord2.text = "keyword2"
        cell.keyWord2.layer.borderColor = UIColor.black.cgColor
        cell.keyWord2.layer.borderWidth = 1.0
        cell.keyWord2.layer.cornerRadius = 8.0
        
        cell.keyWord3.text = "keyword3"
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


