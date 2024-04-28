import AVFoundation
import SwiftUI

struct rangeSlider: View {
    @Binding var width1: Double
    @Binding var width: Double
    @Binding var progress: Double
    
    @State var circle: Double = 0
    @State var circle2: Double = 100
    
    init(width1: Binding<Double>, width: Binding<Double>, progress: Binding<Double>) {
        self._width1 = width1
        self._width = width
        self._progress = progress
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            Rectangle()
                .fill(Color.black.opacity(0.20))
                .frame(width: 325, height: 6)
            
            Rectangle()
                .fill(Color.white.opacity(0.60))
                .offset(x: self.circle + 18)
                .frame(width: self.circle2 - self.circle + 18, height: 6)
            
            Rectangle()
                .fill(Color.green.opacity(0.60))
                .offset(x: self.circle + 18)
                .frame(width: progress - self.circle > 0 ? progress - self.circle : 0, height: 6)
            
            HStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 18, height: 18)
                    .offset(x: self.circle)
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                if value.location.x >= 0 && value.location.x <= self.circle2 - 30{
                                    self.circle = value.location.x
                                }
                            })
                            .onEnded({ _ in
                                width = circle
                            })
                    )
                Circle()
                    .fill(Color.white)
                    .frame(width: 18, height: 18)
                    .offset(x: self.circle2 - 5)
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                if value.location.x <= 290 && value.location.x >= self.circle + 30 {
                                    self.circle2 = value.location.x
                                }
                            })
                            .onEnded({ _ in
                                width1 = circle2
                            })
                    )
            }
        }

    }
}
