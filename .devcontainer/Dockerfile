# Copyright © 2001 by the Rectors and Visitors of the University of Virginia.
FROM python:3.14-slim-bookworm
LABEL org.opencontainers.image.description="Lean-Enabled DEvelopment and Publication VM"

ARG DEBIAN_FRONTEND=noninteractive
ARG YQ_VERSION=4.2.0
ARG GH_VERSION=2.87.2
ARG MDBOOK_VERSION=0.5.4
ARG MDBOOK_TOC_VERSION=0.15.4
ARG MDBOOK_MERMAID_VERSION=0.17.1

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    PYTHONIOENCODING=utf-8 \
    SHELL=/bin/bash

SHELL ["/bin/bash", "-c"]
USER root

# ----- Base tools -----
RUN apt-get update --fix-missing && \
    apt-get install --no-install-recommends --assume-yes \
    build-essential \
    curl \
    git \
    openssh-client \
    less \
    libffi-dev \
    libssl-dev \
    locales \
    pkg-config \
    unzip \
    vim \
    wget \
    zip \
    sudo && \
    sed -i '/en_US.UTF-8/s/^# //' /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ----- yq (system-wide, architecture-aware) -----
RUN ARCH=$(dpkg --print-architecture) && \
    case "$ARCH" in \
      amd64) YQ_ARCH=amd64 ;; \
      arm64) YQ_ARCH=arm64 ;; \
      *) echo "Unsupported arch: $ARCH" && exit 1 ;; \
    esac && \
    curl -fsSLo /tmp/yq.tar.gz "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_${YQ_ARCH}.tar.gz" && \
    tar -xzf /tmp/yq.tar.gz -C /tmp && \
    mv /tmp/yq_linux_${YQ_ARCH} /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq && \
    rm -f /tmp/yq.tar.gz

# ----- GitHub CLI (system-wide, architecture-aware) -----
RUN ARCH=$(dpkg --print-architecture) && \
    case "$ARCH" in \
      amd64) GH_ARCH=amd64 ;; \
      arm64) GH_ARCH=arm64 ;; \
      *) echo "Unsupported arch: $ARCH" && exit 1 ;; \
    esac && \
    curl -fsSLo /tmp/gh.tar.gz "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_${GH_ARCH}.tar.gz" && \
    tar -xzf /tmp/gh.tar.gz -C /tmp && \
    mv /tmp/gh_${GH_VERSION}_linux_${GH_ARCH}/bin/gh /usr/local/bin/gh && \
    chmod +x /usr/local/bin/gh && \
    rm -rf /tmp/gh.tar.gz /tmp/gh_${GH_VERSION}_linux_${GH_ARCH}

# ----- Rust toolchain (system-wide, retained in the image) -----
# Installed under /usr/local rather than /root so the non-root `dev` user can
# run cargo, and deliberately KEPT (previously deleted after use) so mdBook
# preprocessors can be added or rebuilt inside a running container.
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:${PATH}
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
        sh -s -- -y --no-modify-path --profile minimal && \
    chmod -R a+rwX ${RUSTUP_HOME} ${CARGO_HOME} && \
    printf '%s\n' \
        'export RUSTUP_HOME=/usr/local/rustup' \
        'export CARGO_HOME=/usr/local/cargo' \
        'export PATH="/usr/local/cargo/bin:$PATH"' \
        > /etc/profile.d/rust.sh && \
    chmod 0644 /etc/profile.d/rust.sh && \
    cargo --version && rustc --version

# ----- mdBook + preprocessors (system-wide, architecture-aware) -----
# mdbook has pre-built arm64+amd64 Linux binaries; preprocessors are compiled
# from source via cargo because their releases lack arm64 Linux assets.
RUN ARCH=$(dpkg --print-architecture) && \
    case "$ARCH" in \
      amd64) GNU_ARCH=x86_64-unknown-linux-gnu ;; \
      arm64) GNU_ARCH=aarch64-unknown-linux-musl ;; \
      *) echo "Unsupported arch: $ARCH" && exit 1 ;; \
    esac && \
    curl -fsSLo /tmp/mdbook.tar.gz "https://github.com/rust-lang/mdBook/releases/download/v${MDBOOK_VERSION}/mdbook-v${MDBOOK_VERSION}-${GNU_ARCH}.tar.gz" && \
    tar -xzf /tmp/mdbook.tar.gz -C /usr/local/bin && chmod +x /usr/local/bin/mdbook && rm -f /tmp/mdbook.tar.gz && \
    cargo install mdbook-toc     --version ${MDBOOK_TOC_VERSION} && \
    cargo install mdbook-mermaid --version ${MDBOOK_MERMAID_VERSION} && \
    cp ${CARGO_HOME}/bin/mdbook-toc \
       ${CARGO_HOME}/bin/mdbook-mermaid /usr/local/bin/ && \
    rm -rf ${CARGO_HOME}/registry ${CARGO_HOME}/git

# ----- Create non-root user and workspace -----
RUN useradd -m -s /bin/bash dev && \
    usermod -aG sudo dev && \
    echo 'dev ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/dev && \
    chmod 0440 /etc/sudoers.d/dev && \
    mkdir -p /home/dev/app && chown -R dev:dev /home/dev/app

# Make the workspace path safe for Git even if mounted by host
RUN git config --global --add safe.directory /home/dev/app

# ----- Switch to dev for user-scoped installs -----
USER dev
WORKDIR /home/dev

# Put user-local tools on PATH globally for this image
ENV PATH="/home/dev/.elan/bin:/home/dev/.local/bin:/usr/local/bin:${PATH}"

# ----- Claude Code CLI (user-local) -----
# Installed AFTER the USER switch: running the installer as root placed the
# binary in /root/.local/bin, which the `dev` user cannot read.
RUN curl -fsSL https://claude.ai/install.sh | bash

# ----- elan + Lean toolchain -----
# Not installed here — the leanprover.lean4 VS Code extension installs elan and
# the correct toolchain on first attach (driven by lean-toolchain files per package).
# After Lean is available, run: ./build.sh cache

# Workspace
WORKDIR /home/dev/app

# Keep the devcontainer running so VS Code can attach
CMD ["sleep", "infinity"]
