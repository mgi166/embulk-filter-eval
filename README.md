# Eval filter plugin for Embulk

Evaluate the row element by ruby code

## Overview

* **Plugin type**: filter

## Configuration

* **eval_columns**: (array)
   * The ruby code to be evaluated for each element
* **out_columns**: (array)
   * The column to be output from the input columns

## install

`$ embulk gem install embulk-filter-eval`

## Example

```
$ embulk example
$ embulk guess embulk-example/example.yml -o config.yml
$ embulk preview config.yml

+---------+--------------+-------------------------+-------------------------+----------------------------+
| id:long | account:long |          time:timestamp |      purchase:timestamp |             comment:string |
+---------+--------------+-------------------------+-------------------------+----------------------------+
|       1 |       32,864 | 2015-01-27 19:23:49 UTC | 2015-01-27 00:00:00 UTC |                     embulk |
|       2 |       14,824 | 2015-01-27 19:01:23 UTC | 2015-01-27 00:00:00 UTC |               embulk jruby |
|       3 |       27,559 | 2015-01-28 02:20:02 UTC | 2015-01-28 00:00:00 UTC | Embulk "csv" parser plugin |
|       4 |       11,270 | 2015-01-29 11:54:36 UTC | 2015-01-29 00:00:00 UTC |                       NULL |
+---------+--------------+-------------------------+-------------------------+----------------------------+
```

config.yml as follows

```yaml
filters:
  - type: eval
    eval_columns:
      - id: value + 1
      - account:
      - time: Time.now
      - comment: "'Evil is Evil! ' + value"
```

`value` is an element of the column.  
Such as sample, output will be this.

```
+---------+--------------+-----------------------------+-------------------------+------------------------------------------+
| id:long | account:long |              time:timestamp |      purchase:timestamp |                           comment:string |
+---------+--------------+-----------------------------+-------------------------+------------------------------------------+
|       2 |       32,864 | 2015-03-13 13:20:18.753 UTC | 2015-01-27 00:00:00 UTC |                     Evil is Evil! embulk |
|       3 |       14,824 | 2015-03-13 13:20:18.754 UTC | 2015-01-27 00:00:00 UTC |               Evil is Evil! embulk jruby |
|       4 |       27,559 | 2015-03-13 13:20:18.755 UTC | 2015-01-28 00:00:00 UTC | Evil is Evil! Embulk "csv" parser plugin |
|       5 |       11,270 | 2015-03-13 13:20:18.756 UTC | 2015-01-29 00:00:00 UTC |                       Evil is Evil! NULL |
+---------+--------------+-----------------------------+-------------------------+------------------------------------------+
```

## Build

```
$ rake
```
