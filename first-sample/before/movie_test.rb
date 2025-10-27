require 'minitest/autorun'
require_relative 'movie'

class MovieTest < Minitest::Test
  def test_movie_creation
    movie = Movie.new("インセプション", Movie::REGULAR)
    assert_equal "インセプション", movie.title
    assert_equal Movie::REGULAR, movie.price_code
  end

  def test_price_code_change
    movie = Movie.new("新作映画", Movie::NEW_RELEASE)
    movie.price_code = Movie::REGULAR
    assert_equal Movie::REGULAR, movie.price_code
  end
end