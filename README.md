# PrologForge

A containerized SWI-Prolog development environment for macOS (and other Docker-capable systems), with Docker Compose, Zed editor integration, and a Prolog Language Server.

## What you get

- SWI-Prolog runs in Docker; no host Prolog installation is required.
- Docker Compose provides repeatable build and run commands.
- A Zed extension registers Prolog syntax and starts the SWI-Prolog LSP inside Docker.
- Zed tasks for an interactive REPL and running the current file.
- A small example project and helper scripts.

> **Status:** This is a starter project. The Docker workflow is designed to be reproducible, but the custom Zed extension must be built and validated in your local Zed installation. Zed extension APIs and the SWI-Prolog LSP pack can evolve.

## Requirements

- macOS, Linux, or Windows with a Unix-like shell
- Docker Desktop (or Docker Engine + Compose plugin)
- Zed
- Git
- Rust toolchain only if you want to build the bundled Zed extension locally

## Quick start: Docker and Prolog

Clone the repository and enter it:

```bash
git clone https://github.com/YOUR_USERNAME/prolog-forge.git
cd prolog-forge
```

Build the image:

```bash
./scripts/build.sh
```

Check SWI-Prolog:

```bash
./scripts/prolog-version.sh
```

Run the example:

```bash
./scripts/run-file.sh src/family.pl
```

Run a query:

```bash
./scripts/query.sh src/family.pl "grandparent(john, X), writeln(X)"
```

Start an interactive REPL:

```bash
./scripts/repl.sh
```

The scripts mount the project directory into the container. Files saved in Zed are immediately visible to SWI-Prolog in Docker.

## Zed setup

1. Open this repository as a project in Zed.
2. The `.zed/settings.json` config selects the `swipl-lsp` language server for Prolog.
3. Build/install the bundled extension from `zed-extension/`:
   - Install Rust using <https://rustup.rs/>.
   - Ensure the WASI target is installed: `rustup target add wasm32-wasip2`.
   - In Zed, run **zed: install dev extension** and select this repository's `zed-extension` directory.
4. Restart/reload the project in Zed if prompted.

The extension starts the LSP using `docker compose run --rm -T prolog ...`. It mounts the project at the same absolute path inside the container so file URIs sent by Zed resolve correctly.

### Zed tasks

Use the command palette to run:
- `task: PrologForge - Start REPL`
- `task: PrologForge - Run current file`

If Zed does not discover the tasks immediately, reload the project or run them from `.zed/tasks.json`.

## Project layout

```text
prolog-forge/
├── .zed/
│   ├── settings.json
│   └── tasks.json
├── docker/
│   └── Dockerfile
├── scripts/
│   ├── build.sh
│   ├── prolog-version.sh
│   ├── query.sh
│   ├── repl.sh
│   └── run-file.sh
├── src/
│   └── family.pl
├── zed-extension/
│   ├── Cargo.toml
│   ├── extension.toml
│   └── src/lib.rs
├── compose.yaml
└── README.md
```

## Notes and troubleshooting

- Docker Desktop must be running before using the scripts or the LSP.
- The first build downloads the SWI-Prolog image and installs the `lsp_server` pack; it can take a little while.
- The LSP and REPL are separate containers. The LSP stays alive for the editor session; execution containers start when requested and are removed on exit.
- If the language server fails to start, first verify Docker execution with `./scripts/prolog-version.sh`, then inspect Zed's language-server logs.
- If the `lsp_server` pack cannot be installed in the image, check the SWI-Prolog image/package manager output and rebuild with `docker compose build --no-cache`.
- The bundled Zed extension reuses the Prolog grammar repository and commit referenced in its manifest. Check that upstream repository and Zed's extension API documentation if you update it.

## License

Choose a license before publishing. MIT is a common permissive choice for developer tooling; add a `LICENSE` file if you choose it.
