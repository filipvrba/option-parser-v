module op

struct Flag {
mut:
	short 		string
	long 		string
	description string
	block 		fn(string)
}

fn (mut f Flag) is_value() bool {
	return f.short.index_any(' ') != -1 || f.long.index_any(' ') != -1
}

fn (mut f Flag) is_valid(arg Arg) bool {
	if f.is_value() {
		short_sub := if f.short != "" { f.short.substr(0, f.short.index_any(" ")) } else { f.short }
		long_sub := if f.long != "" { f.long.substr(0, f.long.index_any(" ")) } else { f.long }

		return short_sub == arg.origin[arg.position] || long_sub == arg.origin[arg.position]
	}
	else {
		return f.short == arg.origin[arg.position] || f.long == arg.origin[arg.position]
	}
}

fn (mut f Flag) call(arg Arg) ! {
	if f.is_value() {
		id_up := arg.position + 1
		if id_up < arg.origin.len {
			f.block(arg.origin[id_up])
		}
		else {
			return error("For this '${arg.origin[arg.position]}' argument, kindly provide a value.")
		}
	}
	else {
		f.block('')
	}
}