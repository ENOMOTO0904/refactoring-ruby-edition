require 'minitest/autorun'
require_relative 'movie'
require_relative 'rental'

class RentalTest < Minitest::Test
  def test_rental_creation
    movie = Movie.new("となりのトトロ", Movie::CHILDREN)
    rental = Rental.new(movie, 5)

    assert_equal movie, rental.movie
    assert_equal 5, rental.days_rented
  end
end
