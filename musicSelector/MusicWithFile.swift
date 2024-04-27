import AVFoundation
import SwiftUI

struct MusicWithFile: View {
    @State private var artistName = ""
    @State private var coverImage: UIImage?

    @State var width: Double = 0
    @State var width1: Double = 100
    
    @State var player: playerModel?
    
    @State var playerItem: AVPlayerItem?
    @State var playerQueue: AVQueuePlayer?
    @State var looper: AVPlayerLooper?
    
    @State var duration: Double = 0.0
    @State var scale: Double = 0.0
    @State var currentTime: String = ""
    
    private let musicTitle: String
    private let musicURL: String
    
    private let fullWidth = UIScreen.main.bounds.width
    private let fullHeight = UIScreen.main.bounds.height
    
    private let formatter = DateComponentsFormatter()

    @State var isloading = true
    
    init(musicURL: String, musicTitle: String){
        self.musicURL = musicURL
        self.musicTitle = musicTitle
        
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
    }
    
    var body: some View {
        ZStack{
            if isloading {
                ProgressView()
            } else {
                if let cover = coverImage {
                    ZStack {
                        Rectangle()
                            .fill(.ultraThickMaterial)
                            .overlay(content: {
                                Rectangle()
                                Image(uiImage: coverImage!)
                                    .resizable()
                                    .blur(radius: 30)
                                //.opacity(0.5)
                            })
                        VStack {
                            Spacer()
                                .frame(height: 150)
                            Image(uiImage: coverImage!)
                                .resizable()
                                .frame(width: 300, height: 300)
                            Spacer()
                                .frame(height: 40)
                            HStack {
                                Spacer()
                                    .frame(width: 25)
                                Text(musicTitle)
                                    .frame(alignment: .leading)
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 26))
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                    .frame(width: 25)
                                Text(artistName)
                                    .frame(alignment: .leading)
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 15))
                                    .padding()
                                Spacer()
                            }
                            
                            Text(currentTime)

                            Spacer()
                                .frame(height: 50)
                            rangeSlider(width1: $width1, width: $width)
                            Spacer()
                        }
                       
                    }
                    .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                        currentTime = String(playerQueue?.currentTime().seconds ?? 0)
                    }
                    .onChange(of: width, {
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
                        
                    })
                    .onChange(of: width1, {
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
                    })
                    .edgesIgnoringSafeArea(.all)
                        
                } else {
                    ProgressView()
                }
            }
        }
        .onAppear {
            testFunc()
            //downloadAndExtractMetadata(musicURL: musicURL)
        }
    }
    
    
    func testFunc() {

        guard let url = URL(string: musicURL) else {
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
                        self.coverImage = image
                        print("success1")
                    }
                } else {
                    print("Cover image not found in metadata")
                }

                if let artistItem = metadata.first(where: { $0.commonKey == .commonKeyArtist }),
                   let artistName = try await artistItem.load(.stringValue) {
                    DispatchQueue.main.async {
                        self.artistName = artistName
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
