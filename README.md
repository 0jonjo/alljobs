# ALLJOBS ![Tests](https://github.com/0jonjo/alljobs/actions/workflows/ruby.yml/badge.svg) [![Maintainability](https://api.codeclimate.com/v1/badges/ab338714ffa9065409de/maintainability)](https://codeclimate.com/github/0jonjo/alljobs/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/ab338714ffa9065409de/test_coverage)](https://codeclimate.com/github/0jonjo/alljobs/test_coverage)


This is a study project to a job opening website using Ruby on Rails in a TDD way. Alljobs focuses on job search, management of applications, proposals and communication. It has 2 roles: headhunter (job opening creation, candidate management, feedback, proposal) and user (profile creation, job search and application).

[Project Board](https://github.com/users/0jonjo/projects/3)

Side repository: [alljobs-api](https://github.com/0jonjo/alljobs-api/)

- Ruby: 3.0.5
- Rails: 7.1
- Relevant technologies: Postgres, Docker, Devise, Rspec, Capybara, Sidekiq, Shoulda Matchers, SimpleCov, Rubocop, Kaminari and Faraday.

## Install

### Clone the repository

```shell
git clone git@github.com:0jonjo/alljobs.git
cd alljobs
```

### Install dependencies

```shell
bundle install
```

## Create, migrate and seed database

```shell
rails db:prepare
```

## Serve

```shell
rails server
```

## Run tests

```shell
rspec
```

# Containers

To use the containerized version, uncomment line 5 (url) in database.yml. After that:

```shell
docker compose up
```

