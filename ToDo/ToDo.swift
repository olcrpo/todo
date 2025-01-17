//
//  ToDo.swift
//  ToDo
//
//  Created by 이수겸 on 1/17/25.
//

import Foundation
import SwiftData

@Model
final class ToDo {
    var name: String
    var isDone: Bool
    var isImportant: Bool
    
    init(name: String, isDone: Bool, isImportant: Bool) {
        self.name = name
        self.isDone = isDone
        self.isImportant = isImportant
    }
}
