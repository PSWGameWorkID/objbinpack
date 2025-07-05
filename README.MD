# objbinpack
Simple objcopy-style binary packing tool with multiple source file support. So far only supports gcc and clang.

This program is written in V.

## Usage
```
objbinpack -o (OUTPUT) -l (LANGUAGE) [varname=]path/to/file.ext [[varname2]=path/to/file_2.ext ...]

objbinpack -o main.o -l cpp file.vert frag_file=file.frag
```

### Flags
- `-o path/to/output.o` = Output File
- `-l language` = Intermediate language before compilation
- `[varname=]path/to/file.ext` = Path to the file, with optional variable 
name ( default to the file name if not specified )

### Supported languages
- `c` = C, your standard C linkage ( default )
```
extern uint8_t* mydata_data;
extern size_t mydata_length;
```
- `cpp` = C++, namespace-style
```
namespace mydata
{
    extern uint8_t* data;
    extern size_t length;
}
```

### Environment Variables
- `CXX` - C++ compiler to be used if `cpp` is used, defaults to `g++` 
- `CC` - C++ compiler to be used if `cpp` is used, defaults to `gcc`
- `OFLAGS` - Compiler flags

## Building
### Prerequisites
- V toolchain ( tested on 0.4.10 2bd2d00 )
- GNU Make
- Git

### Steps
- Clone the repository
```
git clone https://github.com/PSWGameWorkID/objbinpack 
```
- Enter the repository directory
```
cd objbinpack 
```
- Compile
```
make
```
- Install ( optional )
```
sudo make install
```

## Additional files
- `tools/printstdio.cpp`
A testing tool to dump stdin file to `stdio.in` file. You can plug the 
executable as `CXX` or `CC` and it will dump the generated source code.

## License
GNU General Public License v3 ( GPLv3 ), see [LICENSE](LICENSE)
