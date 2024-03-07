Experimenting with a cue (https://cuelang.org/) renderer for Saltstack.

Includes a test SLS with some random test features, and a cuelang SLS to install
the cue binary somewhere.

The cue binary must be accessible by salt for this to work, as the renderer
calls it.

Salt grains are referenced by `#grains.grain_name` (eg, `#grains.os` for `grains['os']`).

`salt-call --local testing -l debug`
