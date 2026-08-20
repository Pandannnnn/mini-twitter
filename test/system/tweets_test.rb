require "application_system_test_case"

class TweetsTest < ApplicationSystemTestCase
  test "visiting the timeline" do
    visit root_path

    assert_selector "h1", text: "Twitter"
  end
end
