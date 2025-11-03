# NOTE: before版ではRentalが料金計算の分岐と頻度ポイントの計算を直接抱えており、Movieの振る舞いと乖離していました。料金はMovieに委譲しRentalは期間などの構造的な情報に専念させています。
class Rental
  attr_reader :movie, :days_rented

  def initialize(movie, days_rented)
    @movie = movie
    @days_rented = days_rented
  end

  def charge
    movie.charge(days_rented)
  end

  def frequent_renter_points
    movie.frequent_renter_points(days_rented)
  end
end
