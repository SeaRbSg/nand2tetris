#!/usr/bin/env ruby

require 'bundler'
Bundler.setup

require 'pathname'

$: << '.'

require 'vm_translator'

infname = Pathname.new ARGV[0]
infnames = nil
outfname = nil
if infname.file?
    infnames = [ infname ]
    outfname = infname.parent + "#{infname.basename(infname.extname)}.asm"
else
    outfname = "#{infname.basename}.asm"
    infnames = Pathname.glob "#{infname}/*.vm"
end

File.open(outfname, 'w') do |f|
    infnames.each do |infname|
        ns = infname.basename(infname.extname)
        ast = VM::Translator.new.translate(infname, ns) do |op|
            if ENV.key?('DEBUG')
                puts op.inspect
            end
            if op.respond_to?(:descr)
                f.puts "// #{op.descr}"
            end
            if op.respond_to?(:to_asm)
                f.puts op.to_asm
            end
        end
    end
end
