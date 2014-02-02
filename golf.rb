#!/usr/bin/ruby -w

class Golf
  def self.run args
    args << "01" if args.empty?
    report args.join ","
  end

  def self.report dir
    golfers = {}

    glob = "{#{dir}}/*.hdl"

    users = Dir["*"].find_all { |f| File.directory? f } - %w(projects tools)
    users.each do |user|
      golf = Golf.new user
      golf.scan glob
      golfers[user] = golf
    end
    users.reject! { |u| golfers[u].scores.any? { |_,v| v.zero? } }

    sorted_users = users.sort_by { |u| golfers[u].sum }

    fmt = "%%-10s: %s" % sorted_users.map { |u| "%#{u.size}X" }.join(" | ")

    data = ["gate\\user", *sorted_users]
    puts fmt.gsub("X", "s") % data
    data = ["total"] + sorted_users.map { |user| golfers[user].sum }
    puts fmt.gsub("X", "d") % data
    puts

    best = golfers[sorted_users.first]
    gates = best.path.keys.sort_by { |g| best.gate[g] }
    gates.each do |gate|
      data = [gate] + sorted_users.map { |user| golfers[user].gate[gate] }
      puts fmt.gsub("X", "d") % data
    end
  end

  attr_accessor :gate
  attr_accessor :name
  attr_accessor :path
  attr_accessor :scores
  attr_accessor :sum

  def initialize name = ""
    self.name = name
    self.path = {}
    self.gate = {}
    self.scores = {}
    self.sum = 0
  end

  def scan glob
    Dir["#{self.name}/#{glob}"].each do |path|
      gate = File.basename path, ".hdl"

      self.path[gate] = path
    end

    self.path.keys.each do |gate|
      score = process(gate)
      self.scores[gate] = score
      self.sum += score
    end
  end

  def process gate
    return self.gate[gate] if self.gate[gate]

    score = 0

    path = self.path[gate] || "#{self.name}/01/#{gate}.hdl"

    file = File.read path
    file.gsub!(/(\/\/|\*).*/, "")

    file.scan(/(\w+)\s*\(/).flatten.each do |sub|
      case sub
      when "Nand" then
        score += 1
      when "DFF" then
        score += 1
      else
        score += process(sub)
      end
    end

    self.gate[gate] = score
  end
end

Golf.run ARGV if $0 == __FILE__
