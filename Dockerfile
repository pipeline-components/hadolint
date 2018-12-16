FROM alpine:3.8 as build

RUN apk --no-cache add curl=7.61.1-r1 cabal=2.2.0.0-r0 ghc=8.4.3-r0 build-base=0.5-r1 upx=3.94-r0
RUN curl -sSL https://get.haskellstack.org/ -o /tmp/gethaskell && sh /tmp/gethaskell && rm /tmp/gethaskell 
RUN mkdir -p /app/hadolint
WORKDIR /app/hadolint
RUN curl --location  -o ../hadolint.tar.gz https://github.com/hadolint/hadolint/archive/v1.15.0.tar.gz
RUN tar --strip 1 -zxvf ../hadolint.tar.gz
RUN stack --no-terminal build --test --split-objs --executable-stripping  --system-ghc --only-dependencies 
RUN stack --no-terminal install --system-ghc --split-objs --executable-stripping --ghc-options="-fPIC  "  

RUN upx -9 /root/.local/bin/hadolint

FROM alpine:3.8
COPY --from=build /root/.local/bin/hadolint /usr/local/bin/hadolint

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
