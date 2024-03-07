{% set osarch = ((grains['kernel'] ~ '_' ~ grains['osarch']) | lower ) %}
{# {% set base_download = 'https://github.com/cue-lang/cue/releases/download/v0.8.0-alpha.5/cue_v0.8.0-alpha.5_' %} #}
{% set base_download = 'salt://cue_v0.8.0-alpha.5_' %}
{% set full_download = base_download ~ osarch ~ '.tar.gz' %}

{%
    if (grains['kernel'] | lower in ["linux", "darwin"])
        and (grains['osarch'] | lower in ["amd64", "arm64"])
 %}

/opt/cuelang:
  archive.extracted:
    - source: {{ full_download | lower }}
    - use_etag: true
    - enforce_toplevel: false

/usr/local/bin/cue:
  file.symlink:
    - target: /opt/cuelang/cue
    - mode: 0755

/usr/local/bin/cuepls:
  file.symlink:
    - target: /opt/cuelang/cuepls
    - mode: 0755

{% else %}

cuelang setup:
  test.succeed_without_changes:
    - name: "No cuelang release for this os-arch combo ({{ osarch }})."

{% endif %}

