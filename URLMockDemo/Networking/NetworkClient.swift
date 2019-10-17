import Foundation

class NetworkClient {

    private var session: URLSessionProtocol

    init(withSession session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func searchItunes(url: URL, completion: @escaping  (_ trackStore: TrackStore?, _ errorMessage: String?) -> Void) {

        let dataTask = session.dataTask(with: url) { (data, response, error) in

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                return
            }

            guard let data = data else {
                completion(nil, "No Data")
                return
            }

            switch statusCode {
            case 200:
                let trackStore = try! JSONDecoder().decode(TrackStore.self, from: data)
                completion(trackStore, nil)
            case 404:
                completion(nil, "Bad Url")
            default:
                completion(nil, "statusCode: \(statusCode)")
            }
        }

        dataTask.resume()
    }
}
