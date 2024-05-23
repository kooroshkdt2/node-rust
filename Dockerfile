FROM   docker.io/node:latest

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Update and install required packages
RUN apt-get update && apt-get install -y \
  git \
  lld \
  sudo \
  nsis \
  llvm \
  curl \
  unzip \
  mingw-w64 \
  apt-utils \
  ca-certificates \
  build-essential \
  && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Add Rust to PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Windows Rust target
RUN rustup target add x86_64-pc-windows-msvc

# Install xwin
RUN cargo install xwin

# Set the WORKDIR to your project directory
WORKDIR /project

# Set up xwin (adjust paths as necessary)
RUN mkdir /root/.xwin
RUN xwin --accept-license splat --output /root/.xwin || xwin --accept-license splat --output /root/.xwin --disable-symlinks
