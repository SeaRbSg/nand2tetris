#!/usr/bin/env ruby

require 'bundler'
Bundler.setup

require 'pathname'

$: << '.'

require 'vm_translator'

infname = Pathname.new ARGV[0]
outfname = infname.parent + "#{infname.basename(infname.extname)}.asm"

File.open(outfname, 'w') do |f|
    ast = VM::Translator.new.translate(infname) do |op|
        if ENV.key?('DEBUG')
            puts op.inspect
        end
        if op.respond_to?(:to_asm)
            f.puts op.to_asm
        end
    end
end
