# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Default Admin
Headhunter.create(email: 'herbiehancock@ndtheheadhunters.com',
             password: 'watermelonman')
#Default User
User.create(email: 'usuario@disco1995.com.br',
             password: 'd2blackalien')
