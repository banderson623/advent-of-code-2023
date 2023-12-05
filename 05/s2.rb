class LookUpMap
  attr_reader :name, :from, :to

  def initialize(name, data)
    @name = name
    @data = data.map do |line|
      destination, source, count = line.split(" ").map(&:to_i)
      offset = destination - source
      [Range.new(source, source + count), offset]
    end
  end

  def map(source)
    @data.each do |mapped|
      if(mapped.first.include?(source))
        # puts "#{@name} #{source} -> #{source + mapped.last}"
        return source + mapped.last
      end
    end

    # Any source numbers that aren't mapped correspond to the same destination number.
    return source
  end
end

seed_ranges = []

seed_line = File.foreach('input.txt').first
_, seed_string = seed_line.match(/^seeds:\s(.*)/).to_a

seed_string.scan(/(([0-9]+) ([0-9]+))+/) do |match|
  start, length = match.to_a.drop(1).map(&:to_i)
  # puts "#{start} length: #{length}"
  seed_ranges.push(Range.new(start, start + length - 1))
end

maps = []

current_map = nil
current_numbers = []

File.foreach("input.txt") do |line|

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

locations = []
cache = {}

seed_ranges.each do |seed_range|
  pp seed_range
  seed_range.each do |seed|
    if cache.has_key?(seed)
      print '**************'
      return cache[seed]
    end


    # take advantage of their order in the input
    value = seed
    maps.each do |map|
      value = map.map(value)
    end

    cache[seed] = value
    locations.push(value)
  end
end

puts "Smallest location: #{locations.sort.first}"