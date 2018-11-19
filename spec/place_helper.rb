module PlaceHelper
  def self.faker_place
    letters = (0...3).map { (65 + rand(26)).chr }.join
    numbers = (0...4).map { rand(0..9) }.join
    result = letters + '-' + numbers
    result
  end

  def self.faker_renavan
    numbers = (0...10).map { rand(0..9) }.join
    numbers
  end

  def self.faker_chassi
    numbers = 'BR' + (0...18).map { rand(0..9) }.join
  end
end
