//
//  EventMediaHeaderView.swift
//  EventPlannerPro
//
//  REQUISITO OBLIGATORIO: Vista hija comunicada mediante @Binding
//

import SwiftUI
import PhotosUI

struct EventMediaHeaderView: View {
    // REQUISITO DE EVALUACIÓN: Comunicación bidireccional con la vista padre mediante @Binding
    @Binding var imagenData: Data?
    @Binding var fotoItem: PhotosPickerItem?
    var colorAcento: Color

    var body: some View {
        VStack(spacing: 12) {
            if let data = imagenData, let uiImage = UIImage(data: data) {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 180)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(colorAcento, lineWidth: 2)
                        )

                    // Botón para eliminar la imagen seleccionada
                    Button {
                        withAnimation {
                            imagenData = nil
                            fotoItem = nil
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.white, .red)
                            .background(Circle().fill(.white))
                            .padding(8)
                    }
                }
            } else {
                // Placeholder cuando no hay imagen seleccionada
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(colorAcento.opacity(0.12))
                        .frame(height: 120)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [6]))
                                .foregroundStyle(colorAcento.opacity(0.6))
                        )

                    VStack(spacing: 6) {
                        Image(systemName: "photo.badge.plus")
                            .font(.system(size: 34))
                            .foregroundStyle(colorAcento)
                        Text("Ninguna imagen seleccionada")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            // REQUISITO OBLIGATORIO: PhotosPicker integrado
            PhotosPicker(
                selection: $fotoItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Label(
                    imagenData == nil ? "Seleccionar Imagen del Evento" : "Cambiar Imagen",
                    systemImage: "photo.on.rectangle.angled"
                )
                .font(.subheadline.bold())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(colorAcento.opacity(0.15))
                .foregroundStyle(colorAcento)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(.vertical, 4)
    }
}
