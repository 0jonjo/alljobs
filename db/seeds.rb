# frozen_string_literal: true

# Default Headhunter
password = 'test123'
headhunter = Headhunter.create(email: 'headhunter@test.com', password: password)

# Default Country
country = Country.create(acronym: 'US', name: 'United States')

# Default User and Profile
user = User.create(email: 'user@test.com', password: password)
description = 'Description'
profile = Profile.create!(
  name: 'Tester',
  social_name: 'Tester Social Name',
  birthdate: '21/03/1977',
  description:,
  educacional_background: 'Educational Background',
  experience: 'Experience',
  user_id: user.id,
  country_id: country.id,
  city: 'City'
)

# Default Company
company = Company.create(
  name: 'Company',
  description:,
  website: 'www.test.com',
  email: 'company@test.com',
  phone: '999999999'
)

# Default Job
salary = 99
job = Job.create(
  title: 'Title',
  description:,
  skills: 'Skills',
  salary:,
  level: :junior,
  company_id: company.id,
  country_id: country.id,
  city: 'City',
  date: 10.years.from_now
)

# Default Apply
apply = Apply.create(job: job, user: user)

# Default Comment on Apply
Comment.create(body: 'Comment body',
               apply_id: apply.id,
               author_id: headhunter.id,
               author_type: 'Headhunter')

# Default Star
Star.create(headhunter_id: headhunter.id, apply_id: apply.id)
