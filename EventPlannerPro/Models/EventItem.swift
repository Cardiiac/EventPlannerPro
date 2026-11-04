//
//  EventItem.swift
//  EventPlannerPro
//
//  Created for Evaluación Continua PA3 - Pregunta 4
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class EventItem {
    var id: UUID = UUID()
    var titulo: String
    var descripcion: String
    var fecha: Date
    var colorHex: String
    @Attribute(.externalStorage) var imagenData: Data?

    init(
        id: UUID = UUID(),
        titulo: String,
        descripcion: String,
        fecha: Date,
        colorHex: String = "#4A90E2",
        imagenData: Data? = nil
    ) {
        self.id = id
        self.titulo = titulo
        self.descripcion = descripcion
        self.fecha = fecha
        self.colorHex = colorHex
        self.imagenData = imagenData
    }

    // Color representativo calculado a partir del Hexadecimal guardado
    var color: Color {
        get { Color(hex: colorHex) }
        set { colorHex = newValue.toHex() }
    }

    // Fecha formateada para la interfaz
    var fechaFormateada: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "es_PE")
        return formatter.string(from: fecha)
    }

    // Indica si el evento ya pasó
    var yaPaso: Bool {
        fecha < Date()
    }
}
