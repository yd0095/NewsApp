//
//  TableViewResource.swift
//  NewsApp
//
//  Created by iamport on 30/03/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit

struct TableViewResource {
    
    var title : String
    var image : UIImage
    var content : String
    var link : String
    var keywords = [String]()
}

typealias contentPageSource = (title: String, link: String, keywords: [String])
