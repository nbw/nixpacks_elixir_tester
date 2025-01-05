FROM ghcr.io/railwayapp/nixpacks:ubuntu-1733184274

ENTRYPOINT ["/bin/bash", "-l", "-c"]
WORKDIR /app/


COPY .nixpacks/nixpkgs-c5702bd28cbde41a191a9c2a00501f18941efbd0.nix .nixpacks/nixpkgs-c5702bd28cbde41a191a9c2a00501f18941efbd0.nix
RUN nix-env -if .nixpacks/nixpkgs-c5702bd28cbde41a191a9c2a00501f18941efbd0.nix && nix-collect-garbage -d


ARG ELIXIR_ERL_OPTIONS LANG LANGUAGE MIX_ENV=prod NIXPACKS_METADATA
ENV ELIXIR_ERL_OPTIONS=$ELIXIR_ERL_OPTIONS LANG=$LANG LANGUAGE=$LANGUAGE MIX_ENV=$MIX_ENV NIXPACKS_METADATA=$NIXPACKS_METADATA

# setup phase
# noop

# install phase
COPY config/config.exs /app/config/config.exs
COPY config/prod.exs /app/config/${MIX_ENV}.exs
COPY mix.exs /app/mix.exs
COPY mix.lock /app/mix.lock
RUN  mix local.hex --force
RUN  mix local.rebar --force
RUN  mix deps.get --only prod

# build phase
COPY config/runtime.exs /app/config/runtime.exs
COPY assets /app/assets
COPY priv /app/priv
COPY config /app/config
COPY lib /app/lib
RUN  mix compile
RUN  mix assets.deploy





# start


CMD ["mix ecto.setup && mix phx.server"]

