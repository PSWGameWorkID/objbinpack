/* SPDX-License-Identifier: GPL-3.0 */
/**
 * printstdio.cpp
 * 
 * PURPOSE
 *  Dumps stdin to stdio.in file
 * 
 * COPYRIGHT
 *  (C) 2025 Syahriel "EmiyaSyahriel" Ibnu Irfansyah
 */

#include <iostream>

int main()
{
    const int BUFFER_LEN = 128;
    char *data = new char[BUFFER_LEN];
    
    FILE* out = fopen("stdio.in", "wb");
    ssize_t len = BUFFER_LEN;
    while(!feof(stdin) && !ferror(stdin))
    {
        len = fread(data, 1, BUFFER_LEN, stdin);
        if(len > 0)
        {
            fwrite(data, 1, len, out);
        }
    }

    delete []data;
    return 0;
}