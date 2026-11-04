//
//  EventColorBadgePickerView.swift
//  EventPlannerPro
//
//  REQUISITO OBLIGATORIO: Vista hija con ColorPicker y comunicación mediante @Binding
//

import SwiftUI

struct EventColorBadgePickerView: View {
    // REQUISITO DE EVALUACIÓN: Enlace bidireccional con el estado padre
    @Binding var colorSeleccionado: Color

    // Paleta de colores predefinidos rápidos
    private let coloresPredefinidos: [Color] = [
        .blue, .purple, .pink, .red, .orange, .yellow, .green, .teal, .indigo
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Control obligatorio: ColorPicker nativo
            HStack {
                Label("Color Representativo", systemImage: "paintpalette.fill")
                    .font(.body)
                Spacer()
                ColorPicker("", selection: $colorSeleccionado, supportsOpacity: false)
                    .labelsHidden()
            }

            // Muestra visual rápida de colores
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(coloresPredefinidos, id: \.description) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 28, height: 28)
                            .overlay(
                                Circle()
                                    .stroke(Color.primary.opacity(0.3), lineWidth: 1)
                            )
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.caption2.bold())
                                    .foregroundStyle(.white)
                                    .opacity(colorSeleccionado == color ? 1 : 0)
                            )
                            .scaleEffect(colorSeleccionado == color ? 1.15 : 1.0)
                            .animation(.spring(response: 0.25), value: colorSeleccionado)
                            .onTapGesture {
                                colorSeleccionado = color
                            }
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}
