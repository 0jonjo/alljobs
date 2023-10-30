# ALLJOBS ![Tests](https://github.com/0jonjo/alljobs/actions/workflows/ruby.yml/badge.svg) [![Maintainability](https://api.codeclimate.com/v1/badges/ab338714ffa9065409de/maintainability)](https://codeclimate.com/github/0jonjo/alljobs/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/ab338714ffa9065409de/test_coverage)](https://codeclimate.com/github/0jonjo/alljobs/test_coverage)


This is a study project to a job opening website using Ruby on Rails in a TDD way. Alljobs focuses on job search, management of applications, proposals and communication. It has 3 roles: admin (general management), headhunter (job opening creation, candidate management, feedback, proposal) and user (profile creation, job search and application).

[Project Board](https://github.com/users/0jonjo/projects/3)

Side repository to test API: [Seejobs](https://github.com/0jonjo/seejobs/)

- Ruby: 3.0.5
- Rails: 7.1
- Relevant technologies: Postgres, Docker, Devise, Rspec, Capybara, Sidekiq, Shoulda Matchers, SimpleCov, Rubocop, Kaminari, Faraday and Rails Admin.

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

## Create and migrate database

```shell
rails db:create
rails db:migrate
```

## Serve

```shell
rails server
```

# Containers

To use the containerized version, uncomment line 5 (url) in database.yml. After that:

```shell
docker compose up
```

