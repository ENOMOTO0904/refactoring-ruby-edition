# NOTE: before版のテストは動作確認に十分でしたが、リファクタ後のAPIをそのまま流用できることを確認するため答え用にも同一シナリオを用意しています。
require 'minitest/autorun'
require_relative 'movie'
require_relative 'rental'
require_relative 'customer'

class CustomerTest < Minitest::Test
  def setup
    @customer = Customer.new("田中 太郎")

    @movie_new = Movie.new("新作映画", Movie::NEW_RELEASE)
    @movie_reg = Movie.new("一般映画", Movie::REGULAR)
    @movie_child = Movie.new("子供向け映画", Movie::CHILDREN)
  end

  def test_customer_creation
    assert_equal "田中 太郎", @customer.name
  end

  def test_statement_for_no_rentals
    expected_statement = <<~EOS
      Rental Record for 田中 太郎
      Amount owed is 0
      You earned 0 frequent renter points
    EOS

    assert_equal expected_statement.chomp, @customer.statement
  end

  def test_statement_for_multiple_rentals
    @customer.add_rental(Rental.new(@movie_new, 2))
    @customer.add_rental(Rental.new(@movie_reg, 3))
    @customer.add_rental(Rental.new(@movie_child, 4))

    expected_statement = <<~EOS
      Rental Record for 田中 太郎
      	新作映画	6
      	一般映画	3.5
      	子供向け映画	3.0
      Amount owed is 12.5
      You earned 4 frequent renter points
    EOS

    assert_equal expected_statement.chomp, @customer.statement
  end

  def test_statement_new_release_one_day
    @customer.add_rental(Rental.new(@movie_new, 1))

    assert_includes @customer.statement, "Amount owed is 3"
    assert_includes @customer.statement, "You earned 1 frequent renter points"
  end

  def test_statement_regular_short_rental
    @customer.add_rental(Rental.new(@movie_reg, 2))

    assert_includes @customer.statement, "Amount owed is 2"
    assert_includes @customer.statement, "You earned 1 frequent renter points"
  end

  def test_statement_children_short_rental
    @customer.add_rental(Rental.new(@movie_child, 3))

    assert_includes @customer.statement, "Amount owed is 1.5"
    assert_includes @customer.statement, "You earned 1 frequent renter points"
  end
end
