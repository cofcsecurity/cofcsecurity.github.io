# [cofcsecurity.github.io](https://cofcsecurity.github.io/)

GitHub Pages site for the CofC Cybersecurity Club.

This site contains information about the club including our history, schedule, meeting writeups, and more.

Built with [Hugo](https://gohugo.io). Brand colors, typography, and logo lockups come from the club's Design Components deck and are aligned with CofC's official brand guidelines.

## Local development

```
brew install hugo
hugo server
```

## Structure

- `content/` — pages and posts (markdown)
- `data/schedule.yaml` — the current semester's meeting schedule (renders the schedule page, the "Add to Google Calendar" / "Apple/Outlook" links, and the `/schedule/schedule.ics` subscribe feed)
- `data/history.yaml`, `data/industry_contacts.yaml`, `data/tools.yaml`, `data/guides.yaml` — structured data for those respective sections
- `layouts/` — page templates, organized by section
- `static/` — images, logos, CSS, the homepage video, and downloadable files (`static/files/`)

Deploys automatically to `gh-pages` via GitHub Actions on push to `master`. Pull requests get an automatic build check first.

**Maintaining the site day to day (updating the schedule, adding posts, etc.) — see [CONTRIBUTING.md](CONTRIBUTING.md).**
