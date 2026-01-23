FROM node:22-trixie-slim

ARG CLAUDE_CODE_BASE_URL=https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases
ARG DBHUB_CODE_VERSION=0.15.0
ARG TASK_VERSION=3
ARG PNPM_VERSION=10

# Install system tools
RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  docker-cli \
  fd-find \
  fzf \
  gh \
  git \
  git-delta \
  gnupg2 \
  jq \
  ripgrep \
  unzip \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Claude Code binary with SHA256 verification
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN BASE_URL="${CLAUDE_CODE_BASE_URL}" && \
  # Detect platform architecture
  ARCH=$(uname -m) && \
  if [ "$ARCH" = "x86_64" ]; then \
    PLATFORM="linux-x64"; \
  elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then \
    PLATFORM="linux-arm64"; \
  else \
    echo "Unsupported architecture: $ARCH" && exit 1; \
  fi && \
  echo "Detected platform: ${PLATFORM}" && \
  # Get latest version
  VERSION=$(curl -fsSL "${BASE_URL}/latest") && \
  echo "Installing Claude Code version: ${VERSION}" && \
  # Download manifest for checksum verification
  curl -fsSL "${BASE_URL}/${VERSION}/manifest.json" -o /tmp/manifest.json && \
  EXPECTED_SHA=$(jq -r ".platforms.\"${PLATFORM}\".checksum" /tmp/manifest.json) && \
  # Download Claude Code binary
  curl -fsSL "${BASE_URL}/${VERSION}/${PLATFORM}/claude" -o /tmp/claude && \
  # Verify SHA256 checksum
  echo "${EXPECTED_SHA}  /tmp/claude" | sha256sum -c - && \
  # Install binary to ~/.local/bin (native installation location)
  chmod +x /tmp/claude && \
  mkdir -p /root/.local/bin && \
  mv /tmp/claude /root/.local/bin/claude && \
  rm /tmp/manifest.json

# Install npm packages globally
RUN npm install -g \
  @bytebase/dbhub@${DBHUB_CODE_VERSION} \
  @go-task/cli@${TASK_VERSION} \
  pnpm@${PNPM_VERSION}

# Set environment variables
ENV PATH="/root/.local/bin:${PATH}" \
    CLAUDE_CONFIG_DIR=./.claude/config \
    DISABLE_AUTOUPDATER=1 \
    TERM=xterm-256color \
    COLORTERM=truecolor

# Configure git to use delta
RUN git config --global core.pager delta

# Set working directory
WORKDIR /workspace

CMD ["/bin/bash"]
