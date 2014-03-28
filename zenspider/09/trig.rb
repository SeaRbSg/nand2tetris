#!/usr/bin/ruby -w

divs = (ARGV.shift || 16).to_i
unit = (ARGV.shift || 4).to_i

xys = (0...360).step(360.0/divs).map { |n|
  a = 2 * Math::PI * (n / 360.0)
  s = (Math.sin(a) * unit).to_i
  c = (Math.cos(a) * unit).to_i
  [c, s]
}

extra = divs / 4

puts "  static Array xs, ys;"
puts
puts "  function void init() {"
puts "    let segments = #{divs};"
puts "    let xs = Array.new(#{divs+extra});"
puts
xys.each_with_index do |(x, y), i|
  puts "    let xs[%2d] = %3d; // ys[%2d] = %3d;" % [i, x, i, -y]
end

(0...extra).each do |i|
  puts "    let xs[%2d] = xs[%3d];" % [divs+i, i]
end

puts
puts "    let ys = xs + #{extra};"
puts
puts "    return;"
puts "  }"
