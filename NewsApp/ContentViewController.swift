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
    
    var link : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // navigationController?.hidesBarsOnSwipe = true
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
