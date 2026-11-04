//
//  EventPlannerProApp.swift
//  EventPlannerPro
//
//  Created for Evaluación Continua PA3 - Pregunta 4
//

import SwiftUI
import SwiftData

@main
struct EventPlannerProApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: EventItem.self)
    }
}
