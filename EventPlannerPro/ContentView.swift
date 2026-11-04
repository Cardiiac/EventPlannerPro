//
//  ContentView.swift
//  EventPlannerPro
//
//  Created for Evaluación Continua PA3 - Pregunta 4
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        EventListView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: EventItem.self, inMemory: true)
}
