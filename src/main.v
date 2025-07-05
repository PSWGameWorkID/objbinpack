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
		if current == "-h" || current == "--help" {
			eprintln('Usage: objbinpack [OPTIONS] [VARNAME=]FILE...
Puts multiple text/binary files into a linkable C/C++ object file.

Options: 
  -h, --help                    Display this help
  -o FILE, --output FILE        Where to place the output file
  -l LANG, --language LANG      Which language to use as intermediate language and resulting linkable object
  [VARNAME=]FILE                Input file path, can be specified multiple times.
                                Variable name is optional, if not specified, will use transformed file name.

Environment Variables:
  CC=C_COMPILER                 Custom C compiler, by default uses gcc
  CXX=CPP_COMPILER              Custom C++ compiler, by default uses g++
  OFLAGS=FLAGS                  Additional compilation flags

Supported Languages:
  c                             C language, uses "VARNAME_data" and "VARNAME_length" syntax
  cpp                           C++ language, uses VARNAME::data and "VARNAME::length" syntax
')
			exit(0)
		}
		else if (current == "-o" || current == "--output") && i + 1 < args.len {
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

	if info.inputs.len <= 0 {
		eprint("objbinpack: fatal error: no input files")
		exit(1)
	}

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
