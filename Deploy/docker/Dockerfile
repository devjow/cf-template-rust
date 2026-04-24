ARG BUILDER_IMG=cyberfabric/builder-base:latest
ARG RUNNER_IMG=cyberfabric/runner-base:latest

FROM ${BUILDER_IMG} AS builder

ARG ARTIFACT_NAME
ARG CYBERFABRIC_FEATURES=

WORKDIR /workspace

COPY Cargo.toml Cargo.toml
COPY .cyberfabric/${ARTIFACT_NAME}/ .cyberfabric/${ARTIFACT_NAME}/
COPY modules/ modules/
COPY config/${ARTIFACT_NAME} config/${ARTIFACT_NAME}

RUN cargo build --release --manifest-path .cyberfabric/${ARTIFACT_NAME}/Cargo.toml --target-dir /workspace/target ${CYBERFABRIC_FEATURES}

FROM ${RUNNER_IMG}

ARG ARTIFACT_NAME

COPY --from=builder /workspace/target/release/${ARTIFACT_NAME} /srv/server
COPY config/${ARTIFACT_NAME} /srv/config
ENV CF_CLI_CONFIG=/srv/config
CMD ["/srv/server"]
