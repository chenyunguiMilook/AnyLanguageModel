import XCTest
@testable import AnyLanguageModel

final class QwenLanguageModelTests: XCTestCase {
    func testInitialization() {
        let modelID = "qwen-max"
        let apiKey = "test-key"
        let model = QwenLanguageModel(apiKey: apiKey, model: modelID)
        
        XCTAssertEqual(model.model, modelID)
        XCTAssertEqual(model.baseURL, QwenLanguageModel.defaultBaseURL)
    }

    func testCustomBaseURL() {
        let customURL = URL(string: "https://custom.qwen.api/v1/")!
        let model = QwenLanguageModel(baseURL: customURL, apiKey: "key", model: "qwen-plus")
        
        XCTAssertEqual(model.baseURL, customURL)
    }
}
