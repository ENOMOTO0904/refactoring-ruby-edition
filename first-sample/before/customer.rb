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
    total_price = 0          # 合計金額
    frequent_renter_points = 0  # ポイント
    result = "Rental Record for #{@name}\n" # 出力結果の文字列

    @rentals.each do |rental|
      price = rental.caluculate_rental_price
      total_price += price
      frequent_renter_points += rental.add_renter_point

      result += "\t" + rental.movie.title + "\t" + price.to_s + "\n"
    end

    # フッター（合計金額とポイント）を追加
    result += "Amount owed is #{total_price}\n"
    result += "You earned #{frequent_renter_points} frequent renter points"
    result
  end
end
