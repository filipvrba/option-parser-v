module op

import os

pub struct Indentation {
pub mut:
	left   int = 4
	middle int = 34
}

pub struct OptionParser {
pub mut:
	indentation Indentation
mut:
	args   []string
	banner string
	flags  []Flag
}

struct Arg {
	origin 	 []string
	position int
}

pub fn (mut o OptionParser) banner(description string) {
	o.banner = description
}

pub fn (mut o OptionParser) on(short_flag string, long_flag string,
						   	   description string, block fn(string)) {
	o.flags << Flag{
		short_flag, long_flag, description, block
	}
}

pub fn (mut o OptionParser) init() {
	o.args = unsafe { os.args }
	
	for i := 0; i < o.args.len; i++ {
		arg := Arg { o.args, i }

		for flag in o.flags {
			unsafe {
				if flag.is_valid(arg) {
					flag.call(arg) or {
						println(err)
						exit(1)
					}
				}
			}
		}
	}
}

pub fn (mut o OptionParser) help_str() string {
	mut result := "$o.banner\n"
	for flag in o.flags {
		flag_l := if flag.long == "" { "" } else { ", $flag.long" }
		flags_str := " ".repeat(o.indentation.left) + "$flag.short$flag_l"
		desc := flag.description.replace("\n", "\n" + " ".repeat(o.indentation.middle))
		
		mut tail_length := o.indentation.middle - flags_str.len
		if tail_length <= 0 {
			tail_length = 2
		}

		flag_row := "$flags_str${' '.repeat(tail_length)}$desc\n"
		result += flag_row
	}
	return result
}

pub fn (mut o OptionParser) have_arguments() bool {
	return o.args.len > 1
}
