FROM hadolint/hadolint:v2.10.0 as hadolint

FROM pipelinecomponents/base-entrypoint:0.5.0 as entrypoint

FROM alpine:3.16.1@sha256:7580ece7963bfa863801466c0a488f11c86f85d9988051a9f9c68cb27f6b7872
COPY --from=entrypoint /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
ENV DEFAULTCMD hadolint

COPY --from=hadolint /bin/hadolint /usr/local/bin/hadolint

COPY app /app/

WORKDIR /code/

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF

# Labels
LABEL \
    maintainer="Robbert Müller <dev@pipeline-components.dev>" \
    org.label-schema.description="Hadolint in a container for gitlab-ci" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Hadolint" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://pipeline-components.gitlab.io/" \
    org.label-schema.usage="https://gitlab.com/pipeline-components/hadolint/blob/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://gitlab.com/pipeline-components/hadolint/" \
    org.label-schema.vendor="Pipeline Components"
