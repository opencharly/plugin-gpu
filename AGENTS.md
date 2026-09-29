# AGENTS.md — plugin-gpu

Standalone plugin repo for the `gpu` capability (`verb:gpu`) — the GPU/VFIO
host-detection and driver-switch plugin. The plugin is a Go module at
`candy/plugin-gpu/` (module path
`github.com/opencharly/plugin-gpu/candy/plugin-gpu`); the root `charly.yml` only
declares `discover: candy` so the repo is a project and its candy is scanned.

Canonical files:

- `candy/plugin-gpu/charly.yml` — the `plugin-gpu:` candy entity (`plugin:`
  block, `plan:` check).
- `candy/plugin-gpu/main.go` — `NewProvider()` / `NewMeta()` and the OpRun
  dispatch (detection + driver-switch action vocabularies).
- `candy/plugin-gpu/detect.go` / `switch.go` — the detection and driver-switch
  legs.
- `candy/plugin-gpu/data.go` / `data.yml` — the embedded detection tables.
- `candy/plugin-gpu/schema/gpu.cue` — the self-contained plugin schema.
- `.github/workflows/tag-on-merge.yml` — CalVer tag + `CHANGELOG/` on merge.
- `README.md` — user overview only; never agent guidance.

## Load these skills first (R0)

- `/charly-vm:vm` — the GPU-passthrough surface (`charly vm gpu status` / `list` /
  `mode` / `recover`) that dispatches `verb:gpu`, and the VFIO host-readiness
  model (the plugin's primary user-facing surface). Load before changing a
  detection or driver-switch leg.
- `/charly-core:charly-doctor` — the `charly doctor` hardware report that
  peer-`InvokeProvider`s `verb:gpu` for its GPU/VFIO/device section.
- `/charly-internals:plugin` — the plugin authoring reference: the `plugin:`
  block, the unified Provider model, the per-plugin CUE-schema contract,
  placement. Load before touching the provider or schema.
- `/charly-internals:git-workflow` — before any git/PR action.

## Build / validate / test

- `go build ./...` in `candy/plugin-gpu/` — compile the plugin module.
- `go test ./...` in `candy/plugin-gpu/` — the plugin's Go tests (detect,
  switch, schema-serve seams).
- `charly box validate` at the repo root — the structural check (the candy +
  `plugin:` block, CUE schema).
- The merge gate is the **org-wide** `charly/pr-validator` (required check
  `validate / validate`, defined in `opencharly/.github`); this repo has **no**
  per-repo candy gate.
- The R10 witness is `charly vm gpu status` / `list` / `plan` exiting 0 host-side
  on a GPU-less host (the live `check-gpu-local` bed).

## Modify this repo

- Edit the `plugin-gpu:` candy entity, the Go source, and `schema/gpu.cue`
  **together** — the schema is the served declaration surface.
- Keep the three static data tables this plugin's own embed; it is the only
  detection consumer (R3), not charly-core.
- Keep the plugin compiled-in: the deploy/config hot paths and
  `MemlockLimitBytes` need in-process placement.
- The verb multiplexes TWO disjoint action vocabularies on OpRun (detection and
  driver-switch); keep both dispatch paths working.

## Landing

- PR-only. Every change lands through a pull request; the org-required
  `charly/pr-validator` validates the diff and body and arms native auto-merge on
  PASS. Direct pushes to `main` are blocked.
- History lives in `CHANGELOG/` (written by `tag-on-merge` at merge time); the PR
  body IS the changelog.
- The authoritative rulebook is the umbrella `AGENTS.md` in
  `opencharly/opencharly` and `charly/AGENTS.md` in the charly repo. Do not
  restate its rules here.
