# Climber Compete

## Background

A web app to allow rock climbers to have friendly competitions between each other. Users setup competitions between one another to see who can finish the most climbs in a 3 month period or who can get to 50 climbs first. The app then uses the [Mountain Project Data API](https://www.mountainproject.com/data) to gather stats on climber's Mountain Project ticks (climbs) to determine who wins and facilitate the competition.

Built with Rails 5, Ember, Postgres, and Sidekiq.

## Dependencies

All requirements and installation docs below assume the developer is on Mac OSX.

* [Git](https://git-scm.com/)
* [Node.js > 4](https://nodejs.org/) (with NPM)
* [Ruby-2.4.1](https://rvm.io/)
* [Postgresql](https://launchschool.com/blog/how-to-install-postgresql-on-a-mac)

## Developer Installation

### Backend (Rails)

1. `cd backend`
2. `bundle install`
3. `rake db:create && rake db:migrate`
4. `rails server`

### Frontend (Ember CLI)

1. `cd frontend`
2. `npm install`
3. `ember serve`

You should now be able to navigate to [localhost:8080](http://localhost:8080).
