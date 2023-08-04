# ALLJOBS

This is a TDD study project to a job opening website using Ruby on Rails.

[Project Board (To do, In Progress, Done)](https://github.com/users/0jonjo/projects/3)

Ruby: 3.0.0
Rails: 6.1.4.1 
Gems:
- Devise (4.8.0)
- Rspec-rails (5.0.2)
- Capybara (3.37.1)
- Kaminari (1.2.1)  
- Delayed Job (4.1.10)
- Daemons (1.4.1)
- Faraday (2.5.2)
- Rails_admin (3.1.0)

- [x] 1. Headhunter creates an account 
- [x] 2. Headhunter registers/searchs a job opening
- [x] 3. Candidate creates an account
- [x] 4. Candidate completes his profile
- [x] 5. Candidate applies for a job opening 
- [x] 6. Headhunter sees everyone registered for a job opening
- [x] 7. Headhunter writes comments on the applicant's profile for a job 
- [x] 8. Headhunter stars a profile
- [x] 9. Headhunter rejects applicant providing feedback
- [x] 10. Headhunter sends proposal to applicant
- [x] Applicant receives feedback if rejected for a job
- [x] Candidate receives proposal sent by headhunter
- [x] Candidate accepts/rejects proposal
14. Headhunter receives response from candidate
15. Headhunter closes registration for a job 

## Others:
- [x] Use asynchronous processing to delete applications from archived job openings 
- [x] Create a side repository to test API [(Seejobs)](https://github.com/0jonjo/seejobs/)
- [x] Translate Alljobs to Portuguese. 
- [x] Create Admin role and page.
- [ ] Implement a cool design.

## Install

### Clone the repository

```shell
git clone git@github.com:0jonjo/alljobs.git
cd alljobs
```

### Install dependencies

Using [Bundler](https://github.com/bundler/bundler)

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
