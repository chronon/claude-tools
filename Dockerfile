FROM node:22-trixie-slim

ARG CLAUDE_CODE_VERSION=latest
ARG DBHUB_CODE_VERSION=0.13.0
ARG TASK_VERSION=3
ARG PNPM_VERSION=10

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
  @bytebase/dbhub@${DBHUB_CODE_VERSION} \
  @go-task/cli@${TASK_VERSION} \
  pnpm@${PNPM_VERSION}

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
