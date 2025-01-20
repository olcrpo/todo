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
    var id: String = UUID().uuidString
    var title: String
    var isDone: Bool
    var isImportant: Bool
    var createdAt: Date
    
    init(title: String, isDone: Bool = false, isImportant: Bool = false, createdAt: Date = Date()) {
        self.title = title
        self.isDone = isDone
        self.isImportant = isImportant
        self.createdAt = createdAt
    }
}
