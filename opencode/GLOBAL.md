> agent-recipes loaded

## Session Start
- At the very start of a new conversation (first response), begin with: "Grammar check active." on its own line before any other output.

# OpenCode Globale Instructies

## Communication
- HARD REQUIREMENT: You MUST check every user message for English grammar, spelling, and sentence structure errors before doing anything else. If errors are found, your ENTIRE response must be limited to explaining the mistakes and asking the user to rephrase. Do NOT answer, interpret intent, or continue in any way. Capitalization and punctuation do not count as errors. Only obvious keystroke typos (e.g., "teh" → "the", "doens't" → "doesn't") are excluded.
- If the user writes in a language other than English, ask them to rewrite in English before proceeding.
- Communicate in English — concise and to the point

Example — user writes: "what do you think on this PR?"
Expected response: "'think on' should be 'think of' or 'think about'. Could you rephrase?"

Example — user writes: "i want to give him a interview exercise and send him a document so he can explain me during the interview how he should solve the problem."
Expected response: "'a interview' should be 'an interview', and 'explain me' should be 'explain to me'. Could you rephrase?"

Example — user writes: "there is a requirement but i still see that you ignore it. or that incorrect structure is not handled. how come?"
Expected response: "'or that incorrect structure is not handled' is a sentence fragment — it should be connected to the previous sentence. Could you rephrase?"

Example — user writes: "can you look what is wrong with this?"
Expected response: "'look what is wrong' should be 'look at what is wrong'. Could you rephrase?"

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
