---
date: 2021-02-25T11:26
tags:
  - .wharf-ci.yml
---

# Levels of variable substitution

This is mostly just a brainstorm of the levels of variable substitution
complexity in YAML files.

This could be translated as well over to Kubernetes manifests that are written
in YAML, leading to letting YAML be the language of choice in Wharf, or if we
expand to allow other object notations as well such as JSON, SEN, XML, etc.

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
## Table of contents

- [Levels of variable substitution](#levels-of-variable-substitution)
  - [0. Current](#0-current)
  - [1. Keeping the basic types](#1-keeping-the-basic-types)
  - [2. Keeping even lists](#2-keeping-even-lists)
  - [3. Full dynamic AST traversal](#3-full-dynamic-ast-traversal)
  - [4. Recursive dynamic AST traversal](#4-recursive-dynamic-ast-traversal)
  - [5. Recursive variable lookup](#5-recursive-variable-lookup)

<!-- markdown-toc end -->

## 0. Current

This is how our variable substitution in our Jenkinsfile works currently.

It sort of resembles variable substitution in scripting languages such as
`sh` or `bash`, as they only support strings and force all values into strings
at all times. It's very unflexible and very common cause of headaches.

Wharf sufferes kind of the same symphtoms in users, as the border of where the
features stop seems arbitrary and lackluster.

```yaml
environments:
  myEnv:
    myBool: true
    myString: "true"

myStage:
  environments: [myEnv]
  myStep1:
    docker:
      push: true
  myStep2:
    docker:
      push: ${myBool}
  myStep3:
    docker:
      push: ${myString}
```

Resolves to:

```yaml
myStage:
  environments: [myEnv]
  myStep1:
    docker:
      push: true
  myStep2:
    docker:
      push: "true"
  myStep3:
    docker:
      push: "true"

# And then the Groovy code in the Jenkinsfile parses it again when reading the
# property, meaning we could probably even allow values such as `1` or `"on"`
```

## 1. Keeping the basic types

```yaml
environments:
  myEnv:
    myBool: true
    myString: "true"

myStage:
  environments: [myEnv]
  myStep1:
    docker:
      push: true
  myStep2:
    docker:
      push: ${myBool}
  myStep3:
    docker:
      push: ${myString}
```

Resolves to:

```yaml
myStage:
  environments: [myEnv]
  myStep1:
    docker:
      push: true
  myStep2:
    docker:
      push: true
  myStep3:
    docker:
      # Here we could throw because the variable is not a boolean
      push: "true"
```

## 2. Keeping even lists

```yaml
environments:
  myEnv:
    myCmds:
      - a
      - b
      - c

myStage:
  environments: [myEnv]
  myStep1:
    container:
      cmds:
        - foo
        - bar
  myStep2:
    container:
      cmds: ${myCmds}
  myStep3:
    container:
      # What do we do here?
      # a: throw an error
      # b: try to deal with it
      cmds: "${myCmds} heyo"
```

Resolves to:

```yaml
myStage:
  environments: [myEnv]
  myStep1:
    container:
      cmds:
        - foo
        - bar
  myStep2:
    container:
      cmds:
        - a
        - b
        - c
  myStep3:
    container:
      # If we "b: try to deal with it", how would that look?
      cmds: "[a, b, c] heyo"
      cmds:
        - a
        - b
        - c heyo
      cmds:
        - a
        - b
        - c
        - heyo
      cmds:
        - a heyo
        - b heyo
        - c heyo
```

## 3. Full dynamic AST traversal

This could more or less only be accomplished by storing the entire abstract
syntax tree (AST) of the YAML in memory, and as we traverse it we will
substitute variables appropriately.

This resembles more how scripting languages such as PowerShell works.

```yaml
environments:
  myEnv:
    myContainer:
      image: ubuntu:20.04
      cmds:
        - echo foo
        - sleep 5s
        - echo bar
    myStep:
      docker:
        push: true

myStage:
  environments: [myEnv]
  myStep1:
    container:
      cmds:
        - foo
        - bar

  myStep2:
    container: ${myContainer}

  myStep3:
    # Difficult to come up with a good way this should be interpreted as.
    # Best solution should probably just be to throw here, but for consistency
    # then the above example should also throw on its weird list thing
    container: "${myContainer} heyo"
    
  myStep4: ${myStep}
```

Resolves to:

```yaml
myStage:
  environments: [myEnv]
  myStep1:
    container:
      cmds:
        - foo
        - bar
  myStep2:
    container:
      image: ubuntu:20.04
      cmds:
        - echo foo
        - sleep 5s
        - echo bar
        
  # `myStep3` omitted for demo purposes because it would throw an error
  
  myStep4:
    docker:
      push: true
```

## 4. Recursive dynamic AST traversal

To allow variables to reference each other, this can get messy quickly.
We would have to be able to detect recursion loops for this to be viable.

```yaml
inputs:
  myImage:
    type: string
    default: ubuntu:20.04

environments:
  myEnv:
    myContainer:
      image: ${myImage}
      cmds: ${myCmds}
    myCmds:
      - a
      - b
      - c

myStage:
  environments: [myEnv]
  myStep:
    container: ${myContainer}
```

Resolves to:

```yaml
myStage:
  environments: [myEnv]
  myStep:
    container:
      # Given that the input was not changed from its default value.
      image: ubuntu:20.04
      cmds:
        - a
        - b
        - c
```

## 5. Recursive variable lookup

Here we enter the land of *"Yo wtf!"*

This would require recursive traversal on even the variable lookups.

> Would this even be useful? Some might like it, but it will probably just be
> confusing to read.

```yaml
inputs:
  myStepSelection:
    type: enum
    default: 
    values:
      - Container
      - Docker

environments:
  myEnv:
    myDocker:
      docker:
        image: ubuntu:20.04
    myContainer:
      container:
        image: ubuntu:20.04
        cmds: ${myCmds}
    myCmds:
      - a
      - b
      - c
    mySteps:
      - myDocker
      - myContainer

myStage:
  environments: [myEnv]
  # Select the variable based on another variable
  # Either resolves to
  #   if ${myStepSelection}="Container" -> ${myContainer}
  #   if ${myStepSelection}="Docker" -> ${myDocker}
  myStep: ${my${myStepSelection}}

myMatrixStage:
  # No clue how we would resolve lists, but this might be the technique
  step_${mySteps}: ${${mySteps}}
```

Resolves to: (if `myStepSelection` is set to `Container`)

```yaml
myStage:
  environments: [myEnv]
  myStep:
    container:
      image: ubuntu:20.04
      cmds:
        - a
        - b
        - c

myMatrixStage:
  step_myDocker:
    docker:
      image: ubuntu:20.04
      
  step_myContainer:
    container:
      image: ubuntu:20.04
      cmds:
        - a
        - b
        - c
```

Resolves to: (if `myStepSelection` is set to `Docker`)

```yaml
myStage:
  environments: [myEnv]
  myStep:
    docker:
      image: ubuntu:20.04

myMatrixStage:
  step_myDocker:
    docker:
      image: ubuntu:20.04
      
  step_myContainer:
    container:
      image: ubuntu:20.04
      cmds:
        - a
        - b
        - c
```
