import itertools as itt
import opcode
import dis
import types

def assemble(instructions):
    '''Hackish assemble function.

    I expect there are many problems with this definition as I'm just a
    beginner in python bytecode.

    '''
    return bytes(itt.chain(*[(opcode.opmap[instruction], argument)
                             for instruction, argument in instructions]))


def chunks(iterable, size):
    '''Split `iterable` into tuples of len `size`.'''
    sourceiter = iter(iterable)
    batchiter = itt.islice(sourceiter, size)
    yieldval = tuple(batchiter)
    while yieldval:
        yield yieldval
        yieldval = tuple(itt.islice(sourceiter, size))


def modified_code(orig_code, return_address, entry_address):
    '''Return a bytecode string updated for tracing.

    We copy the original code, replacing any RETURN_VALUE instructions with a
    jump to `return_address`.
    We also replace the first insruction with a jump to `entry_address`.

    '''
    # TODO Account for return_address or entry_address being larger than one
    # byte. This would require an EXTENDED_ARG for the JUMP_ABSOLUTE
    # instruction, and would hence require changing all jump instruction
    # arguments.
    def translate_returnval(opnum, arg):
        if opcode.opname[opnum] == 'RETURN_VALUE':
            return (opcode.opmap['JUMP_ABSOLUTE'], return_address)
        return (opnum, arg)

    # Replace the first two bytes with a jump to the entry code.
    return bytes(itt.chain(assemble([('JUMP_ABSOLUTE', entry_address),]),
                           *[translate_returnval(*val)
                             for val in chunks(orig_code[2:], 2)]))


def first_full_instruction(bytecode):
    '''Return the first instruction, account for EXTENDED_ARG'''
    # May be other instructions we should account for ... again I'm no expert
    init = bytecode[:2]
    bytecode = bytecode[2:]
    while init[-2] == opcode.EXTENDED_ARG:
        init += bytecode[:2]
        bytecode = bytecode[2:]
    return init


def trace_this(fn):
    orig_code = fn.__code__
    new_names = (orig_code.co_names
                 if 'print' in orig_code.co_names else
                 orig_code.co_names + ('print',))
    num_args = orig_code.co_argcount + orig_code.co_kwonlyargcount
    print_index = new_names.index('print')

    exit_code = assemble([
        ('DUP_TOP', 0),
        ('LOAD_GLOBAL', print_index),
        ('ROT_TWO', 0),
        ('CALL_FUNCTION', 1),
        ('POP_TOP', 0),
        ('RETURN_VALUE', 0),
    ])

    # Create the insructions to print all arguments.
    init_instructions = [('LOAD_GLOBAL', print_index),]
    for local_index in range(0, num_args):
        init_instructions.append(('LOAD_FAST', local_index))

    init_instructions.extend([
        ('CALL_FUNCTION', num_args),
        ('POP_TOP', 0),
    ])

    # Print all arguments.
    entry_code = assemble(init_instructions)
    # Do whatever the first instruction of the original function was.
    # Have to account for the EXTENDED_ARG opcode.
    first_instr = first_full_instruction(orig_code.co_code)
    entry_code += first_instr
    # Jump to the start of the second instruction
    entry_code += assemble([('JUMP_ABSOLUTE', len(first_instr))])

    # Place the entry and exit code after the functions bytecode.
    # That way we don't change the offset into the function of any existing
    # bytecode.
    exit_address = len(orig_code.co_code)
    initmes_address = exit_address + len(exit_code)

    # Replace first two bytes with a jump to initmes_address, and all
    # RETURN_VALUE instructions with a jump to exit_address.
    alternate_code = modified_code(orig_code.co_code,
                                   return_address=exit_address,
                                   entry_address=initmes_address)
    full_instructions = alternate_code + exit_code + entry_code

    new_code = types.CodeType(
        fn.__code__.co_argcount,
        fn.__code__.co_kwonlyargcount,
        fn.__code__.co_nlocals,
        fn.__code__.co_stacksize + num_args + 2,
        fn.__code__.co_flags,
        full_instructions,
        fn.__code__.co_consts,
        new_names,
        fn.__code__.co_varnames,
        fn.__code__.co_filename,
        fn.__code__.co_name,
        fn.__code__.co_firstlineno,
        fn.__code__.co_lnotab,
        fn.__code__.co_freevars,
        fn.__code__.co_cellvars
    )

    if getattr(fn, '__trace_orig_code', None) is None:
        fn.__trace_orig_code = orig_code
    else:
        raise ValueError('Tracing function with __trace_orig_code attribute.\n'
                         'Probably an already traced function.')

    fn.__code__ = new_code
    return


if __name__ == "__main__":
    trace_this(test_function)
