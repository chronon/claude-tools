FROM node:22-trixie

ARG CLAUDE_CODE_VERSION=latest
ARG DBHUB_CODE_VERSION=0.13.0

# Install system tools
RUN apt-get update && apt-get install -y --no-install-recommends \
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

# Install npm packages globally
RUN npm install -g \
  @anthropic-ai/claude-code@${CLAUDE_CODE_VERSION} \
  @bytebase/dbhub@${DBHUB_CODE_VERSION}

# Enable Corepack and prepare pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# Set environment variables
ENV CLAUDE_CONFIG_DIR=./.claude/config
ENV DISABLE_AUTOUPDATER=1
ENV TERM=xterm-256color
ENV COLORTERM=truecolor

# Configure git to use delta
RUN git config --global core.pager delta

# Set working directory
WORKDIR /workspace

CMD ["/bin/bash"]
