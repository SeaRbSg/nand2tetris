#!/usr/bin/env ruby

require 'bundler'
Bundler.setup

require 'pathname'

$: << '.'

require 'jack_compiler'

infname = Pathname.new ARGV[0]
infnames = nil
if infname.file?
    infnames = [ Pathname.new(infname) ]
else
    infnames = Pathname.glob "#{infname}/*.jack"
end

infnames.each do |infname|
    ns = infname.basename(infname.extname)
    outfname = infname.parent + "#{infname.basename(infname.extname)}.vm"
    ast = Jack::Compiler.new.compile(infname, ns) do |ast|
        File.open(outfname, 'w') do |f|
            ast.render do |vm|
                f.puts vm
            end
        end
    end
end
