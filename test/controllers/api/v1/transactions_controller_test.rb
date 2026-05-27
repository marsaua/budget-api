require "test_helper"

class Api::V1::TransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(name: "Alice", email: "alice@example.com", password: "password123")
    post "/api/v1/auth/sign_in",
      params: { user: { email: "alice@example.com", password: "password123" } },
      as: :json
    @token = response.headers["Authorization"]
    @room = Room.create!(name: "Test Room", owner: @user)
    @room.transactions.create!(description: "Pizza", amount: 100, kind: "expense",
      category: "food", occurred_on: "2024-01-10", author: @user)
    @room.transactions.create!(description: "Bus", amount: 50, kind: "expense",
      category: "transport", occurred_on: "2024-01-11", author: @user)
    @room.transactions.create!(description: "Salary", amount: 3000, kind: "income",
      category: "income", occurred_on: "2024-01-01", author: @user)
  end

  test "index returns all transactions when no categories param" do
    get "/api/v1/rooms/#{@room.id}/transactions",
      params: { year: 2024, month: 1 },
      headers: { "Authorization" => @token }
    assert_response :ok
    assert_equal 3, response.parsed_body["transactions"].length
  end

  test "index filters by a single category" do
    get "/api/v1/rooms/#{@room.id}/transactions",
      params: { year: 2024, month: 1, categories: ["food"] },
      headers: { "Authorization" => @token }
    assert_response :ok
    body = response.parsed_body
    assert_equal 1, body["transactions"].length
    assert_equal "food", body["transactions"].first["category"]
  end

  test "index filters by multiple categories" do
    get "/api/v1/rooms/#{@room.id}/transactions",
      params: { year: 2024, month: 1, categories: ["food", "transport"] },
      headers: { "Authorization" => @token }
    assert_response :ok
    assert_equal 2, response.parsed_body["transactions"].length
  end

  test "summary reflects the category filter" do
    get "/api/v1/rooms/#{@room.id}/transactions",
      params: { year: 2024, month: 1, categories: ["food"] },
      headers: { "Authorization" => @token }
    summary = response.parsed_body["summary"]
    assert_equal 100.0, summary["expense"]
    assert_equal 0.0, summary["income"]
    assert_equal(-100.0, summary["balance"])
  end
end
