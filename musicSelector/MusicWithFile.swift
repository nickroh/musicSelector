import AVFoundation
import SwiftUI

struct MusicWithFile: View {
    @State private var musicINFO: MusicINFO
    
    @State var width: Double = 0
    @State var width1: Double = 100
    @State var duration: Double = 0.0
    @State var scale: Double = 0.0
    @State var progress: Double = 0.0
    
    @State var playerItem: AVPlayerItem?
    @State var playerQueue: AVQueuePlayer?
    @State var looper: AVPlayerLooper?
    
    @State var isloading = true
    
    private let fullWidth = UIScreen.main.bounds.width
    private let fullHeight = UIScreen.main.bounds.height

    init(musicURL: String, musicTitle: String){
        musicINFO = MusicINFO(musicTitle: musicTitle, musicURL: musicURL)
    }
    
    var body: some View {
        ZStack{
            if isloading {
                ProgressView()
            } else {
                if let cover = musicINFO.coverImage {
                    ZStack {
                        Rectangle()
                            .fill(.ultraThickMaterial)
                            .overlay(content: {
                                Rectangle()
                                Image(uiImage: cover)
                                    .resizable()
                                    .blur(radius: 30)
                                //.opacity(0.5)
                            })
                        VStack {
                            Spacer()
                                .frame(height: 150)
                            Image(uiImage: cover)
                                .resizable()
                                .frame(width: 300, height: 300)
                            Spacer()
                                .frame(height: 40)
                            HStack {
                                Spacer()
                                    .frame(width: 25)
                                Text(musicINFO.musicTitle)
                                    .frame(alignment: .leading)
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 26))
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                    .frame(width: 25)
                                Text(musicINFO.artistName)
                                    .frame(alignment: .leading)
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 15))
                                    .padding()
                                Spacer()
                            }
                            
                            Text("\(progress * scale)")

                            Spacer()
                                .frame(height: 50)
                            rangeSlider(width1: $width1, width: $width, progress: $progress)
                            Spacer()
                        }
                       
                    }
                    .onReceive(Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()) { _ in
                        progress = (playerQueue?.currentTime().seconds ?? 0) / scale
                    }
                    .onChange(of: width, {
                        restartMusic()
                    })
                    .onChange(of: width1, {
                        restartMusic()
                    })
                    .edgesIgnoringSafeArea(.all)
                        
                } else {
                    ProgressView()
                }
            }
        }
        .onAppear {
            testFunc()
        }
    }
    
    
    func restartMusic() {
        self.playerQueue?.pause()
        self.playerQueue?.removeAllItems()
        
        self.looper = nil
        if let item = playerItem {
            if let queue = playerQueue {
                let range = CMTimeRange(start: CMTime(seconds: width * scale, preferredTimescale: 600), end: CMTime(seconds: width1 * scale, preferredTimescale: 600))
                self.looper = AVPlayerLooper(player: queue, templateItem: item, timeRange: range)
                self.playerQueue?.play()
                self.playerQueue?.volume = 0.5
            }
            
        }
    }
    
    func testFunc() {
        guard let url = URL(string: musicINFO.musicURL) else {
            print("Invalid URL")
            return
        }
        Task {
            do {
                let item = AVPlayerItem(url: url)
                self.playerItem = item
                let metadata = try await item.asset.load(.metadata)
                if let artwork = metadata.first(where: { $0.commonKey == .commonKeyArtwork }),
                   let imageData = try await artwork.load(.dataValue),
                   let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.musicINFO.coverImage = image
                        print("success1")
                    }
                } else {
                    print("Cover image not found in metadata")
                }

                if let artistItem = metadata.first(where: { $0.commonKey == .commonKeyArtist }),
                   let artistName = try await artistItem.load(.stringValue) {
                    DispatchQueue.main.async {
                        self.musicINFO.artistName = artistName
                        print("success2")
                    }
                } else {
                    print("Artist name not found in metadata")
                }
                
                let audioDuration = try await item.asset.load(.duration)
                self.duration = audioDuration.seconds
                self.scale = duration / 290
                print("duration: ", duration)
                
                self.playerQueue = AVQueuePlayer(items: [item])
                if let queue = playerQueue {
                    let range = CMTimeRange(start: CMTime(seconds: width * scale, preferredTimescale: 600), end: CMTime(seconds: width1 * scale, preferredTimescale: 600))
                    self.looper = AVPlayerLooper(player: queue, templateItem: item, timeRange: range)
                    self.playerQueue?.play()
                    self.playerQueue?.volume = 0.5
                    self.isloading = false
                }

            } catch {
                print("Error extracting metadata: \(error.localizedDescription)")
            }
        }
    }
  
}
