import SwiftUI

struct MusicINFO {
    public var artistName: String = ""
    public var coverImage: UIImage?
    public let musicTitle: String
    public let musicURL: String
    
    init(musicTitle: String, musicURL: String) {
        self.musicTitle = musicTitle
        self.musicURL = musicURL
    }
}
