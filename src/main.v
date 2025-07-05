/* SPDX-License-Identifier: GPL-3.0 */
/**
 * main.v
 * 
 * PURPOSE
 *  Program entry points and backend manager
 * 
 * COPYRIGHT
 *  (C) 2025 Syahriel "EmiyaSyahriel" Ibnu Irfansyah
 */

module main
import os

struct InputInfo
{
pub mut:
	variable_name string
	file_path string
}

struct States {
pub mut:
	out_path string
	language string
	cflags string
	inputs []InputInfo
}

fn main() {
	mut info := States {}
	
	args := arguments()
	mut i := 1
	for i < args.len 
	{
		current := args[i]
		if (current == "-o" || current == "--output") && i + 1 < args.len {
			info.out_path = args[i + 1]
			i++
		}
		else if (current == "-l" || current == "--language") && i + 1 < args.len {
			info.language = args[i + 1]
			i++
		}
		else {
			if current.contains("=")
			{
				// 2 parts
				parts := current.split("=")
				if parts.len <= 2
				{
					nif := InputInfo{ 
						variable_name: parts[0] 
						file_path: parts[1]
						}

					if !os.exists(nif.file_path) {
						panic("File \"${nif.file_path}\" not found")
					}

					info.inputs << nif
				}
			}
			else
			{
				filename := os.base(current)
				varname := filename_to_varname(filename)

				if !os.exists(filename) {
					error("File \"${filename}\" not found")
				}

				nif := InputInfo{ 
					variable_name: varname
					file_path: filename
					}

				info.inputs << nif
			}
		}

		i++
	}

	info.cflags = os.getenv_opt("OFLAGS") or { "" }

	match info.language.to_lower() {
		"cpp" {
			mut cpp := MakerCPP {}
			cpp.process(info)
		}
		"c" {
			mut c := MakerC {}
			c.process(info)
		}
		else {
			error("Unknown language : ${info.language}")
			exit(1)
		}
	}
}
