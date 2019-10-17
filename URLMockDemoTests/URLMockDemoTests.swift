import XCTest
@testable import URLMockDemo

class URLMockDemoTests: XCTestCase {

    var sut: NetworkClient!
    var mockSession: MockURLSession!

    override func tearDown() {
        sut = nil
        mockSession = nil
        super.tearDown()
    }

    func testNetworkClient_successResult() {

        mockSession = createMockSession(fromJsonFile: "Search", andStatusCode: 200, andError: nil)
        sut = NetworkClient(withSession: mockSession)

        sut.searchItunes(url: URL(string: "TestUrl")!) { (trackStore, errorMessage) in

            XCTAssertNotNil(trackStore)
            XCTAssertNil(errorMessage)

            XCTAssertTrue(trackStore!.results.count == 1)

            let track = trackStore!.results.first!
            XCTAssertTrue(track.trackName == "Breathe")
        }
    }

    func testNetworkClient_404Result() {

        mockSession = createMockSession(fromJsonFile: "Search", andStatusCode: 404, andError: nil)
        sut = NetworkClient(withSession: mockSession)

        sut.searchItunes(url: URL(string: "TestUrl")!) { (trackStore, errorMessage) in

            XCTAssertNotNil(errorMessage)
            XCTAssertNil(trackStore)
            XCTAssertTrue(errorMessage == "Bad Url")
        }
    }

    func testNetworkClient_NoData() {

        mockSession = createMockSession(fromJsonFile: "A", andStatusCode: 500, andError: nil)
        sut = NetworkClient(withSession: mockSession)

        sut.searchItunes(url: URL(string: "TestUrl")!) { (trackStore, errorMessage) in

            XCTAssertNotNil(errorMessage)
            XCTAssertNil(trackStore)
            XCTAssertTrue(errorMessage == "No Data")
        }
    }

    func testNetworkClient_AnotherStatusCode() {

        mockSession = createMockSession(fromJsonFile: "Search", andStatusCode: 401, andError: nil)
        sut = NetworkClient(withSession: mockSession)

        sut.searchItunes(url: URL(string: "TestUrl")!) { (trackStore, errorMessage) in

            XCTAssertNotNil(errorMessage)
            XCTAssertNil(trackStore)
            XCTAssertTrue(errorMessage == "statusCode: 401")
        }
    }

    private func loadJsonData(file: String) -> Data? {

        if let jsonFilePath = Bundle(for: type(of: self)).path(forResource: file, ofType: "json") {
            let jsonFileURL = URL(fileURLWithPath: jsonFilePath)

            if let jsonData = try? Data(contentsOf: jsonFileURL) {
                return jsonData
            }
        }
        return nil
    }

    private func createMockSession(fromJsonFile file: String,
                                   andStatusCode code: Int,
                                   andError error: Error?) -> MockURLSession? {

        let data = loadJsonData(file: file)
        let response = HTTPURLResponse(url: URL(string: "TestUrl")!, statusCode: code, httpVersion: nil, headerFields: nil)
        return MockURLSession(completionHandler: (data, response, error))
    }
}
