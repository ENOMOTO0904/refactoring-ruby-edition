# NOTE: before版では料金計算とポイント付与の条件がRental側にまとまっており、価格コードが増えると複数クラスを横断して修正が必要になる構造でした。この版では価格ごとの振る舞いをMovie配下のオブジェクトに委譲し、変更点を局所化しています。
class Movie
  REGULAR = 0
  NEW_RELEASE = 1
  CHILDREN = 2

  attr_reader :title

  def initialize(title, price_code)
    @title = title
    self.price_code = price_code
  end

  def price_code
    price.code
  end

  def price_code=(code)
    @price = Price.for(code)
  end

  def charge(days_rented)
    price.charge(days_rented)
  end

  def frequent_renter_points(days_rented)
    price.frequent_renter_points(days_rented)
  end

  private

  attr_reader :price

  class Price
    def self.for(code)
      case code
      when Movie::REGULAR
        RegularPrice.new
      when Movie::NEW_RELEASE
        NewReleasePrice.new
      when Movie::CHILDREN
        ChildrenPrice.new
      else
        raise ArgumentError, "Unknown price code: #{code}"
      end
    end

    def code
      raise NotImplementedError, "#{self.class} must implement #code"
    end

    def charge(_days_rented)
      raise NotImplementedError, "#{self.class} must implement #charge"
    end

    def frequent_renter_points(_days_rented)
      1
    end
  end

  class RegularPrice < Price
    def code
      Movie::REGULAR
    end

    def charge(days_rented)
      result = 2
      result += (days_rented - 2) * 1.5 if days_rented > 2
      result
    end
  end

  class NewReleasePrice < Price
    def code
      Movie::NEW_RELEASE
    end

    def charge(days_rented)
      days_rented * 3
    end

    def frequent_renter_points(days_rented)
      days_rented > 1 ? 2 : 1
    end
  end

  class ChildrenPrice < Price
    def code
      Movie::CHILDREN
    end

    def charge(days_rented)
      result = 1.5
      result += (days_rented - 3) * 1.5 if days_rented > 3
      result
    end
  end
end
