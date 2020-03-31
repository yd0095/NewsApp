//
//  ViewController.swift
//  NewsApp
//
//  Created by iamport on 27/03/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit
import Kanna

class ViewController: UIViewController { 
    
    @IBOutlet weak var tableView: UITableView!
    
    private var refreshControl : UIRefreshControl?
    private var presentRow : Int = 0
    private var tableData = [TableViewResource]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableData = Plugin.shared.getTableContents()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        addRefreshControl()
        
    }
    func addRefreshControl() {
        
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.red
        refreshControl?.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        tableView.addSubview(refreshControl!)
    }
    @objc func refreshList() {
        Plugin.shared.fetch()
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tableData.count
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsCell
        
        cell.imageFromRSS.image = self.tableData[indexPath.row].image
        cell.titleFromRSS.text = self.tableData[indexPath.row].title
        cell.contentFromRSS.text = self.tableData[indexPath.row].content
        
        cell.keyWord1.adjustsFontSizeToFitWidth = true
        cell.keyWord1.minimumScaleFactor = 0.2
        
        cell.keyWord2.adjustsFontSizeToFitWidth = true
        cell.keyWord2.minimumScaleFactor = 0.2
        
        cell.keyWord3.adjustsFontSizeToFitWidth = true
        cell.keyWord3.minimumScaleFactor = 0.2
        
        if self.tableData[indexPath.row].content != "" {
            
            cell.keyWord1.text = self.tableData[indexPath.row].keywords[0].trimmingCharacters(in: ["\"","“","'","‘",","])
            cell.keyWord1.layer.borderColor = UIColor.black.cgColor
            cell.keyWord1.layer.borderWidth = 1.0
            cell.keyWord1.layer.cornerRadius = 8.0
            
            cell.keyWord2.text = self.tableData[indexPath.row].keywords[1].trimmingCharacters(in: ["\"","“","'","‘",","])
            cell.keyWord2.layer.borderColor = UIColor.black.cgColor
            cell.keyWord2.layer.borderWidth = 1.0
            cell.keyWord2.layer.cornerRadius = 8.0
            
            cell.keyWord3.text = self.tableData[indexPath.row].keywords[2].trimmingCharacters(in: ["\"","“","'","‘",","])
            cell.keyWord3.layer.borderColor = UIColor.black.cgColor
            cell.keyWord3.layer.borderWidth = 1.0
            cell.keyWord3.layer.cornerRadius = 8.0
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.presentRow = indexPath.row
        self.performSegue(withIdentifier: "ToContent", sender: self)
        
    }
    
}
extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToContent" {
            guard let toContent = segue.destination as? ContentViewController else { return }
            toContent.row = self.presentRow
        }
    }
    
    
}


