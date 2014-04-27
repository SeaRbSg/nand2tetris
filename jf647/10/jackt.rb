#!/usr/bin/env ruby

require 'bundler'
Bundler.setup

require 'pathname'

$: << '.'

require 'jack_tokenizer'

infname = Pathname.new ARGV[0]
outfname = nil
if infname.file?
    outfname = infname.parent + "#{infname.basename(infname.extname)}T.xml.mine"
else
    raise 'input must be a filename'
end

tok = Jack::Tokenizer.new
File.open(outfname, 'w') do |f|
    f.puts "<tokens>"
    tok.tokenize(infname) do |t|
        f.puts "  #{tok.to_xml(t)}"
    end
    f.puts "</tokens>"
end
