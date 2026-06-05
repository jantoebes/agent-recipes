# Kotlin Spring Boot Backend — Recipe

## Package Structure

Use feature-based packaging. Each feature is a top-level subpackage with internal layers:

```
feature/
├── consumer/    — Kafka consumers
├── producer/    — Kafka producers
├── service/     — Business logic
├── mapper/      — Mappie mappers
├── controller/  — REST endpoints
├── repo/
│   ├── rec/     — Database records (data classes)
│   └── table/   — Table objects (name + column constants)
└── model/       — Domain models
```

Subfolders are optional; put cross-cutting concerns (config, security, DB setup) in `shared/`.

## Code

General Kotlin rules:
- Never use `!!` to suppress types
- Never use `as` casts — use `is` smart casts, `when` exhaustiveness, or generics
- Never use `@Suppress("UNCHECKED_CAST")` — fix the root cause with generics or type-safe alternatives

**Database:**
- Never use `DEFAULT` in Flyway migrations for values the backend can determine (e.g. `now()`, UUIDs)

**Domain models:**
- Use `data class` for records and models
- Use `object` for pure utilities
- No inheritance in the domain layer

**Arrow error handling:**

Log at the origin. Use `Either` only to carry "stop" through a pipeline. No error hierarchy unless the call site needs a different path per type (retry, HTTP status, log level).

```kotlin
// either {} with .bind(), ensureNotNull() and raise()
either {
    val item = ensureNotNull(repo.findById(id)) { logger.error { "Item $id not found" }; SkipMarker }
    ensure(item.isValid) { ValidationError("...") }
    process(item)
}

// Either.catch with .onLeft logging
Either.catch { externalCall() }
    .onLeft { e -> logger.error(e) { "Call failed for $id" } }

// either with .fold for branching
either<ErrorType, Result> { compute() }
    .fold(ifLeft = { fallback(it) }, ifRight = { it })

// nullable {} for optional chains
nullable {
    val a = source.fieldA.bind()
    val b = source.fieldB.bind()
    Combined(a, b)
}

// option {} with .getOrNull() fallback
option { original.copy(extra = repo.findExtra(id).bind()) }.getOrNull() ?: original
```

Rules:
- Prefer `ensureNotNull()` over `?: raise()`
- Use sealed class errors only when the call site needs a different path per type
- Define skip markers as `private data object Skip`

**Transaction scoping via context receivers:**

Repo methods declare scope as a context receiver; services open a block via `tx.write {}` or `tx.read {}`:

```kotlin
@Repository
open class CourierTripRepo(private val jdbi: Jdbi) {
    context(_: DbWriteScope)
    fun upsert(rec: CourierTripRec) { ... }

    context(_: DbReadScope)
    fun findByTripUuid(id: UUID): CourierTripRec? { ... }
}
```

**Mappie mappers:**
- Use Mappie for all object-to-object mappings, including to/from Avro-generated classes
- Define mappers as `object` extending `ObjectMappie<From, To>`
- Use declarative `mapping { }` syntax
- Properties with the same name in source and target do not need to be mapped explicitly (automapping)

**Pipeline style:**
```kotlin
InputMapper.map(input)
    .also { repo.upsert(it) }
    .let(OutputMapper::map)
```

## Testing

To run integration tests:
1. `docker kill $(docker ps -q); docker rm $(docker ps -a -q)` — stop and remove all running containers
2. `docker compose up -d` in the repo root — start the required infrastructure
3. Then run the integration tests

- Use almost exclusively integration tests — no mocks, real Spring context + infrastructure
- `ItTestBase` resets the DB before each test via Flyway + wipe (`@BeforeEach`)
- `ItWaiter` (Awaitility wrapper) for async assertions at repo level after Kafka processing
- Define sample objects as top-level `object` in `src/test/kotlin/.../it/samples/` — never `class`, no builders
- Layer them: `SamplePrimitives` → `SampleXxxRec` → `SampleXxx` (domain) → `SampleKafka`
- Primitive constants: `const val UPPER_SNAKE_CASE`; complex objects: `val sampleXxx` (camelCase)
- Use extra `val` or `.copy()` for variants, no methods unless parameterization is truly necessary
- Use one `assertThat` per object — no individual `assertThat` per field. Compare with `assertThat(obj).isEqualTo(sample.copy(...))`. For dynamic fields (id, timestamp): copy them back into the expected object via `.copy()`. Use `usingRecursiveComparison()` only when `.copy()` is insufficient (e.g. nested objects with dynamic fields). Never use `ignoringFields`.
- Never use `Thread.sleep` — use Awaitility for async assertions
- Only use unit tests for pure calculations (e.g. `HaversineCalculatorTest`)
