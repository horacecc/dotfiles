FROM node:20-slim

RUN apt-get update && apt-get install -y git curl ca-certificates && rm -rf /var/lib/apt/lists/*

RUN npm install -g @anthropic-ai/claude-code

ENV CLAUDE_CONFIG_DIR=/claude-config
WORKDIR /workspace

CMD ["claude"]
