---
date: 2021-02-04T14:36
tags: 
  - stub
---

# Procedure of a Wharf container step

Sample `.wharf-ci.yml`:

```yaml
myStage:
  myStep:
    container:
      image: mcr.microsoft.com/dotnet/sdk:latest
      cmds:
        - dotnet run
```

Then you run something like

```sh
wharf build kubernetes --namespace build
```

Here's a comparison of procedures between running in Kubernetes and locally via
Docker:

## Kubernetes

1. Start pod
   - name: wharf-container-12345
     - emptyDir volume
     - initcontainer:
       - mount emptyDir at `/emptyDir`
       - image: `alpine/git:latest`
       - cmd: `git clone "${REPO}" /emptyDir/repo`
     - container:
       - image: `${myStage.myStep.container.image}`
       - cmd: `${myStage.myStep.container.shell}` *(Just to make the container sit and wait for input that we're never going to give it)*
       - tty: `true`
       - working dir: `/emptyDir/repo`

2. Wait until initcontainer is done and container has started

3. Run the commands remotely

   - Alternative A:
     1. Write the commands into a file and add the leading shebang. Ex:
        ```sh
        #!${myStage.myStep.container.shell}
        ${myStage.myStep.container.cmds}
        ```
        
     2. Get that file over to the container. For example like how `kubectl cp`
        does it. (This would require having `tar` installed though).

        Could use a ConfigMap or Secret here and set the 
        `configMap.defaultMode` to `777`.[^volume-projections]
        
     3. Run the script. Use something equivalent to
     
        ```sh
        kubectl exec -ti "${podName}" /path/to/script
        ```
        
   - Alternative B:
     1. Run the commands by assuming the shell got a `-c` flag:
     
        ```sh
        kubectl exec -ti "${podName}" \
          "${myStage.myStep.container.shell}" \
          -c "${myStage.myStep.container.cmds}"
        ```
        
   - Alternative C:
     1. Feed init container with the command and then let it place that inside
        the emptyDir. Example:
        
        ```sh
        git clone "${REPO}" /emptyDir/repo
        
        cat <<'WHARF_CONTAINER_SCRIPT' > /emptyDir/script
        #!${myStage.myStep.container.shell}
        ${myStage.myStep.container.cmds}
        WHARF_CONTAINER_SCRIPT
        
        chmod +x /emptyDir/script
        ```

     2. Run the script. Use something equivalent to
     
        ```sh
        kubectl exec -ti "${podName}" /emptyDir/script
        ```
        
## Local via Docker

1. Write the commands to a temporary file. Ex:

   ```sh
   mkdir -p /tmp/wharf/build/12345

   cat <<'WHARF_CONTAINER_SCRIPT' > /tmp/wharf/build/12345/script
   #!${myStage.myStep.container.shell}
   ${myStage.myStep.container.cmds}
   WHARF_CONTAINER_SCRIPT

   chmod +x /tmp/wharf/build/12345/script
   ```
   
2. Copy the repo

   ```sh
   cp -r . /tmp/wharf/build/12345/repo
   ```

2. Run the command via docker

   ```sh
   # Assuming the repo is at pwd
   docker run --rm -it \
     --volume /tmp/wharf/build/12345:/wharf \
     --workdir /wharf/repo \
     --entrypoint "${myStage.myStep.container.shell}" \
     "${myStage.myStep.container.image}" \
     /wharf/script
   ```

[^volume-projections]: Kubernetes reference. Config and Storage Resources, Volume, Projections <https://kubernetes.io/docs/reference/kubernetes-api/config-and-storage-resources/volume/#Projections>
