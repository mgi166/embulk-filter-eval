# Eval filter plugin for Embulk

TODO: Write short description here and embulk-filter-eval.gemspec file.

## Overview

* **Plugin type**: filter

## Configuration

- **eval_columns**: (array, required)

## Example

```yaml
filters:
  - type: eval
    eval_columns:
      - id: value + 1
      - account:
      - comment: value + 'Eval is Evil!'
```


## Build

```
$ rake
```
