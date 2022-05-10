# Wharf architecture

This repo contains notes about the architecture. The ones that are unfinished
will be found under the `stub` directory.

We're using [neuron](https://github.com/srid/neuron) for this to turn it into
a web page with HTML files instead of markdown files.

## Reading: <https://wharf.iver.com/wharf-notes>

All commits to `master` are deployed there using GitHub pages.

## Writing

Recommended to use an editor plugin for this. Check the neuron documentation
for [Editor integration](https://neuron.zettel.page/editor.html) for more info.

For comtributors/maintainers with write access to this repo: It's OK to push to
`master` here, as it's mostly used to keep temporary/draft/stub notes.

## Running

### Running via docker

> This will watch the files for changes, but will not automatically refresh your
> browser. You'll have to refresh the page manually.

```sh
docker run --rm -it -p 8080 -v $(pwd):/notes sridca/neuron neuron rib -Sw
```

### Running via neuron

You can run it locally and have it hosted as a web page to see it rendered.

1. Install neuron: <https://neuron.zettel.page/install.html>

2. Run the `rib` subcommand to generate and host the files on localhost:8080

   > This will watch the files for changes, but will not automatically refresh your
   > browser. You'll have to refresh the page manually.

   ```sh
   # -S makes it host at localhost:8080
   # -w makes it watch for changes and automatically regenerate
   neuron rib -Sw
   ```

3. Visit <http://localhost:8080>

## Building

### Building docker image

```sh
docker build -t wharf-notes .

docker run --rm -it -p 8080:8080 wharf-notes
```

### Building via neuron

You can also just generate the files and then host it via for example nginx.

1. Install neuron: <https://neuron.zettel.page/install.html>

2. Run the `rib` subcommand, but without any arguments

   ```sh
   neuron rib
   ```

3. Publish the files found in `.neuron/output`

---

Maintained by [Iver](https://www.iver.com/en).
Licensed under the [MIT license](./LICENSE).
