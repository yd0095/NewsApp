//
//  TableManager.swift
//  NewsApp
//
//  Created by iamport on 30/03/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit
import Kanna

final class TableManager {
    
    private var tableContents = [TableViewResource]()
    
    init() {
        fetch()
    }
    
    func fetch() {
        
        let urlString = "https://news.google.com/rss?hl=ko&gl=KR&ceid=KR:ko"
        guard let url = URL(string: urlString) else {return}
        
        if let doc = try? XML(url: url, encoding: .utf8) {
            
            var rowCnt = 0
            
            for item in doc.xpath("//item/title") {
                self.tableContents.insert(TableViewResource(title: item.text!, image: UIImage(named: "SampleLogo1.jpg")!, content: "", link: "", keywords: [String]()),at: rowCnt)
                rowCnt += 1
            }
            
            rowCnt = 0
            
            for item in doc.xpath("//item/link") {
                self.tableContents[rowCnt].link = item.text!
                rowCnt += 1
            }
            
            for item in 0..<rowCnt {
                DispatchQueue.global().async {
                 
                let urlTmp = URL(string: self.tableContents[item].link)
                print(urlTmp)
        
                if let mainContent = try? HTML(url: urlTmp!, encoding: .utf8) {
                    //image 추출
                    
                    for contentFromHTML in mainContent.xpath("//meta[@property='og:image']") {
                        
                        let imageUrlString = contentFromHTML["content"]
                        guard let imageUrl = URL(string: imageUrlString!) else { return }
                        
                        do {
                         let dataFromLink = try Data(contentsOf: imageUrl)
                         let imageFromLink = UIImage(data: dataFromLink)
                         self.tableContents[item].image = imageFromLink!
                            
                        } catch let err {
                         print("Error : \(err.localizedDescription)")
                        }
                           
                        //file download assurance TODO!!
                        
                    }
                    
                        
                    }
                    
                }

            }
            for item in 0..<rowCnt {
                DispatchQueue.global().async {
                    let urlTmp = URL(string: self.tableContents[item].link)
                    if let mainContent = try? HTML(url: urlTmp!, encoding: .utf8) {
                        for contentFromHTML in mainContent.xpath("//meta[@property='og:description']") {
                            let contentFromUrl = contentFromHTML["content"]
                            self.tableContents[item].content = contentFromUrl!
                         
                        }
                        self.findKeyword(row: item)
                    }
                }
            
            }
            
        }
        
    }
    

    
    final func findKeyword(row : Int) {
        
        for contentFromUrl in self.tableContents {
            let arr = contentFromUrl.content.components(separatedBy: " ")
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
                self.tableContents[row].keywords.append(index.key)
            }
        }
    }
    
    func getTableContents() -> [TableViewResource] {
        return self.tableContents
    }
    
    func getContentPageSource(row : Int) -> contentPageSource {
        return (title: self.tableContents[row].title, link: self.tableContents[row].link,keywords: self.tableContents[row].keywords)
    }
    
}
