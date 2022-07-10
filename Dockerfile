# Create base image with dependencies
# needed by both builder and final
FROM ubuntu:16.04 as base-image

RUN apt-get update && apt-get install -y build-essential \
    libmysqlclient-dev \
    libdb5.3-dev 

COPY scripts /app/scripts
RUN ln -s /app/scripts/swgemu.sh /usr/bin/swgemu

# Create builder image from base and add
# needed items for building the project
FROM base-image as build-image
RUN apt-get install -y git \
    default-jre \
    curl

# builder image to handle intermediary actions if needed
# this is separate to facilicate using
# the prior layer for local development
FROM build-image as builder

RUN curl -L https://github.com/krallin/tini/releases/download/v0.18.0/tini -o /usr/bin/tini

# Create final image that could be used as a 
# lighter-weight production image
FROM base-image as final

COPY --from=builder /usr/bin/tini /usr/bin/tini
RUN chmod a+x /usr/bin/tini

#WORKDIR /app/MMOCoreORB/bin
#COPY --from=builder /app/MMOCoreORB/bin .

# tini is needed as core3 does not explicitly handle SIGTERM signals - could be dropped in db only
ENTRYPOINT ["tini", "--"]
