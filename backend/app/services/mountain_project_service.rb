require 'json'
# API Documentaion: https://www.mountainproject.com/data
module MountainProjectService
  # email       - Email of user to fetch climbs for
  # start_pos   - Start start_pos of the pagination, default 0
  # block       - Block to call on the User's climbs
  #
  # Invokes the given block on the routes returned for the given user's email
  # starting from start_pos and finished at their first climb.
  def self.process_user_climbs(email, start_pos = 0, &block)
    ticks_response = fetch_for_action(:getTicks, email: email, 'startPos' => start_pos)

    return if ticks_response.nil?
    route_ids = ticks_response['ticks'].map { |tick| tick['routeId'] }

    routes = route_ids.each_slice(200).map do |slice|
      routes_response = fetch_for_action(:getRoutes, routeIds: slice.join(','))
      routes_response['routes'] unless routes_response.nil?
    end.flatten.compact

    block.call(routes)

    process_user_climbs(email, start_pos + 200, &block) if route_ids.size == 200
  end

  # Method to abstract away requesting again the Mountain Project Data API.
  def self.fetch_for_action(action, extra_params)
    params = { action: action, key: ENV['MOUNTAIN_PROJECT_API_KEY'] }.merge(extra_params)
    response = RestClient.get('https://www.mountainproject.com/data', params)
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => err
    puts "Error with Request to Mountain Project: #{err.response}"
    nil
  end
end
