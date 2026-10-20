# java-node
Docker images that for java and node

Supported major versions (reviewed 2026-10-20):

| Runtime | Supported LTS | Latest GA |
| --- | --- | --- |
| Java (Eclipse Temurin) | 8, 11, 17, 21, 25 | 27 |
| Node.js | 22, 24 | 26 |

Images are built for every combination with tags `java-<major>-node-<major>`.
The `lts` tag uses Java 25 and Node.js 24; `latest` uses Java 27 and Node.js 26.
Building the Dockerfile without build arguments defaults to the latest LTS pair.
End-of-life releases and older non-LTS releases are excluded from future builds.

Release policies: [Eclipse Temurin](https://adoptium.net/support/) and
[Node.js](https://github.com/nodejs/Release#release-schedule).
