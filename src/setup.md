# Setting Up Your Machine

Everything in this course runs inside a **development container** — a
preconfigured Linux environment, defined by files in this repository, that
Docker builds on your laptop. You do not install Lean, Mathlib, or the book
tooling yourself. You install Docker and VS Code, open this project, and let
the container supply the rest.

The benefit is that every student has an identical environment with fairly low effort.

Work through the steps in order. Step 4 takes the longest; start it before
you need it.

## 1. Install the prerequisites

You need four things on your laptop. Install them in this order.

| | What | Notes |
|---|---|---|
| 1 | A [GitHub account](https://github.com/signup) | Free. Use an address you check. |
| 2 | [Git](https://git-scm.com/downloads) | Already present on macOS and most Linux systems. Check with `git --version`. |
| 3 | [Docker Desktop](https://www.docker.com/products/docker-desktop/) | The container engine. Choose the build matching your chip — Apple Silicon or Intel on macOS. |
| 4 | [Visual Studio Code](https://code.visualstudio.com/) | The editor. |

Then install one VS Code extension by hand — the
[**Dev Containers**](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
extension (`ms-vscode-remote.remote-containers`). Open the Extensions view
(`Cmd+Shift+X` / `Ctrl+Shift+X`), search for "Dev Containers", and install it.
Every *other* extension you need, including Lean 4, is installed automatically
inside the container.

**Give Docker enough room.** This container requests 10 GB of memory, and a
built Mathlib occupies roughly 7 GB on disk. Before continuing:

- Open Docker Desktop → **Settings** → **Resources**.
- Set memory to **at least 10 GB** (12 GB or more if your laptop has 16 GB).
- Confirm you have **15 GB of free disk space**.

On Windows, Docker Desktop must use the **WSL 2** backend; its installer will
offer to set this up.

Start Docker Desktop and leave it running. The container cannot start if the
Docker engine is not running — the single most common setup failure.

## 2. Fork this repository

A *fork* is your own copy of the repository on GitHub. You will do your work
in your fork, so your changes are yours and cannot disturb the course
repository.

1. Go to **[github.com/kevinsullivan/Lean4CS1](https://github.com/kevinsullivan/Lean4CS1)**.
2. Click **Fork** (top right).
3. Leave the name as `Lean4CS1` and click **Create fork**.

You now have `https://github.com/YOUR-USERNAME/Lean4CS1`.

## 3. Clone your fork and open it in VS Code

### Windows users: configure Git first

Do this **before you clone**. These settings affect how files are written to
disk during the clone, so applying them afterward means re-cloning.

This repository is Linux-based: every file in it ends its lines with a single
newline (LF), and the container runs Linux. Git for Windows, by default,
converts line endings to Windows style (CRLF) on checkout. That conversion
breaks things inside the container — shell scripts fail with errors like
`bash\r: command not found`, and `scripts/convert.py` and the `Makefile`
misbehave in ways whose cause is not obvious from the symptom.

Open **Git Bash** or **PowerShell** and run:

```bash
git config --global core.autocrlf false
git config --global core.eol lf
git config --global core.longpaths true
```

What each one does:

| Setting | Why |
|---|---|
| `core.autocrlf false` | Stops Git rewriting LF to CRLF on checkout. Files stay exactly as the repository stores them. |
| `core.eol lf` | Makes LF the line ending Git writes, so files you create match the rest of the repository. |
| `core.longpaths true` | Lifts Windows' 260-character path limit. Mathlib's nested paths under `.lake/packages/` exceed it, and without this the toolchain fails with confusing "file not found" errors. |

Confirm they took effect:

```bash
git config --global --list | findstr core
```

You should see `core.autocrlf=false`, `core.eol=lf`, and
`core.longpaths=true`.

**Set your editor to write LF too.** VS Code shows the current line ending in
the status bar, at the right, as `LF` or `CRLF`. To make LF the default, open
Settings (`Ctrl+,`), search for **Files: Eol**, and choose `\n`.

**Already cloned with the wrong settings?** Apply the three settings above,
then delete the folder and clone again. Re-checking-out in place will not
reliably fix line endings that are already on disk.

**A note on where you clone.** Everything below works from an ordinary Windows
folder such as `C:\Users\you\Lean4CS1`. If builds feel slow, the cause is
usually that Docker reaches Windows files through a translation layer. Cloning
into the WSL 2 filesystem instead — from a WSL terminal, into your Linux home
directory — is substantially faster. Do that only if you are comfortable with
WSL; it is a performance improvement, not a requirement.

### Clone

Clone *your fork*, not the original. Substitute your GitHub username:

```bash
git clone https://github.com/YOUR-USERNAME/Lean4CS1.git
cd Lean4CS1
code .
```

If `code` is not a recognized command, open VS Code, press
`Cmd+Shift+P` / `Ctrl+Shift+P`, run **Shell Command: Install 'code' command in
PATH**, then try again — or simply use **File → Open Folder** and select the
cloned directory.

While you are here, connect your fork back to the course repository so you can
pull in updates later:

```bash
git remote add upstream https://github.com/kevinsullivan/Lean4CS1.git
```

## 4. Reopen the project in the container

With the project open in VS Code, a notification should appear in the
lower-right corner:

> **Folder contains a Dev Container configuration file. Reopen folder to
> develop in a container.**

Click **Reopen in Container**.

If the notification does not appear, press `Cmd+Shift+P` / `Ctrl+Shift+P` and
run **Dev Containers: Reopen in Container**.

**The first build takes a long time — plan on 15 to 45 minutes**, depending on
your laptop and network. Docker is downloading a base image and building the
environment. Click **show log** in the notification if you want to watch. Do
not close VS Code; interrupting it means starting over.

Later launches reuse the built image and take well under a minute.

You know it worked when the green indicator in the bottom-left corner of the
VS Code window reads **Dev Container: CS1**. Open a terminal
(`` Ctrl+` ``, or Terminal → New Terminal) — you are now a user named `dev`
inside Linux, whatever your laptop actually runs.

## 5. Install the Lean toolchain and Mathlib

Two steps remain, both run in the VS Code terminal *inside* the container.

**Open any Lean file first** — for example
`FPCourse/T01_ExpressionsFunctionsRecursion/Week00_AlgebraicTypes.lean`. The Lean 4 extension activates,
notices the `lean-toolchain` file, and installs the exact compiler version
this course uses. A progress notice appears in the status bar. Wait for it to
finish, then confirm:

```bash
lean --version
```

It should report the version named in `lean-toolchain`.

**Then fetch prebuilt Mathlib.** Mathlib is large; compiling it from source
takes hours, and there is no reason to. Download the prebuilt libraries
instead:

```bash
lake exe cache get
```

This retrieves several gigabytes — expect ten minutes or so on a good
connection. Once it finishes, compile the course sources:

```bash
lake build
```

The first run works through the course files; later runs only rebuild what
changed. If `lake build` completes without errors, your environment is
correct and complete.

> **If `lake exe cache get` fails or you skip it**, `lake build` will try to
> compile Mathlib from scratch. If a build seems to run forever with
> unfamiliar file names streaming past, stop it with `Ctrl+C`, run
> `lake exe cache get`, and try again.

## 6. Read the book beside the code

The intended way to study is the rendered book on one side of the screen and
the live, type-checked Lean source on the other.

In the container terminal:

```bash
make serve
```

This runs `mdbook serve -n 0.0.0.0`. The `-n 0.0.0.0` matters: left to its
default, mdBook binds only the IPv6 loopback address, while VS Code's port
forwarding reaches the container over IPv4. The browser then reports
`ERR_CONNECTION_REFUSED` even though the server is running and rebuilding
normally. Wait for the line `Serving on: http://0.0.0.0:3000` before going
on.

**Then find the address your own browser should use.** Port 3000 is the port
*inside* the container. VS Code forwards it to a port on your laptop, and
that port is frequently *not* 3000 — it is often a high number such as
`64461`, and it can change from one session to the next. Do not guess it,
and do not assume `http://localhost:3000` will work.

Open the **PORTS** panel — the tab beside TERMINAL — and read the **Local
Address** column on the row labeled **mdBook**. Whatever it says is the
address that works. Right-click that row and choose **Open in Browser**, or
copy the address.

To keep everything in one window, run **Simple Browser: Show** from the
Command Palette and paste that same address, then drag the tab to the right
half of the editor.

The server rebuilds and refreshes automatically as files change. Leave it
running while you work. If you stop it, or close the terminal it is running
in, the forwarded address stops serving and the page goes blank instead of
reporting an error.

## 7. Verify your setup

Work down this list. If every line holds, you are ready.

- [ ] VS Code's bottom-left indicator reads **Dev Container: CS1**.
- [ ] `lean --version` matches the version in `lean-toolchain`.
- [ ] `lake build` finishes without errors.
- [ ] Opening a `.lean` file shows the Lean infoview; placing the cursor on a
      `#eval` or `#check` line displays its result.
- [ ] `make serve` prints `Serving on: http://0.0.0.0:3000`, and the **Local
      Address** shown in the **PORTS** panel opens this book in a browser.
- [ ] `git remote -v` lists both `origin` (your fork) and `upstream`.

## Working from day to day

**Save your work.** The container is disposable; your files live in the
cloned folder on your laptop and are safe. Commit and push regularly so your
work also exists on GitHub:

```bash
git add .
git commit -m "Week 3 exercises"
git push origin main
```

**Collect course updates.** When new material is published:

```bash
git fetch upstream
git merge upstream/main
```

If the update changes `lean-toolchain` or `lake-manifest.json`, run
`lake exe cache get` again afterward.

## When something goes wrong

| Symptom | Likely cause and remedy |
|---|---|
| "Cannot connect to the Docker daemon" | Docker Desktop is not running. Start it and retry. |
| Container build fails partway | Usually disk or memory. Free space, raise Docker's memory limit, then run **Dev Containers: Rebuild Container**. |
| No Lean infoview; no red squiggles | The Lean extension has not activated. Open a `.lean` file and wait; if nothing happens, run **Developer: Reload Window**. |
| `lake: command not found` | The toolchain is not installed yet. Complete step 5, then open a fresh terminal. |
| Build runs for hours | Mathlib is compiling from source. `Ctrl+C`, then `lake exe cache get`. |
| `bash\r: command not found`, or scripts failing oddly (Windows) | Files were checked out with CRLF line endings. Apply the Git settings in step 3, then delete the folder and clone again. |
| "File name too long" or missing files under `.lake` (Windows) | `core.longpaths` is not set. Run `git config --global core.longpaths true`. |
| `ERR_CONNECTION_REFUSED` in the browser | Most often you used `http://localhost:3000` instead of the **Local Address** from the **PORTS** panel — they are usually different ports. Failing that, mdBook was started without `-n 0.0.0.0` and is listening on IPv6 loopback only; stop it with `Ctrl+C` and rerun `make serve`. |
| The page is completely blank, with no error message at all | The forward is alive but nothing is answering behind it: mdBook is not running. It was stopped, or the terminal it started in was closed. Rerun `make serve`. |
| No **mdBook** row in the **PORTS** panel | The forward was never established. Click **Forward a Port** in that panel and enter `3000`, or run `"$BROWSER" http://localhost:3000/` in the container terminal, which asks VS Code to create the forward and open it. |

Still stuck? Bring the exact command you ran and the exact message you saw —
copy the text rather than describing it — and ask in office hours or by
email.
