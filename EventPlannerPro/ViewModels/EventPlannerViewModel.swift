//
//  EventPlannerViewModel.swift
//  EventPlannerPro
//
//  Created for Evaluación Continua PA3 - Pregunta 4
//

import Foundation
import SwiftUI
import SwiftData
import PhotosUI

enum FiltroTemporal: String, CaseIterable, Identifiable {
    case todos = "Todos"
    case proximos = "Próximos"
    case pasados = "Pasados"

    var id: String { rawValue }
}

@Observable
final class EventPlannerViewModel {
    // MARK: - Estado de Búsqueda y Filtros
    var textoBusqueda: String = ""
    var filtroSeleccionado: FiltroTemporal = .todos

    // MARK: - Estado del Formulario (Creación / Edición)
    var titulo: String = ""
    var descripcion: String = ""
    var fecha: Date = Date()
    var colorSeleccionado: Color = Color.blue
    var imagenDataSeleccionada: Data? = nil
    var fotoItemSeleccionado: PhotosPickerItem? = nil {
        didSet {
            Task {
                await procesarFotoSeleccionada()
            }
        }
    }

    // MARK: - Control de Vistas Modales
    var mostrarFormularioCreacion: Bool = false
    var eventoAEditar: EventItem? = nil

    // MARK: - Validación de Negocio
    var esFormularioValido: Bool {
        !titulo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // MARK: - Filtrado de Eventos en Memoria
    func filtrarEventos(_ eventos: [EventItem]) -> [EventItem] {
        var resultado = eventos

        // Filtro por fecha (Próximos / Pasados / Todos)
        let ahora = Date()
        switch filtroSeleccionado {
        case .proximos:
            resultado = resultado.filter { $0.fecha >= ahora }
        case .pasados:
            resultado = resultado.filter { $0.fecha < ahora }
        case .todos:
            break
        }

        // Filtro por texto de búsqueda
        if !textoBusqueda.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let termino = textoBusqueda.lowercased()
            resultado = resultado.filter {
                $0.titulo.lowercased().contains(termino) ||
                $0.descripcion.lowercased().contains(termino)
            }
        }

        // Ordenamiento por fecha ascendente
        return resultado.sorted { $0.fecha < $1.fecha }
    }

    // MARK: - Operaciones CRUD

    /// Carga los datos de un evento existente en las variables del formulario
    func prepararEdicion(de evento: EventItem) {
        self.eventoAEditar = evento
        self.titulo = evento.titulo
        self.descripcion = evento.descripcion
        self.fecha = evento.fecha
        self.colorSeleccionado = evento.color
        self.imagenDataSeleccionada = evento.imagenData
        self.fotoItemSeleccionado = nil
    }

    /// Limpia todos los campos del formulario para un nuevo registro
    func reiniciarFormulario() {
        self.eventoAEditar = nil
        self.titulo = ""
        self.descripcion = ""
        self.fecha = Date()
        self.colorSeleccionado = Color.blue
        self.imagenDataSeleccionada = nil
        self.fotoItemSeleccionado = nil
    }

    /// Guarda un nuevo evento o actualiza uno existente en SwiftData
    @MainActor
    func guardarEvento(en contexto: ModelContext) {
        guard esFormularioValido else { return }

        let hexColor = colorSeleccionado.toHex()

        if let evento = eventoAEditar {
            // Actualización (Update)
            evento.titulo = titulo.trimmingCharacters(in: .whitespacesAndNewlines)
            evento.descripcion = descripcion.trimmingCharacters(in: .whitespacesAndNewlines)
            evento.fecha = fecha
            evento.colorHex = hexColor
            evento.imagenData = imagenDataSeleccionada
        } else {
            // Creación (Create)
            let nuevoEvento = EventItem(
                titulo: titulo.trimmingCharacters(in: .whitespacesAndNewlines),
                descripcion: descripcion.trimmingCharacters(in: .whitespacesAndNewlines),
                fecha: fecha,
                colorHex: hexColor,
                imagenData: imagenDataSeleccionada
            )
            contexto.insert(nuevoEvento)
        }

        do {
            try contexto.save()
            reiniciarFormulario()
        } catch {
            print("Error al guardar en SwiftData: \(error.localizedDescription)")
        }
    }

    /// Elimina un evento de la base de datos local
    @MainActor
    func eliminarEvento(_ evento: EventItem, en contexto: ModelContext) {
        contexto.delete(evento)
        do {
            try contexto.save()
        } catch {
            print("Error al eliminar evento: \(error.localizedDescription)")
        }
    }

    /// Procesa la imagen seleccionada desde PhotosPicker
    @MainActor
    private func procesarFotoSeleccionada() async {
        guard let item = fotoItemSeleccionado else { return }
        do {
            if let data = try await item.loadTransferable(type: Data.self) {
                self.imagenDataSeleccionada = data
            }
        } catch {
            print("Error al cargar la foto: \(error.localizedDescription)")
        }
    }
}
