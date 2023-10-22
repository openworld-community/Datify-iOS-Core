//
//  DtCropView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 28.09.2023.
//

import SwiftUI

struct DtCropView: View {
    @Environment(\.dismiss) var dismiss
    @State private var imageScale: CGFloat = 1
    @State private var previousScale: CGFloat = 0
    @State private var imageOffset: CGSize = .zero
    @State private var previousOffset: CGSize = .zero
    @State private var cropSize: CGSize = .zero
    @State private var commonScale: CGFloat = .zero
    @GestureState private var isInteracting: Bool = false
    var inputUIImage: UIImage?
    var onCrop: (UIImage?) -> Void

    var body: some View {
        NavigationStack {
            imageView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .readSize(onChange: { newSize in
                    cropSize = .init(
                        width: newSize.width * 0.9,
                        height: newSize.width * 0.9 / 0.75
                    )
                    if let inputUIImage {
                        commonScale = min(
                            (inputUIImage.size.width) / cropSize.width,
                            (inputUIImage.size.height) / cropSize.height
                        )
                    }
                })
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.backgroundPrimary, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        guard let inputUIImage else { return }

                        var xOffset = (inputUIImage.size.width - cropSize.width * commonScale / imageScale) / 2 - imageOffset.width * commonScale / imageScale
                        var yOffset = (inputUIImage.size.height - cropSize.height * commonScale / imageScale) / 2 - imageOffset.height * commonScale / imageScale
                        let cropWidth: CGFloat = cropSize.width * commonScale / imageScale
                        let cropHeight: CGFloat = cropSize.height * commonScale / imageScale

                        if xOffset + cropWidth > inputUIImage.size.width {
                            xOffset = inputUIImage.size.width - cropWidth
                        }
                        if yOffset + cropHeight > inputUIImage.size.height {
                            yOffset = inputUIImage.size.height - cropHeight
                        }

                        let cropRect: CGRect = .init(
                            x: xOffset < 0 ? 0 : xOffset,
                            y: yOffset < 0 ? 0 : yOffset,
                            width: cropWidth,
                            height: cropHeight
                        )

                        onCrop(cropImage(image: inputUIImage, cropRect: cropRect))
//                        if let cgImage = inputUIImage.cgImage,
//                           let croppedImage = cgImage.cropping(to: cropRect) {
//                            onCrop(UIImage(cgImage: croppedImage, scale: inputUIImage.scale, orientation: inputUIImage.imageOrientation)/*UIImage(cgImage: croppedImage)*/)
//                        }
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.callout.bold())
                            .foregroundColor(.textPrimary)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.callout.bold())
                            .foregroundColor(.textPrimary)
                    }
                }
            }
        }
    }

    @ViewBuilder
    func imageView() -> some View {
        Group {
            if let inputUIImage {
                Image(uiImage: inputUIImage)
                    .resizableFill()
                    .overlay(content: {
                        GeometryReader { proxy in
                            let rect = proxy.frame(in: .named("CROPVIEW"))

                            Color.clear
                                .onChange(of: isInteracting) { _ in
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if rect.minX > 0 {
                                            imageOffset.width -= rect.minX
                                            // we can add here haptics
                                            // haptics(.medium)
                                        }
                                        if rect.minY > 0 {
                                            imageOffset.height -= rect.minY
                                            // haptics(.medium)
                                        }
                                        if rect.maxX < cropSize.width {
                                            imageOffset.width = rect.minX - imageOffset.width
                                            // haptics(.medium)
                                        }
                                        if rect.maxY < cropSize.height {
                                            imageOffset.height = rect.minY - imageOffset.height
                                            // haptics(.medium)
                                        }
                                    }

                                    previousOffset = imageOffset
                                }
                        }
                    })
                    .frame(width: cropSize.width, height: cropSize.height)
            }
        }
        .scaleEffect(imageScale)
        .offset(imageOffset)
        .coordinateSpace(name: "CROPVIEW")
        .gesture(
            DragGesture()
                .updating($isInteracting, body: { _, out, _ in
                    out = true
                })
                .onChanged { value in
                    imageOffset = CGSize(
                        width: value.translation.width + previousOffset.width,
                        height: value.translation.height + previousOffset.height)
                }
                .onEnded { _ in
                    previousOffset = imageOffset
                }
        )
        .gesture(
            MagnificationGesture()
                .updating($isInteracting, body: { _, out, _ in
                    out = true
                })
                .onChanged { scale in
                    let updatedScale = scale + previousScale
                    imageScale = (updatedScale < 1 ? 1 : updatedScale)
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if imageScale < 1 {
                            imageScale = 1
                            previousScale = 0
                        } else {
                            previousScale = imageScale - 1
                        }
                    }
                }
        )
        .frame(width: cropSize.width, height: cropSize.height)
        .cornerRadius(AppConstants.Visual.cornerRadius)
    }

    private func cropImage(image: UIImage, cropRect: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(cropRect.size, false, 0)
        image.draw(at: CGPoint(x: -cropRect.origin.x, y: -cropRect.origin.y))
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return croppedImage ?? UIImage()
        }
}
