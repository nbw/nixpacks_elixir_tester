docker build .nixpacks -f .nixpacks/.nixpacks/Dockerfile -t 42b85e74-b9dd-4f9b-b08e-d003d7537177 --build-arg ELIXIR_ERL_OPTIONS=+fnu --build-arg MIX_ENV=prod --build-arg NIXPACKS_METADATA=elixir