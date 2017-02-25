require 'test_helper'

class CompetitionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @competition = competitions(:one)
  end

  test "should get index" do
    get competitions_url, as: :json
    assert_response :success
  end

  test "should create competition" do
    assert_difference('Competition.count') do
      post competitions_url, params: { competition: { end_date: @competition.end_date, name: @competition.name, start_date: @competition.start_date } }, as: :json
    end

    assert_response 201
  end

  test "should show competition" do
    get competition_url(@competition), as: :json
    assert_response :success
  end

  test "should update competition" do
    patch competition_url(@competition), params: { competition: { end_date: @competition.end_date, name: @competition.name, start_date: @competition.start_date } }, as: :json
    assert_response 200
  end

  test "should destroy competition" do
    assert_difference('Competition.count', -1) do
      delete competition_url(@competition), as: :json
    end

    assert_response 204
  end
end
