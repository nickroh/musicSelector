import AVFoundation
import SwiftUI

struct ContentView: View {
    @State var showMusic = false
    
    var body: some View {
        
        VStack {
            Button {
                showMusic.toggle()
            } label: {
                Text("music")
            }

        }
        .fullScreenCover(isPresented: $showMusic) {
            SelectMusic()
        }
        .padding()
        
    }
}

#Preview {
    ContentView()
}
