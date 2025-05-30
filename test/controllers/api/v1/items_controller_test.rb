require "controllers/api/v1/test"

class Api::V1::ItemsControllerTest < Api::Test
  setup do
    # See `test/controllers/api/test.rb` for common set up for API tests.

    @item = build(:item, team: @team)
    @other_items = create_list(:item, 3)

    @another_item = create(:item, team: @team)

    @item.layout = Rack::Test::UploadedFile.new("test/support/foo.txt")
    @another_item.layout = Rack::Test::UploadedFile.new("test/support/foo.txt")
    # 🚅 super scaffolding will insert file-related logic above this line.
    @item.save
    @another_item.save

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
  def assert_proper_object_serialization(item_data)
    # Fetch the item in question and prepare to compare it's attributes.
    item = Item.find(item_data["id"])

    assert_equal_or_nil item_data['name'], item.name
    assert_equal_or_nil item_data['description'], item.description
    assert_equal_or_nil item_data['location_id'], item.location_id
    assert_equal_or_nil item_data['active'], item.active
    assert_equal_or_nil item_data['overlap_offset'], item.overlap_offset
    assert_equal_or_nil item_data['image_tag'], item.image_tag
    assert_equal_or_nil item_data['clean'], item.clean
    assert_equal_or_nil item_data['flip_time'], item.flip_time
    assert_equal_or_nil item_data['beds'], item.beds
    assert_equal item_data['layout'], rails_blob_path(@item.layout) unless controller.action_name == 'create'
    assert_equal_or_nil item_data['tag_ids'], item.tag_ids
    assert_equal_or_nil item_data['items_area_id'], item.items_area_id
    assert_equal_or_nil item_data['abbreviation'], item.abbreviation
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal item_data["team_id"], item.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/items", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    item_ids_returned = response.parsed_body.map { |item| item["id"] }
    assert_includes(item_ids_returned, @item.id)

    # But not returning other people's resources.
    assert_not_includes(item_ids_returned, @other_items[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/items/#{@item.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/items/#{@item.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    item_data = JSON.parse(build(:item, team: nil).api_attributes.to_json)
    item_data.except!("id", "team_id", "created_at", "updated_at")
    params[:item] = item_data

    post "/api/v1/teams/#{@team.id}/items", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/items",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/items/#{@item.id}", params: {
      access_token: access_token,
      item: {
        name: 'Alternative String Value',
        description: 'Alternative String Value',
        abbreviation: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @item.reload
    assert_equal @item.name, 'Alternative String Value'
    assert_equal @item.description, 'Alternative String Value'
    assert_equal @item.abbreviation, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/items/#{@item.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Item.count", -1) do
      delete "/api/v1/items/#{@item.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/items/#{@another_item.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
