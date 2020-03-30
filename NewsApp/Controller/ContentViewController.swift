//
//  ContentViewController.swift
//  NewsApp
//
//  Created by iamport on 29/03/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit
import WebKit

class ContentViewController: UIViewController ,UIGestureRecognizerDelegate{

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var viewForTitle: UIView!
    
    @IBOutlet weak var titleFromUrl: UILabel!
    
    @IBOutlet weak var keyWord1: UILabel!
    @IBOutlet weak var keyWord2: UILabel!
    @IBOutlet weak var keyWord3: UILabel!
    
    
    var row = 0
    var link = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGestureRecognizer()
        getDataFromPlugin()
    }
    
    func getDataFromPlugin() {
        
        let data = Plugin.shared.getContentPageSource(row: self.row)
        self.titleFromUrl.text = data.title
        self.link = data.link
        self.keyWord1.text = data.keywords[0]
        self.keyWord2.text = data.keywords[1]
        self.keyWord3.text = data.keywords[2]

    }
    
    func setGestureRecognizer(){
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))
        swipeUp.direction = .up
        swipeUp.delegate = self
        self.webView.scrollView.panGestureRecognizer.require(toFail: swipeUp)
        self.webView.addGestureRecognizer(swipeUp)
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadWebPage(url: link)
        
    }
     func loadWebPage(url: String) {
             let myUrl = URL(string: url)
             let request = URLRequest(url: myUrl!)
             self.webView.load(request)
    }
    
}
extension ContentViewController {
    @objc func handleGesture(gesture: UISwipeGestureRecognizer){
        if gesture.direction == .up {
            viewForTitle.isHidden = true
        }
    }
}
