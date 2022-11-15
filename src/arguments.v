module src

import option_parser

fn block_help(helper string) {
	print(helper)
}

fn block_version(arg string) {
	println("[version] $arg")
}

pub fn main() {
	op := option_parser.OptionParser{
		banner: "This is test app.\nUsage: app [options]\n\nOptions:"
		on: [
			option_parser.Argument{
				short_flag: "-h"
				long_flag: "--help"
				description: "Shown help"
				block: block_help
			}
			option_parser.Argument{
				short_flag: "-v VER"
				long_flag: "--version VER"
				description: "Shown version"
				block: block_version
			}
		]
	}

	op.init()
}
