class LookUpMap
  attr_reader :name, :from, :to

  def initialize(name, data)
    @name = name
    @from = @name.split('-to-').first
    @to = @name.split('-to-').last

    @data = data.map do |line|
      destination, source, count = line.split(" ").map(&:to_i)
      offset = destination - source
      [Range.new(source, source + count), offset]
    end
  end

  def map(source)
    @data.each do |mapped|
      if(mapped.first.include?(source))
        puts "#{@from} -> #{@to} (#{source} -> #{source + mapped.last})"
        return source + mapped.last
      end
    end

    # puts "#{@from} -> #{@to} (#{source} -> #{source})"
    # Any source numbers that aren't mapped correspond to the same destination number.
    return source
  end
end

seeds = []

seed_line = File.foreach('input.txt').first
_, seeds = seed_line.match(/^seeds:\s(.*)/).to_a
seeds = seeds.split(' ').map(&:strip).map(&:to_i)

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

locations = seeds.map do |seed|
  value = seed
  # take advantage of their order in the input
  maps.each do |map|
    value = map.map(value)
  end

  value
end

puts "Smallest location: #{locations.sort.first}"