/* SPDX-License-Identifier: GPL-3.0 */
/**
 * strutil.v
 * 
 * PURPOSE
 *  String handling utilities
 * 
 * COPYRIGHT
 *  (C) 2025 Syahriel "EmiyaSyahriel" Ibnu Irfansyah
 */

module main

const valid_var_chars = "abcdefghijklmnopqrstuvwxyz_"

fn filename_to_varname(filename string) string
{
	mut str_buf := []rune{}

	for ch in filename.to_lower().runes() {
		mut found := false
		for i in valid_var_chars.runes() {
			if i == ch { // Rune valid, add
				str_buf << ch;
				found = true
				break
			}
		}

		// Added, continue to next char
		if found { continue }

		// Add `_` to it's place
		str_buf << `_`

		// it's a dot? add another `_`
		if ch == `.` {
			str_buf << `_`
		}
	}
	
	
	return str_buf.string()
}

fn parse_oflags(source string) []string {
	mut args := []string{}
	mut current := ""
	mut is_in_quote := false
	mut escape := false
	for ch in source {
		if escape {
			current += ch.str()
			escape = false
			continue
		}
		match ch {
			`\\` {
				escape = true
			}
			`"` {
				is_in_quote = !is_in_quote
			}
			` ` {
				if is_in_quote {
					current += " "
				}else{
					if current.len > 0 {
						args << current
						current = ""
					}
				}
			}
			else{
				current += ch.str()
			}
		}
	}
	if current.len > 0
	{
		args << current
	}
	return args
}