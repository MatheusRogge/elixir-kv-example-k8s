###################################################

FROM hexpm/elixir:1.12.2-erlang-24.2-alpine-3.15.0 AS builder

# install build dependencies
RUN apk add --no-cache build-base git

# sets work dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && mix local.rebar --force

# Setup Enviroment
ENV MIX_ENV="prod"

# Copy apps
COPY apps/kv apps/kv
COPY apps/kv_server apps/kv_server

# install mix dependencies
COPY mix.exs mix.lock ./
COPY rel rel
COPY config config
RUN mix do deps.get, deps.compile

# Prepare release
RUN mix do deps.compile, release kv_server --overwrite

###################################################

FROM alpine:3.14.2 AS app

# install runtime dependencies
RUN apk add --no-cache libstdc++ openssl ncurses-libs

# Set workdir
WORKDIR /app

# Change permissions to unprivileged on app directory
RUN chown nobody:nobody /app

# Set user
USER nobody:nobody

# Set exposed ports
EXPOSE 8080

# copy release executables
COPY --from=builder --chown=nobody:nobody /app/_build/prod/rel/kv_server ./

# Configure env vars
ENV PORT="8080"
ENV HOME="/app"

# Execute entrypoint script
CMD ["bin/kv_server", "start"]