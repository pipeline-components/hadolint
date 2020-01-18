FROM hadolint/hadolint:v1.17.4@sha256:e1937b12b3d856e21c94ed0db8ff4a274aa5a440bf9cd55c6e281a5ac1d3462e as hadolint

FROM pipelinecomponents/base-entrypoint:0.2.0 as entrypoint

FROM alpine:3.11.3@sha256:ddba4d27a7ffc3f86dd6c2f92041af252a1f23a8e742c90e6e1297bfa1bc0c45
COPY --from=entrypoint /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
ENV DEFAULTCMD hadolint

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
