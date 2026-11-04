//
//  EventDetailView.swift
//  EventPlannerPro
//
//  Created for Evaluación Continua PA3 - Pregunta 4
//

import SwiftUI
import SwiftData

struct EventDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let evento: EventItem
    @Bindable var viewModel: EventPlannerViewModel

    @State private var mostrarEdicion: Bool = false
    @State private var mostrarConfirmacionEliminar: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Cabecera multimedia
                if let data = evento.imagenData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 240)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(evento.color, lineWidth: 3)
                        )
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(evento.color.gradient)
                            .frame(height: 140)

                        VStack(spacing: 8) {
                            Image(systemName: "calendar.badge.clock")
                                .font(.system(size: 40))
                                .foregroundStyle(.white)
                            Text("Event Planner Pro")
                                .font(.caption.bold())
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }
                }

                // Título y Color Representativo
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .center, spacing: 10) {
                        Circle()
                            .fill(evento.color)
                            .frame(width: 18, height: 18)

                        Text(evento.titulo)
                            .font(.title.bold())
                    }

                    HStack(spacing: 6) {
                        Image(systemName: "clock.fill")
                            .foregroundStyle(evento.color)
                        Text(evento.fechaFormateada)
                            .font(.subheadline)
                            .bold()
                            .foregroundStyle(.secondary)
                    }
                }

                Divider()

                // Descripción
                VStack(alignment: .leading, spacing: 8) {
                    Text("Descripción")
                        .font(.headline)

                    if evento.descripcion.isEmpty {
                        Text("Sin descripción proporcionada.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .italic()
                    } else {
                        Text(evento.descripcion)
                            .font(.body)
                            .lineSpacing(4)
                    }
                }

                Spacer(minLength: 20)

                // Botones de Acción
                VStack(spacing: 12) {
                    Button {
                        viewModel.prepararEdicion(de: evento)
                        mostrarEdicion = true
                    } label: {
                        Label("Editar Evento", systemImage: "pencil")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(evento.color)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    Button(role: .destructive) {
                        mostrarConfirmacionEliminar = true
                    } label: {
                        Label("Eliminar Evento", systemImage: "trash")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.12))
                            .foregroundStyle(.red)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Detalle del Evento")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $mostrarEdicion) {
            EventFormView(viewModel: viewModel)
        }
        .confirmationDialog(
            "¿Deseas eliminar este evento?",
            isPresented: $mostrarConfirmacionEliminar,
            titleVisibility: .visible
        ) {
            Button("Eliminar", role: .destructive) {
                viewModel.eliminarEvento(evento, en: modelContext)
                dismiss()
            }
            Button("Cancelar", role: .cancel) {}
        } message: {
            Text("Esta acción no se puede deshacer.")
        }
    }
}
