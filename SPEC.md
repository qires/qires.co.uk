# Qires.co.uk — Static Holding Page

## 1. Project Overview
- **Type**: Hugo-based static website
- **Core functionality**: Brand holding page with sectioned content, mobile-first responsive design
- **Target users**: Potential clients/visitors viewing the Qires brand

## 2. Visual & Rendering Specification

### Color Palette
| Role | Color | Hex |
|------|-------|-----|
| Primary (Brand) | Orange | `#f79055` |
| Navy (Highlights/Text) | Navy Blue | `#1e3a5f` |
| Background | White | `#ffffff` |
| Light Gray (Subtle backgrounds) | Light Gray | `#f8f9fa` |
| Dark Text | Charcoal | `#2d3748` |

### Typography
- **Headings**: "DM Sans" (Google Fonts) — bold, modern sans-serif
- **Body**: "Inter" (Google Fonts) — clean, readable
- **Fallbacks**: system-ui, -apple-system, sans-serif

### Layout
- **Container**: max-width 1200px, centered
- **Grid**: Single column mobile, multi-column desktop
- **Breakpoints**:
  - Mobile: < 640px
  - Tablet: 640px – 1024px
  - Desktop: > 1024px

### Sections
1. **Header/Navigation** — Sticky, logo + nav links
2. **Hero** — Brand statement, tagline, CTA button
3. **About/Services** — Grid of service cards
4. **Features** — Icon-based feature list
5. **Contact** — Simple contact form placeholder
6. **Footer** — Links, copyright

## 3. Technical Specification

### Framework
- **Hugo** (latest stable)
- **Tailwind CSS** via CDN or Hugo Pipes
- **No JavaScript frameworks** — vanilla JS for interactions

### File Structure
```
/
├── config.toml
├── content/
│   ├── about.md
│   ├── services.md
│   ├── contact.md
│   └── _index.md
├── layouts/
│   ├── _default/
│   │   ├── baseof.html
│   │   ├── list.html
│   │   └── single.html
│   ├── index.html
│   ├── partials/
│   │   ├── header.html
│   │   ├── footer.html
│   │   ├── hero.html
│   │   └── features.html
│   └── sections/
│       ├── about-section.html
│       ├── services-section.html
│       └── contact-section.html
├── static/
│   └── css/
│       └── custom.css
└── resources/
    └── _gen/
```

### Hugo Configuration
- Language: en-GB
- Title: "Qires"
- Theme colors defined in params

## 4. Interaction Specification

### Navigation
- Mobile: Hamburger menu with slide-out drawer
- Desktop: Horizontal nav links
- Smooth scroll to sections on anchor click

### Responsive Behavior
- Images scale with container
- Typography scales down on mobile
- Cards stack vertically on mobile, grid on desktop

### Animations (CSS only)
- Hover transitions on buttons/cards (150ms ease)
- Subtle fade-in on scroll for sections

## 5. Acceptance Criteria

- [ ] Hugo site builds without errors
- [ ] All pages render with correct color scheme (#f79055, navy #1e3a5f, white)
- [ ] Mobile menu works correctly
- [ ] All sections display placeholder content
- [ ] Site is fully responsive (test at 375px, 768px, 1440px)
- [ ] Tailwind CSS classes applied consistently
- [ ] Google Fonts load correctly
- [ ] No console errors on page load
