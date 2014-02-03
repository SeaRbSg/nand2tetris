task :default => :test

user = ENV["GH"]
user ||= "zenspider" if ENV["USER"] == "ryan"
user = "nanoxd" if ENV["USER"] == "nano"
user = "thagomizer" if ENV["USER"] == "aja"

if user then
  %w(01 02 03/a 03/b).reverse.each do |n|
    desc "Test chapter #{n}."
    task "ch#{n}" do
      Dir["#{user}/#{n}/*.tst"].each do |f|
        f = File.expand_path f
        sh "./tools/HardwareSimulator.sh #{f}"
      end
    end

    desc "Run all the tests"
    task :test => "ch#{n}"
  end
else
  warn "Run or define GH=<your-github-username> for automated testing."
end

def run cmd
  f = File.expand_path ENV["F"] if ENV["F"]
  sh "./tools/#{cmd}.sh #{f}"
end

desc "Run the hardware simulator; Opt: use F=<username/.../f.tst> to run a test"
task :hdl do
  run "HardwareSimulator"
end

desc "Run the assembler; Opt: use F=<username/.../blah.asm>"
task :asm do
  run "Assembler"
end

desc "Run the CPU emulator; Opt: use F=<username/.../f.tst> to run a test."
task :cpu do
  run "CPUEmulator"
end
