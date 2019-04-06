FROM alpine:3.9.2 as build

RUN apk --no-cache add curl=7.64.0-r1 cabal=2.2.0.0-r0 ghc=8.4.3-r0 build-base=0.5-r1 upx=3.95-r1
RUN mkdir -p /app/hadolint
WORKDIR /app/hadolint

RUN cabal update
RUN cabal new-install --jobs  --enable-executable-stripping --enable-optimization=2 --enable-shared --enable-split-sections  --disable-debug-info --constraint="hadolint == 1.16.3" "hadolint"
RUN if [ -h /root/.cabal/bin/hadolint ] ; then cp --remove-destination "$(readlink -f /root/.cabal/bin/hadolint )" /root/.cabal/bin/hadolint ; fi

RUN upx -9 /root/.cabal/bin/hadolint

FROM alpine:3.9.2
COPY --from=build /root/.cabal/bin/hadolint /usr/local/bin/hadolint

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
