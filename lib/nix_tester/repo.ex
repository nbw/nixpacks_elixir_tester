defmodule NixTester.Repo do
  use Ecto.Repo,
    otp_app: :nix_tester,
    adapter: Ecto.Adapters.Postgres
end
