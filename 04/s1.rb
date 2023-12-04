total = 0
File.foreach("input.txt") do |card|
  _,label, winning, scratched = /(.*):(.*)\|(.*)/.match(card).to_a

  card_value = 0
  winning.split(' ').map{|v| " #{v} "}.each{ |value|
    scratched+=" "
    if scratched.include? value
      card_value = card_value == 0 ? 1 : card_value * 2
    end
  }
  puts "#{label} -> #{card_value}"
  total += card_value
end

puts "total: #{total}"