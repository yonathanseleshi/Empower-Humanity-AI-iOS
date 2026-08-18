# Empower Humanity AI — Design Guide (for AI Agents)

A practical, self-contained reference for any AI coding agent building or modifying the Empower Humanity AI product. Distilled from the full design system in this project (`readme.md`, `tokens/`, `components/`). When in doubt, prefer this guide's rules over generic AI-product conventions (ChatGPT-style, single-accent "purple AI," dark neon, etc.) — those are explicit anti-patterns here.

## 1. What this product is

Empower Humanity AI is **one persistent AI co-intelligence (default name: Alex) working alongside one human over time** — not a chatbot, not a message window, not an enterprise dashboard, not "an AI wrapper around forms." North star: *"Living intelligence in service of human possibility."*

The interface must communicate a canonical hierarchy — never invert it:

```
Human → Co-Intelligence → What Matters → Goals / Work / Decisions → AI Actions → Devices / Infrastructure
```

## 2. Hard rules (anti-patterns)

Never build toward any of these:
1. A ChatGPT clone with different colours.
2. A single-accent "purple AI" interface.
3. A dark neon "AI operating system."
4. A SaaS admin dashboard with AI bolted on.
5. Unrelated rainbow colour with no system.
6. Constant, distracting AI animation.
7. An interface dominated by infrastructure/runtime concepts.

## 3. Colour — the Intelligence Spectrum

One interconnected six-colour spectrum, not isolated brand accents:

| Name | Hex | Meaning |
|---|---|---|
| Trust Blue | `#2563EB` | trust, navigation, primary actions |
| Intelligence Indigo | `#4F46E5` | reasoning, synthesis, system state |
| Cognition Purple | `#7C3AED` | AI, cognition, transformation |
| Human Pink | `#EC4899` | humanity, relationship, creativity |
| Progress Green | `#22C55E` | progress, completion, momentum |
| Intelligence Cyan | `#06B6D4` | realtime activity, data, awareness |

Extended accents (semantic states **only**, use sparingly): Amber `#F59E0B` (attention/waiting), Orange `#F97316` (high attention), Red `#EF4444` (risk/error), Teal `#14B8A6` (connectivity).

Neutrals/surfaces: White `#FFFFFF`, Soft White `#FAFBFD`, Page `#F7F8FC`, Surface Muted `#F1F5F9`, Border `#E2E8F0`. Text: Primary `#0F172A`, Secondary `#334155`, Muted `#64748B`, Subtle `#94A3B8`. **Light mode is canonical** — dark mode exists (`#0B1020` bg) but is never the primary identity, and never pure black.

**Signature gradient** (co-intelligence identity, hero moments only — never on every surface):
```css
linear-gradient(135deg, #2563EB 0%, #4F46E5 28%, #7C3AED 52%, #EC4899 76%, #06B6D4 100%)
```
Five secondary gradients exist for Relationship (purple→pink), Action (blue→green), Intelligence (indigo→purple→cyan), Progress (green→cyan), Possibility (pink→purple→blue) — use the one matching the moment's meaning, not decoratively.

All values are CSS custom properties in `tokens/colors.css` and `tokens/gradients.css` (e.g. `var(--eh-purple-500)`, `var(--gradient-co-intelligence)`) — always reference the token, never hardcode a hex that duplicates one.

## 4. Typography

- **Display/headings:** Plus Jakarta Sans. **Interface/body:** Inter. Both via Google Fonts.
- Scale: display-xl 64 · display 52 · hero 44 · h1 36 · h2 30 · h3 24 · h4 20 · body-lg 18 · body 16 · body-sm 14 · label 13 · caption 12 · micro 11 (px).
- **Voice:** AI speaks in first person ("I found one issue…"), human addressed in second person ("Good morning, Ben."). Sentence case for headlines/body; short Title Case only for status/chip labels. No exclamation-point hype ("Your AI superpower is ready!" is an explicit anti-example). No emoji.
- **Plain language over jargon:** say "Alex is working," not "Current Runtime Execution State." Use *your co-intelligence, Alex, active work, needs your approval, connected computers, dedicated AI compute, permissions, autonomy*. Never surface *agent runtime, execution fabric, inference router, capability provider, worker process, execution provenance* in default UI — advanced/debug views only.

## 5. Shape, surfaces, spacing

- **Radius:** sm 8 · md 12 · lg 16 (standard cards) · xl 20 (intelligence surfaces) · 2xl 28 (major co-intelligence moments) · pill (chips/buttons).
- **Spacing:** strict 4pt scale (4–96px). Generous whitespace in Chat/Today/onboarding; denser-but-breathable in Activity/Work/Devices.
- **Six-level surface hierarchy:** 0 environment (page bg) → 1 flat white card (1px border `#E2E8F0`, no shadow) → 2 elevated intelligence card (90% white, faint purple border `rgba(124,58,237,.14)`, soft shadow) → 3 low-saturation tinted context surface → 4 restrained glass (blur+translucency — composer/floating panels only) → 5 signature-gradient surface (onboarding/celebration/premium empty states only).
- **Content width caps:** standard 1120–1280px · conversation 760–900px · workspace ≤1440px · forms 680–820px. Never stretch content edge-to-edge on large viewports.
- **Sidebar:** 240–264px, white, collapsible. Active nav item = soft tinted pill, never a solid colour block.

## 6. Motion

Timing tokens only: instant 100ms · fast 150ms · standard 220ms · panel 280ms · intelligence 600ms (slow drift — e.g. the orb). One ease everywhere: `cubic-bezier(.4,0,.2,1)` — no bounce/elastic. Animate only real, measurable state (progress fills, status transitions, the orb's states) — never fake indeterminate progress, never whole-page motion.

## 7. Co-Intelligence Presence (the signature system)

The AI has a persistent visual identity: a soft multi-colour spectrum **orb** (`CoIntelligenceOrb`), never a bare chatbot icon. States: available (static) · listening (outward pulse) · thinking (slow internal colour drift) · acting (directional gradient movement) · waiting (amber edge) · completed (one-shot resolution pulse) · attention/error (small corner dot, identity stays intact — never turn the whole orb red).

**Rule:** use presence only when it communicates identity, state, relationship, or active intelligence. Never a giant glowing orb on every page, never constant animation, never an AI avatar beside every card.

## 8. Iconography

Rounded, stroke-based **Lucide** icon language. Implementation detail for agents: load the Lucide runtime via a plain `<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js">` tag (script-tag loading works; runtime `fetch`/XHR to CDNs is blocked in some hosting sandboxes), then render icons via `<i data-lucide="icon-name">` + `lucide.createIcons()` — this yields real inline SVG using `stroke="currentColor"`, so CSS `color` drives icon colour. No icon font, no PNG, no emoji, no Unicode symbols. Verify icon names against the current Lucide set before use — Lucide renames icons across versions (e.g. `check-square` → `square-check`); a stale name fails silently with no console error.

Concept → icon: Co-Intelligence `sparkles` · Chat `message-circle` · Today `sun` · Goals `target` · Plans `map` · Tasks `square-check` · Projects `folder-kanban` · Decisions `git-branch` · Knowledge `library` · Activity `activity` · Runtime `cpu` · Device `laptop` · Dedicated Compute `server` · Autonomy `sliders-horizontal` · Approval `shield-check` · Execution `workflow` · Intelligence `brain-circuit` · Reality `network`.

## 9. Card system

Every card follows the same anatomy: context marker (tinted icon container) → title → summary → primary data/state → optional AI explanation → actions. **Colour lives in the icon container, badges, and status elements — never as a fully saturated card background.**

Card families and their fixed colour identity:
- **Relationship** (purple+pink) — Co-Intelligence Card, Reflection, Relationship Insight
- **Intelligence** (purple/indigo/amber/pink by kind) — Insight, Recommendation, Risk, Opportunity
- **Planning** (purple+blue+green) — Goal, Plan, Milestone, Decision (indigo+purple+amber for uncertainty), Priority
- **Execution** (blue+green+cyan) — AI Work, Execution, Approval (amber accent), Device, Dedicated Compute
- **Information** (blue+cyan+neutral) — Knowledge, Artifact, Event

## 10. Status & execution language

Fixed colour per lifecycle state, **always paired with an icon/label** (never colour alone): Active/Working → cyan-ish, Waiting/Needs approval → amber, Completed → green, Blocked → red, Paused/Offline → neutral gray.

Execution progression is always: Requested → Preparing → Waiting for approval → Working → Completed (or Failed/Cancelled). Approvals show What / Why / Where / Risk and only the valid actions (Approve once / Allow for session / Deny) — never expose raw Runtime IDs in default UI.

## 11. Terminology guardrail

The product has real underlying architecture (Human, Primary Co-Intelligence, Reality/Context, Runtime Node, Dedicated Compute Node, Execution Job, Capability, Approval Request — see the Reality Model) — but default UI speaks in human terms only. Runtime/infrastructure vocabulary belongs in an explicit "advanced details" affordance, never the primary surface copy.

## 12. Where to find the implementation

- Tokens: `tokens/*.css` → imported by `styles.css`.
- Components (35, in 8 groups): `components/{core,presence,chat,cards,overlays,forms,nav,layout}/` — each is a self-contained React component using only inline styles + these CSS variables.
- Reference screens: `ui_kits/web/` (Today, Chat, Work, Goals, Devices).
- Full detail and rationale: `readme.md` at the project root.

When building new screens or components for this product, compose from the existing `components/` set first; only introduce a new primitive if nothing in the inventory fits, and give it the same token-driven, inline-style treatment as the rest of the system.
