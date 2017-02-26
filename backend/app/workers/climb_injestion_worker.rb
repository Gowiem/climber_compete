class ClimbInjestionWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    MountainProjectService.process_user_climbs(user.email) do |routes|
      routes = routes.values.map(&:with_indifferent_access)
      routes.each { |route| create_climb(route, user) }
    end
  end

  private

  def create_climb(route, user)
    date = route[:date].split('-')
    climb_date = DateTime.new(date[0].to_i, date[1].to_i, date[2].to_i)
    Climb.create(name: route[:name],
                 climb_type: route[:type],
                 rating: route[:rating],
                 pitches: route[:pitches].to_i,
                 route_id: route[:id],
                 climb_date: climb_date,
                 user: user)
  end
end
