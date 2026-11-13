# Implementation conventions

How each kind of API change has been implemented in past upgrades. Copy the closest existing
example rather than writing from scratch; the classes named below are good templates.
`git show 6aac571` (Zulip 12) and `git show 929efe3` (Zulip 11) are complete worked upgrades.

Base path: `src/main/java/com/github/jamesnetherton/zulip/client/api/`

## New endpoint

1. **Path constant** in `<domain>/request/<Domain>RequestConstants.java`. Path params use
   `%s` placeholders formatted in `execute()` (wrap values with `ZulipUrlUtils.pathSegment`).
2. **Request** `<domain>/request/<Verb><Thing>ApiRequest.java` extends `ZulipApiRequest`
   implements `ExecutableApiRequest<T>`. Required args go in the constructor via `putParam`;
   optional ones become `withX(...)` builder methods via `putParam` (or `putParamAsJsonString`
   for lists/objects) and return `this`. Javadoc `@see <a href="https://zulip.com/api/<operationId>">` on the class.
   `spec_report.sh` matches classes to spec operations through these links, so the slug must be
   the exact operationId from the spec.
   - For endpoints that return only `result`/`msg`, implement `VoidExecutableApiRequest` instead
     (template: `server/request/DeleteProfileFieldApiRequest.java`). Otherwise return the domain
     object or a scalar (template: `message/request/CheckThumbnailStatusApiRequest.java`).
3. **Response** `<domain>/response/<Verb><Thing>ApiResponse.java` extends `ZulipApiResponse`,
   fields annotated `@JsonProperty` (snake_case mapping is global; field names are camelCase).
   Skip it when the endpoint returns nothing beyond `result`/`msg` (use `ZulipApiResponse`).
4. **Service method** on `<Domain>Service.java`, with javadoc mirroring the others (`@see` link,
   `@param`, `@return`). Place it near related methods.
5. **HTTP verb**: `client().get/post/patch/put/delete/upload`. PUT support was added in Zulip 12;
   if a new verb or body type is needed, update `ZulipHttpClient`, `ZulipCommonsHttpClient`,
   the delegating client in `ZulipIntegrationTestBase`, `CustomZulipHttpClientTest`, and the
   `HttpMethod` enum in `ZulipApiTestBase`.

## New request parameter

Add a constant to the request class (`private static final String FOO = "foo";`) and a
`withFoo(...)` method. For enums sent to the server, pass the enum's wire value
(see how `WebHomeView` / `DataExportType` are sent).

## New response field / model property

Add a `@JsonProperty` field plus getter to the model (`User`, `Stream`, `Message`, ...) or to
`*ApiResponse`. Booleans use `isX()`. If the model is also built from another response
(e.g. `UserApiResponse` → `User`), wire the field through there too. Update the JSON fixture in
`src/test/resources/.../api/<domain>/` so the unit test asserts the new value.

## New enum value

Add the constant to the enum. Check how that enum deserialises: some have an `UNKNOWN` fallback,
others will fail on a value they don't know, which makes a missing constant a runtime bug.

## Breaking change (removal / rename / type change)

The project removes things outright in the major-version commit; there is no deprecation cycle.
- Delete the method/field/class/enum constant (or rename it to match the new API name).
- Fix every caller in main and test code.
- Add one bullet per change under **Breaking changes** in `CHANGELOG.adoc`, naming the old and
  new API exactly (see the 0.10.0 section for the house style).

## New event type

Add an `Event` subclass named `<PascalCaseType>Event` in `api/event` if the payload is useful,
compile, then bump `ZULIP_OPENAPI_YAML` in `EventTypeEnumGenerator` and run
`./mvnw test -Dtest=EventTypeEnumGenerator -Devent.type.generate`.

## Tests

- **Unit** (`src/test/java/.../api/<domain>/Zulip<Domain>ApiTest.java`): stub with
  `stubZulipResponse(METHOD, path, params, "fixture.json")`, call the API, assert the result.
  Params in the stub are matched against the form body, so they verify the wire names.
  Fixture JSON lives next to the others for that domain and mirrors the example response
  from https://zulip.com/api/<slug>.
  Tests that need a file (uploads) create it under a JUnit `@TempDir` parameter, not with
  `Files.createTempFile`, so it's removed when the test ends. Multipart stubs
  (`stubMultiPartZulipResponse`) match the `files` part's content type and a body of `test content`.
- **Integration** (`src/test/java/.../api/integration/<domain>/Zulip<Domain>IT.java`): exercise
  the call against the Docker server where it's feasible (no OAuth, mobile push or external
  services). The IT harness throws if the server reports `ignored_parameters_unsupported`,
  which catches parameters Zulip has removed or renamed.
