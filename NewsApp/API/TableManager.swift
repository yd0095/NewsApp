//
//  TableManager.swift
//  NewsApp
//
//  Created by iamport on 30/03/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit
import Kanna

//https://github.com/tid-kijyun/Kanna [Kanna]
//XML,HTML Parser

final class TableManager {
    
    private var tableContents = [TableViewResource]()
    private var notLoadedList = [Int]()
    private var eraseOnceFlag = false
    
    init() {
        fetch()
        
        
    }
    
    func fetch() {
        self.tableContents.removeAll()
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
                let urlTmp = URL(string: self.tableContents[item].link)
                if let mainContent = try? HTML(url: urlTmp!, encoding: .utf8) {
                        //image 추출
                        
                        for contentFromHTML in mainContent.xpath("//meta[@property='og:image']") {
                            
                            let imageUrlString = contentFromHTML["content"]
                            guard let imageUrl = URL(string: imageUrlString!) else { return }
                            
                            do {
                             let dataFromLink = try Data(contentsOf: imageUrl)
                             let imageFromLink = UIImage(data: dataFromLink)
                             self.tableContents[item].image = imageFromLink!
                            print("image loaded")
                            } catch let err {
                             print("Error : \(err.localizedDescription)")
                            }
                               
                            //file download assurance TODO!!
                            
                        }
                        for contentFromHTML in mainContent.xpath("//meta[@property='og:description']") {
                            let contentFromUrl = contentFromHTML["content"]
                            self.tableContents[item].content = contentFromUrl!
                            print("contentLoaded")
                         
                        }
                        
                }
                else {
                    print(urlTmp)
                    print("url not loaded")
                    notLoadedList.append(item)
                }
            }
            self.eraseList()
            self.findKeyword()
        }
        
    }
    final func eraseList() {
        if eraseOnceFlag == false {
            var interval = 0
            for i in self.notLoadedList {
                //debug
                print("\(i)번째 삭제")
                self.tableContents.remove(at: i-interval)
                interval+=1
            }
            self.eraseOnceFlag = true
        }
        
        
        
    }

    
    final func findKeyword() {
        
        for cnt in 0..<self.tableContents.count {
            let arr = self.tableContents[cnt].content.components(separatedBy: " ")
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
                self.tableContents[cnt].keywords.append(index.key)
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
