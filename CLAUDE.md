# bookmark-x

A fork / modernization of Drew Adams' **Bookmark-X** package (originally
hosted on EmacsWiki), targeting **Emacs 30+**. Vendored as a git submodule
under the parent `.emacs.d` repo; the `.git` file points to
`../../.git/modules/bookmark-x`.

## Layout

- `bookmark-x.el` — driver / entry point
- `bookmark-x-mac.el` — macros (load *source*, not `.elc`, before
  byte-compiling the rest)
- `bookmark-x-1.el` — main non-bmenu code
- `bookmark-x-bmu.el` — `*Bookmark List*` (bmenu) buffer
- `bookmark-x-key.el` — key and menu bindings
- `bookmark-x-lit.el` — bookmark highlighting (optional)
- `doc/bookmark-x.texi` — user manual (texinfo source).
  Build with `make -C doc` to produce `doc/bookmark-x.info`.
- `doc/Makefile` — `make` builds info; `make html` / `make pdf` available.
- `test/` — ERT test suite.  Run with `make test` from the repo root.
  Tests are isolated: each one rebinds `bookmark-alist`,
  `bookmark-default-file`, and friends to a unique temp file, so the
  user's real bookmarks are never touched.  See `test/bmkx-test-helper.el`
  for the `bmkx-test-with-clean-bookmarks` macro every test uses.
- `Makefile` (repo root) — `make test`, `make compile`, `make clean`.
- `readme.org`, `doc/reference.org` — locally-authored quickstart and
  command-table references (kept alongside the Info manual; the manual
  is the authoritative user doc).
- `bookmark-x-preview.el` — live preview for `bmkx-jump` and `*Bmkx List*`
  (always loaded; consult integration is soft-gated on `(featurep 'consult)`)
- `casual-bmkx.el` — optional Casual-style Transient menu for `*Bmkx List*`.
  Soft-loaded only if `casual-lib` is on `load-path`. Bound to `c` in
  `bmkx-list-mode-map`. Not built by the standard byte-compile command
  below (depends on third-party `casual-lib`); your runtime Emacs will
  compile it when first loaded.

## What this fork has dropped from upstream

Modernization replaced or removed each of these external dependencies.
**Do not reintroduce them** — corresponding replacements are in place:

| Upstream dep | Replacement |
|---|---|
| `crosshairs.el` (Drew Adams) | built-in `pulse.el` (`bmkx-highlight-on-jump-flag` / `bmkx-highlight-jump-target`) |
| `fit-frame.el` (Drew Adams) | built-in `fit-frame-to-buffer` (helper: `bmkx-fit-bmenu-frame`) |
| `narrow-indirect.el` (Drew Adams) | built-in `clone-indirect-buffer-other-window` + `narrow-to-region` |
| `thingatpt+.el` (Drew Adams) | inlined as `bmkx-symbol-nearest-point`, `bmkx-region-or-symbol-name-nearest-point`, `bmkx-thing-at-point`; `bmkx-near-point-distance` defcustom |
| `zones.el` (Drew Adams) helper calls | inlined as `bmkx-read-any-variable`, `bmkx-readable-marker`. The izones bookmark *type* is still gated on `(boundp 'zz-izones-var)` because the data structure is zones-specific. |
| `linkd.el` (Drew Adams, dead since 2007) | built-in `outline-minor-mode` with `outline-regexp` matching Drew's `;;(@*` / `;;(@>` markers |
| `emacs-w3m` active integration | `bmkx-jump-w3m` now routes to `bmkx-jump-eww`; no new w3m bookmarks created |
| Icicles completion-framework integration | bookmark-x uses the built-in `completing-read` everywhere; users layer vertico / consult / marginalia / etc. on top |

`dired+.el` is still recognised as an optional dependency (Drew Adams, still
maintained); referenced via `(declare-function ...)`.

## Architecture: additive sibling of built-in `bookmark.el`

Bookmark-X does **not** redefine functions from the built-in
`bookmark.el`. Instead it ships parallel commands under the `bmkx-*`
namespace that operate on the same `bookmark-alist`:

| Concern              | Built-in                  | Bookmark-X              |
|----------------------|---------------------------|--------------------------|
| Create at point      | `bookmark-set`            | `bmkx-set`               |
| Jump                 | `bookmark-jump`           | `bmkx-jump`              |
| Rename / delete      | `bookmark-{rename,delete}`| `bmkx-{rename,delete}`   |
| Annotation editing   | `bookmark-edit-annotation`| `bmkx-edit-annotation`   |
| Load / save file     | `bookmark-{load,save}`    | `bmkx-{load,save}`       |
| Browse buffer        | `*Bookmark List*`         | `*Bmkx List*`            |

Both command sets see the same records; either can read and edit the
other's output. Key facts when working here:

- **Built-in is untouched.** `C-x r m / b / l` and `M-x bookmark-jump`
  still call the Emacs manual's `bookmark.el`. Pulse highlight, tags,
  region restore, etc. fire only on `bmkx-*` commands.
- **No compat aliases.** When a `bookmark-*` redefinition was renamed
  to `bmkx-*`, the old name was *not* re-exported. Callers were updated.
- **`*Bmkx List*` is a separate buffer** with its own major mode
  `bmkx-list-mode` (derived from `special-mode`). The built-in's
  `*Bookmark List*` is left alone.
- **Identity field.** Every record carries `(id . UUID)` from
  `bookmark-make-record-default`; bookmarks lacking one get a fresh id
  on load. Lookup helper is `bmkx-get-by-id`. Names stay unique through
  auto-disambiguation (`foo`, `foo<2>`, ...) in `bookmark-store` plus a
  `bmkx-deduplicate-bookmark-names` pass on load.
- **File format** is plain printable Lisp — no `print-circle` markers,
  no `bmkx-full-record` text property. Files round-trip through the
  built-in's `bookmark.el` losslessly.

Users who want bmkx behavior on the standard keys (`C-x r m / b / l`)
rebind them or `advice-add` `bookmark-jump` themselves; see
`readme.org` → "Binding bmkx commands to standard keys". The package
does **not** install advice on load.

See `DESIGN.md` for the full refactor design and the phased plan.

## Working here

- Source `.el` files are fair game to modify.
- Files are large (`bookmark-x-1.el` is ~600 KB). Use `Read` with
  `offset`/`limit`, and `grep` for symbols before editing.
- Build cleanly with: `emacs -Q --batch -L . -l bookmark-x-mac.el -f
  batch-byte-compile bookmark-x-mac.el bookmark-x-lit.el bookmark-x-bmu.el
  bookmark-x-1.el bookmark-x-key.el bookmark-x.el`. Should produce **0
  warnings** under Emacs 30+.
- Confirm the approach before making changes (per global `CLAUDE.md`).
- **Do not commit** unless the user explicitly grants authority for the
  current session. When in doubt, stage and ask.
