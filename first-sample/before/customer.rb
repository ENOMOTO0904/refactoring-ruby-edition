require_relative 'movie'
require_relative 'rental'

class Customer
  attr_reader :name

  def initialize(name)
    @name = name
    @rentals = [] # レンタル履歴
  end

  # レンタル履歴の追加
  def add_rental(arg)
    @rentals << arg
  end

  # 料金計算とレシート出力を行うメソッド (リファクタリング対象)
  def statement
    total_amount = 0          # 合計金額
    frequent_renter_points = 0  # ポイント
    result = "Rental Record for #{@name}\n" # 出力結果の文字列

    @rentals.each do |element|
      this_amount = 0 # 今回のレンタル料金

      # 料金の計算
      case element.movie.price_code
      when Movie::REGULAR # 一般作
        this_amount += 2
        this_amount += (element.days_rented - 2) * 1.5 if element.days_rented > 2
      when Movie::NEW_RELEASE # 新作
        this_amount += element.days_rented * 3
      when Movie::CHILDREN # 子供向け
        this_amount += 1.5
        this_amount += (element.days_rented - 3) * 1.5 if element.days_rented > 3
      end

      # レンタルポイントの加算
      frequent_renter_points += 1
      # 新作を2日以上借りた場合はボーナスポイント
      if element.movie.price_code == Movie::NEW_RELEASE && element.days_rented > 1
        frequent_renter_points += 1
      end

      # このレンタルの情報を結果に追加
      result += "\t" + element.movie.title + "\t" + this_amount.to_s + "\n"
      total_amount += this_amount
    end

    # フッター（合計金額とポイント）を追加
    result += "Amount owed is #{total_amount}\n"
    result += "You earned #{frequent_renter_points} frequent renter points"
    result
  end
end
