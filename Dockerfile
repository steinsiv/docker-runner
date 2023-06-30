FROM debian:stable-slim AS prepare

ARG RUNNER_VERSION="2.305.0"

# Get and install needed packages
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y curl jq build-essential ca-certificates openssh-client apt-transport-https lsb-release gnupg && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Github runner
WORKDIR /home/github/runner
RUN curl -OsL https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    rm ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    DEBIAN_FRONTEND=noninteractive ./bin/installdependencies.sh

# Add non-root user/group
RUN groupadd -g 1001 github && useradd --uid 1001 -g github github && chown github:github -R /home/github

COPY --chown=github:github ./start.sh .
RUN chmod u+x start.sh

USER 1001

ENTRYPOINT ["/home/github/runner/start.sh"]