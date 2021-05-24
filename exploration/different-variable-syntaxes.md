---
date: 2021-03-05T10:42
tags:
  - .wharf-ci.yml
---

# Different variable syntaxes

Currently Wharf's variable syntax looks like this: `${myVariable}`, and is
escaped like this: `${%myVariable%}`

This is a weird syntax, and except the escaping part, it actually collides too
heavily with variable syntaxes from other systems such as bash, PowerShell,
Dockerfile, et.al.

## Inspiration

Here's some different syntaxes that can be found out in the wild:

| Used in                                             | Usage                        | Escaped                   |
| -------                                             | -----                        | -------                   |
| Bash, PowerShell, Dockerfile, CircleCI env var      | `$myVariable`                | `\$myVariable`            |
| Bash, PowerShell, Dockerfile env var                | `${myVariable}`              | `\${myVariable}`          |
| Batch (.bat)                                        | `%myVariable%`               | `%%myVariable%%`          |
| CircleCI parameter                                  | `<<parameters.myVariable>>`  | *unknown*                 |
| Mustache templates (ex: Helm)                       | `{{myVariable}}`             | ``{{`{{myVariable}}`}}``  |
| A.P. value expr[^ap-expr]                           | `$(myVariable)`              | *unknown*                 |
| A.P. runtime expr[^ap-expr]                         | `$[myVariable]`              | *unknown*                 |
| A.P. compile-time expr[^ap-expr], GitHub Actions    | `${{parameters.myVariable}}` | *unknown*                 |
| XML/HTML                                            | `<!--myVariable-->`          | `&lt;!--myVariable--&gt;` |

### CircleCI boolean parameters

If a parameter is of type boolean in CircleCI, then you can have a slighly
varied syntax that can omit some text based on that boolean value.[^circleci-bool-param]

<!-- Just using F# syntax here because it looked nice when rendered -->

```fsharp
<<# myBoolVar >>conditionally outputted<</ myBoolVar >>
```

Example:

```yaml
inputs:
  - name: forcePush
    type: boolean
    default: false

myStage:
  myStep:
    container:
      image: ubuntu:20.04
      cmds:
        - git push <<# forcePush >>--force<</ forcePush >>
```

## Other ideas

| Usage              | Escaped |
| -----              | ------- |
| `#{myVariable}`    | ...     |
| `{\|myVariable\|}` | ...     |
| `<\|myVariable\|>` | ...     |
| `#:myVariable:#`   | ...     |
| `@@myVariable@@`   | ...     |
| `::myVariable::`   | ...     |

The winning qualities of a good variable substitution syntax is:

- low collision with already used syntaxes (counterexample: `${myVariable}`)

- easy to see (counterexample: `__myVariable__`)

- easy to write (counterexample: `$*^myVariable^*$`)

- small overhead (counterexample:
  `$$WHARF-VAR-BEGIN: myVariable :WHARF-VAR-END$$`)

- usable in YAML, i.e. YAML should not try to parse it as anything else than a
  string (counterexample: `{myVariable}`)
  
  - starting with `{` could be interpreted as map
  - starting with `[` could be interpreted as sequence
  - starting with `%` could be interpreted as YAML/tag directive (ex: `%YAML 1.3`)
  - starting with `?` could be interpreted as map key (ex: `? key`)
  - starting with `:` could be interpreted as map value (ex: `: value`)
  - including `#` could be interpreted as a comment
  - including `:` could be interpreted as property key-value (ex: `key: value`)
  - including `!` could be interpreted as tags (ex: `!yaml!str`)
  - including `&` could be interpreted as anchor definition (ex: `&A`)
  - including `*` could be interpreted as anchor reference (ex: `*A`)

[^circleci-bool-param]: CircleCI boolean parameter syntax, <https://circleci.com/docs/2.0/reusing-config/#boolean>
[^ap-expr]: Azure Pipelines (A.P) YAML expressions, <https://docs.microsoft.com/en-us/azure/devops/pipelines/process/expressions?view=azure-devops>
