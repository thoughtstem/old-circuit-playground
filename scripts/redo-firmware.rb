#!/usr/bin/ruby

while !File.exists?("/Volumes/CIRCUITPY") do
  puts `pwd`
  puts "Is the device in the normal state?"
  gets 
end

`mv /Volumes/CIRCUITPY/tslib.py ./tools/circuitpython/atmel-samd/modules/`
Dir.chdir "./tools/circuitpython/atmel-samd/"
`rm -r build-*`

while !File.exists?("/Volumes/CPLAYBOOT") do
  puts `pwd`
  puts "Is the device ready to flash?"
  gets 
end

system "make BOARD=circuitplayground_express FROZEN_MPY_DIR=modules/"
`cp build-circuitplayground_express/firmware.uf2 /Volumes/CPLAYBOOT`
`cp build-circuitplayground_express/firmware.uf2 ../../`
