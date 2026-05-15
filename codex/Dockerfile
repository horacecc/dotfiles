FROM node:22-slim

RUN apt-get update && apt-get install -y \
    git curl ca-certificates \
    less jq ripgrep \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g @openai/codex

ENV CODEX_HOME=/codex-config

RUN mkdir -p /codex-config && \
    echo 'cli_auth_credentials_store = "file"' > /codex-config/config.toml

WORKDIR /workspace

CMD ["codex"]
