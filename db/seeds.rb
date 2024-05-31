# frozen_string_literal: true

# Default Admin
Admin.create(email: 'admin@test.com',
             password: 'test123')
# Default Headhunter
headhunter = Headhunter.create(email: 'headhunter@test.com',
                               password: 'test123')
# Default Country
country = Country.create(acronym: 'US', name: 'United States')

# Default User and Profile
user = User.create(email: 'user@test.com',
                   password: 'test123')
profile = Profile.create!(name: 'Tester', social_name: 'Tester Social Name',
                          birthdate: '21/03/1977', description: 'Nice person', educacional_background: 'High School',
                          experience: 'Dancer long time ago', user_id: user.id,
                          country_id: country.id, city: 'Test City')
# Default Comment on Profile
Comment.create(body: 'Seed comment', profile_id: profile.id,
               headhunter_id: headhunter.id)
# Default Company
company = Company.create(name: 'Acme', description: 'Seeds Company',
                         website: 'www.test.com', email: 'acme@test.com',
                         phone: '999999999')
# Default Job
job = Job.create(title: 'Test 123', description: 'Lorem ipsum dolor sit amet',
                 skills: 'Nam mattis, felis ut adipiscing.', salary: 99, level: :junior,
                 company_id: company.id, country_id: country.id, city: 'Test City', date: 10.years.from_now)
# Default Apply
apply = Apply.create(job: job, user: user)

# Default Star
Star.create(headhunter_id: headhunter.id, apply_id: apply.id)

# Default Feedback Apply
FeedbackApply.create(headhunter_id: headhunter.id, apply_id: apply.id, body: 'Just a text Feedback')

# Default Proposal
proposal = Proposal.create(apply: apply, salary: 999, benefits: 'some benefits',
                           expectations: 'some expectations', expected_start: 1.month.from_now,
                           user_accepted: true)

# Default Proposal Comment
ProposalComment.create(proposal_id: proposal.id, author_id: headhunter.id, author_type: headhunter.class,
                       body: 'Just a test comment')
