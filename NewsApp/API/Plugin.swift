//
//  Plugin.swift
//  NewsApp
//
//  Created by iamport on 30/03/2020.
//  Copyright © 2020 iamport. All rights reserved.
//

import UIKit

final class Plugin {
    
    static let shared = Plugin()
    private let tableManager =  TableManager()
    
    private init() { }
    
    func getTableContents() -> [TableViewResource] {
        return tableManager.getTableContents()
    }
    
    func fetch() {
        self.tableManager.fetch()
    }
    
    func eraseList() {
        self.tableManager.eraseListTableManager()
    }
    
    func findKeyWords() {
        self.tableManager.findKeywordTableManager()
    }
    
    func getContentPageSource(row: Int) -> contentPageSource {
        return tableManager.getContentPageSource(row: row)
    }
}

