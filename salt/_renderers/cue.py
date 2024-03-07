import json
import subprocess
import pprint

from salt.exceptions import SaltRenderError

def render(template, saltenv='base', sls='', **kwargs):
    if not isinstance(template, str):
        template = template.read()
    
    # Strip shebang off file if needed. Assumes it's first thing in file.
    if template.startswith("#!"):
        template = template[(template.find("\n") + 1) :]

    print(template)

    print("Showing variables:")
    grain_names = __salt__['grains.ls']
    grains = __salt__['grains.items'](grain_names)
    pprint.pprint(grains)

    # Create cuelang compat text block with all values for substitutions
    grains_inject = "#grains: " + json.dumps(grains)
    full_template = template + "\n" + grains_inject

    # TODO: Also do this for pillars.

    # Process it with cue
    command_line = ["cue", "export", "--out", "json"]

    # Add any other args here

    command_line.append("-") # Make it read from stdin/write to stdout

    result = subprocess.run(command_line, input=full_template, text=True, capture_output=True, timeout=10)

    print(result.stderr)
    result.check_returncode() # explode if doesn't return 0 (success)

    parsed_output = json.loads(result.stdout)

    print("Final output:")
    pprint.pprint(parsed_output)

    return parsed_output
