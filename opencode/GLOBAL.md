# OpenCode Globale Instructies

## Communicatie
- Reageer in het Nederlands met de gebruiker, Engels in code en documentatie
- Beknopt en to the point

## AGENTS.md
- Houd elk AGENTS.md zo compact mogelijk — elke instructie moet aantoonbaar gedrag sturen
- Houd AGENTS.md actief relevant: stel een update voor als iets ontbreekt of verouderd is; comprimeer voor je toevoegt

## Git & PR
- Commit messages: kort, in het engels, beschrijvend, geen conventional commits (geen `feat:`, `fix:`)
- Branch naam gebruik: `DCA-korte-beschrijving`. CPS is keywoord als afkorting van de repo naam (als je in courier-pud-services zit)
- PR titel: identiek aan branchnaam
- Geen PR beschrijving
- Gebruik nooit force push

## Worktrees
- Gebruik altijd de `wt` tool (via Bash) — nooit `git worktree` handmatig
- Aanmaken: `wt switch --create <branch> --base <base>`
- Navigeren: `wt switch <branch>`
- Voor opschonen gebruik het commando /cleanup-worktrees

## Code
Wanneer je in codebases werkt
- Altijd functioneel programmeren style
- Cleancode principes
- Kleine, enkelvoudige functies met beschrijvende namen (DRY, geen onnodige commentaar)

## Frontend
Wanneer je in een frontend codebase werkt met typescript
- Gebruik nooit `!` om types te onderdrukken

## Kotlin
- Gebruik nooit `!!` om types te onderdrukken
