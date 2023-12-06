file_name = "input.txt"

class LookUpMap
  attr_reader :name

  def initialize(name, transforms)
    @name = name
    @transforms = transforms.map do |line|
      destination, source, size = line.split(" ").map(&:to_i)
      offset = destination - source
      [
        Range.new(source, source + size),
        size,
        offset,
      ]
    end
    @transforms.sort!{|a,b| a.first.min <=> b.first.min}
    # pp self
    self.fill_holes

    # pp self
  end

  def fill_holes
    last_seen = 0
    transforms_to_add = []

    @transforms.each do |mapping|
      if mapping.first.min > last_seen
        puts "#{@name} has a hole at #{last_seen} to #{mapping.first.min}"
        transforms_to_add.push([
          Range.new(last_seen, mapping.first.min),
          mapping.first.min - last_seen,
          0
        ])
      end
      last_seen = mapping.first.max
    end

    puts "#{@name} has no gaps" if transforms_to_add.empty?

    @transforms = @transforms.concat(transforms_to_add).sort{|a,b| a.first.min <=> b.first.min}

  end

  def map_ranges(source_ranges)
    outgoing_ranges = []

    source_ranges.each do |source_range|
      puts "mapping #{source_range} in #{@transforms}"

      range_mapped = false
      @transforms.each do |mapping|
        range = mapping.first
        offset = mapping.last

        if range.cover?(source_range)
          new_range = Range.new(source_range.min + offset, source_range.max + offset)
          puts "Transformed: #{source_range} with offset #{offset} to #{new_range}"
          outgoing_ranges.push(new_range)
          range_mapped = true
        end
      end

      # pass through above
      if source_range.min > @transforms.last.first.max
        range_mapped = true
        outgoing_ranges.push(source_range)
      end

      if !range_mapped
        puts "SPLITTING - range didn't fit #{source_range} in #{@transforms}"

        non_fitting_ranges = [source_range]

        until non_fitting_ranges.empty?
          range_to_split = non_fitting_ranges.pop
          @transforms.each do |d|
            range = d.first
            offset = d.last

            if range.cover?(range_to_split)
              new_range = Range.new(range_to_split.min + offset, range_to_split.max + offset)
              puts "SPLITTING looking for home for #{range_to_split} and covered by #{range} (w/offset #{offset}) transformed to #{new_range}"
              outgoing_ranges.push(new_range)

            elsif range.min < range_to_split.min && range.max > range_to_split.min
              new_range = Range.new(range_to_split.min + offset, range.max + offset)
              puts "SPLITTING #{range_to_split} at #{range.max} (offset #{offset}) and transformed to #{new_range}"
              outgoing_ranges.push(new_range)

              whats_left_of_that_range = Range.new(range.max, range_to_split.max)
              puts "SPLITTING - Remaining #{whats_left_of_that_range}"
              non_fitting_ranges.push(whats_left_of_that_range)
            end
          end
        end


      end
    end

    outgoing_ranges.sort!{|a,b| a.min <=> b.min}

    puts "incoming: #{source_ranges}"
    puts "outgoing: #{outgoing_ranges}"

    return outgoing_ranges

  end

  def map(source)
    @transforms.each do |mapped|
      if(mapped.first.include?(source))
        return source + mapped.last
      end
    end

    # Any source numbers that aren't mapped correspond to the same destination number.
    return source
  end
end


seed_ranges = []

seed_line = File.foreach(file_name).first
_, seed_string = seed_line.match(/^seeds:\s(.*)/).to_a

seed_string.scan(/(([0-9]+) ([0-9]+))+/) do |match|
  start, length = match.to_a.drop(1).map(&:to_i)
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


maps.each do |map|
  puts "---#{map.name}----"
  outgoing = map.map_ranges(seed_ranges)
  puts "Map: #{map.name}, buckets going in #{seed_ranges.size}, buckets coming out #{outgoing.size}"
  seed_ranges = outgoing
end

puts "\nfound location #{seed_ranges.first.min}"


