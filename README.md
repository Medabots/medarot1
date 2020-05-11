[![CircleCI](https://circleci.com/gh/VariantXYZ/medarot_1/tree/tr_EN.svg?style=svg)](https://app.circleci.com/pipelines/github/VariantXYZ/medarot_1?branch=tr_EN)

[Medapedia page](http://medarot.meowcorp.us/wiki/Medapedia:Medarot_1_Translation_Project) (source reference for a lot of text and information)

# Building

## Dependencies

* Medarot 1 KABUTO ROM v1.1 (md5: 78c568cbfff6314b1416880d9efaeca6)
	* Currently relies on the rgbds overlay feature as parts are disassembled and tacked on
* Make
* Python 3.6 or greater, aliased to 'python3'
* [rgbds](https://github.com/rednex/rgbds)

# Make

1. Name the Medarot 1 KABUTO v1.1 ROM 'baserom.gb' and drop it in the project root
1. Execute make (optionally pass -j)