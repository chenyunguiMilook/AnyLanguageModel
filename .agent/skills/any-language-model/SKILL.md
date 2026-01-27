# Language Model Abstraction (AnyLanguageModel)

This skill provides expert knowledge on generating text, structured data, and managing LLM interactions using the `AnyLanguageModel` framework. Use this to integrate AI features like content generation, semantic search, or automated tool execution.

## Core Responsibilities
- **Model Interop**: Abstract away specific provider APIs (OpenAI, Gemini, etc.) into a unified Swift interface.
- **Structured Generation**: Use `@Generable` to force models to return data matching Swift structs.
- **Session Management**: Handle conversation history, prompt prefixes, and context windows.
- **Tool Dispatch**: Orchestrate the execution of local Swift functions triggered by LLM calls.

## Generation Workflow
1. **Define Schema**: Create a `@Generable` struct for the desired output.
2. **Setup Session**: Initialize a `LanguageModelSession`.
3. **Execute**: Call `model.respond(within: session, to: prompt, generating: MyStruct.self)`.

## Common Procedures

### Implementing a Custom Model
To add support for a new LLM provider, create a type implementing the `LanguageModel` protocol. Pay special attention to handles `Transcript` conversion and `GenerationSchema` embedding.

### Using Tools
Tools must be provided in `GenerationOptions`:
```swift
let options = GenerationOptions(tools: [myWeatherTool])
let response = try await model.respond(to: "What's the weather?", options: options)
```

### Prompt Engineering
Use `Prompt.Entry` types (`.user`, `.assistant`, `.system`) to build complex conversation states.

## Reference Commands
- Build (Catalyst): `xcodebuild -scheme AnyLanguageModel -destination "generic/platform=macOS,variant=Mac Catalyst" build`
- Run Tests: `swift test`
