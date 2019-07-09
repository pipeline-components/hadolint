FROM hadolint/hadolint:v1.17.1@sha256:567dd3eb729d76abe14d315bb5e9133ad587db7acd910e1c55d8d5d57bea4a8f as hadolint

FROM alpine:3.10.0@sha256:ca1c944a4f8486a153024d9965aafbe24f5723c1d5c02f4964c045a16d19dc54
COPY --from=hadolint /bin/hadolint /usr/local/bin/hadolint

WORKDIR /code/

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF

# Labels
LABEL \
    maintainer="Robbert Müller <spam.me@grols.ch>" \
    org.label-schema.description="Hadolint in a container for gitlab-ci" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Hadolint" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://pipeline-components.gitlab.io/" \
    org.label-schema.usage="https://gitlab.com/pipeline-components/hadolint/blob/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://gitlab.com/pipeline-components/hadolint/" \
    org.label-schema.vendor="Pipeline Components"
