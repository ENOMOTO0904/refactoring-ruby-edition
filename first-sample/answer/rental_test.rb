# NOTE: before版ではレンタル料金の計算ロジックを直接テストしていませんでしたが、ここではMovieへの委譲が正しく行われるかを確認する足がかりとして作成しています。
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

  def test_charge_delegates_to_movie
    movie = Movie.new("新作映画", Movie::NEW_RELEASE)
    rental = Rental.new(movie, 2)

    assert_equal 6, rental.charge
  end

  def test_frequent_renter_points_delegates_to_movie
    movie = Movie.new("新作映画", Movie::NEW_RELEASE)
    rental = Rental.new(movie, 3)

    assert_equal 2, rental.frequent_renter_points
  end
end
