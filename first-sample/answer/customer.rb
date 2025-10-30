# NOTE: before版のstatementは文字列連結と合計計算が混在しており、Rentalの綴り誤りメソッドを直接呼び出すなど責務が肥大化していました。合計計算を明示的に分離し、整形ロジックを小さなメソッドへ抽出して読みやすさと拡張性を高めています。
require_relative 'movie'
require_relative 'rental'

class Customer
  attr_reader :name

  def initialize(name)
    @name = name
    @rentals = []
  end

  def add_rental(rental)
    rentals << rental
  end

  def statement
    lines = rentals.map { |rental| rental_line(rental) }
    ([header_line] + lines + footer_lines).join("\n")
  end

  private

  attr_reader :rentals

  def header_line
    "Rental Record for #{name}"
  end

  def rental_line(rental)
    "\t#{rental.movie.title}\t#{format_amount(rental.charge)}"
  end

  def footer_lines
    [
      "Amount owed is #{format_amount(total_charge)}",
      "You earned #{total_frequent_renter_points} frequent renter points"
    ]
  end

  def total_charge
    rentals.sum(&:charge)
  end

  def total_frequent_renter_points
    rentals.sum(&:frequent_renter_points)
  end

  def format_amount(amount)
    amount.is_a?(Integer) ? amount.to_s : format('%.1f', amount)
  end
end
