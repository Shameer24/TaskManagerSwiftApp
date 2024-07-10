//
//  TaskManagerSwiftApp.swift
//  TaskManagerSwift
//
//  Created by Mohamed Shameer on 7/8/24.
//

import SwiftUI

@main
struct TaskManagerSwiftApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for : Task.self)
    }
}
