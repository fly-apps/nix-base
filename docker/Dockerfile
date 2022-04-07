# syntax=docker/dockerfile:1.4
FROM alpine
ENV USER root

RUN apk add rsync curl ca-certificates xz bash
RUN mkdir -m 0755 /nix && chown root /nix

RUN <<EOF
  CPUS=$(nproc)
  addgroup nixbld
  for num in `seq 1 $CPUS`; do
    adduser --disabled-password nixbld${num} -G nixbld
  done
EOF

RUN mkdir -p /root/.config/nix && echo 'filter-syscalls = false' >> /root/.config/nix/nix.conf

RUN sh <(curl -L https://nixos.org/nix/install) --no-daemon
RUN ln -s /root/.nix-profile/etc/profile.d/nix.sh /etc/profile.d/nix.sh

RUN mkdir /source
WORKDIR /source

RUN ls /nix
RUN cp -pr /nix /nix-backup
COPY . /nix_support

SHELL ["bash", "-l", "-c"]

# The following should run at build time on the client

# Warm up the Nix cache
ONBUILD RUN --mount=type=cache,id=nix-store,target=/nix cp -pr /nix-backup/* /nix

ONBUILD COPY . .

ONBUILD ARG FLY_API_TOKEN
ONBUILD ARG TAG
ONBUILD ENV FLY_API_TOKEN=${FLY_API_TOKEN}
ONBUILD ENV TAG=${TAG}

ONBUILD RUN cp -pr /nix_support .nix

ONBUILD RUN --mount=type=cache,id=nix-store,target=/nix .nix/bundle
ONBUILD RUN --mount=type=cache,id=nix-store,target=/nix .nix/build
