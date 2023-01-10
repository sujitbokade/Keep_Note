//
//  Note.swift
//  Login Page
//
//  Created by Macbook on 27/12/22.
//

import Foundation

struct Note{
    var title:String?
    var note:String?
    var id:String
    var date: Date?
    var isRemainder: Bool
    
    init(title: String? , note: String? , id:String, date:Date?, isRemainder: Bool ) {
        self.title = title
        self.note = note
        self.id = id
        self.date = date
        self.isRemainder = isRemainder
    }
}
