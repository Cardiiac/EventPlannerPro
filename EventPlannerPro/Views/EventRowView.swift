//
//  EventRowView.swift
//  EventPlannerPro
//
//  Created for Evaluación Continua PA3 - Pregunta 4
//

import SwiftUI

struct EventRowView: View {
    let evento: EventItem

    var body: some View {
        HStack(spacing: 14) {
            // Indicador de imagen o ícono con color representativo
            if let data = evento.imagenData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 58, height: 58)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(evento.color, lineWidth: 2)
                    )
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(evento.color.opacity(0.18))
                        .frame(width: 58, height: 58)

                    Image(systemName: "calendar")
                        .font(.title3)
                        .foregroundStyle(evento.color)
                }
            }

            // Datos del evento
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(evento.titulo)
                        .font(.headline)
                        .lineLimit(1)

                    Spacer()

                    // Píldora de estado si el evento ya venció
                    if evento.yaPaso {
                        Text("Pasado")
                            .font(.caption2.bold())
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.gray.opacity(0.2))
                            .foregroundStyle(.secondary)
                            .clipShape(Capsule())
                    }
                }

                Text(evento.fechaFormateada)
                    .font(.caption)
                    .foregroundStyle(evento.color)
                    .bold()

                if !evento.descripcion.isEmpty {
                    Text(evento.descripcion)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
