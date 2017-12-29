# Partypeli

## Quickstart

  * Install dependencies with `mix deps.get`
  * Copy .env.sample into .env, fill in the blanks and source the file
  * Start database with `docker-compose up -d`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Requirements

  * [Elixir 1.5.x](https://elixir-lang.org/install.html)
  * [PostgreSQL 9.6](https://www.postgresql.org/)
  * [NodeJS](https://nodejs.org/en/)
  * [Docker](https://www.docker.com/) (Optional) for setting up database for development

## Environment

This project utilized environment variables for secrets and app configuration.

Begin by copying `.env.sample` into `.env` file, which should never be added into version control. You can load environment variables defined in `.env` file into your environment by running

After you have installed dependencies with `mix deps.get` you can generate secrets for `GUARDIAN_SECRET_KEY` and `SECRET_KEY_BASE` by running command

```
mix phx.gen.secret
```

Make sure you generate unique secrets for production, testing and development environments!

## Documentation

This project has Swager API documentation generated with [phoenix_swagger](https://github.com/xerions/phoenix_swagger).

Documentation is automatically generated on deployments. You can manually generate it by running

```
mix phx.swagger.generate priv/static/swagger.json -r BoothyliciousWeb.Router -e BoothyliciousWeb.Endpoint
```

## Debugging

To debug code, you can stop the execution at a desired place by adding

```
require IEx;

# Debugger will stop here
IEx.pry
```

Next start a new IEx session with

```
iex -S mix phx.server
````

Execution should stop at `IEx.pry`, and you can restart it with `respawn`.


## Deployment

The project is deployed on Heroku with Postgres plugin.

```
git push heroku master
```

