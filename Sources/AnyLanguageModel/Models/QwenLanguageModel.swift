import Foundation
import JSONSchema

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

/// A language model that connects to Qwen (DashScope) APIs.
///
/// Use this model to generate text using Alibaba Cloud's Qwen models.
/// This model uses the DashScope OpenAI-compatible API.
///
/// ```swift
/// let model = QwenLanguageModel(
///     apiKey: "your-api-key",
///     model: "qwen-max"
/// )
/// ```
public struct QwenLanguageModel: LanguageModel {
    /// The reason the model is unavailable.
    /// This model is always available.
    public typealias UnavailableReason = Never

    /// The default base URL for Qwen's DashScope compatible API.
    public static let defaultBaseURL = URL(string: "https://dashscope.aliyuncs.com/compatible-mode/v1/")!

    /// Custom generation options specific to Qwen models.
    ///
    /// Qwen uses the same options as OpenAI-compatible APIs.
    public typealias CustomGenerationOptions = OpenAILanguageModel.CustomGenerationOptions

    private let underlyingModel: OpenAILanguageModel

    /// The base URL for the API endpoint.
    public var baseURL: URL { underlyingModel.baseURL }

    /// The model identifier to use for generation.
    public var model: String { underlyingModel.model }

    /// The availability of the model.
    public var availability: Availability<Never> { .available }

    /// Creates a Qwen language model.
    ///
    /// - Parameters:
    ///   - baseURL: The base URL for the API endpoint. Defaults to DashScope's official OpenAI-compatible API.
    ///   - apiKey: Your DashScope API key or a closure that returns it.
    ///   - model: The model identifier (for example, "qwen-max", "qwen-plus").
    ///   - session: The URL session to use for network requests.
    public init(
        baseURL: URL = defaultBaseURL,
        apiKey tokenProvider: @escaping @autoclosure @Sendable () -> String,
        model: String,
        session: URLSession = URLSession(configuration: .default)
    ) {
        self.underlyingModel = OpenAILanguageModel(
            baseURL: baseURL,
            apiKey: tokenProvider(),
            model: model,
            apiVariant: .chatCompletions,
            session: session
        )
    }

    public func respond<Content>(
        within session: LanguageModelSession,
        to prompt: Prompt,
        generating type: Content.Type,
        includeSchemaInPrompt: Bool,
        options: GenerationOptions
    ) async throws -> LanguageModelSession.Response<Content> where Content: Generable {
        // Map any Qwen-specific options to the underlying OpenAI model
        var options = options
        if let qwenOptions = options[custom: QwenLanguageModel.self] {
            options[custom: OpenAILanguageModel.self] = qwenOptions
        }

        return try await underlyingModel.respond(
            within: session,
            to: prompt,
            generating: type,
            includeSchemaInPrompt: includeSchemaInPrompt,
            options: options
        )
    }

    public func streamResponse<Content>(
        within session: LanguageModelSession,
        to prompt: Prompt,
        generating type: Content.Type,
        includeSchemaInPrompt: Bool,
        options: GenerationOptions
    ) -> sending LanguageModelSession.ResponseStream<Content> where Content: Generable {
        // Map any Qwen-specific options to the underlying OpenAI model
        var options = options
        if let qwenOptions = options[custom: QwenLanguageModel.self] {
            options[custom: OpenAILanguageModel.self] = qwenOptions
        }

        return underlyingModel.streamResponse(
            within: session,
            to: prompt,
            generating: type,
            includeSchemaInPrompt: includeSchemaInPrompt,
            options: options
        )
    }
}
