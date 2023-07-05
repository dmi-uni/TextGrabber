//
//  ScanData.swift
//  TextGrabber
//
//  Created by Danil Masnaviev on 13/12/21.
//

import Foundation

struct ScanData:Identifiable {
    var id = UUID()
    let content: String
    
    init(content:String) {
        self.content = content
    }
}
