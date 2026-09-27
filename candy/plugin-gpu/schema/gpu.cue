// plugin-gpu's OWN self-contained CUE schema — the SINGLE SOURCE for this plugin's
// declaration surface, served over Describe exactly like every other plugin's schema
// (there is no schema-less plugin):
//
//  1. SERVE over Describe — the host splices `base ++ plugin` at the load gate
//     (registerPluginUnitSchema), so the plugin's declarations travel WITH it and
//     a self-contained schema that will not splice is a LOUD load failure.
//  2. DOCUMENT — `charly docs generate` renders this plugin's page from its
//     providers + this schema + the candy `description:`.
//
// verb:gpu's authored input is NOT a plugin_input: callers resolve the word and Invoke
// OpRun with a structured spec.GpuProbeInput (detection) or spec.GpuSwitchInput
// (driver switch), so this schema DOCUMENTS the verb contract (no #*Input def).
// SELF-CONTAINED: it references no base def, so it compiles STANDALONE (the property
// that lets the SDK compile it serve-side).
#GpuPlugin: {
	// The capability word the plugin serves.
	verb: "gpu"

	// What the verb does, in one line (the public-docs surface): detect host GPU /
	// VFIO state and switch the NVIDIA driver binding.
	contract: string & !=""
}
