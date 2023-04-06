# option-parser-v

*Here is an example of use:*
```v
import src.op

fn main() {
	mut option_parser := op.OptionParser{}
	mut ref_op := &option_parser

	option_parser.banner('This is test app')
	option_parser.on("-h", "--help", "Show help", fn [mut ref_op] (_ string) {
		print(ref_op.help_str())
		exit(0)
	})
	
	option_parser.init()
}
```