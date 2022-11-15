module option_parser

pub struct Argument {
	short_flag  string
	long_flag   string
	description string
	block 		Callback
}

pub struct OptionParser {
	banner string
	on []Argument
}

struct Cmdarg {
	origin []string
	arg 	 string
	position int
}