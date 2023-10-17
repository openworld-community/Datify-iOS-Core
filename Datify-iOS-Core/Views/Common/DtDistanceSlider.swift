//
//  DtCustomSlider.swift
//  Datify-iOS-Core
//
//  Created by Илья on 17.10.2023.
//

import SwiftUI

struct DtDistanceSlider: View {
    @Binding var selectedDistance: Int
    @State var offset: CGFloat = -6

    init(selectedDistance: Binding<Int>, offset: CGFloat = -6) {
        _selectedDistance = selectedDistance
        self.offset = offset
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius)
                .foregroundStyle(Color.backgroundSecondary)
                .frame(height: 84)
            VStack(alignment: .center) {
                HStack(alignment: .center) {
                    Text("5 km")
                    Spacer()
                    Text("25 km")
                    Spacer()
                    Text("50 km")
                        .offset(x: 10.0)
                    Spacer()
                    Text("100 km")
                        .offset(x: 17.5)
                    Spacer()
                    Text("150 km")
                }
                .dtTypo(.p3Medium, color: .textPrimary)
                .padding(.horizontal)
                slider
            }

        }
    }

}

private extension DtDistanceSlider {
    var slider: some View {
        GeometryReader { geometry in
            let step = geometry.size.width/4
            VStack(alignment: .center) {
                ZStack(alignment: .leading) {
                    sliderLayout
                        .foregroundStyle(Color.backgroundStroke)

                    Color.DtGradient.brandLight
                        .mask(sliderLayout)
                        .mask {
                            HStack {
                                Rectangle().frame(width: offset*2+34)
                                    .position(x: 0, y: 5)
                            }
                        }
                    ZStack {
                        Circle()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(Color.backgroundPrimary)
                            .overlay {
                                Image("strokes")
                            }
                            .shadow(radius: 6, y: 5)
                            .offset(x: offset)
                            .gesture(DragGesture().onChanged { value in
                                if value.location.x >= 20 && value.location.x <= geometry.size.width {
                                    switch value.location.x {
                                    case -10...40:
                                        offset = -6
                                        selectedDistance = 5
                                    case step-10...step+10:
                                        offset = -11 + step
                                        selectedDistance = 25
                                    case step*2-10...step*2+10:
                                        offset = -16 + step*2
                                        selectedDistance = 50
                                    case step*3-10...step*3+10:
                                        offset = -21 + step*3
                                        selectedDistance = 100
                                    case step*4-30...step*4+10:
                                        offset = -26 + step*4
                                        selectedDistance = 150
                                    default: ()
                                    }
                                }
                            })
                    }
                }
            }

        }
        .padding(.horizontal)
        .frame(height: 30)
    }

    var sliderLayout: some View {
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
}

#Preview {
    DtDistanceSlider(selectedDistance: .constant(5))
}
