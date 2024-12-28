FROM ghcr.io/railwayapp/nixpacks:ubuntu-1733184274

ENTRYPOINT ["/bin/bash", "-l", "-c"]
WORKDIR /app/


COPY .nixpacks/nixpkgs-c5702bd28cbde41a191a9c2a00501f18941efbd0.nix .nixpacks/nixpkgs-c5702bd28cbde41a191a9c2a00501f18941efbd0.nix
RUN nix-env -if .nixpacks/nixpkgs-c5702bd28cbde41a191a9c2a00501f18941efbd0.nix && nix-collect-garbage -d


ARG ELIXIR_ERL_OPTIONS MIX_ENV NIXPACKS_METADATA
ENV ELIXIR_ERL_OPTIONS=$ELIXIR_ERL_OPTIONS MIX_ENV=$MIX_ENV NIXPACKS_METADATA=$NIXPACKS_METADATA

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
# ENV LC_ALL=en_US.UTF-8

# is this set by a variable?
ENV MIX_ENV=prod

# setup phase
# noop

# install phase
COPY config/config.exs /app/config/config.exs
COPY config/prod.exs /app/config/prod.exs
COPY mix.exs /app/mix.exs
COPY mix.lock /app/mix.lock
RUN  mix local.hex --force
RUN  mix local.rebar --force
RUN  mix deps.get --only prod

# build phase
COPY assets /app/assets
COPY priv /app/priv
COPY config /app/config
COPY lib /app/lib
RUN  mix compile
RUN  mix assets.deploy
# RUN  mix ecto.setup

# start
# COPY . /app

CMD ["mix ecto.setup && mix phx.server"]

