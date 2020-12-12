vshcmd: > # Part of what I need to do for this task is to have some set of data
vshcmd: > # for what each letter value should look like.
vshcmd: > #
vshcmd: > # I'm thinking that I have a box of a standard width and height for
vshcmd: > # every letter, and hence every letter/number is described by a
vshcmd: > # (width x height) matrix of which pixels should be set and which
vshcmd: > # should not.
vshcmd: > python
Python 3.8.1 (default, Jan 22 2020, 06:38:00) 
[GCC 9.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> 
vshcmd: > import copy
vshcmd: > import itertools as itt
vshcmd: > from PIL import Image
vshcmd: > lettersimage = Image.open('creating-letters.png')
vshcmd: > pixel_values = lettersimage.getdata()
vshcmd: > list(pixel_values)[:100]
>>> >>> >>> >>> >>> [(255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255), (255, 255, 255)]
>>> 
vshcmd: > next((i, val) for i, val in enumerate(pixel_values) if val != (255, 255, 255))
(9645, (183, 183, 183))
>>> 
vshcmd: > # It turns out that there are more than just black and white colours.
vshcmd: > all_pixel_kinds = set(pixel_values)
vshcmd: > len(all_pixel_kinds)
>>> 255
>>> 
vshcmd: > # These utility functions turn an iterable of pixels into an image I
vshcmd: > # can view.
vshcmd: > def iter_values(pixels):
vshcmd: >   for i in pixels:
vshcmd: >       yield i[0]
vshcmd: >       yield i[1]
vshcmd: >       yield i[2]
vshcmd: > def image_from_pixels(image, pixels):
vshcmd: >   image_bytes = bytes(iter_values(pixels))
vshcmd: >   return Image.frombytes(image.mode, image.size, image_bytes)
... ... ... ... ... >>> ... ... ... >>> 
vshcmd: > # Let's have a look at what a picture where all the values are either
vshcmd: > # pure black or pure white looks like.
vshcmd: > twotone_pixels = (x if x == (255, 255, 255) else (0, 0, 0)
vshcmd: >                   for x in lettersimage.getdata())
... >>> 
vshcmd: > # It turns out that this essentially looks like all the letters are
vshcmd: > # bold.  That's good enough for my purposes, and only looking for
vshcmd: > # black or white makes things a bit easier when working with the
vshcmd: > # pixels, hence I'll work with that from now on.
vshcmd: > modifiedimage = image_from_pixels(lettersimage, twotone_pixels)
vshcmd: > modifiedimage.show()
>>> >>> 
vshcmd: > # #########################
vshcmd: > # Have switched grayscale to just black and white, now want to
vshcmd: > # identify the position of the different letters.
vshcmd: > modifiedimage.size
vshcmd: > marked_rows = []
vshcmd: > new_pixels = list(modifiedimage.getdata())
vshcmd: > for i in range(600):
vshcmd: >     has_letters = (0, 0, 0) in new_pixels[i*800:(i+1)*800]
vshcmd: >     marked_rows.append(has_letters)
(800, 600)
>>> >>> >>> ... ... ... >>> 
vshcmd: > rows_with_letters = [i for i, x in enumerate(marked_rows) if x]
vshcmd: > rows_with_letters
>>> [12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 245]
>>> 
vshcmd: > discontinuities = []
vshcmd: > i = 0
vshcmd: > for y in rows_with_letters:
vshcmd: >   if y != i+1:
vshcmd: >       discontinuities.append(i)
vshcmd: >       discontinuities.append(y)
vshcmd: >   i = y
>>> >>> ... ... ... ... ... >>> 
vshcmd: > # The discontinuities shows us the range in rows of each line of letters.
vshcmd: > discontinuities
[0, 12, 40, 83, 111, 154, 176, 245]
>>> 
vshcmd: > # Note, that 245 is just about visible on the image as a random dot
vshcmd: > # somewhere in the middle.  I'll just ignore it.
vshcmd: > marked_rows[240:250]
[False, False, False, False, False, True, False, False, False, False]
>>> 
vshcmd: > # Height of each line of letters is
vshcmd: > #   28  28, 22
vshcmd: > # Hence we use 30 as our 'letter height'.
vshcmd: > # 
vshcmd: > # Do something similar for letter width to isolate the letters in
vshcmd: > # each row.
vshcmd: > def find_letter_columns(text_line, width):
vshcmd: >   marked_columns = []
vshcmd: >   for i in range(width):
vshcmd: >       has_letters = (0, 0, 0) in text_line[i::width]
vshcmd: >       marked_columns.append(has_letters)
vshcmd: >   columns_with_letters = [i for i, x in enumerate(marked_columns) if x]
vshcmd: >   return columns_with_letters
vshcmd: >
vshcmd: > def find_disconinuities(items):
vshcmd: >   discontinuities = []
vshcmd: >   i = 0
vshcmd: >   for y in items:
vshcmd: >     if y != i+1:
vshcmd: >         discontinuities.append(i)
vshcmd: >         discontinuities.append(y)
vshcmd: >     i = y
vshcmd: >   return discontinuities
... ... ... ... ... ... ... >>> ... ... ... ... ... ... ... ... ... >>> 
vshcmd: > rowa_column_discontinuities = find_disconinuities(find_letter_columns(new_pixels[0:41*800], 800))
>>> 
vshcmd: > rowa_column_discontinuities
[0, 16, 30, 45, 60, 73, 86, 99, 114, 128, 143, 155, 166, 177, 192, 207, 221, 236, 239, 251]
>>> 
vshcmd: > # Many different widths of letters, 15 seems to be the maximum.
vshcmd: > # Can use a width of 17 for buffer.
vshcmd: > [y - x for y, x in zip(rowa_column_discontinuities[1:], rowa_column_discontinuities[:-1])]
[16, 14, 15, 15, 13, 13, 13, 15, 14, 15, 12, 11, 11, 15, 15, 14, 15, 3, 12]
>>> 
vshcmd: > # Try and isolate the 'a':
vshcmd: > #   - Know the rows are between 11 and 41 (since in first row)
vshcmd: > #   - Know the columns are between 15 and 31 (since is first letter)
vshcmd: > a_pixels = []
vshcmd: > for row in range(11, 42):
vshcmd: >   current_row = new_pixels[row*800:(row+1)*800]
vshcmd: >   a_pixels.extend(current_row[15:32])
>>> ... ... ... >>> 
vshcmd: > # a_pixels is an image of 31 rows and 17 columns
vshcmd: > len(a_pixels) / 17
31.0
>>> 
vshcmd: > def image_from_mode_size_and_pixels(mode, size, pixels):
vshcmd: >   image_bytes = bytes(iter_values(pixels))
vshcmd: >   return Image.frombytes(mode, size, image_bytes)
... ... ... >>> 
vshcmd: > # This seems to work nicely.
vshcmd: > just_a = image_from_mode_size_and_pixels('RGB', (17, 31), a_pixels)
vshcmd: > just_a.show()
>>> >>> 
vshcmd: > # Hence algorithm to isolate letters is as follows:
vshcmd: > #    - For each "row discontinuity"
vshcmd: > #      - For each "column discontinuity" in that set of rows.
vshcmd: > #        - the row and column edges define a box, that box outlines the letter.
vshcmd: > def find_row_discontinuities(image):
vshcmd: >   data = list(image.getdata())
vshcmd: >   width, height = image.size
vshcmd: >   discontinuities = []
vshcmd: >   prev_has_data = False
vshcmd: >   for i in range(height):
vshcmd: >       has_data = (0, 0, 0) in new_pixels[i*width:(i+1)*width]
vshcmd: >       if has_data != prev_has_data:
vshcmd: >           discontinuities.append(i)
vshcmd: >       prev_has_data = has_data
vshcmd: >   return discontinuities
vshcmd: > find_row_discontinuities(modifiedimage)
... ... ... ... ... ... ... ... ... ... ... >>> [12, 41, 83, 112, 154, 177, 245, 246]
>>> 
vshcmd: > def row_ranges_from_discontinuities(discontinuities):
vshcmd: >   discontinuities = discontinuities[:-2] # Hack, happen to know this.
vshcmd: >   return ranges_from_discontinuities(discontinuities)
... ... ... >>> 
vshcmd: > def ranges_from_discontinuities(discontinuities):
vshcmd: >   def pairwise(x):
vshcmd: >       while x:
vshcmd: >           yield tuple(x[0:2])
vshcmd: >           x = x[2:]
vshcmd: >   return list(pairwise(discontinuities))
vshcmd: > row_ranges_from_discontinuities(find_row_discontinuities(modifiedimage))
... ... ... ... ... ... >>> [(12, 41), (83, 112), (154, 177)]
>>> 
vshcmd: > def find_column_discontinuities(image, row_range):
vshcmd: >   width, height = image.size
vshcmd: >   start, end = row_range
vshcmd: >   start = start - 1
vshcmd: >   end = end + 1
vshcmd: >   data = list(image.getdata())
vshcmd: >   rows = data[start*width:end*width]
vshcmd: >   discontinuities = []
vshcmd: >   prev_has_data = False
vshcmd: >   for i in range(width):
vshcmd: >       has_data = (0, 0, 0) in rows[i::width]
vshcmd: >       if has_data != prev_has_data:
vshcmd: >           discontinuities.append(i)
vshcmd: >       prev_has_data = has_data
vshcmd: >   return discontinuities
vshcmd: > row_ranges = row_ranges_from_discontinuities(find_row_discontinuities(modifiedimage))
vshcmd: > ranges_from_discontinuities(find_column_discontinuities(modifiedimage, row_ranges[0]))
... ... ... ... ... ... ... ... ... ... ... ... ... ... ... >>> >>> [(16, 31), (45, 61), (73, 87), (99, 115), (128, 144), (155, 167), (177, 193), (207, 222), (236, 240), (251, 258)]
>>> 
vshcmd: > def image_range(image, row_range, column_range):
vshcmd: >   width, height = image.size
vshcmd: >   data = list(image.getdata())
vshcmd: >   row_start, row_end = row_range
vshcmd: >   column_start, column_end = column_range
vshcmd: >   row_start, column_start = (x - 1 for x in (row_start, column_start))
vshcmd: >   row_end, column_end = (x + 1 for x in (row_end, column_end))
vshcmd: >   ret = []
vshcmd: >   rows = data[row_start*width:row_end*width]
vshcmd: >   for row in range(row_start, row_end):
vshcmd: >       start_of_row = row*width
vshcmd: >       ret.append(data[start_of_row+column_start:start_of_row+column_end])
vshcmd: >   return ret
... ... ... ... ... ... ... ... ... ... ... ... ... >>> 
vshcmd: > class Letter:
vshcmd: >   def __init__(self, width, height, pixels):
vshcmd: >       assert (len(pixels) == height)
vshcmd: >       for i in pixels:
vshcmd: >           assert(len(i) == width)
vshcmd: >       self.width = width
vshcmd: >       self.height = height
vshcmd: >       self.pixels = pixels
vshcmd: >   def __repr__(self):
vshcmd: >       return 'Letter(width={}, height={}, pixels not shown)'.format(self.width, self.height)
vshcmd: >   def __str__(self):
vshcmd: >       return 'Letter(width={}, height={}, pixels not shown)'.format(self.width, self.height)
vshcmd: > def find_letters(image):
vshcmd: >   letters = []
vshcmd: >   row_discontinuities = find_row_discontinuities(image)
vshcmd: >   for row_range in row_ranges_from_discontinuities(row_discontinuities):
vshcmd: >       column_discontinuities = find_column_discontinuities(image, row_range)
vshcmd: >       for column_range in ranges_from_discontinuities(column_discontinuities):
vshcmd: >           width = column_range[1] - column_range[0] + 2
vshcmd: >           height = row_range[1] - row_range[0] + 2
vshcmd: >           letters.append(Letter(width, height, image_range(image, row_range, column_range)))
vshcmd: >   return letters
... ... ... ... ... ... ... ... ... ... ... ... >>> ... ... ... ... ... ... ... ... ... ... >>> 
vshcmd: > myletters = find_letters(modifiedimage)
>>> 
vshcmd: > myletters[0]
Letter(width=17, height=31, pixels not shown)
>>> 
vshcmd: > max(x.width for x in myletters)
vshcmd: > max(x.height for x in myletters)
27
>>> 31
>>> 
vshcmd: > def round_up_height(letter, height):
vshcmd: >   assert (letter.height <= height)
vshcmd: >   if letter.height == height:
vshcmd: >       return letter
vshcmd: >   diff = height - letter.height
vshcmd: >   assert(diff % 2 == 0)
vshcmd: >   padding = [[(255, 255, 255)]*letter.width]*(diff // 2)
vshcmd: >   new_pixels = padding + letter.pixels + padding
vshcmd: >   return Letter(letter.width, height, new_pixels)
... ... ... ... ... ... ... ... ... >>> 
vshcmd: > height_rounded_letters = [round_up_height(x, 31) for x in myletters]
>>> 
vshcmd: > def round_up_width(letter, width):
vshcmd: >   assert (letter.width <= width)
vshcmd: >   if letter.width == width:
vshcmd: >       return letter
vshcmd: >   diff = width - letter.width
vshcmd: >   row_padding = [(255, 255, 255)]*(diff // 2)
vshcmd: >   new_pixels = []
vshcmd: >   for row in letter.pixels:
vshcmd: >       new_pixels.append(row_padding + row + row_padding)
vshcmd: >       if diff % 2:
vshcmd: >           new_pixels[-1].append((255, 255, 255))
vshcmd: >   return Letter(width, letter.height, new_pixels)
vshcmd: > both_rounded_letters = [round_up_width(x, 27) for x in height_rounded_letters]
... ... ... ... ... ... ... ... ... ... ... ... >>> >>> 
vshcmd: > height_rounded_letters[1]
Letter(width=18, height=31, pixels not shown)
>>> 
vshcmd: > both_rounded_letters[1]
Letter(width=27, height=31, pixels not shown)
>>> 
vshcmd: > # Just check that the above code does indeed isolate the different
vshcmd: > # letters properly.  Try and generate an image based on the letters
vshcmd: > # we identified above, and print that.
vshcmd: > def join_letters(letter_iterable):
vshcmd: >   iterator = iter(letter_iterable)
vshcmd: >   first_letter = next(iterator)
vshcmd: >   joined_list = copy.deepcopy(first_letter.pixels)
vshcmd: >   total_width = first_letter.width
vshcmd: >   for letter in iterator:
vshcmd: >       assert (letter.height == len(joined_list))
vshcmd: >       total_width += letter.width
vshcmd: >       for row, extension in zip(joined_list, letter.pixels):
vshcmd: >           row.extend(extension)
vshcmd: >   return Letter(total_width, len(joined_list), joined_list)
vshcmd: > 
vshcmd: > def duplicate_row(letter, num_times):
vshcmd: >   new_pixels = letter.pixels * num_times
vshcmd: >   new_height = letter.height * num_times
vshcmd: >   return Letter(letter.width, new_height, new_pixels)
vshcmd: >
vshcmd: > def image_from_letter(letter):
vshcmd: >   image_bytes = bytes(iter_values(itt.chain.from_iterable(letter.pixels)))
vshcmd: >   return Image.frombytes('RGB', (letter.width, letter.height), image_bytes)
vshcmd: >   
vshcmd: > # Just to calculate how many rows we can make.
vshcmd: > # import string
vshcmd: > # len(string.ascii_lowercase + string.digits) => 36
vshcmd: > # 8 bits per pixel => 256 colour choices
vshcmd: > # 256 - (one for the red that gets moved) = 255
vshcmd: > # 255 - (2 for the background) = 253
vshcmd: > # 253 // 2 (since each letter needs two colours) = 126
vshcmd: > # 126 / 36 (for each row of characters) = 3
vshcmd: >
vshcmd: > one_row = join_letters(both_rounded_letters)
vshcmd: > three_rows = duplicate_row(one_row, 3)
vshcmd: > combined_image = image_from_letter(three_rows)
... ... ... ... >>> ... ... ... >>> >>> >>> >>> >>> 
vshcmd: > combined_image.show()
>>> 
vshcmd: > # Now have something that gives us an organisation of pixels to
vshcmd: > # describe letters, we want to create an image from those letters.
vshcmd: > #
vshcmd: > # We plan on using the 8bit-per-pixel maximum size of indexes for
vshcmd: > # indexed images (see
vshcmd: > # https://en.wikipedia.org/wiki/Portable_Network_Graphics).
vshcmd: > #
vshcmd: > # Given we want to "shift" all the indexes by one at some point, and
vshcmd: > # "retain" the same colour setup, we need to index our colours
vshcmd: > # something like the below.
vshcmd: > #
vshcmd: > # I want to insert the "red" colour at position 0 (since that makes
vshcmd: > # the puzzle much easier, removing one of the dimensions).
vshcmd: > # If I don't want the background to change colour (so that all that
vshcmd: > # happens is that the letters appear), I'll need to have the
vshcmd: > # background indexed as colour 1 (to get the colour that was in 0
vshcmd: > # after the shift).
vshcmd: > #
vshcmd: > # In the outline below, 'a' indicates places where we should insert
vshcmd: > # the colour that the letter 'a' should be after the shift, and
vshcmd: > # similar for other letters.
vshcmd: > #
vshcmd: > # 0     1     2     3     4     5     6     7     8 ...
vshcmd: > #      back   a   white   b   white   c   white   d 
vshcmd: > #
vshcmd: > #
vshcmd: > # This means that the image I want to create should be just the
vshcmd: > # number `1` for the background, the number `3` for the first letter,
vshcmd: > # the number `5` for the second letter, and so on.
vshcmd: > #
vshcmd: > # Create the image using these indexes rather than RGB pixel values.
vshcmd: > def convert_letter_pixels_to_indexed(pixels, index):
vshcmd: >   new_pixels = []
vshcmd: >   for row in pixels:
vshcmd: >       new_pixels.append([1 if x == (255, 255, 255) else index for x in row])
vshcmd: >   return new_pixels
vshcmd: >
vshcmd: > def create_my_image(letters):
vshcmd: >   first_row, second_row, third_row = [], [], []
vshcmd: >   for i, x in enumerate(letters):
vshcmd: >       i = i*2   # Since each letter is indexed two from the last.
vshcmd: >       f_pixels = convert_letter_pixels_to_indexed(x.pixels, i+3)
vshcmd: >       s_pixels = convert_letter_pixels_to_indexed(x.pixels, i+75)
vshcmd: >       t_pixels = convert_letter_pixels_to_indexed(x.pixels, i+147)
vshcmd: >       first_row.append(Letter(x.width, x.height, f_pixels))
vshcmd: >       second_row.append(Letter(x.width, x.height, s_pixels))
vshcmd: >       third_row.append(Letter(x.width, x.height, t_pixels))
vshcmd: >   first_row, second_row, third_row = [join_letters(x) for x in
vshcmd: >                                       (first_row, second_row, third_row)]
vshcmd: >   new_pixels = first_row.pixels
vshcmd: >   new_pixels.extend(second_row.pixels)
vshcmd: >   new_pixels.extend(third_row.pixels)
vshcmd: >   return Letter(len(new_pixels[0]), len(new_pixels), new_pixels)
vshcmd: > 
vshcmd: > total_image = create_my_image(both_rounded_letters)
... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... >>> >>> >>> 
vshcmd: > total_image
Letter(width=972, height=93, pixels not shown)
>>> 
vshcmd: > set(itt.chain.from_iterable(total_image.pixels))
{1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 37, 39, 41, 43, 45, 47, 49, 51, 53, 55, 57, 59, 61, 63, 65, 67, 69, 71, 73, 75, 77, 79, 81, 83, 85, 87, 89, 91, 93, 95, 97, 99, 101, 103, 105, 107, 109, 111, 113, 115, 117, 119, 121, 123, 125, 127, 129, 131, 133, 135, 137, 139, 141, 143, 145, 147, 149, 151, 153, 155, 157, 159, 161, 163, 165, 167, 169, 171, 173, 175, 177, 179, 181, 183, 185, 187, 189, 191, 193, 195, 197, 199, 201, 203, 205, 207, 209, 211, 213, 215, 217}
>>> 
vshcmd: > # Create the IHDR chunk.
vshcmd: > from analysis import *
vshcmd: > ihdr_info = IHDR_tuple(width=total_image.width, height=total_image.height,
vshcmd: >                        bitdepth=8, color_type=3, method=0, filtermethod=0,
vshcmd: >                        interlacemethod=0)
vshcmd: > IHDR_chunk = create_chunk('IHDR', ihdr_info)
>>> 
vshcmd: > # Create the PLTE chunk.
vshcmd: > def make_row_mapping(start_index):
vshcmd: >   return [(char, ((i)*2)+start_index)
vshcmd: >           for i, char in
vshcmd: >           enumerate(string.ascii_lowercase + string.digits)]
vshcmd: > 
vshcmd: > def make_letter_mapping():
vshcmd: >   return (make_row_mapping(2)
vshcmd: >           + make_row_mapping (74)
vshcmd: >           + make_row_mapping (146))
vshcmd: >   
vshcmd: > def create_indexes_from_password(password):
vshcmd: >   indexes = []
vshcmd: >   orig_mapping = iter(make_letter_mapping())
vshcmd: >   for char in password:
vshcmd: >       indexes.append(next(x[1] for x in orig_mapping if x[0] == char))
vshcmd: >   return indexes
... ... ... ... >>> >>> ... ... ... ... >>> >>> ... ... ... ... ... ... >>> 
vshcmd: > create_indexes_from_password('ax13bqxx')
[2, 48, 56, 60, 76, 106, 120, 192]
>>> 
vshcmd: > def create_palette_from_indexes(indexes):
vshcmd: >   palette = [(255, 255, 255) if i not in indexes else (0, 0, 0)
vshcmd: >              for i in range(256)]
vshcmd: >   return palette
... ... ... ... >>> 
vshcmd: > def plte_from_password(password):
vshcmd: >   indexes = create_indexes_from_password(password)
vshcmd: >   palette = create_palette_from_indexes(indexes)
vshcmd: >   return create_chunk('PLTE', bytes(itt.chain.from_iterable(palette)))
... ... ... ... >>> 
vshcmd: > PLTE_chunk = plte_from_password('ax13bqxx')
>>> 
vshcmd: > def idat_from_image(imagedata):
vshcmd: >   filter_byte = 0
vshcmd: >   data = []
vshcmd: >   for row in imagedata.pixels:
vshcmd: >       data.append(filter_byte)
vshcmd: >       data.extend(row)
vshcmd: >   return create_chunk('IDAT', zlib.compress(bytes(data)))
... ... ... ... ... ... ... >>> 
vshcmd: > IDAT_chunk = idat_from_image(total_image)
>>> 
vshcmd: > IEND_chunk = create_chunk('IEND', b'')
>>> 
vshcmd: > chunk_list = [IHDR_chunk, PLTE_chunk, IDAT_chunk, IEND_chunk]
vshcmd: > output_data = output_png(chunk_list)
vshcmd: > with open('generated.png', 'wb') as outfile:
vshcmd: >   outfile.write(output_data)
>>> >>> ... ... 5825
>>> 
vshcmd: > with open('generated.png', 'rb') as infile:
vshcmd: >   read_data = infile.read()
vshcmd: > read_chunk_list = parse_png(read_data)
vshcmd: > orig_palette = create_palette_from_password('ax13bqxx')
vshcmd: > alt_palette = orig_palette[-1:] + orig_palette[:-1]
vshcmd: > alt_plte = create_chunk('PLTE', bytes(itt.chain.from_iterable(alt_palette)))
vshcmd: > alt_chunk_list = [IHDR_chunk, alt_plte, IDAT_chunk, IEND_chunk]
vshcmd: > with open('modified.png', 'wb') as outfile:
vshcmd: >   outfile.write(output_png(alt_chunk_list))
... ... >>> >>> >>> >>> >>> >>> ... ... 5825
>>> 
vshcmd: > # Now have created an image that does what I want.
vshcmd: > # Just need to find a pixel that keeps the same CRC when moved from
vshcmd: > # the end to the front and use that for my image.
vshcmd: > # That would mean I have all the features I want.
vshcmd: > def crcs_match(prefix, left, right):
vshcmd: >   left_bytes = bytes(itt.chain.from_iterable(left))
vshcmd: >   right_bytes = bytes(itt.chain.from_iterable(right))
vshcmd: >   return zlib.crc32(prefix + left_bytes) == zlib.crc32(prefix + right_bytes)
vshcmd: > 
vshcmd: > def generate_all_pixels():
vshcmd: >   for i in range(0, 256):
vshcmd: >       for j in range(0, 256):
vshcmd: >           for k in range(0, 256):
vshcmd: >               yield (i, j, k)
vshcmd: > 
vshcmd: > def search_for_palette(original):
vshcmd: >   byte_name = 'PLTE'.encode('utf8')
vshcmd: >   for red_pixel in generate_all_pixels():
vshcmd: >       original[-1] = red_pixel
vshcmd: >       other = original[-1:] + original[:-1]
vshcmd: >       if crcs_match(byte_name, original, other):
vshcmd: >           yield red_pixel
vshcmd: > 
vshcmd: > for i in search_for_palette(create_palette_from_password('ax13bqxy')):
vshcmd: >   print(i)
... ... >>> 
vshcmd: > # That kind of sucks -- there is no pixel that works in the way I was
vshcmd: > # hoping.  I can search through a bunch of other palette variants,
vshcmd: > # but I really want something moved from the end to the start (since
vshcmd: > # anything else adds an obscure extra bit of information).
vshcmd: > #
vshcmd: > # I think it's easier to use some sort of reverse calculation to
vshcmd: > # figure out what to do.
vshcmd: > # https://stackoverflow.com/questions/48247647/how-do-i-modify-a-file-while-maintaining-its-crc-32-checksum
vshcmd: > # https://stackoverflow.com/questions/1515914/crc32-collision
vshcmd: > #
vshcmd: > # However, that reverse calculation seem to largely revolve around
vshcmd: > # actions that don't work for what I want.
vshcmd: > # I think the below should search for everything I'd be happy doing.
vshcmd: > # If none of those values work then I'll just have to mention
vshcmd: > # updating the CRC in the clue I give.
vshcmd: > #
vshcmd: > # Actually, thinking about it, I'd be happy with any number of
vshcmd: > # padding pixels before the first 'a', as long as that doesn't reduce
vshcmd: > # the number of lines I can create.
vshcmd: > # Hence this is not quite the exhaustive search I was thinking it
vshcmd: > # would be -- and I may do that in the future.
vshcmd: > def search_for_palette(original):
vshcmd: >   byte_name = 'PLTE'.encode('utf8')
vshcmd: >   for new_background in generate_all_pixels():
vshcmd: >       orig = copy.copy(original)
vshcmd: >       orig[0] = new_background
vshcmd: >       for move_pixel in generate_all_pixels():
vshcmd: >           orig[-1] = move_pixel
vshcmd: >           other = orig[-1:] + orig[:-1]
vshcmd: >           if crcs_match(byte_name, orig, other):
vshcmd: >               yield (move_pixel, new_background)
vshcmd: > 
vshcmd: > for i in search_for_palette(create_palette_from_password('ax13bqxy')):
vshcmd: >   print(i)
... ... ... ... ... ... ... ... ... ... ... ... ... >>> >>> ... ... Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "<stdin>", line 12, in search_for_palette
  File "<stdin>", line 2, in crcs_match
KeyboardInterrupt
>>> 
vshcmd: > PLTE_chunk.parsed_data
b'\xff\xff\xff\xff\xff\xff\x00\x00\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff'
>>> 
vshcmd: > zlib.crc32(PLTE_chunk.parsed_data)
3121254612
>>> 
vshcmd: > hex(PLTE_chunk.crc)
'0xfc9a9049'
>>> 
vshcmd: > # See spoofing-crc.vsh for why I'm calculating these things.
vshcmd: > # `degree`
vshcmd: > degree = len(PLTE_chunk.parsed_data)*8
vshcmd: > print(degree)
>>> 6144
>>> 
vshcmd: > polynomial = hex(PLTE_chunk.crc)
