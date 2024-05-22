FROM   docker.io/node:latest
RUN    # Update and install required packages
RUN    apt-get update
RUN    apt-get install -y git lld sudo nsis llvm curl unzip mingw-w64 apt-utils ca-certificates build-essential
RUN    rm -rf /var/lib/apt/lists/*
RUN    # Install Rust
RUN    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN    # Add Rust to PATH
RUN    export PATH="/root/.cargo/bin:${PATH}"
RUN    # Install Windows Rust target
RUN    rustup target add x86_64-pc-windows-msvc
RUN    # Install xwin
RUN    cargo install xwin
RUN    # Ensure .cargo folder exists
RUN    mkdir -p .cargo
RUN    # Set up the Rust toolchain to use the installed tools
RUN    echo '[target.x86_64-pc-windows-msvc]' > .cargo/config.toml
RUN    echo 'linker = "lld"' >> .cargo/config.toml
RUN    echo 'rustflags = ["-Lnative=/root/.xwin/crt/lib/x86_64", "-Lnative=/root/.xwin/sdk/lib/um/x86_64", "-Lnative=/root/.xwin/sdk/lib/ucrt/x86_64"]' >> .cargo/config.toml
RUN    # Add pnpm
RUN    npm install -g pnpm
RUN    # Set up xwin (adjust paths as necessary)
RUN    mkdir /root/.xwin
RUN    # Install node packages
RUN    pnpm config set store-dir .pnpm-store # Set the pnpm store directory
RUN    pnpm install --prefer-offline
 
