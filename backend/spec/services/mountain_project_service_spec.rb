require 'mountain_project_service'
require 'rest_client'

RSpec.describe 'MountainProjectService' do
  context '#process_user_climbs' do
    # This is shit. I realize that. I'm not sure of a great way to clean it up.
    # Maybe I'll ask someone.
    def mock_mp_requests(expected_num_results)
      ticks = { ticks: Array.new(expected_num_results.clamp(0, 200)) { |i| { routeId: i } } }
      routes = { routes: Array.new(expected_num_results.clamp(0, 200)) { |i| { routeId: i } } }
      ticks_response = RestClient::Response.new(ticks.to_json)
      routes_response = RestClient::Response.new(routes.to_json)

      expect(RestClient).to(receive(:get))
                        .with(anything, hash_including(action: :getTicks, 'startPos' => 0))
                        .and_return(ticks_response)
      expect(RestClient).to(receive(:get))
                        .with(anything, hash_including(action: :getRoutes))
                        .and_return(routes_response)

      return if expected_num_results < 200

      ticks200 = { ticks: (200...expected_num_results).map { |i| { routeId: i } } }
      ticks200_response = RestClient::Response.new(ticks200.to_json)
      expect(RestClient).to(receive(:get))
                        .with(anything, hash_including(action: :getTicks, 'startPos' => 200))
                        .and_return(ticks200_response)

      routes200 = { routes: (200...expected_num_results).map { |i| { routeId: i } } }
      route_ids = routes200[:routes].map { |r| r[:routeId] }.join(',')
      routes200_response = RestClient::Response.new(routes200.to_json)
      expect(RestClient).to(receive(:get))
                        .with(anything, hash_including(action: :getRoutes, routeIds: route_ids))
                        .and_return(routes200_response)
    end

    it 'should process a batch of 5' do
      mock_mp_requests(5)
      MountainProjectService.process_user_climbs('mock@user.email', 0) do |routes|
        expect(routes.size).to eq(5)
      end
    end

    it 'should process a batch of 205' do
      mock_mp_requests(205)
      routes_processed = 0
      MountainProjectService.process_user_climbs('mock@user.email', 0) do |routes|
        routes_processed += routes.size
      end
      expect(routes_processed).to eq(205)
    end

    it 'should handle failures without exploding' do
      expect(RestClient).to(receive(:get))
                        .with(any_args)
                        .and_raise(RestClient::ExceptionWithResponse)
      MountainProjectService.process_user_climbs('mock@user.email', 0) do |_|
        expect(false).to be true
      end
    end
  end
end
