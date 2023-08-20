# ALLJOBS

This is a TDD study project to a job opening website using Ruby on Rails in a TDD way. Alljobs focuses on job search, management of applications, proposals and communication. It has 3 roles: admin (general management), headhunter (job creation, candidate, feedback, proposals) and user (profile creation, job search and application).

[Project Board](https://github.com/users/0jonjo/projects/3)

Side repository to test API: [Seejobs](https://github.com/0jonjo/seejobs/)

- Ruby: 3.0.0
- Rails: 6.1.4
- Relevant Gems: Devise, Rspec, Capybara, Shoulda Matchers, SimpleCov, Kaminari, DelayedJob, Faraday and Rails Admin.

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
rails s
```
