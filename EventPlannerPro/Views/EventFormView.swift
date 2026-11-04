//
//  EventFormView.swift
//  EventPlannerPro
//
//  Created for Evaluación Continua PA3 - Pregunta 4
//

import SwiftUI
import SwiftData

struct EventFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    // ViewModel compartido
    @Bindable var viewModel: EventPlannerViewModel

    // Título dinámico si es creación o edición
    private var esModoEdicion: Bool {
        viewModel.eventoAEditar != nil
    }

    var body: some View {
        NavigationStack {
            Form {
                // Sección 1: Información básica
                Section("Detalles del Evento") {
                    TextField("Título del evento *", text: $viewModel.titulo)
                        .textInputAutocapitalization(.words)

                    TextField("Descripción o notas adicionales", text: $viewModel.descripcion, axis: .vertical)
                        .lineLimit(3...6)
                }

                // Sección 2: Fecha y Hora con DatePicker obligatorio
                Section("Programación") {
                    DatePicker(
                        "Fecha y Hora",
                        selection: $viewModel.fecha,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.compact)
                }

                // Sección 3: Vista hija con ColorPicker (@Binding)
                Section("Identidad Visual") {
                    EventColorBadgePickerView(colorSeleccionado: $viewModel.colorSeleccionado)
                }

                // Sección 4: Vista hija con PhotosPicker (@Binding)
                Section("Imagen del Evento") {
                    EventMediaHeaderView(
                        imagenData: $viewModel.imagenDataSeleccionada,
                        fotoItem: $viewModel.fotoItemSeleccionado,
                        colorAcento: viewModel.colorSeleccionado
                    )
                }
            }
            .navigationTitle(esModoEdicion ? "Editar Evento" : "Nuevo Evento")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        viewModel.reiniciarFormulario()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(esModoEdicion ? "Guardar" : "Crear") {
                        viewModel.guardarEvento(en: modelContext)
                        dismiss()
                    }
                    .disabled(!viewModel.esFormularioValido)
                    .bold()
                }
            }
        }
    }
}
