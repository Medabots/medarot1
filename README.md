[![CircleCI](https://circleci.com/gh/Medabots/medarot1/tree/tr_EN.svg?style=svg)](https://app.circleci.com/pipelines/github/Medabots/medarot1?branch=tr_EN)

# Obtaining/Applying the Patch

**NOTE:** The versions marked '-portraits' are in development and not release ready yet, play the non-portrait builds for the most stable experience.

1. Obtain the original ROM for the Medarot 1 version you want (the md5 hashes are below)
1. Head to the [Latest release](https://github.com/Medabots/medarot1/releases/latest) page and grab the .ips file for your preferred version
1. Use an IPS Patching Tool like [LunarIPS](https://www.romhacking.net/utilities/240/), or online patcher like [this](https://vxyz.me/rompatcher/) to apply the IPS patch to your ROM

The '+txt.N' versions indicates the version of the translation.

# Reporting Bugs

Feel free to create an issue here with a save and/or screenshots of your issue.

If that's not possible, steps to reproduce it will suffice.

# Building

If all you care about is playing the patch, then refer to the instructions at the top of this README. Otherwise, continue below for build instructions.

## Dependencies

* Medarot 1 KABUTO ROM v1.1 (md5: 78c568cbfff6314b1416880d9efaeca6) and/or Medarot 1 KUWAGATA ROM v1.1 (md5: a9c9d6b6759c28f2b3986717f4df2f98)
	* Currently relies on the rgbds overlay feature as parts are disassembled and tacked on
* Make 4.0+
* Python 3.6 or greater, aliased to 'python3'
* [rgbds v0.4.1+](https://github.com/rednex/rgbds)

## Make

1. Rename the Medarot 1 KABUTO v1.1 ROM and/or Medarot 1 KUWAGATA v1.1 ROM to 'baserom_kabuto.gb' or 'baserom_kuwagata.gb' respectively and drop it in the project root
1. Execute make (optionally pass -j), pass a specific version (kabuto or kuwagata) or 'all'
	* The default for no arguments is 'kabuto'
1. 'medarot_kabuto.gb' or 'medarot_kuwagata.gb' should be generated in your project root, depending on the version

# Other References

[Medapedia page](http://medarot.meowcorp.us/wiki/Medapedia:Medarot_1_Translation_Project) (source reference for a lot of text and information)

[Translation Spreadsheet](https://github.com/Medabots/medarot1_translation)

# Contributing

The patch is totally playable from start to finish, but if you'd like to submit any fixes we missed or submit a text correction, feel free to submit a Pull Request or join the [Medabots Discord](https://discord.gg/4hHxKSX).

If you'd like to locally edit test your changes, you can directly edit files under the text/ folder and rebuild. If you prefer to use the spreadsheet for editing, setup a virtualenv and restore the packages with pip and use the xlsx2csv and xlsx2list scripts (usage is in the file comments).

# Contributors

(The [Contributors](https://github.com/VariantXYZ/medarot1/graphs/contributors) page only covers GitHub contributions)

* [VariantXYZ](https://github.com/VariantXYZ) (Repo maintainer, Disassembly, Developer)
* [andwhyisit](https://github.com/andwhyisit) (Disassembly, Developer)
* [Kimbles](https://medarot.meowcorp.us/wiki/User:Kimbles) (Translations, Editing, Initial research)
* Tobias (Translations)
* [Sanqui](https://github.com/Sanqui) (Initial research and disassembly, the overlay feature in rgbds, a number of other things)
* [Hideto](https://digicorearg.blogspot.com/) (Portrait mapping, Spanish translation on tr_ES branch)

And of course, various members of the community for playtesting and submitting bug reports. 
