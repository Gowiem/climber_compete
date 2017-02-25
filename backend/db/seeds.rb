gowie = User.create(first_name: 'Matt',
                    last_name: 'Gowie',
                    email: 'gowie.matt@gmail.com',
                    password: 'supersecret',
                    password_confirmation: 'supersecret')

gian = User.create(first_name: 'Chris',
                   last_name: 'Gian',
                   email: 'christopher.gian@gmail.com',
                   password: 'supersecret',
                   password_confirmation: 'supersecret')

comp = Competition.create(name: 'Starter Comp',
                          start_date: DateTime.new(2017),
                          end_date: DateTime.new(2017, 4))

gowie.user_comps.create(competition: comp)
gian.user_comps.create(competition: comp)
