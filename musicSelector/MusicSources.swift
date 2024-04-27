import Foundation
import SwiftUI

struct MusicSources {
    
    private var musicData: [musicLabel] = [
        musicLabel(url: "https://s3.amazonaws.com/bucket.zippercorp.com/static/music/testtrack/SPYAIR+-+Sakuramitsutsuki.mp3", title: "SPYAIR / Sakuramitsutsuki"),
        musicLabel(url: "https://s3.amazonaws.com/bucket.zippercorp.com/static/music/testtrack/%E1%84%80%E1%85%AC%E1%84%86%E1%85%AE%E1%86%AF+(%E6%80%AA%E7%89%A9).mp3", title: "Yoasobi / Monster"),
        musicLabel(url: "https://s3.amazonaws.com/bucket.zippercorp.com/static/music/testtrack/%E7%B1%B3%E6%B4%A5%E7%8E%84%E5%B8%AB++Kenshi+Yonezu+-+LADY.mp3", title: "Yonezu Kenshi / Lady"),
        musicLabel(url: "https://s3.amazonaws.com/bucket.zippercorp.com/static/music/testtrack/%E7%B1%B3%E6%B4%A5%E7%8E%84%E5%B8%AB+-+%E3%83%92%E3%82%9A%E3%83%BC%E3%82%B9%E3%82%B5%E3%82%A4%E3%83%B3+%2C+Kenshi+Yonezu+-+Peace+Sign.mp3", title: "Yonezu Kenshi / Peace Sign"),
        musicLabel(url: "https://s3.amazonaws.com/bucket.zippercorp.com/static/music/testtrack/%E7%B1%B3%E6%B4%A5%E7%8E%84%E5%B8%AB++-+orion.mp3", title: "Yonezu Kenshi / Orion")
        
    ]
    
    public func getMusic() -> [musicLabel] {
        print("size of music Data is : \(musicData.count)")
        return self.musicData
    }
    
}

struct musicLabel: Hashable {
    init(url: String, title: String) {
        self.url = url
        self.title = title
    }
    let url: String
    let title: String
}
