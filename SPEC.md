# qires.co.uk — QI Resolved holding page

## 1. Project overview
- **Type**: Hugo static site, single page with anchored sections
- **Purpose**: Introduce QI Resolved — an app for quinquennial inspectors — ahead of launch
- **Audience**: Inspecting architects and surveyors, conservation practices, dioceses
- **Sources**: `assets/` holds the brand inputs this site is built from — the logo
  (`QIResolved_Logo_1_AI.png`), the layout mockup (`WEBSITE DESIGN 3_2.jpg`) and the
  proposal the copy is drawn from (`QI RESOLVED FOR QIR_20260822.pdf`)

## 2. Visual specification

### Colour palette
Taken **primarily from the logo**, secondarily from the mockup. Contrast ratios are
measured against the cream page ground.

| Role | Hex | Source | On cream |
|------|-----|--------|----------|
| Orange (primary) | `#F36B22` | Logo — the arch and vertical bar | 2.8:1 — display type only |
| Navy (secondary) | `#22346E` | Logo — the horizontal rule and circle arc | 10.7:1 |
| Slate (tertiary) | `#3C5553` | Logo v01 — where orange and navy overlapped. The v02 mark knocks the overlap out, so this is now a retained derived tone rather than a sampled one | 7.3:1 |
| Deep orange | `#B24A12` | Derived from the logo orange | 4.9:1 — AA |
| Cream (ground) | `#FAF5D8` | Mockup — page background | — |
| Cream deep (panels) | `#F4EBC4` | Mockup | — |
| Orange soft (rules) | `#F7A96B` | Mockup | decorative only |

**Avoiding a background/logo conflict.** The logo orange gives 2.8:1 on the mockup's
cream. That is enough for the hero display type (48px+, weight 800), where the mockup
uses it deliberately, but not for anything smaller. Every orange element below display
size therefore uses the derived deep orange at 4.9:1 — rail labels, links, card lead-ins
and the footer. Navy carries body text at 10.7:1, so cream and navy never compete.

Both colour sets are declared once in `static/css/custom.css` as custom properties, and
mirrored in the Tailwind config in `layouts/_default/baseof.html` and in `config.toml`
under `[params]`.

### Typography
- **Inter** (Google Fonts), weights 400/500/600/700/800 — one family, matching the mockup
- Fallbacks: `system-ui`, `-apple-system`, `sans-serif`
- Display: 800 weight, uppercase, tight tracking

### Layout
- Container: max-width 1400px, centred
- Desktop (≥1024px): two columns — a 210px sticky section rail on the left, content right
- Below 1024px: the rail is replaced by a menu button and a slide-down panel
- Breakpoints follow Tailwind defaults (sm 640, lg 1024, xl 1280)

### The logo lockup
The mark sits at the top right with a navy rule running the full width of the page and
straight through it, continuing the horizontal line drawn in the logo itself. The mark is
cropped so its own navy bar spans its full width; `.logo-rule` is positioned at 63.64% of
the mark's height with a thickness of 4.95% of it, which keeps the two aligned at any
`--mark-h`. The wordmark below sets "QI R" in orange and "esolved" in navy.

## 3. Technical specification
- **Hugo** 0.165+ (`make build` pins 0.165.0 via Docker; CI uses the same)
- **Tailwind CSS** via the Play CDN, configured inline in `baseof.html`
- **Vanilla JS only** — `static/js/menu.js` handles the menu and the rail scroll-spy.
  The reveal-on-scroll is CSS (`animation-timeline: view()`), guarded by `@supports`
  so the hidden start state only exists where the animation can actually run. An
  earlier JS version could strand blocks at opacity 0 if the observer missed them

```
config.toml              site config + palette params + section list
content/_index.md        home page stub
content/privacy.md       privacy policy, rendered by single.html
data/features.yaml       the nine features from the proposal, one line each
data/partners.yaml       executive partner profiles (name, role, one line, LinkedIn)
layouts/
  _default/baseof.html   shell, fonts, Tailwind config
  _default/list.html     unused fallback, kept in palette
  _default/single.html   unused fallback, kept in palette
  index.html             the single page
  _default/_markup/render-table.html  wraps tables so they scroll on a phone
  partials/header.html   logo lockup, navy rule, menu button, menu panel
  partials/nav-rail.html sticky section rail (lg and up)
  partials/footer.html   rule + copyright
static/
  css/custom.css         palette, header geometry, rail, prose
  js/menu.js             menu, rail scroll-spy
  img/logo-mark.png      cropped glyph, for the header
  img/logo-full.png      unmodified logo
  img/favicon.png        512px square
  img/church-{1..4}.jpg  rail illustrations, cropped from the mockup
```

### Assets derived from the brand inputs
- `logo-mark.png` — crop of the logo at x 456–1626, y 292–1788, to the glyph
- `favicon.png` — 1600px square crop centred on the glyph
- `church-1..4.jpg` — the four line drawings from the mockup's rail. Their ground is
  exactly `#FAF5D8`, the same as the page, and they are composited with
  `mix-blend-mode: darken` so the ground drops out and only the line work shows

## 4. Privacy policy

`content/privacy.md`, linked from the footer. Written for UK GDPR and the DPA 2018 around
the data the app will hold, on four decisions taken with the client:

- **Roles** — QI Resolved is controller for account, billing and usage data, and processor
  for what inspectors record about churches and clients. The policy is split accordingly
  so a church contact is directed to the inspecting practice, not to us.
- **Commercial reservation** — limited to irreversibly anonymised and aggregated data
  (defect prevalence, deterioration rates, cost benchmarks, model training). That falls
  outside the UK GDPR under Recital 26, so it needs no consent. Reuse of data held as
  processor is made conditional on the contract with the practice.
- **Hosting** — UK only, with a transfers section covering any future change.
- **Entity** — not yet incorporated, so controller identity, company number, registered
  address and ICO registration number are left as `[bracketed]` placeholders.

Section 11 discloses that this website loads Google Fonts and the Tailwind CDN, which
transmits visitor IP addresses outside the UK before any interaction. Self-hosting those
files would remove the transfer and let that disclosure be dropped.

## 5. Content
Copy is drawn from the QI Resolved proposal and kept deliberately short. The hero,
the two outlined cards and the section names reproduce the mockup. Sections: hero,
the new workflow / our vision, Our Story (with the nine features and the on-site and
post-inspection flows), Pricing, Our Partners, Disclaimer.

**Our Partners** profiles the two executive partners — Howard HW Lee on architecture and
conservation, Roger M Pettett on software and technology — each with a role, a one-line
description and a LinkedIn link. The word "partners" is used in the practice sense, of the
principals; the outreach to inspecting practices and diocesan advisory committees sits at
the end of Our Story instead. The one-line descriptions state each partner's role only.
**No qualifications, accreditations, employers or years of experience are claimed**,
because those could not be verified — LinkedIn refuses automated requests. Add them to
`data/partners.yaml` if you want them stated.

## 6. Acceptance criteria
- [x] Hugo builds with no warnings or errors
- [x] Palette drawn from the logo first, mockup second, with no cream/orange conflict
      at body sizes
- [x] Logo mark, wordmark and full-width navy rule align as in the mockup
- [x] Section rail on desktop; menu button and panel below 1024px
- [x] No horizontal overflow at 390px; verified at 390, 485 and 1440
- [x] Menu opens, closes on link click and on Escape
- [x] `prefers-reduced-motion` honoured for scroll behaviour and reveals
- [x] Privacy policy renders and is linked from the footer; its tables scroll within
      their own container rather than widening the page
