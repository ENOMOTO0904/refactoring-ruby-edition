# NOTE: before版のMovieは単なるデータホルダーで、料金計算を担っていませんでした。ここでは価格オブジェクト移譲後のcharge/frequent_renter_points振る舞いも検証します。
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

  def test_charge_for_regular_movie
    movie = Movie.new("一般映画", Movie::REGULAR)
    assert_equal 2, movie.charge(2)
    assert_equal 3.5, movie.charge(3)
  end

  def test_charge_for_new_release_movie
    movie = Movie.new("新作映画", Movie::NEW_RELEASE)
    assert_equal 9, movie.charge(3)
  end

  def test_charge_for_children_movie
    movie = Movie.new("子供映画", Movie::CHILDREN)
    assert_equal 1.5, movie.charge(3)
    assert_equal 3.0, movie.charge(4)
  end

  def test_frequent_renter_points_for_new_release
    movie = Movie.new("新作映画", Movie::NEW_RELEASE)
    assert_equal 2, movie.frequent_renter_points(2)
    assert_equal 1, movie.frequent_renter_points(1)
  end

  def test_unknown_price_code_raises_error
    assert_raises(ArgumentError) { Movie.new("？？？", 99) }
  end
end
