# AnyLanguageModel — Copilot Instructions

## Project Context
`AnyLanguageModel` is a Swift package that provides a standardized abstraction layer for Large Language Models (LLMs), designed as a drop-in replacement for Apple's Foundation Models framework. It allows developers to switch between different LLM backends (local or remote) without changing their business logic.

## Core Architecture
- **LanguageModel Protocol**: The central interface for interacting with any LLM.
- **Generable Protocol**: A macro-powered system for defining structured output schemas.
- **LanguageModelSession**: Manages the state, context, and conversation history.
- **Tool System**: Allows models to perform actions via local tool definitions.

## Key Patterns
- **Protocol-Oriented**: All specific model implementations (OpenAI, Anthropic, Local) must conform to the `LanguageModel` protocol.
- **Structured Outputs**: Uses Swift macros (`@Generable`) to generate JSON schemas that guide the model to return specifically typed data.
- **Streaming Support**: First-class support for `ResponseStream<Content>` for real-time UI updates.

## Building & Testing
- **SwiftPM**: `swift build`
- **Mac Catalyst**: `xcodebuild -scheme AnyLanguageModel -destination "generic/platform=macOS,variant=Mac Catalyst" build`
- **Tests**: `swift test` (verifies prompt construction, tool dispatch, and serialization).

## Guidelines for Changes
- **Swift 6 Concurrency**: The package is fully `Sendable` and handles strict concurrency. Ensure all protocol methods maintain these safety guarantees.
- **Schema Evolution**: When modifying `GenerationSchema`, ensure backward compatibility for session transcripts.
- **Foundation Compatibility**: Maintain 1:1 API parity with Apple's `FoundationModels` where possible to minimize migration friction.

## Common Tasks
- **Implementing a Backend**: Create a new type conforming to `LanguageModel` and implement `respond` and `streamResponse`.
- **Defining a Tool**: Create a type conforming to `Tool` with a `@Generable` arguments struct.
- **Creating a Session**: `let session = LanguageModelSession()`.
