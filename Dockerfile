FROM nixos/nix

RUN nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
RUN nix-channel --update
RUN echo experimental-features = nix-command flakes >> /etc/nix/nix.conf

ARG FLAKE_URL=/src/cloud-nix
ENV FLAKE_URL=${FLAKE_URL}
COPY . /src/cloud-nix
RUN nix run "${FLAKE_URL}#geodesix" -- -c "terraform version"

WORKDIR /localhost
ENV HOME=/localhost
CMD nix run "${FLAKE_URL}#geodesix"
