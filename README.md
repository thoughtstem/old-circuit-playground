# circuit-racket

See the racket docs:

https://pkgd.racket-lang.org/pkgn/package/circuit-playground

If you make big changes to the api, you'll need to rebuild the firmware.  Not a pretty process, but I'll document anyway for my own benefit:

* Make sure the compiler outputs tslib.py to the CPX (edit circuit-playground.rkt)
* Make sure the arm gcc is on your path
* Run ./scripts/redo-firmware.rb
* Put the CPX into bootloader mode, put ./tools/firmware.uf2 onto the CPX

* If all is good, commit the new firmware to github

