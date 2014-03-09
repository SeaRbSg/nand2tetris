#!/usr/bin/env ruby

require 'bundler'
Bundler.setup

require 'pathname'

$: << '.'

require 'j5_assembler'

infname = Pathname.new ARGV[0]
outfname = infname.parent + "#{infname.basename(infname.extname)}.hack"

File.open(outfname, 'w') do |f|
    ast = JohnnyFive::Assembler.new.assemble(infname) do |statement|
        f.puts statement.to_bin if statement.respond_to?(:to_bin)
    end
end
