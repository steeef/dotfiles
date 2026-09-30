# syntax=docker/dockerfile:1
ARG NODE_IMAGE
FROM ${NODE_IMAGE}

RUN apt-get update \
  && apt-get install -y --no-install-recommends bash ca-certificates fd-find git ripgrep \
  && ln -s "$(command -v fdfind)" /usr/local/bin/fd \
  && rm -rf /var/lib/apt/lists/*

ARG PI_VERSION
RUN --mount=type=cache,target=/root/.npm \
  npm install -g --ignore-scripts "@earendil-works/pi-coding-agent@${PI_VERSION}"

WORKDIR /workspace
USER node

ARG PI_EXTENSIONS
RUN --mount=type=cache,target=/home/node/.npm,uid=1000 \
  for e in ${PI_EXTENSIONS}; do pi install "$e"; done

COPY --chown=node defaults.json /tmp/defaults.json
RUN node -e '\
  const fs = require("fs"); \
  const f = "/home/node/.pi/agent/settings.json"; \
  const s = JSON.parse(fs.readFileSync(f)); \
  Object.assign(s, JSON.parse(fs.readFileSync("/tmp/defaults.json"))); \
  fs.writeFileSync(f, JSON.stringify(s, null, 2));' \
  && rm /tmp/defaults.json

ENTRYPOINT ["pi", "--no-sandbox"]
