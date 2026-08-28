# Maintaining this site

This doc is for whoever's running the club site next — it assumes no prior Hugo experience. Everything below is a markdown/YAML edit in GitHub's web editor; you don't need to install anything to make most changes (though `hugo server` locally lets you preview before pushing — see the README).

Every change goes through a pull request. Opening a PR automatically runs a build check (`.github/workflows/pr-check.yml`) that catches broken YAML or template errors before they can reach the live site — if that check is red, don't merge until it's fixed.

## Update the schedule each semester

Edit [`data/schedule.yaml`](data/schedule.yaml). It's a list of meetings:

```yaml
- week: 1
  day: "Tuesday"
  date: 2026-08-25
  start: "17:30"
  end: "19:30"
  topic: "Introduction to the Club & CTF Basics"
  notes: "Day after classes start"
```

For a skipped week (breaks, holidays), omit `week`/`start`/`end`/`topic` and add `skipped: true`:

```yaml
- day: "Tuesday"
  date: 2026-10-13
  skipped: true
  notes: "No meeting (Fall break)"
```

This one file drives everything: the schedule page table, the "next meeting" card on the homepage, the per-meeting Google Calendar and Apple/Outlook (.ics) links, and the `/schedule/schedule.ics` subscribe feed. You don't need to touch anything else.

Also update `semester` and `location` at the top of the file if either changes.

**At the end of a semester**, move the finished semester's table into [`content/schedule/archive.md`](content/schedule/archive.md) (plain markdown, just paste it in) before starting the new `schedule.yaml`.

## Keeping Discord in sync

Editing `data/schedule.yaml` also keeps Discord up to date, via a companion repo: [cofcsecurity/discord-event-bot](https://github.com/cofcsecurity/discord-event-bot). It creates/updates native Discord Scheduled Events from this file and posts a same-day `@everyone` announcement before each meeting. You don't do anything extra here — this section explains how the two repos connect, so you know where to look if Discord ever falls out of sync.

### How it's wired together

1. Someone edits `data/schedule.yaml` in this repo and pushes to `master`.
2. This repo's [`notify-event-bot.yml`](.github/workflows/notify-event-bot.yml) workflow fires a `repository_dispatch` to `discord-event-bot`.
3. That repo's `sync.yml` workflow picks it up and creates/updates Discord events to match, usually within a minute or two.
4. Separately, that repo's `announce.yml` workflow runs every Tuesday/Thursday morning and posts that day's meeting to Discord, if there is one.
5. As a safety net, `discord-event-bot` also re-syncs once a day on its own schedule, so a missed dispatch is never more than a day stale.

If a schedule change doesn't show up in Discord within a day, check the Actions tab in both repos for failed runs — a missing or expired secret (below) is the usual cause.

### Secrets

**In this repo** (Settings → Secrets and variables → Actions):

| Secret | Used by | Purpose |
|---|---|---|
| `DISCORD_BOT_DISPATCH_TOKEN` | `notify-event-bot.yml` | Lets this repo trigger a workflow in `discord-event-bot`. |

To create it:
1. As someone with admin on `cofcsecurity/discord-event-bot`, go to GitHub → **Settings → Developer settings → Personal access tokens → Fine-grained tokens → Generate new token**.
2. Set **Resource owner** to `cofcsecurity`, and restrict **Repository access** to just `discord-event-bot`.
3. Under **Permissions → Repository permissions**, set **Actions** to **Read and write** (nothing else is needed).
4. Generate it and copy the token (shown once).
5. In this repo, go to **Settings → Secrets and variables → Actions → New repository secret**, name it `DISCORD_BOT_DISPATCH_TOKEN`, and paste the token in.

Until this secret exists, `notify-event-bot.yml` just skips quietly instead of failing — `discord-event-bot`'s daily safety-net sync still catches every change, just up to a day later. Fine-grained tokens expire (you set the expiration when creating one, up to a year out); when it does, dispatches will silently stop firing until someone regenerates the token and updates this secret.

**In the `discord-event-bot` repo** (same Settings path, over there):

| Secret | Used by | Purpose |
|---|---|---|
| `DISCORD_BOT_TOKEN` | `sync.yml`, `announce.yml` | The Discord bot's own token, from the Discord Developer Portal. |
| `ANNOUNCE_CHANNEL_ID` | `announce.yml` | The Discord channel ID that meeting-day announcements post to. |

Getting these two values (creating the Discord bot application, granting it permissions, adding it to the server, and finding the channel ID) is covered step by step in that repo's [README, under "One-time setup"](https://github.com/cofcsecurity/discord-event-bot#one-time-setup). Once you have them, add them as repo secrets there the same way as above, rather than the local environment variables the README shows for testing on your own machine.

### Maintaining discord-event-bot day to day

Full detail lives in that repo's own README, but the short version:

- **Changing a meeting's time/topic/location**: just edit it here in `data/schedule.yaml` as usual — nothing to do in the bot repo.
- **Cover photos**: are Discord-only, so they're mapped in the bot repo's own `images.yaml` (by meeting date), not here.
- **Removing a meeting from Discord**: deleting it from `schedule.yaml` does *not* delete the Discord event — run `delete "Exact Title"` (or `wipe`) directly in the bot repo.
- **Protecting an event from being auto-edited or deleted** (e.g. one people already RSVP'd to): use that repo's `lock` command.
- **Testing a schedule change before it's pushed**: run the bot script locally against your uncommitted `schedule.yaml` (see `SCHEDULE_PATH` in that repo's README).

## Add a meeting write-up

Add a new markdown file to `content/posts/`, e.g. `content/posts/2026-fall-intro.md`:

```markdown
---
title: "Introduction to the Club"
date: 2026-08-25
---

Whatever you want to write. Standard markdown works, including images
(link to a hosted image, e.g. a GitHub raw URL) and embedded YouTube
iframes if you want video.
```

It'll show up automatically on `/posts/` and become searchable (see below) on the next deploy.

## Add or update competition guides

PDFs live in `static/files/`. To add a new one:

1. Drop the PDF into `static/files/`.
2. Add an entry to [`data/guides.yaml`](data/guides.yaml) under the right group (or add a new `group:`).

```yaml
- title: "New Guide"
  file: "new-guide.pdf"
  description: "One sentence on what it covers."
```

## Add a tool logo

The "What we practice with" grid on the About page is driven by [`data/tools.yaml`](data/tools.yaml). Three ways to add an entry:

- **Have a logo image?** Drop a white/transparent PNG into `static/img/tools/`, then add `- name: "Tool Name"` / `slug: "filename-without-extension"`.
- **No logo available, but a generic icon fits?** Use `icon: "cloud"` (or add a new icon to `layouts/partials/icon.html`) instead of `slug` — this is what we did for AWS, since no licensed logo asset was available.
- **Nothing fits?** Use `wordmark: true` instead of `slug` to render the name as bold text.

## Add on analytics

Off by default. To enable one:

- **GoatCounter** (simplest, no cookie banner needed): sign up free at [goatcounter.com](https://www.goatcounter.com/), then set `goatcounterSite` in `hugo.toml` to your site code.
- **Plausible**: sign up at [plausible.io](https://plausible.io/) (paid), then set `plausibleDomain` in `hugo.toml` to your domain.

Leave both blank to keep the site analytics-free.

## How search works

Meeting-writeup search on `/posts/` is powered by [Pagefind](https://pagefind.app/). It indexes the built site automatically in CI (`.github/workflows/pages.yml`) — nothing to maintain. It won't show results when running `hugo server` locally; if you want to test search itself, run:

```
hugo --minify
npx pagefind --site public
npx serve public
```

## The two themes

- **Light/dark toggle** (sun/moon icon, top nav): a normal accessibility feature, respects the visitor's OS preference by default.
- **Hidden theme** (small `_` in the bottom-right corner of every page): a black/neon-green easter egg using the old site's original color scheme. Doesn't need maintenance — it's a CSS variable override (`[data-theme="hacker"]` in `static/css/style.css`) — but if you ever redo the brand colors, both this and the dark-mode block will need matching updates since they don't inherit automatically.

## Deployment

Push to `master` → GitHub Actions builds with Hugo, indexes search, and deploys to the `gh-pages` branch. Usually live within a minute or two. There's no staging environment — a PR's build check tells you whether it *builds*, not whether it *looks right*, so preview visually with `hugo server` before merging anything that touches layout or CSS.

It also rebuilds automatically every morning (9:00 UTC) even with no new commits, so "next meeting" on the homepage and the `.ics` calendar feed stay accurate day to day instead of only updating on the next push. You can also trigger a rebuild manually any time from the Actions tab → Pages → Run workflow.
