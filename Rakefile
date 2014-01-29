task :default => :test

user = ENV["GH"]
user = "zenspider" if ENV["USER"] == "ryan"

if user then
  %w(01 02 03/a 03/b).reverse.each do |n|
    desc "Test chapter #{n}"
    task "ch#{n}" do
      Dir["#{user}/#{n}/*.tst"].each do |f|
        f = File.expand_path f
        sh "./tools/HardwareSimulator.sh #{f}"
      end
    end

    task :test => "ch#{n}"
  end
else
  warn "Run or define GH=<your-github-username> for automated testing."
end

task :run do
  f = File.expand_path ENV["F"] if ENV["F"]
  sh "./tools/HardwareSimulator.sh #{f}"
end
