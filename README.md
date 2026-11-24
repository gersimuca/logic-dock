# LogicDock

**A complete, containerized SWI-Prolog development environment powered by Docker, Docker Compose and Zed.**

LogicDock brings together everything needed to develop, execute and debug Prolog applications in one reproducible development environment.

It uses Docker to run SWI-Prolog, integrates with the Zed editor, and provides Language Server Protocol (LSP) support for editor assistance.

The goal is simple: write Prolog code in Zed, receive intelligent editor assistance, and execute your programs inside an isolated Docker environment without installing SWI-Prolog directly on your host machine.

---

## Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Technology Stack](#technology-stack)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Docker Environment](#docker-environment)
- [Running Prolog](#running-prolog)
- [Interactive REPL](#interactive-repl)
- [Zed Editor Integration](#zed-editor-integration)
- [Language Server Protocol](#language-server-protocol)
- [Example Project](#example-project)
- [GitHub Setup](#github-setup)
- [Troubleshooting](#troubleshooting)
- [Development and Contributions](#development-and-contributions)
- [License](#license)

---

## Features

### Containerized Prolog Runtime

- SWI-Prolog runs inside Docker.
- No host-level SWI-Prolog installation required.
- Reproducible development environment.
- Docker Compose service management.
- Shared project files between the host and containers.

### Zed Editor Integration

- Prolog syntax highlighting.
- Language Server Protocol integration.
- Diagnostics and error reporting.
- Predicate completion.
- Go to definition and find references.
- Hover documentation, where supported by the LSP.

*The available editor features depend on the SWI-Prolog language server and its current implementation.*

### Prolog Execution

- Execute individual Prolog files.
- Run custom Prolog queries.
- Start an interactive SWI-Prolog REPL.
- Execute programs through Docker Compose.
- Launch execution tasks from Zed.

### Developer Experience

- Simple shell scripts.
- Centralized Docker configuration.
- Example Prolog knowledge base.
- GitHub-ready project structure.
- Easy setup for new development machines.

---

## Architecture

PrologForge separates the editor assistance process from program execution.

Both run inside Docker containers and access the same project directory.

```text
                  PROLOGFORGE
                       |
          +------------+------------+
          |                         |
          v                         v
      ZED EDITOR               TERMINAL / ZED
          |                         |
          v                         v
    Language Server             Execution
          |                         |
          v                         v
      DOCKER                    DOCKER
          |                         |
          v                         v
    SWI-PROLOG LSP           SWI-PROLOG RUNTIME
          |                         |
          +------------+------------+
                       |
                       v
               SHARED PROJECT FILES
                       |
                       v
                  PROLOG SOURCE
```

### Editor Assistance

The Zed extension starts the SWI-Prolog Language Server inside Docker.

Zed communicates with it using the Language Server Protocol over standard input and output (stdio).

### Program Execution

Docker Compose starts a separate SWI-Prolog process when a file or query is executed.

An interactive REPL can also be started independently.

### Shared Filesystem

The project directory is mounted into the containers.

This means:

- Files saved in Zed are immediately visible inside Docker.
- Prolog source files do not need to be copied into containers.
- Changes to source files do not require rebuilding the Docker image.

---

## Technology Stack

| Technology | Purpose |
|---|---|
| SWI-Prolog | Prolog engine and runtime |
| Docker | Containerized execution |
| Docker Compose | Container orchestration |
| Zed | Code editor |
| Language Server Protocol | Editor assistance |
| Rust | Custom Zed extension |
| Tree-sitter | Prolog syntax parsing |
| Git | Version control |
| GitHub | Source code hosting |

---

## Project Structure

```text
logic-dock/
│
├── .zed/
│   ├── settings.json
│   └── tasks.json
│
├── docker/
│   └── Dockerfile
│
├── scripts/
│   ├── build.sh
│   ├── prolog-version.sh
│   ├── query.sh
│   ├── repl.sh
│   └── run-file.sh
│
├── src/
│   └── family.pl
│
├── zed-extension/
│   ├── Cargo.toml
│   ├── extension.toml
│   └── src/
│       └── lib.rs
│
├── compose.yaml
├── .gitignore
└── README.md
```

### Directory Responsibilities

**`.zed/`**

Contains Zed editor configuration and task definitions.

**`docker/`**

Contains the Dockerfile used to build the SWI-Prolog development image.

**`scripts/`**

Contains helper scripts for building the environment, checking the Prolog version, running files, executing queries and starting the REPL.

**`src/`**

Contains Prolog source code and example applications.

**`zed-extension/`**

Contains the custom Zed extension responsible for launching the SWI-Prolog Language Server inside Docker.

---

## Prerequisites

Before installing PrologForge, make sure the following tools are available.

### 1. Docker Desktop

Download and install Docker Desktop:

https://www.docker.com/products/docker-desktop/

Start Docker Desktop before running any PrologForge commands.

Verify the installation:

```bash
docker --version
docker compose version
```

### 2. Zed Editor

Download Zed:

https://zed.dev/

LogicDock uses Zed as its primary development editor.

### 3. Git

Verify Git:

```bash
git --version
```

### 4. Rust

Rust is required to build and install the custom Zed extension locally.

Install Rust:

https://rustup.rs/

Verify:

```bash
rustc --version
cargo --version
```

Install the WebAssembly target used by Zed extensions:

```bash
rustup target add wasm32-wasip2
```

---

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/gersimuca/logic-dock.git
```

Enter the project directory:

```bash
cd logic-dock
```

### 2. Make Scripts Executable

```bash
chmod +x scripts/*.sh
```

### 3. Build the Docker Image

```bash
./scripts/build.sh
```

This builds the SWI-Prolog Docker image and installs the required Prolog Language Server package.

The first build may take some time because Docker needs to download the base image and install the package.

### 4. Verify SWI-Prolog

```bash
./scripts/prolog-version.sh
```

If the installation succeeds, the SWI-Prolog version will be displayed.

Your Docker-based Prolog runtime is now ready.

---

## Docker Environment

LogicDock uses Docker Compose to manage the SWI-Prolog environment.

The main configuration is located in:

```text
compose.yaml
```

The Docker image is defined in:

```text
docker/Dockerfile
```

### Build

```bash
./scripts/build.sh
```

### Rebuild Without Cache

```bash
docker compose build --no-cache
```

### Start an Interactive Prolog Session

```bash
./scripts/repl.sh
```

### Remove Stopped Containers

Execution containers are started with `--rm`, so they are automatically removed after exiting.

To inspect Docker resources:

```bash
docker ps -a
docker images
```

---

## Running Prolog

LogicDock provides scripts for executing Prolog source files and custom queries.

### Execute a Prolog File

```bash
./scripts/run-file.sh src/family.pl
```

This loads the specified Prolog file inside the Docker container.

### Execute a Query

```bash
./scripts/query.sh src/family.pl "grandparent(john, X), writeln(X)"
```

Expected output:

```text
alice
```

### Execute Other Queries

Find John's children:

```bash
./scripts/query.sh src/family.pl "parent(john, X), writeln(X)"
```

Find Mary's children:

```bash
./scripts/query.sh src/family.pl "parent(mary, X), writeln(X)"
```

Find John's grandchildren:

```bash
./scripts/query.sh src/family.pl "grandparent(john, X), writeln(X)"
```

---

## Interactive REPL

LogicDock supports an interactive SWI-Prolog Read-Eval-Print Loop.

Start it using:

```bash
./scripts/repl.sh
```

You should see the SWI-Prolog prompt:

```text
?-
```

You can now execute queries interactively.

For example:

```prolog
?- parent(john, mary).
```

Expected result:

```text
true.
```

Another example:

```prolog
?- grandparent(john, X).
```

Expected result:

```text
X = alice.
```

Exit the REPL:

```prolog
?- halt.
```

The interactive session runs inside Docker.

---

## Zed Editor Integration

PrologForge is designed to use Zed as its primary development environment.

Open the project:

```bash
zed .
```

The repository includes Zed settings in:

```text
.zed/settings.json
```

The configuration selects the `swipl-lsp` language server for Prolog.

### Install the Custom Extension

The custom extension is located in:

```text
zed-extension/
```

Install Rust and the WASI target if you have not already done so.

Open Zed and use the command palette:

```text
zed: install dev extension
```

Select the following directory:

```text
prolog-forge/zed-extension/
```

The extension registers the Prolog language server and launches it through Docker Compose.

Restart or reload the project if necessary.

### Zed Tasks

PrologForge includes task definitions in:

```text
.zed/tasks.json
```

Available tasks:

| Task | Description |
|---|---|
| PrologForge - Start REPL | Starts an interactive SWI-Prolog session |
| PrologForge - Run current file | Executes the current Prolog source file |

Run tasks through the Zed command palette.

---

## Language Server Protocol

PrologForge uses the SWI-Prolog `lsp_server` package.

The language server is responsible for communicating with Zed and providing editor assistance.

### Supported Capabilities

Depending on the installed version of the language server:

- Syntax and semantic diagnostics.
- Predicate completion.
- Go to definition.
- Find references.
- Hover documentation.
- Symbol highlighting.
- Variable renaming.
- Code formatting.

### How It Starts

The language server is launched using:

```bash
swipl \
  -O \
  -g "use_module(library(lsp_server))" \
  -g "lsp_server:main" \
  -t halt \
  -- stdio
```

The custom Zed extension invokes this command inside the Docker container.

Communication between Zed and the language server uses stdio.

**Note:** Language Server Protocol support is provided by the SWI-Prolog package. PrologForge supplies the Docker and Zed integration. It does not implement a separate Prolog language server.

---

## Example Project

The repository includes a simple Prolog knowledge base:

```text
src/family.pl
```

Example:

```prolog
% Facts

parent(john, mary).
parent(mary, alice).
parent(john, peter).

% Rules

grandparent(X, Y) :-
    parent(X, Z),
    parent(Z, Y).

grandchild(X, Y) :-
    grandparent(Y, X).
```

Run the example:

```bash
./scripts/query.sh src/family.pl "grandparent(john, X), writeln(X)"
```

Expected output:

```text
alice
```

Use this example to verify that Prolog execution works correctly before developing your own applications.

---

## Troubleshooting

### Docker Is Not Running

If you receive an error indicating that Docker cannot connect to its daemon, start Docker Desktop and try again.

### SWI-Prolog Cannot Be Found

Rebuild the image:

```bash
docker compose build --no-cache
```

Then verify:

```bash
./scripts/prolog-version.sh
```

### Language Server Does Not Start

Check the following:

1. Docker Desktop is running.
2. The Docker image has been built successfully.
3. The `lsp_server` package is installed.
4. The custom Zed extension is installed.
5. The project is open as a Zed worktree.
6. The Zed language server is enabled for Prolog.

You can also inspect Zed's language server logs.

### Prolog Syntax Highlighting Is Missing

Verify that the custom Prolog extension is installed and that the Prolog grammar is available.

Reload Zed after installing the extension.

### Scripts Are Not Executable

Run:

```bash
chmod +x scripts/*.sh
```

### Changes Are Not Visible in Docker

Check that the project directory is mounted correctly in `compose.yaml`.

The Docker volume should map the host project directory to the same absolute path inside the container when using the LSP integration.

---

## Development and Contributions

Contributions, suggestions and improvements are welcome.

Potential areas for future development include:

- Improved Zed integration.
- More advanced Prolog debugging workflows.
- Additional Prolog language tooling.
- Automated testing.
- Multiple Prolog project templates.
- Better execution and query management.
- CI/CD workflows.
- Development container improvements.
- Additional documentation and examples.

### Contribution Workflow

1. Fork the repository.
2. Create a feature branch.
3. Implement your changes.
4. Test your changes locally.
5. Submit a pull request.

Example:

```bash
git checkout -b feature/my-improvement
```

---

## License

This project is intended to be open source.

Add a `LICENSE` file to the repository before publishing and choose an appropriate license, such as the MIT License.
