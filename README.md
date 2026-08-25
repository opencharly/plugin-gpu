# plugin-gpu

The `plugin-gpu` plugin candy of the [opencharly/charly](https://github.com/opencharly/charly)
candy library, as a standalone repo (the candy de-submodule cutover, plugin
kind). The Go module lives at `candy/plugin-gpu/` with module path
`github.com/opencharly/plugin-gpu/candy/plugin-gpu`; the charly resolver fetches this repo at the pinned tag and
the compiled-in wiring imports the module at that path.
