class ClimbInjestionWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)

    return unless MountainProjectService.new_climbs?(user)

    new_latest_climb = nil
    MountainProjectService.process_user_climbs(user.email) do |climbs|
      new_latest_climb = climbs.first if new_latest_climb.nil?
      climbs.each { |climb| create_climb(climb.with_indifferent_access, user) }
    end

    # Update the user model with some info so we can determine where to start
    # the injestion process next time.
    User.update_with_latest_climb(new_latest_climb)
  end

  private

  def create_climb(climb, user)
    Climb.create(name: climb[:name],
                 climb_type: climb[:type],
                 rating: climb[:rating],
                 pitches: climb[:pitches].to_i,
                 route_id: climb[:id],
                 climb_date: Climb.parse_date_from_mp_format(climb[:date]),
                 user: user)
  end
end
