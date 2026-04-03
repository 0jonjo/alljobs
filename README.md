# Alljobs API

[![CI](https://github.com/0jonjo/alljobs/actions/workflows/rspec_and_rubocop_ci.yml/badge.svg)](https://github.com/0jonjo/alljobs/actions/workflows/rspec_and_rubocop_ci.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/ab338714ffa9065409de/maintainability)](https://codeclimate.com/github/0jonjo/alljobs/maintainability)

## Overview

A JSON API for job search and talent acquisition. Candidates create profiles and apply for jobs. Headhunters post vacancies, review applications, star candidates, and exchange comments.

**Stack:** Ruby 3.4 · Rails 8.1 · PostgreSQL · JWT auth · Solid Queue

## Requirements

- Ruby 3.4.4 (managed via [asdf](https://asdf-vm.com))
- PostgreSQL 16 (via Docker)

## Local setup

```shell
git clone git@github.com:0jonjo/alljobs.git
cd alljobs
```

Install Ruby and gems:

```shell
asdf install
bundle install
```

Start the database:

```shell
docker compose up -d db
```

Create and migrate the database:

```shell
rails db:create db:migrate
```

Start the server:

```shell
rails server
```

## Running tests

```shell
bundle exec rspec
```

## Lint

```shell
bundle exec rubocop
```

## API authentication

All endpoints (except `/api/v1/auth_user` and `/api/v1/auth_headhunter`) require a JWT token in the `Authorization` header.

Obtain a token:

```shell
POST /api/v1/auth_user
{ "email": "user@example.com", "password": "secret" }

POST /api/v1/auth_headhunter
{ "email": "hh@example.com", "password": "secret" }
```

Use the returned token:

```shell
Authorization: <token>
```

## Main endpoints

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/api/v1/jobs` | List jobs (supports `?title=` filter) |
| `POST` | `/api/v1/jobs` | Create job (headhunter) |
| `GET` | `/api/v1/jobs/:id` | Job detail |
| `PUT/PATCH` | `/api/v1/jobs/:id` | Update job |
| `DELETE` | `/api/v1/jobs/:id` | Archive job |
| `GET` | `/api/v1/jobs/:id/stars` | Stars for a job (headhunter) |
| `GET/POST/DELETE` | `/api/v1/jobs/:job_id/applies` | Candidatures |
| `GET/POST/DELETE` | `/api/v1/jobs/:job_id/applies/:apply_id/stars` | Star a candidature |
| `GET/POST/DELETE` | `/api/v1/jobs/:job_id/applies/:apply_id/comments` | Comments on a candidature |
| `GET/POST/PUT` | `/api/v1/profiles` | Candidate profiles |

## License

[GPL-3.0](LICENSE)
