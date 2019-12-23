FROM hadolint/hadolint:v1.17.3@sha256:ddc2ae945d20738c0d836661eabb685352ad457d756b37a7d8a82656ea52f1d5 as hadolint

FROM pipelinecomponents/base-entrypoint:0.2.0 as entrypoint

FROM alpine:3.11.0@sha256:d371657a4f661a854ff050898003f4cb6c7f36d968a943c1d5cde0952bd93c80
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
