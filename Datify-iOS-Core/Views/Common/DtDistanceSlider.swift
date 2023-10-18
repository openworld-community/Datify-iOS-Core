//
//  DtCustomSlider.swift
//  Datify-iOS-Core
//
//  Created by Илья on 17.10.2023.
//

import SwiftUI

struct DtDistanceSlider: View {

    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedDistance: Int
    @State var offset: CGFloat = -6
    @State var isInitialized: Bool = false
    var body: some View {

        ZStack {
            RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius)
                .foregroundStyle(Color.backgroundSecondary)
                .frame(height: 84)
                .task {
                    try? await Task.sleep(nanoseconds: UInt64(30))
                    isInitialized = true
                }
            if isInitialized {
                VStack {
                        labelStack
                            .frame(height: 15)
                        slider
                            .frame(height: 30)
                }

                .padding(.horizontal)

            }
        }
    }
}

private extension DtDistanceSlider {
    private func getColorSchemeMask() -> some View {
            let gradient = colorScheme == .light ? Color.DtGradient.brandLight : Color.DtGradient.brandDark

            return gradient
                .mask(sliderLayout)
                .mask {
                    HStack {
                        Rectangle().frame(width: offset*2+34)
                            .position(x: 0, y: 5)
                    }
                }

        }

    private func sliderAction(value: DragGesture.Value, step: CGFloat, width: CGFloat) {
        if value.location.x >= 20 && value.location.x <= width {
            switch value.location.x {
            case -10...40:
                offset = -6
                selectedDistance = 5
            case step-10...step+10:
                offset = -16 + step
                selectedDistance = 25
            case step*2-10...step*2+10:
                offset = -16 + step*2
                selectedDistance = 50
            case step*3-10...step*3+10:
                offset = -16 + step*3
                selectedDistance = 100
            case step*4-30...step*4+10:
                offset = -26 + step*4
                selectedDistance = 150
            default: ()
            }
        }
    }

    private var slider: some View {
        GeometryReader { geometry in

            let step = geometry.size.width/4

            ZStack(alignment: .leading) {
                Color.backgroundStroke
                    .mask(sliderLayout)

                getColorSchemeMask()

                Circle()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(Color.white)
                    .overlay {
                        Image(DtImage.strokes)
                    }
                    .shadow(radius: 6, y: 5)
                    .offset(x: offset)
                    .gesture(DragGesture().onChanged {
                        sliderAction(value: $0, step: step, width: geometry.size.width)
                    })

            }
            .task {
                switch selectedDistance {
                case 5: offset = -6
                case 25: offset = step - 16
                case 50: offset = 2*step - 16
                case 100: offset = 3*step - 16
                case 150: offset = 4*step - 26
                default: offset = -6
                }
            }
        }
        .frame(height: 30)
    }

    private var sliderLayout: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .frame(width: .infinity, height: 2)
            HStack {
                ForEach(0..<5) { index in
                    Capsule()
                        .frame(width: 2, height: 10)
                    if index != 4 {
                        Spacer()
                    }
                }
            }
        }
    }

    private var labelStack: some View {
        GeometryReader { geometry in
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                let label1 = "5 km".localize()
                let label2 = "25 km".localize()
                let label3 = "50 km".localize()
                let label4 = "100 km".localize()
                let label5 = "150 km".localize()
                let labelStep = geometry.size.width/4
                HStack {
                    Text(label1)
                    Spacer()
                    Text(label5)
                }
                Text(label2)
                    .offset(x: labelStep - (label2.getSize(fontSize: 14, fontWeight: .medium)/2))
                Text(label3)
                    .offset(x: 2*labelStep - (label3.getSize(fontSize: 14, fontWeight: .medium)/2))
                Text(label4)
                    .offset(x: 3*labelStep - (label4.getSize(fontSize: 14, fontWeight: .medium)/2))

            }
            .dtTypo(.p3Medium, color: .textPrimary)
        }
    }
}

#Preview {
//    DtDistanceSlider(selectedDistance: .constant(50))
    DatingView(router: Router())
}
