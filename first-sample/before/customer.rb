require_relative 'movie'
require_relative 'rental'

class Customer
  attr_reader :name

  def initialize(name)
    @name = name
    @rentals = [] # レンタル履歴
  end

  def add_rental(arg)
    @rentals << arg
  end

  def statement
    result = "Rental Record for #{@name}\n"
    total_price
    total_frequent_renter_points

    @rentals.each do |rental|
      result += "\t" + rental.movie.title + "\t" + rental.caluculate_rental_price.to_s + "\n"
    end

    # フッター（合計金額とポイント）を追加
    result += "Amount owed is #{total_price}\n"
    result += "You earned #{total_frequent_renter_points} frequent renter points"
    result
  end

  private

  attr_reader :rentals

  def total_price
    rentals.sum(&:caluculate_rental_price)
  end

  def total_frequent_renter_points
    rentals.sum(&:add_rental_point)
  end
end
