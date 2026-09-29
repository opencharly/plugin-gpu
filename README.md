# plugin-gpu

The GPU/VFIO **host-detection** plugin — the sysfs/exec probing formerly held in
charly core (`charly/devices.go`), relocated into a candy behind the
`verb:gpu` provider.

## What it provides

| Capability | Surface |
|---|---|
| `verb:gpu` | the `gpu` verb — OpRun DETECTION actions (`detect-gpu`, `detect-amd-gpu`, `detect-vfio`, `detect-host-devices`, `ensure-cdi`, …) and the DRIVER-SWITCH actions (the `vfio` ↔ `nvidia` rebind plan/apply) |

The detection covers:

- NVIDIA-usable-via-CDI detection (`nvidia-smi` + CDI-spec / `nvidia-ctk`
  reachability),
- AMD-GPU + GFX-version detection (amdgpu DRM + KFD topology),
- VFIO passthrough readiness (IOMMU groups, per-function PCI scan, display-class
  GPU + IOMMU-group members),
- host-device auto-detection (device-pattern glob + real-GPU render-node pick),
- user-scope CDI-spec generation, and the `RLIMIT_MEMLOCK` / `/dev/vfio`
  group-access passthrough-readiness probes.

It also owns the **driver-switch** (`vfio` ↔ `nvidia` rebind) — the
`switchGPUDriverMode` family plus the switch-plan dry-run, served over the same
`verb:gpu` OpRun actions. Every driver-switch consumer (`charly vm gpu`, the
preempt arbiter, plugin-gpu's own switch legs) dispatches `verb:gpu` directly.

The three static data tables (`device_patterns` / `gpu_vendors` /
`pci_class_labels`) are this plugin's own embed (`data.go` / `data.yml`) — it is
the one data source (R3).

The plugin is **compiled-in**: the deploy/config hot paths call the shims many
times, and `MemlockLimitBytes` must read charly's own process `RLIMIT_MEMLOCK` —
both require in-process placement.

## How to use it

The verb is a host-detection surface reached by charly's own commands
(`charly doctor`, the GPU arbiter, `charly vm gpu`, the pod config/start/shell
paths) via peer `InvokeProvider` dispatches — it is not a general authoring step.

```bash
charly vm gpu status    # dispatch verb:gpu detection + switch-plan dry-run
```

## Layout

- `candy/plugin-gpu/` — the plugin module: `main.go` (the OpRun entrypoint),
  `detect.go`, `switch.go`, `data.go` / `data.yml` (the embedded tables),
  `schema/gpu.cue`, `cmd/serve/main.go`.
- `charly.yml` — the root project manifest (`discover: candy`).
- `.github/workflows/tag-on-merge.yml` — CalVer tag + `CHANGELOG/` on merge.

## Related

- Owning skill: `/charly-internals:plugin` — the plugin/provider model. This candy
  carries no `skill:` entity of its own; the gap is tracked in
  [opencharly/opencharly#291](https://github.com/opencharly/opencharly/issues/291).
- [`opencharly/charly`](https://github.com/opencharly/charly) — the charly CLI.
