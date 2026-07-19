# Radiant Joint Alliance — Jekyll Site

This replaces the 86 hand-maintained HTML files with a Jekyll site. The
50 state pages and 13 city pages are no longer files at all — they're
generated automatically from `_data/directory.yml` every time the site
builds.

## What's in here

- `_config.yml`, `Gemfile` — Jekyll configuration
- `_layouts/` — shared page templates (`default.html` wraps every page;
  `state.html` / `city.html` are used by the auto-generated directory pages)
- `_includes/` — the nav, footer, CSS, and shared JS, each in exactly one
  place now instead of copied into every file
- `_data/directory.yml` — every hospital/facility listing. **This is the
  file you'll edit most often.**
- `_data/state_names.yml` — state abbreviation → full name lookup
- `_plugins/directory_pages_generator.rb` — the code that turns
  `directory.yml` into 50 state pages and 13 city pages at build time
- `.github/workflows/jekyll.yml` — builds and deploys the site automatically
  on every push
- `index.html`, `map.html` — untouched, plain files, exactly as they were.
  These are never processed by Jekyll (the native app depends on
  `index.html`'s exact structure)
- Everything else (`about.html`, `faq.html`, the 9 LDRT topic pages, etc.)
  — now short files with a bit of front matter, pulling their shared
  layout from `_includes/`

## One-time setup, before you push

1. Copy all files in this folder into your existing repo, **replacing**
   `index.html`, `map.html`, and any old copies of the pages listed above.
   Do NOT delete `CNAME`, the favicon files, `checklist.pdf`, or
   `og-image.png` — those stay exactly where they are.
2. In your GitHub repo: **Settings → Pages → Build and deployment → Source**
   — change this from "Deploy from a branch" to **"GitHub Actions."**
   This is the only settings change needed; the workflow file in this
   folder handles the rest.
3. Delete `sitemap.xml` and `robots.txt` from your repo root if a plugin
   version conflicts — actually, keep `robots.txt` (it still points to
   `sitemap.xml`), but you can delete the old hand-written `sitemap.xml`.
   The `jekyll-sitemap` plugin now generates it automatically on every
   build, so it will always be current — including the 63 directory pages.
4. Commit and push to `main`. Check the **Actions** tab in your repo to
   watch it build. First build takes 1–2 minutes.

## Adding a new hospital listing (the day-to-day task)

Open `_data/directory.yml` and add an entry:

```yaml
- name: Example Cancer Center
  city: Des Moines
  state: IA
  location: Des Moines, IA
```

That's it. Commit and push. The build will:
- Add the row to `find-a-treatment-location.html`'s master table (once
  that page is also wired to read from the data file — see note below)
- Create `ldrt-in-iowa.html` automatically, since Iowa now has an entry
- Add it to `sitemap.xml` automatically
- If the same city crosses 3 confirmed listings, a city page is created
  automatically too
- Show up in `find-a-treatment-location.html`'s master table automatically
  too — that page also reads live from `directory.yml` now, nothing in it
  is hand-written data anymore

## A note on the two Delaware/Maine entries

`ChristianaCare` (Newark, DE / Chadds Ford, PA) and `Spectrum Healthcare
Partners` (Maine, 6 locations / Portsmouth, NH) each serve two states.
They appear once in the master table (filed under their primary state)
and have a second `secondary: true` copy in `directory.yml` purely so
Delaware and Maine each get their own state page. If you ever need to add
another facility that spans two states, follow this same pattern: one
normal entry, one `secondary: true` copy for the second state, so it
doesn't double up in the master table.

## Testing changes before pushing

If you want to preview changes before they go live, you'll need Ruby and
Jekyll installed locally (`gem install jekyll bundler`, then `bundle
install` and `bundle exec jekyll serve` from this folder). Otherwise,
push to a branch other than `main` and manually trigger the workflow from
the Actions tab to test without affecting the live site.
