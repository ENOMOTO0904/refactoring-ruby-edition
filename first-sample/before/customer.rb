require_relative 'movie'
require_relative 'rental'

class Customer
  attr_reader :name

  def initialize(name)
    @name = name
    @rentals = []
  end

  def add_rental(arg)
    @rentals << arg
  end

  def statement
    header + body + footer
  end

  private

  attr_reader :rentals

  def header
    "Rental Record for #{@name}\n"
  end

  def body
    result = ""
    rentals.each do |rental|
      result += "\t" + rental.movie.title + "\t" + rental.caluculate_rental_price.to_s + "\n"
    end
    result
  end

  def footer
    "Amount owed is #{total_price}\n" +
    "You earned #{total_frequent_renter_points} frequent renter points"
  end

  def total_price
    rentals.sum(&:caluculate_rental_price)
  end

  def total_frequent_renter_points
    rentals.sum(&:add_rental_point)
  end
end
