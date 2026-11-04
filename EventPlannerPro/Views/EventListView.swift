//
//  EventListView.swift
//  EventPlannerPro
//
//  Created for Evaluación Continua PA3 - Pregunta 4
//

import SwiftUI
import SwiftData

struct EventListView: View {
    @Environment(\.modelContext) private var modelContext

    // SwiftData Query: Fuente Única de Verdad para la lista
    @Query(sort: \EventItem.fecha, order: .forward) private var todosLosEventos: [EventItem]

    // ViewModel para lógica de presentación y filtrado (MVVM)
    @State private var viewModel = EventPlannerViewModel()

    // Eventos filtrados según búsqueda y selector temporal
    private var eventosFiltrados: [EventItem] {
        viewModel.filtrarEventos(todosLosEventos)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Selector de Filtro Temporal
                Picker("Filtro", selection: $viewModel.filtroSeleccionado) {
                    ForEach(FiltroTemporal.allCases) { filtro in
                        Text(filtro.rawValue).tag(filtro)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 8)

                // Listado de Eventos
                if eventosFiltrados.isEmpty {
                    ContentUnavailableView {
                        Label(
                            todosLosEventos.isEmpty ? "No hay eventos registrados" : "Sin resultados",
                            systemImage: todosLosEventos.isEmpty ? "calendar.badge.plus" : "magnifyingglass"
                        )
                    } description: {
                        Text(
                            todosLosEventos.isEmpty
                            ? "Presiona el botón '+' para crear tu primer evento con fecha, color e imagen."
                            : "Intenta con otro término de búsqueda o cambia el filtro temporal."
                        )
                    } actions: {
                        if todosLosEventos.isEmpty {
                            Button("Crear Evento de Ejemplo") {
                                insertarEventoEjemplo()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    List {
                        ForEach(eventosFiltrados) { evento in
                            NavigationLink {
                                EventDetailView(evento: evento, viewModel: viewModel)
                            } label: {
                                EventRowView(evento: evento)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    viewModel.eliminarEvento(evento, en: modelContext)
                                } label: {
                                    Label("Eliminar", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    viewModel.prepararEdicion(de: evento)
                                    viewModel.mostrarFormularioCreacion = true
                                } label: {
                                    Label("Editar", systemImage: "pencil")
                                }
                                .tint(.orange)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Event Planner Pro")
            .searchable(
                text: $viewModel.textoBusqueda,
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: "Buscar por título o descripción..."
            )
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.reiniciarFormulario()
                        viewModel.mostrarFormularioCreacion = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $viewModel.mostrarFormularioCreacion) {
                EventFormView(viewModel: viewModel)
            }
        }
    }

    /// Helper opcional para insertar un evento de prueba inicial con un clic
    private func insertarEventoEjemplo() {
        let evento = EventItem(
            titulo: "Conferencia Tech ISIL 2026",
            descripcion: "Exposición de proyectos finales de desarrollo iOS y SwiftData en el auditorio principal.",
            fecha: Date().addingTimeInterval(86400 * 2), // En 2 días
            colorHex: "#34C759"
        )
        modelContext.insert(evento)
        try? modelContext.save()
    }
}
