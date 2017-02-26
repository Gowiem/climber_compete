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
    ticks = ticks_response['ticks']

    # There can be many of the same routeId since the user can tick the route
    # multiple times. We only care to fetch it once though.
    route_ids = Set.new(ticks.map { |t| t['routeId'] })

    routes = fetch_routes(route_ids)

    # We need to pair each tick with it's associated route. There are likely
    # more ticks than routes.
    merged_routes = ticks.each_with_object([]) do |t, memo|
      memo << routes[t['routeId'].to_s].merge(t)
    end

    block.call(merged_routes)

    process_user_climbs(email, start_pos + 200, &block) if ticks.size == 200
  end

  # Iteratively fetches the routes for the given route_ids in batches of 200
  # Returns a hash of all routes in the format { id => route, ... }
  def self.fetch_routes(route_ids)
    routes = route_ids.each_slice(200).map do |slice|
      routes_response = fetch_for_action(:getRoutes, routeIds: slice.join(','))
      return [] if routes_response.nil?
      routes_response['routes']
    end.flatten.compact

    routes.each_with_object({}) { |route, memo| memo[route['id']] = route }
  end

  # Method to abstract away requesting again the Mountain Project Data API.
  def self.fetch_for_action(action, extra_params)
    params = { action: action, key: ENV['MOUNTAIN_PROJECT_API_KEY'] }.merge(extra_params)
    response = RestClient.get('https://www.mountainproject.com/data', params: params)
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => err
    puts "Error with Request to Mountain Project: #{err.response}"
    nil
  end
end
