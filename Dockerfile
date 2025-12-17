FROM node:22-trixie

ARG CLAUDE_CODE_VERSION=latest
ARG DBHUB_CODE_VERSION=0.12.0

# Install system tools
RUN apt-get update && apt-get install -y --no-install-recommends \
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

# Set environment variables
ENV CLAUDE_CONFIG_DIR=./.claude/config
ENV TERM=xterm-256color
ENV COLORTERM=truecolor

# Configure git to use delta
RUN git config --global core.pager delta

# Set working directory
WORKDIR /workspace

CMD ["/bin/bash"]
