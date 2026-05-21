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

## Branches & Worktrees
- Vraag de gebruiker bij het starten van een taak (alleen als je op main zit): worktree, gewone branch, of direct op main?
- Gewone branch: `git checkout -b <branch>`
- Worktree: `wt switch --create <branch> --base <base>` — nooit `git worktree` handmatig
- Navigeren worktrees: `wt switch <branch>`
- Voor opschonen worktrees: `/cleanup-worktrees`

## Code
- Altijd functioneel programmeren style
- Cleancode principes
- Kleine, enkelvoudige functies met beschrijvende namen (DRY)
- Geen commentaar in code — de code spreekt voor zichzelf
- Geen early returns

## Frontend (TypeScript)
- Gebruik nooit `!` om types te onderdrukken
