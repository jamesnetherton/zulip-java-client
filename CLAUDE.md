# Zulip Java Client - AI Agent Guidelines

This file provides guidance for AI agents when working with code in this repository.

## Build & Test Commands

```bash
# Build
./mvnw clean package

# Run all unit tests
./mvnw test

# Run a single unit test class
./mvnw test -Dtest=ZulipMessageApiTest

# Run integration tests (requires a live Zulip server and zuliprc in project root)
./mvnw verify -Dit.test=ZulipMessageIT

# Format code and sort imports (also runs automatically on compile)
./mvnw formatter:format impsort:sort
```

Integration tests use `assumeTrue` guards and are skipped automatically when no `zuliprc` file is present.

## Architecture

### Entry Point and Services

`Zulip` is the main facade. Users instantiate it with credentials and call service accessors:

```java
Zulip zulip = new Zulip.Builder().email(...).apiKey(...).site(...).build();
zulip.messages().sendStreamMessage(...).execute();
```

Each accessor (`.messages()`, `.streams()`, `.users()`, etc.) lazily instantiates and caches a `*Service` instance. All service classes implement the marker interface `ZulipService`.

### Request Builder Pattern

Every API operation follows this chain:

1. A `*Service` method creates a `*ApiRequest` subclass (which extends `ZulipApiRequest`).
2. Builder methods on the request populate a `params` map via `withParam` / `withOptionalParam`.
3. `.execute()` (from `ExecutableApiRequest<T>`) calls the appropriate verb on `ZulipHttpClient` and returns the typed result.

`ZulipApiRequest` holds the `ZulipHttpClient` reference and the params map. Response classes extend `ZulipApiResponse` and are deserialized from JSON by Jackson.

### HTTP Layer

`ZulipHttpClient` is the interface; `ZulipCommonsHttpClient` (Apache HttpComponents 5.x) is the implementation. It is created by `ZulipCommonsHttpClientFactory` and handles:
- Basic auth (email + API key) using `AuthCache` / `CredentialsProvider`
- Proxy support (optional, via `ZulipConfiguration`)
- SSL customisation: insecure mode (trust-all) or custom trust store via cert bundle
- Rate-limit detection (`ZulipRateLimitExceededException` on HTTP 429)
- File upload via `MultipartEntityBuilder`

`ZulipConfiguration` carries all configuration and is passed into the HTTP client factory.

### Package Layout

```
com.github.jamesnetherton.zulip.client
├── Zulip.java                        # Main entry point / facade
├── api/
│   ├── core/                         # ZulipApiRequest, ExecutableApiRequest, ZulipService
│   ├── message/, stream/, user/, ... # Domain API packages
│   │   ├── *Service.java             # Service facade for each domain
│   │   ├── request/                  # Request builder classes
│   │   └── response/                 # Jackson-deserialized response classes
├── http/
│   ├── ZulipHttpClient.java          # HTTP abstraction interface
│   ├── ZulipHttpClientFactory.java   # Factory interface
│   ├── ZulipConfiguration.java       # Configuration holder (credentials, proxy, SSL)
│   └── commons/                      # Apache HttpComponents implementation
├── exception/                        # ZulipClientException, ZulipRateLimitExceededException
└── util/                             # JsonUtils (Jackson), JwtUtils, ZulipUrlUtils
```

### Testing

Unit tests extend `ZulipApiTestBase`, which starts a WireMock server before each test class and configures a `Zulip` client pointed at it. Tests stub responses using `stubZulipResponse()` helpers backed by JSON fixture files in `src/test/resources/`. `UrlEncodedEntityMatcher` is a custom WireMock matcher for verifying form-encoded request bodies.

The `EmojiEnumGenerator` test generates `Emoji.java` from the upstream Zulip emoji map; run it manually with `-Demoji.generate` when Zulip adds new emojis.
