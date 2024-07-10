//
//  TaskExtension.swift
//  TaskManagerSwift
//
//  Created by Mohamed Shameer on 7/9/24.
//

import Foundation
import SwiftUI

struct Tasks{
    let desc : String
    let creationDate : Date
}

extension Color {
    static subscript(name: String) -> Color {
        switch name {
            case "teal":
                return Color.teal
            case "green":
                return Color.green
            case "gray":
                return Color.gray
            case "yellow":
                return Color.yellow
            case "blue":
                return Color.blue
            default:
                return Color.black
        }
    }
}
