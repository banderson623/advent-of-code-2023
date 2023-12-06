file_name = "input.txt"

class LookUpMap
  attr_reader :name, :from, :to

  def initialize(name, data)
    @name = name
    @data = data.map do |line|
      destination, source, count = line.split(" ").map(&:to_i)
      offset = destination - source
      {
        source_range: Range.new(source, source + count),
        offset: offset,
        # destination_range: Range.new(destination, destination + count)
      }
    end
  end

  def map(source)
    @data.each do |mapped|
      if(mapped[:source_range].include?(source))
        return source + mapped[:offset]
      end
    end

    # Any source numbers that aren't mapped correspond to the same destination number.
    return source
  end

  def reverse_map(destination)
    @data.each do |mapped|
      smallest = mapped[:source_range].min + mapped[:offset]
      largest = mapped[:source_range].max + mapped[:offset]
      if(destination >= smallest && destination <= largest)
      # if(mapped[:destination_range].include?(destination))
        # puts "M #{@name.ljust(30)} #{destination.to_s.rjust(10)} ~(#{mapped[:offset].to_s.ljust(8)})~> #{destination - mapped[:offset]}"
        return destination - mapped[:offset]
      end
    end
    # puts "F #{@name.ljust(30)} #{destination.to_s.rjust(10)} ------------> #{destination}"
    return destination
  end
end


seed_ranges = []

seed_line = File.foreach(file_name).first
_, seed_string = seed_line.match(/^seeds:\s(.*)/).to_a

seed_string.scan(/(([0-9]+) ([0-9]+))+/) do |match|
  start, length = match.to_a.drop(1).map(&:to_i)
  # puts "seed #{start}-#{start + length - 1} length: #{length}"
  seed_ranges.push(Range.new(start, start + length - 1))
end

maps = []

current_map = nil
current_numbers = []

File.foreach(file_name) do |line|

  # discover map name
  if current_map.nil? && line.match(/map:$/)
    _, current_map = line.match(/([a-z\-]+) map:/).to_a
    next
  end

  # has content
  if !current_map.nil?
    if line.chomp != ""
      current_numbers.push(line.chomp)
    else
      # all done
      maps <<  LookUpMap.new(current_map, current_numbers)
      current_map = nil
      current_numbers = []
    end
  end
end
maps <<  LookUpMap.new(current_map, current_numbers)

# reverse strategy
def reverse_strategy(seed_ranges, maps)
  puts 'reverse strategy'
  (0..).each do |location|
    # puts "---"
    input = location
    maps.reverse.each do |map|
      input = map.reverse_map(input)
    end

    print "\r trying: #{location.to_s.rjust(10)} seed: #{input}...."

    seed_ranges.each do |seed_range|
      if seed_range.include?(input)
        puts ""
        puts "found lowest location: #{location} (in #{seed_range}, seed #{input})"
        exit
      end
    end
  end
end

def forward_strategy(seed_ranges, maps)
  puts 'forward strategy'
  smallest_location = 102634633

  seed_ranges.each do |seed_range|
    remaining = seed_range.size

    seed_range.each do |seed|
      print("\r #{remaining.to_s.rjust(10)} smallest: #{smallest_location}   ...")

      maps.each do |map|
        seed = map.map(seed)
      end

      if seed < smallest_location
        smallest_location = seed
      end
      remaining -= 1
    end
  end
  puts "\nfound location #{smallest_location}"
end

# forward_strategy(seed_ranges, maps)
reverse_strategy(seed_ranges, maps)

# Wrong solution :/
# 12634633
# found lowest location: 12634633 (in 682397438..712763394, seed 692213655)
