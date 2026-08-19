# Mini Twitter

A small Twitter-style Rails application.

## Development with Docker

Docker provides the Ruby, Rails, and PostgreSQL development environment, so
you do not need to install those dependencies directly on your machine.

### Prerequisites

- Docker Desktop with WSL 2 integration enabled
- Docker Compose

### Setup

Build the development environment:

```bash
docker compose build
```

Create and migrate the database:

```bash
docker compose run --rm web bin/rails db:prepare
```

Start Rails and PostgreSQL:

```bash
docker compose up
```

Open <http://localhost:3000> in your browser.

Stop the application with `Ctrl+C`, or run the following command from another
terminal:

```bash
docker compose down
```

Database data, installed gems, and uploaded files are kept in Docker volumes
between container runs.

### Common commands

Run Rails commands inside the development container:

```bash
docker compose run --rm web bin/rails console
docker compose run --rm web bin/rails db:migrate
docker compose run --rm web bin/rails test
docker compose run --rm web bundle exec rspec
```
