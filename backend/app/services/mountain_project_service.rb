module MountainProjectService
  # email - Email of user to fetch climbs for
  # pos   - Start pos of the pagination, default 0
  # block - Block to call on the User's climbs
  #
  # Returns a HashWithIndifferent of the routes for the given user, starting from pos
  # Returns nil if Mountain Project threw an Error.
  def self.process_user_climbs(email, pos = 0, &block)
    ticks_response = fetch_for_action(:getTicks, email: email, 'startPos' => pos)

    return if ticks_response.nil?
    route_ids = ticks_response['ticks'].map { |tick| tick['routeId'] }

    routes = route_ids.each_slice(100).map do |slice|
      routes_response = fetch_for_action(:getRoutes, routeIds: slice.join(','))
      routes_response['routes'] unless routes_response.nil?
    end.flatten.compact

    block.call(routes)

    get_ticks(email, pos + 199, block) if ticks.size == 200
  end

  def self.fetch_for_action(action, extra_params)
    params = { action: action, key: ENV['MOUNTAIN_PROJECT_API_KEY'] }.merge(extra_params)
    response = RestClient.get('https://www.mountainproject.com/data', params)
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => err
    puts "Error with Request to Mountain Project: #{err.response}"
    nil
  end
end
