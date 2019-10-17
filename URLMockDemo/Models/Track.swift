import Foundation

struct TrackStore: Codable {
    var results: [Track] = []
}

struct Track: Codable {
    var artistName: String
    var trackId: Int
    var trackName: String
}
