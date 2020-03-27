//
//  ViewController.swift
//  NewsApp
//
//  Created by iamport on 27/03/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsCell
        
        cell.imageFromRSS.image = UIImage(named: "SampleLogo1.jpg")
        cell.titleFromRSS.text = "title"
        cell.contentFromRSS.text = "content"
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
