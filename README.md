# ALLJOBS

[![Rspec and Rubocop CI](https://github.com/0jonjo/alljobs/actions/workflows/rspec_and_rubocop_ci.yml/badge.svg)](https://github.com/0jonjo/alljobs/actions/workflows/rspec_and_rubocop_ci.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/ab338714ffa9065409de/maintainability)](https://codeclimate.com/github/0jonjo/alljobs/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/ab338714ffa9065409de/test_coverage)](https://codeclimate.com/github/0jonjo/alljobs/test_coverage)

Welcome to ALLJOBS, a study project for a job opening website built using Ruby on Rails. This project follows a Test-Driven Development (TDD) and Continuous Integration/Continuous Deployment (CI/CD) approach.

## Project Overview

ALLJOBS focuses on job search, application management, and proposal submission. It supports two roles: headhunter (responsible for job opening creation, candidate management, feedback, and proposal) and user (responsible for profile creation, job search, and application).

To get an overview of the project's progress, you can check the [Project Board](https://github.com/users/0jonjo/projects/3).

## Installation

To set up the project locally, follow these steps:

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

```shell
docker compose up
```
