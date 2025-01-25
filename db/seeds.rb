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

# Default Comment on Profile
comment_body = 'Just a text'
Comment.create(
  body: comment_body,
  profile_id: profile.id,
  headhunter_id: headhunter.id
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

# Default Star
Star.create(headhunter_id: headhunter.id, apply_id: apply.id)

# Default Feedback Apply
FeedbackApply.create(
  headhunter_id: headhunter.id,
  apply_id: apply.id,
  body: comment_body
)

# Default Proposal
proposal = Proposal.create(
  apply: apply,
  salary:,
  benefits: 'Benefits',
  expectations: 'Expectations',
  expected_start: 1.month.from_now,
  user_accepted: true
)

# Default Proposal Comment
ProposalComment.create(
  proposal: proposal,
  author_id: headhunter.id,
  author_type: headhunter.class,
  body: comment_body
)
