//
//  Task.swift
//  TaskManagerSwift
//
//  Created by Mohamed Shameer on 7/9/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Task : Identifiable{
    var id : UUID
    var taskTitle : String
    var creationDate : Date
    var isCompleted : Bool
    var tint : String
    
    init(id: UUID = .init(), taskTitle: String, creationDate: Date, isCompleted: Bool = false, tint: String) {
        self.id = id
        self.taskTitle = taskTitle
        self.creationDate = creationDate
        self.isCompleted = isCompleted
        self.tint = tint
    }
}
