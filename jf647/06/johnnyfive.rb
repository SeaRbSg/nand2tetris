#!/usr/bin/env ruby

require 'bundler'
Bundler.setup

require 'pathname'

$: << '.'

require 'j5_assembler'

infname = Pathname.new ARGV[0]
outfname = infname.parent + "#{infname.basename(infname.extname)}.hack"

puts JohnnyFive.new.assemble(infname, outfname)
