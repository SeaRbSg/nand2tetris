#!/usr/bin/env ruby

require 'bundler'
Bundler.setup

require 'pathname'

$: << '.'

require 'jack_compiler'

infname = Pathname.new ARGV[0]
outfname = nil
if infname.file?
    outfname = infname.parent + "#{infname.basename(infname.extname)}.mine.xml"
else
    raise 'input must be a filename'
end

File.open(outfname, 'w') do |f|
    ast = Jack::Compiler.new.compile(infname) do |ast|
        f.puts ast.render
    end
end
