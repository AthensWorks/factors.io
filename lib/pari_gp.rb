module PARI
  class GP
    GP_BIN = "/usr/local/bin/gp"

    def self.factors(number)
      factors = {}
      output = call_function("factor(#{number.to_i})")
      output.scan(/(\d+) (\d+)/) do |factor, exponent|
        factors[factor.to_i] = exponent.to_i
      end
      factors
    end

    def self.divisors(number)
      divisors = []
      output = call_function("divisors(#{number.to_i})")
      output.scan(/\d+/) do |divisor|
        divisors << divisor.to_i
      end
      divisors
    end

    private

    def self.call_function(cmd)
      command = "echo \"#{cmd}\" | #{GP_BIN} -q"
      IO.popen(command).read
    end
  end
end

# number = 4800000000009238742938742938742938757681923423453221345675432145
# puts "Factors for #{number}"
# PARI::GP.factors(number).each_pair do |factor, exponent|
#   puts "factor=#{factor} exponent=#{exponent}"
# end
#
# PARI::GP.divisors(number).each do |divisor|
#   puts divisor
# end
