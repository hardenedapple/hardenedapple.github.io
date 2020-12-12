#!/usr/bin/env python3

import sys
import string
from analysis import *
import os.path
import argparse

def make_row_mapping(start_index):
    return [(char, ((i)*2)+start_index)
            for i, char in
            enumerate(string.ascii_lowercase + string.digits)]

def make_letter_mapping():
    return (make_row_mapping(2)
            + make_row_mapping (74)
            + make_row_mapping (146))

def create_indexes_from_password(password):
    indexes = []
    orig_mapping = iter(make_letter_mapping())
    for char in password:
        indexes.append(next(x[1] for x in orig_mapping if x[0] == char))
    return indexes

def create_palette_from_indexes(indexes):
  palette = [(255, 255, 255) if i not in indexes else (0, 0, 0)
             for i in range(256)]
  return palette

def plte_from_password(password):
  indexes = create_indexes_from_password(password)
  palette = create_palette_from_indexes(indexes)
  return create_chunk('PLTE', bytes(itt.chain.from_iterable(palette)))

def encode(password, base_file, output_filename):
    try:
        plte_chunk = plte_from_password(password)
    except StopIteration:
        print('Password is not valid for this method.')
        sys.exit(1)

    with open(base_file, 'rb') as infile:
        chunks = parse_png(infile.read())
    assert(chunks[1].name == 'PLTE')
    chunks[1] = plte_chunk
    with open(output_filename, 'wb') as outfile:
        outfile.write(output_png(chunks))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='''
        Encode a password using an existing base image.
        Base image must be in the standard form of abcde...89 in three
        lines.''')
    parser.add_argument('password', help='password to encode')
    parser.add_argument('base_file',
        help='Base image file to generate challenge from.')
    parser.add_argument('output_filename',
            help='Output filename to save the challenge under.')
    args = parser.parse_args()
    assert(not os.path.exists(args.output_filename))
    encode(args.password, args.base_file, args.output_filename)
