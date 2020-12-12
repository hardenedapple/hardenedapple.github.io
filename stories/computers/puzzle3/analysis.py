#!/usr/bin/env python3

from collections import namedtuple
import struct
import zlib
import copy
import itertools as itt
from pprint import pprint

# TODO Would be nice to create a parse_idat and output_idat that handles the
# zlib decompression and filter types.
#       These functions may need to know the size of the image, and the zlib
#       compression level used.
#
#       That seems too awkward for now.

# There are a lot of functions using the `data_iter = iter(data)` idiom in this
# file.  This idiom means that if the function is provided an iterator or an
# iterable container it behaves the same.
#
# That means that I can test the functions using
# e.g.
#   parse_chunk(original_data[8:])
# while I can still use the functions with
# e.g.
#   data_iter = iter(data)
#   parse_chunk(data_iter)

def grouper(n, iterable, fillvalue=None):
    "grouper(3, 'ABCDEFG', 'x') --> ABC DEF Gxx"
    args = [iter(iterable)] * n
    return itt.zip_longest(*args, fillvalue=fillvalue)

def take_n_bytes(n, data):
    '''Enable taking a certain number of bytes from any iterable (whether a
       container or iterator itself).'''
    data_iter = iter(data)
    return bytes(next(data_iter) for _ in range(n))


IHDR_tuple = namedtuple('IHDR_tuple',
                        ['width', 'height', 'bitdepth', 'color_type',
                          'method', 'filtermethod', 'interlacemethod'])
def parse_ihdr(data):
    if len(bytes(data)) != 13:
        print('IHDR parsing with too large a buffer')
    ihdr_data = take_n_bytes(4 + 4 + 1 + 1 + 1 + 1 + 1, data)
    ihdr_parts = struct.unpack('>IIBBBBB', ihdr_data)
    return IHDR_tuple(*ihdr_parts)

def parse_default(data):
    return bytes(data)

def parse_iend(data):
    assert bytes(data) == b''
    return b''

known_chunks = {
    'IHDR': parse_ihdr,
    'PLTE': parse_default,
    'IDAT': parse_default,
    'IEND': parse_iend,
}

CHUNK_tuple = namedtuple('CHUNK_tuple', ['length', 'name', 'parsed_data', 'crc'])
def parse_chunk(data):
    data_iter = iter(data)
    length = struct.unpack('>I', take_n_bytes(4, data_iter))[0]
    type = take_n_bytes(4, data_iter)
    name = type.decode('utf8')
    data = take_n_bytes(length, data_iter)
    crc = struct.unpack('>I', take_n_bytes(4, data_iter))[0]
    calc_crc = zlib.crc32(type + data)
    if crc != calc_crc:
        print('CRC incorrect for item', name)
        return None
    parser = known_chunks.get(name, parse_default)
    return CHUNK_tuple(length, name, parser(data), crc)


PNG_FILE_HEADER = b'\x89PNG\r\n\x1a\n'
def parse_file_header(data):
    ident = take_n_bytes(8, data)
    if ident != PNG_FILE_HEADER:
        print('Bad file header')
        return False
    return True

def parse_png(data):
    data_iter = iter(data)
    parse_file_header(data_iter)
    chunk = parse_chunk(data_iter)
    retlist = [chunk]
    while chunk.name != 'IEND':
        chunk = parse_chunk(data_iter)
        retlist.append(chunk)
    return retlist


# Creating a PNG image from the parsed data.

def output_ihdr(ihdr_tuple):
    return struct.pack('>IIBBBBB', *ihdr_tuple)

def output_default(data):
    return data

def output_iend(data):
    assert data == b''
    return b''

chunk_outputs = {
    'IHDR': output_ihdr,
    'PLTE': output_default,
    'IDAT': output_default,
    'IEND': output_iend
}

def output_chunk(chunk_tuple):
    output_func = chunk_outputs.get(chunk_tuple.name, output_default)
    return b''.join([
        struct.pack('>I', chunk_tuple.length),
        chunk_tuple.name.encode('utf8'),
        output_func(chunk_tuple.parsed_data),
        struct.pack('>I', chunk_tuple.crc)])

def output_file_header():
    return PNG_FILE_HEADER

def output_png(chunk_iterable):
    byte_list = [output_file_header()] + [
            output_chunk(chunk) for chunk in chunk_iterable]
    return b''.join(byte_list)



def create_chunk(name, data):
    # Just to let the user pass a string if they want.
    byte_name = bytes(name, 'utf8')
    byte_data = chunk_outputs.get(name, output_default)(data)
    length = len(byte_data)
    return CHUNK_tuple(length=length, name=name, parsed_data=data,
            crc=zlib.crc32(byte_name + byte_data))


def bits_to_bytes(bits, bit_length):
    pass

def create_idat(bit_length, pixel_ids, width, height):
    # Plus one for the filter type (which is always zero for us).
    bytes_per_row = math.ceil((width * bit_length)/8) + 1
    # TODO
    pass


# TODO Can't *just* shift the RED, need to handle the CRC too.
#       Maybe we can generate a CRC that will still work if a value is shifted.
#       How is the CRC calculated?
# https://stackoverflow.com/questions/2587766/how-is-a-crc32-checksum-calculated
#
#   Could simply try all colours that could be interpreted as red.
#   See which colour leaves me with a CRC that is the same between this pixel
#   at the start and that pixel at the end.
#
#   Seems that this doesn't give me anything.
#   Reverse-engineering the CRC seems too much effort for what I want
#   (especially since all the reverse-engineering algorithms I've found so far
#   are based around moving data in ways that would mess up the whole point of
#   what I'm trying to do), so I'm just going to include a clue to update the
#   CRC.
