# Hiera YAML Array

This is a fork of hiera YAML backend with support for array variable interpolations.

## Array interpolations

If `bar` is a variable defined as an array in puppet and you have the following variable interpolation in the YAML file:

```
foo: '%{bar}'
```

The result sill be the same as:

```
foo:
  - bar[0]
  - bar[1]
  - ...
```

On original hiera backend the array variable is just casted to a string.

To trigger this array expansion behavior the string where the interpolation is in should contain just one variable and nothing more.

# Install

`gem install hiera-yaml-array`

# Configuration

Same as the Yaml backend, but use the key `yaml_array` instead of `yaml`.

# Contact

* Maintainer: Hugo Parente Lima c/o Reliant Security, Inc.
* Email: hugoATreliantsecurity.com
* IRC (freenode): hugopl

