module option_parser

import os

pub fn (o OptionParser) init() {
	cmdargs := unsafe { os.args }
	
	for i := 0; i < cmdargs.len; i++ {
		cmdarg := Cmdarg{
			origin: cmdargs
			arg: cmdargs[i]
			position: i
		}

		for arg in o.on {
			if is_flag_valid(arg, cmdarg.arg) {				
				o.block_call(arg, cmdarg) or {
					println(err)
					exit(1)
				}
			}
		}
	}
}

pub fn (o OptionParser) to_s() string {
	mut result := "$o.banner\n"
	for arg in o.on {
		flag_l := if arg.long_flag == "" { "" } else { ", $arg.long_flag" }
		flags_str := " ".repeat(align_left) + "$arg.short_flag$flag_l"
		desc := arg.description.replace("\n", "\n" + " ".repeat(align_middle))
		arg_row := "$flags_str${' '.repeat(align_middle - flags_str.len)}$desc\n"
		result += arg_row
	}
	return result
}

fn (o OptionParser) block_call(arg Argument, cmdarg Cmdarg) ? {
	if is_value(arg) {
		id_up := cmdarg.position + 1
		if id_up < cmdarg.origin.len {
			arg.block(cmdarg.origin[id_up])
		}
		else {
			return error("For this '$cmdarg.arg' argument, kindly provide a value.")
		}
	}
	else {
		if is_helper(arg) {
			arg.block(o.to_s())
		}
		else {
			arg.block('')
		}
	}
}

fn is_helper(arg Argument) bool {
	return arg.short_flag == helper_short || arg.long_flag == helper_long
}

fn is_value(arg Argument) bool {
	return arg.short_flag.index_any(' ') != -1 || arg.long_flag.index_any(' ') != -1
}

fn is_flag_valid(arg Argument, cmdarg string) bool {
	if is_value(arg) {
		short_flag_sub := arg.short_flag.substr(0, arg.short_flag.index_any(" "))
		long_flag_sub := arg.long_flag.substr(0, arg.long_flag.index_any(" "))

		return short_flag_sub == cmdarg || long_flag_sub == cmdarg
	}
	else {
		return arg.short_flag == cmdarg || arg.long_flag == cmdarg
	}
}
