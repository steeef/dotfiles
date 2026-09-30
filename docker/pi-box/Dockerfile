# syntax=docker/dockerfile:1
ARG NODE_IMAGE
FROM ${NODE_IMAGE}

RUN apt-get update \
  && apt-get install -y --no-install-recommends bash ca-certificates git ripgrep \
  && rm -rf /var/lib/apt/lists/*

ARG PI_VERSION
RUN --mount=type=cache,target=/root/.npm \
  npm install -g --ignore-scripts "@earendil-works/pi-coding-agent@${PI_VERSION}"

ARG PI_EXTENSIONS
RUN --mount=type=cache,target=/root/.npm \
  for e in ${PI_EXTENSIONS}; do pi install "$e"; done

COPY defaults.json /tmp/defaults.json
RUN node -e '\
  const fs = require("fs"); \
  const f = "/root/.pi/agent/settings.json"; \
  const s = JSON.parse(fs.readFileSync(f)); \
  Object.assign(s, JSON.parse(fs.readFileSync("/tmp/defaults.json"))); \
  fs.writeFileSync(f, JSON.stringify(s, null, 2));' \
  && rm /tmp/defaults.json

WORKDIR /workspace
ENTRYPOINT ["pi", "--no-sandbox"]
