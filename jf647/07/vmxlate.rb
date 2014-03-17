#!/usr/bin/env ruby

require 'bundler'
Bundler.setup

require 'pathname'

$: << '.'

require 'vm_translator'

infname = Pathname.new ARGV[0]
ns = infname.basename(infname.extname)
outfname = infname.parent + "#{ns}.asm"

File.open(outfname, 'w') do |f|
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
