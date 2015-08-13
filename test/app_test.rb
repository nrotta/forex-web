require 'cuba/test'
require './app'

scope do
  test "that the form is present" do
    get "/"
    assert last_response.body.include?("form")
    assert_equal last_response.status, 200
  end

  test "that a get to an nonexistent path throws a 404" do
    get "/nonexistant"
    assert_equal last_response.status, 404
  end

  test "that a post to an nonexistent path throws a 404" do
    post "/nonexistant"
    assert_equal last_response.status, 404
  end

  test "post with complete information - GBP EUR" do
    post "/", { date: '2015-08-11', amount: 100, base: 'GBP', counter: 'EUR' }
    assert last_response.body.include?("GBP 100 = EUR 141.08 ON 2015-08-11")
    assert_equal last_response.status, 200
  end

  test "post with complete information - EUR GBP" do
    post "/", { date: '2015-08-11', amount: 100, base: 'EUR', counter: 'GBP' }
    assert last_response.body.include?("EUR 100 = GBP 70.88 ON 2015-08-11")
    assert_equal last_response.status, 200
  end

  test "post with complete information - EUR EUR" do
    post "/", { date: '2015-08-11', amount: 100, base: 'EUR', counter: 'EUR' }
    assert last_response.body.include?("EUR 100 = EUR 100.0 ON 2015-08-11")
    assert_equal last_response.status, 200
  end

  test "post with complete information - USD GBP" do
    post "/", { date: '2015-08-11', amount: 100, base: 'USD', counter: 'GBP' }
    assert last_response.body.include?("USD 100 = GBP 64.12 ON 2015-08-11")
    assert_equal last_response.status, 200
  end

  test "post with missing date" do
    post "/", { amount: 100, base: 'GBP', counter: 'EUR' }
    assert last_response.body.include?("Please provide date, amount, and base and counter currencies")
  end

  test "post with missing amount" do
    post "/", { date: '2015-08-11', base: 'GBP', counter: 'EUR' }
    assert last_response.body.include?("Please provide date, amount, and base and counter currencies")
    assert_equal last_response.status, 200
  end

  test "post with missing base" do
    post "/", { date: '2015-08-11', amount: 100, counter: 'EUR' }
    assert last_response.body.include?("Please provide date, amount, and base and counter currencies")
    assert_equal last_response.status, 200
  end

  test "post with missing counter" do
    post "/", { date: '2015-08-11', amount: 100, counter: 'EUR' }
    assert last_response.body.include?("Please provide date, amount, and base and counter currencies")
    assert_equal last_response.status, 200
  end

  test "post with incorrect date" do
    post "/", { date: '20152-08-11', amount: 100, base: 'GBP', counter: 'EUR' }
    assert last_response.body.include?("Please provide correct date, amount, and base and counter currencies")
    assert_equal last_response.status, 200
  end

  test "post with incorrect amount" do
    post "/", { date: '2015-08-11', amount: "XXX", base: 'GBP', counter: 'EUR' }
    assert last_response.body.include?("Please provide correct date, amount, and base and counter currencies")
    assert_equal last_response.status, 200
  end

  test "post with incorrect base" do
    post "/", { date: '2015-08-11', amount: 100, base: 'XXX', counter: 'EUR' }
    assert last_response.body.include?("Please provide correct date, amount, and base and counter currencies")
    assert_equal last_response.status, 200
  end

  test "post with incorrect counter" do
    post "/", { date: '2015-08-11', amount: 100, base: 'GBP', counter: 'XXX' }
    assert last_response.body.include?("Please provide correct date, amount, and base and counter currencies")
    assert_equal last_response.status, 200
  end
end
