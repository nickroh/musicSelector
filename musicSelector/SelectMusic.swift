import SwiftUI
import Foundation

struct SelectMusic: View {
    @State var musicList: [musicLabel] = []
    @State var showMusic = false
    @State var selectedMusic: String = ""
    @State var selectedTitle: String = ""
    private var src = MusicSources()
 
    var body: some View {
        VStack{
            NavigationStack {
                List(musicList, id: \.self) { music in
                    Button(action: {
                        selectedMusic = music.url
                        selectedTitle = music.title
                        showMusic.toggle()
                    }, label: {
                        Text(music.title)
                    })
                }
                .navigationDestination(isPresented: $showMusic, destination: {
                    MusicWithFile(musicURL: selectedMusic, musicTitle: selectedTitle)
                })
                .navigationTitle("Music")
            }
            .onAppear {
                 // Fetch music data when the view appears
                 self.musicList = src.getMusic()
             }

        }
        
    }
}
