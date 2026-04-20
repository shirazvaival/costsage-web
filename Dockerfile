# CostSage website — static HTML served by nginx
# Build: docker build -t costsage-web .
# Run:   docker run --rm -p 8080:80 costsage-web
FROM nginx:1.27-alpine

# Drop default nginx config, install our own
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy static site
COPY site/ /usr/share/nginx/html/

# Build metadata (populated by GitHub Actions via --build-arg)
ARG BUILD_ENV=dev
ARG GIT_SHA=unknown
ARG BUILD_TIME=unknown
ENV BUILD_ENV=$BUILD_ENV GIT_SHA=$GIT_SHA BUILD_TIME=$BUILD_TIME
LABEL org.opencontainers.image.source="https://github.com/shirazvaival/costsage-web" \
      org.opencontainers.image.description="CostSage static site (nginx)" \
      org.opencontainers.image.licenses="UNLICENSED" \
      build.env="$BUILD_ENV" \
      build.sha="$GIT_SHA" \
      build.time="$BUILD_TIME"

# Write a build-info endpoint so you can curl /_build to see which tag is live
RUN printf 'env=%s\nsha=%s\ntime=%s\n' "$BUILD_ENV" "$GIT_SHA" "$BUILD_TIME" > /usr/share/nginx/html/_build

EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://127.0.0.1/_build >/dev/null || exit 1
