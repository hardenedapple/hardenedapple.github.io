#!/usr/bin/env python3

import sys
from analysis import *
import argparse
import os.path

def solve(filename, output_filename):
    with open(filename, 'rb') as infile:
        chunks = parse_png(infile.read())
    assert(chunks[1].name == 'PLTE')
    # To move one pixel colour we move 3 bytes (RGB)
    orig_palette = chunks[1].parsed_data
    new_palette = orig_palette[-3:] + orig_palette[:-3]
    new_PLTE = create_chunk('PLTE', new_palette)
    chunks[1] = new_PLTE
    with open(output_filename, 'wb') as outfile:
        outfile.write(output_png(chunks))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='''Decode a challenge.''')
    parser.add_argument('challenge_file', help='Challenge to decode.')
    parser.add_argument('output_filename',
            help='Output filename to save the solution under.')
    args = parser.parse_args()
    assert(not os.path.exists(args.output_filename))
    solve(args.challenge_file, args.output_filename)
