require "controllers/api/v1/test"

class Api::V1::Items::OptionsControllerTest < Api::Test
  setup do
    # See `test/controllers/api/test.rb` for common set up for API tests.

    @item = create(:item, team: @team)
    @option = build(:items_option, item: @item)
    @other_options = create_list(:items_option, 3)

    @another_option = create(:items_option, item: @item)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @option.save
    @another_option.save

    @original_hide_things = ENV["HIDE_THINGS"]
    ENV["HIDE_THINGS"] = "false"
    Rails.application.reload_routes!
  end

  teardown do
    ENV["HIDE_THINGS"] = @original_hide_things
    Rails.application.reload_routes!
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(option_data)
    # Fetch the option in question and prepare to compare it's attributes.
    option = Items::Option.find(option_data["id"])

    assert_equal_or_nil option_data['name'], option.name
    assert_equal_or_nil option_data['capacity'], option.capacity
    assert_equal_or_nil option_data['image_tag'], option.image_tag
    assert_equal_or_nil option_data['description'], option.description
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal option_data["item_id"], option.item_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/items/#{@item.id}/options", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    option_ids_returned = response.parsed_body.map { |option| option["id"] }
    assert_includes(option_ids_returned, @option.id)

    # But not returning other people's resources.
    assert_not_includes(option_ids_returned, @other_options[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/items/options/#{@option.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/items/options/#{@option.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    option_data = JSON.parse(build(:items_option, item: nil).api_attributes.to_json)
    option_data.except!("id", "item_id", "created_at", "updated_at")
    params[:items_option] = option_data

    post "/api/v1/items/#{@item.id}/options", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/items/#{@item.id}/options",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/items/options/#{@option.id}", params: {
      access_token: access_token,
      items_option: {
        name: 'Alternative String Value',
        description: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @option.reload
    assert_equal @option.name, 'Alternative String Value'
    assert_equal @option.description, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/items/options/#{@option.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Items::Option.count", -1) do
      delete "/api/v1/items/options/#{@option.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/items/options/#{@another_option.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
