# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Default Admin
Headhunter.create(email: 'admin@test.com',
             password: 'test123')
#Default User and Profile
user = User.create(email: 'user@test.com',
             password: 'test123')
profile = Profile.create!(name: 'Tester', social_name: 'Tester Social Name', 
                          birthdate: '21/03/1977', educacional_background: "High School", 
                          experience: 'Dancer long time ago', user_id: user.id)
