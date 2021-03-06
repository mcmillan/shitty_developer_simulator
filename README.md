# Service Downtime Simulator

[![CircleCI](https://circleci.com/gh/deliveroo/service_downtime_simulator/tree/master.svg?style=svg&circle-token=d66bc2c0246da5cdf4eeaeb6c9f7b10bcd74bb7b)](https://circleci.com/gh/deliveroo/service_downtime_simulator/tree/master)

---

:rotating_light: If you work at Deliveroo and you're contributing to this project, please bear in mind that this repository is public.

---

This is a piece of Rack middleware that simulates failures you would want to tolerate in upstream services.

## Installation

### Rails

Add the following in `application.rb`:

```ruby
config.middleware.use(
  ServiceDowntimeSimulator::Middleware,
  config # See below for info about how to configure this
)
```

## Configuration

The middleware takes a `config` argument in the form of a hash. Said hash should have the following shape:

```ruby
{
  enabled: Boolean,
  mode: Symbol,
  excluded_paths: Array<String>,
  logger: Logger?
}
```

Here's what you can supply for each of those options:

- **enabled** (`Boolean`)
  - `true` will enable simulation of failures (assuming you supply a valid `mode`, see below)
  - `false` will disable simulation and your application will function as normal
- **mode** (`Symbol`)
  - `:hard_down` will cause all requests to return a 500 error
  - `:intermittently_down` will cause 50% of requests to return a 500 error
  - `:successful_but_gibberish` will return a 200, but with a response body that is not machine readable
  - `:timing_out` will wait for 15 seconds on each request, and then return a 503
- **excluded_paths** (`Array<String>`)
  - You can supply a list of paths that you don't want to be affected by the simulation here (e.g. `['/foobar']`)
  - The most common thing you're going to want to include here is your service's health check endpoint, as if it is returning a 5xx thanks to this middleware your application will not deploy
- **logger** (`Logger?`)
  - If supplied, useful debug information will be sent here

In order for the middleware to kick in, `enabled` must be explicitly set to `true` and `mode` must be a valid option. Unless both are explicitly supplied, the underlying application will continue to function as normal.

### Examples

Here's a couple of example configurations:

#### Hard-coded Hard Down

This example will always return a 500 for all requests.

```ruby
config.middleware.use(
  ServiceDowntimeSimulator::Middleware,
  {
    enabled: true,
    mode: :hard_down,
    excluded_paths: ['/health'],
    logger: Rails.logger
  }
)
```

#### Environment-variable Controlled Simulation

This is a more practical example, allowing failure simulation to happen based on environment variables. It requires an environment variable with a specific value to enable the failure simulation, and also requires a mode to be provided. If either are missing, the app continues as normal. You can also use this pattern for feature flagging. Probably.

```ruby
config.middleware.use(
  ServiceDowntimeSimulator::Middleware,
  {
    enabled: ENV['FAILURE_SIMULATION_ENABLED'] == 'I_UNDERSTAND_THE_CONSEQUENCES_OF_THIS',
    mode: ENV.fetch('FAILURE_SIMULATION_MODE', '').to_sym,
    excluded_paths: ['/health'],
    logger: Rails.logger
  }
)
```

## Development

- Clone this repository
- Ensure you have Ruby 2.5.1 installed
- `make install` to get the dependencies
- `make test` to run the tests
- `make lint` to lint your code
- ???
- Profit

## Gem Publishing

TBC, but very manual and involved flow is:

- Update version in `lib/service_downtime_simulator.rb` and commit
- Tag version via `git tag XXX`
- Push (`git push origin head --tags`)
- Release to Rubygems (`make publish`)
