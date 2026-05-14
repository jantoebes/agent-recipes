# Kotlin Spring Boot Backend — Recipe

## Mappenstructuur
Feature-based packaging. Elke feature is een top-level subpackage met interne lagen:

```
feature/
├── consumer/    — Kafka consumers
├── producer/    — Kafka producers
├── service/     — Bedrijfslogica
├── mapper/      — Mappie mappers
├── controller/  — REST endpoints
├── repo/
│   ├── rec/     — Database records (data classes)
│   └── table/   — Tabelobjecten (naam + kolomconstanten)
└── model/       — Domeinmodellen
```

Subfolders optioneel; cross-cutting concerns (config, security, DB-setup) in `shared/`.

## Code

Algemene Kotlin-regels:
- Gebruik nooit `!!` om types te onderdrukken
- Geen `as` casts — gebruik `is` smart casts, `when`-exhaustiveness of generics
- Geen `@Suppress("UNCHECKED_CAST")` — los de oorzaak op met generics of type-safe alternatieven

**Domeinmodellen:**
- `data class` voor records en modellen
- `object` voor pure utilities
- Geen inheritance in de domeinlaag

**Arrow foutafhandeling:**

Log bij oorsprong. `Either` alleen om "stop" door pipeline te dragen. Geen error-hiërarchie tenzij aanroepkant per type ander pad kiest (retry, HTTP status, log-level).

```kotlin
// either {} met .bind(), ensureNotNull() en raise()
either {
    val item = ensureNotNull(repo.findById(id)) { logger.error { "Item $id niet gevonden" }; SkipMarker }
    ensure(item.isValid) { ValidationError("...") }
    process(item)
}

// Either.catch met .onLeft logging
Either.catch { externalCall() }
    .onLeft { e -> logger.error(e) { "Call mislukt voor $id" } }

// either met .fold voor vertakking
either<ErrorType, Result> { compute() }
    .fold(ifLeft = { fallback(it) }, ifRight = { it })

// nullable {} voor optionele ketens
nullable {
    val a = source.fieldA.bind()
    val b = source.fieldB.bind()
    Combined(a, b)
}

// option {} met .getOrNull() fallback
option { original.copy(extra = repo.findExtra(id).bind()) }.getOrNull() ?: original
```

Regels:
- `ensureNotNull()` boven `?: raise()`
- Sealed class errors alleen als de aanroepkant per type een ander pad kiest
- Skip-markers als `private data object Skip`

**Transactiescoping via context receivers:**

Repo-methoden declareren scope als context receiver; services openen blok via `tx.write {}` of `tx.read {}`:

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
- Mappers als `object` die `ObjectMappie<From, To>` extenden
- Declaratief met `mapping { }` syntax
- Properties met dezelfde naam in source en target worden niet in code opgenomen (automapping)

**Pipeline-stijl:**
```kotlin
InputMapper.map(input)
    .also { repo.upsert(it) }
    .let(OutputMapper::map)
```

## Testen

Voor het uitvoeren van integratietests:
1. `docker kill $(docker ps -q); docker rm $(docker ps -a -q)` — stop en verwijder alle draaiende containers
2. `docker compose up -d` in de repo-root — start de benodigde infrastructuur
3. Daarna de integratietests uitvoeren

- Vrijwel uitsluitend integratietests — geen mocks, echte Spring-context + infrastructuur
- `ItTestBase` reset DB voor elke test via Flyway + wipe (`@BeforeEach`)
- `ItWaiter` (Awaitility-wrapper) voor async assertions op repo-niveau na Kafka-verwerking
- Sample-objecten als top-level `object` in `src/test/kotlin/.../it/samples/` — nooit `class`, geen builders
- Gelaagd: `SamplePrimitives` → `SampleXxxRec` → `SampleXxx` (domein) → `SampleKafka`
- Primitieve constanten: `const val UPPER_SNAKE_CASE`; complexe objecten: `val sampleXxx` (camelCase)
- Varianten via extra `val` of `.copy()`, geen methoden tenzij parametrisatie echt nodig is
- Assertions met `usingRecursiveComparison().ignoringFields(...)` voor flexibele record-vergelijking
- Unit tests alleen voor pure berekeningen (bijv. `HaversineCalculatorTest`)
