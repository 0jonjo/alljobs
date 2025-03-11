# ALLJOBS

[![Rspec and Rubocop CI](https://github.com/0jonjo/alljobs/actions/workflows/rspec_and_rubocop_ci.yml/badge.svg)](https://github.com/0jonjo/alljobs/actions/workflows/rspec_and_rubocop_ci.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/ab338714ffa9065409de/maintainability)](https://codeclimate.com/github/0jonjo/alljobs/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/ab338714ffa9065409de/test_coverage)](https://codeclimate.com/github/0jonjo/alljobs/test_coverage)

## Project Overview

A Job search and talent acquisition app. Recruiters post jobs and interact with candidates, while candidates create profiles, browse jobs, and submit applications. They can communicate with each other through messages.

Alljobs is built using Ruby on Rails and Postgres. It follows a Test-Driven Development (TDD) and Continuous Integration/Continuous Deployment (CI/CD) approach using GitHub Actions.

To get an overview of the project's progress, you can check the board:

**[Project Board](https://github.com/users/0jonjo/projects/3)**

## Installation

Clone the repository:

```shell
git clone git@github.com:0jonjo/alljobs.git
cd alljobs
```

Install dependencies:

```shell
bundle install
```

To development and tests, start the database in container running:

```shell
docker run -d --hostname localhost -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres
```

Create, migrate, and seed the database:

```shell
rails db:prepare
```

Serve the application:

```shell
rails server
```

Run tests:

```shell
rspec
```

## Containers

To run the application using containers, use the following command:

```shell
docker compose up
```

## License

This project is licensed under the GLP 3.0 - see the [LICENSE](LICENSE) file for details.
