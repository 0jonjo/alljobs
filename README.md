# ALLJOBS

[![Rspec and Rubocop CI](https://github.com/0jonjo/alljobs/actions/workflows/rspec_and_rubocop_ci.yml/badge.svg)](https://github.com/0jonjo/alljobs/actions/workflows/rspec_and_rubocop_ci.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/ab338714ffa9065409de/maintainability)](https://codeclimate.com/github/0jonjo/alljobs/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/ab338714ffa9065409de/test_coverage)](https://codeclimate.com/github/0jonjo/alljobs/test_coverage)

Welcome to ALLJOBS, a job opening website built using Ruby on Rails. This project follows a Test-Driven Development (TDD) and Continuous Integration/Continuous Deployment (CI/CD) approach.

## Project Overview

ALLJOBS is a platform that focuses on job search and application management. It supports two roles: headhunter and user. The headhunter is responsible for job opening creation and candidate management. The user is responsible for profile creation, job search, and application.

To get an overview of the project's progress, you can check the [Project Board](https://github.com/users/0jonjo/projects/3).

Alljobs has a side project built in Spring Boot called [Alljobs Meetings](https://github.com/0jonjo/alljobs-meetings), which serves as a meeting scheduling platform for headhunters and users.

## Installation

To set up the project locally, follow these steps:

Clone the repository:

```shell
git clone git@github.com:0jonjo/alljobs.git
cd alljobs
```

Install dependencies:

```shell
bundle install
```

Set up the database, comment out lines 18-20 and uncomment lines 16-17 in `config/database.yml` . Then start the database in container, run:

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

Feel free to explore the features and functionalities of ALLJOBS. Happy job hunting!
