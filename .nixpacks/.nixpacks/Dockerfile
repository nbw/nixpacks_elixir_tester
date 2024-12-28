FROM ghcr.io/railwayapp/nixpacks:ubuntu-1733184274

ENTRYPOINT ["/bin/bash", "-l", "-c"]
WORKDIR /app/


COPY .nixpacks/nixpkgs-c5702bd28cbde41a191a9c2a00501f18941efbd0.nix .nixpacks/nixpkgs-c5702bd28cbde41a191a9c2a00501f18941efbd0.nix
RUN nix-env -if .nixpacks/nixpkgs-c5702bd28cbde41a191a9c2a00501f18941efbd0.nix && nix-collect-garbage -d


ARG ELIXIR_ERL_OPTIONS MIX_ENV NIXPACKS_METADATA
ENV ELIXIR_ERL_OPTIONS=$ELIXIR_ERL_OPTIONS MIX_ENV=$MIX_ENV NIXPACKS_METADATA=$NIXPACKS_METADATA

# setup phase
# noop

# install phase
COPY . /app/.
RUN  mix local.hex --force
RUN  echo test
RUN  mix local.rebar --force
RUN  mix deps.get --only prod

# build phase
COPY . /app/.
RUN  mix compile
RUN  mix assets.deploy
RUN  mix ecto.setup





# start
COPY . /app

CMD ["mix phx.server"]

