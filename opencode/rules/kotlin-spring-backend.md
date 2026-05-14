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

Alle subfolders zijn optioneel — alleen aanmaken wat de feature nodig heeft.

Cross-cutting concerns (config, security, DB-setup) in een `shared/` package.

## Code

**Domeinmodellen:**
- `data class` voor records en modellen
- `object` voor pure utilities en mappers
- Geen inheritance in de domeinlaag

**Arrow foutafhandeling:**
- Gebruik `either { }`, `nullable { }`, `option { }` met `.bind()`
- Geen eager returns

**Transactiescoping via context receivers:**

Repo-methoden declareren hun vereiste scope als context receiver — de compiler dwingt af dat ze alleen binnen de juiste transactie aangeroepen worden:

```kotlin
@Repository
open class CourierTripRepo(private val jdbi: Jdbi) {
    context(_: DbWriteScope)
    fun upsert(rec: CourierTripRec) { ... }

    context(_: DbReadScope)
    fun findByTripUuid(id: UUID): CourierTripRec? { ... }
}
```

Services injecteren `TransactionScope` en openen een blok via `tx.write { }` of `tx.read { }`:

```kotlin
@Service
open class CourierPipelineService(
    private val repo: CourierTripRepo,
    private val tx: TransactionScope,
) {
    open fun handle(event: TripStart) =
        tx.write {
            repo.upsert(TripStartToRecMapper.map(event))
        }
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

- Vrijwel uitsluitend integratietests — geen mocks, echte Spring-context + infrastructuur
- `ItTestBase` reset DB voor elke test via Flyway + wipe (`@BeforeEach`)
- `ItWaiter` (Awaitility-wrapper) voor async assertions op repo-niveau na Kafka-verwerking
- Sample-objecten als top-level `object` in `src/test/kotlin/.../it/samples/` — nooit `class`, geen builders
- Gelaagd: `SamplePrimitives` → `SampleXxxRec` → `SampleXxx` (domein) → `SampleKafka`
- Primitieve constanten: `const val UPPER_SNAKE_CASE`; complexe objecten: `val sampleXxx` (camelCase)
- Varianten via extra `val` of `.copy()`, geen methoden tenzij parametrisatie echt nodig is
- Assertions met `usingRecursiveComparison().ignoringFields(...)` voor flexibele record-vergelijking
- Unit tests alleen voor pure berekeningen (bijv. `HaversineCalculatorTest`)
