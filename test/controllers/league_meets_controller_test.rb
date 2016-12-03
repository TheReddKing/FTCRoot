require 'test_helper'

class LeagueMeetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @league_meet = league_meets(:one)
  end

  test "should get index" do
    get league_meets_url
    assert_response :success
  end

  test "should get new" do
    get new_league_meet_url
    assert_response :success
  end

  test "should create league_meet" do
    assert_difference('LeagueMeet.count') do
      post league_meets_url, params: { league_meet: { description: @league_meet.description, meetid: @league_meet.meetid, name: @league_meet.name } }
    end

    assert_redirected_to league_meet_url(LeagueMeet.last)
  end

  test "should show league_meet" do
    get league_meet_url(@league_meet)
    assert_response :success
  end

  test "should get edit" do
    get edit_league_meet_url(@league_meet)
    assert_response :success
  end

  test "should update league_meet" do
    patch league_meet_url(@league_meet), params: { league_meet: { description: @league_meet.description, meetid: @league_meet.meetid, name: @league_meet.name } }
    assert_redirected_to league_meet_url(@league_meet)
  end

  test "should destroy league_meet" do
    assert_difference('LeagueMeet.count', -1) do
      delete league_meet_url(@league_meet)
    end

    assert_redirected_to league_meets_url
  end
end
