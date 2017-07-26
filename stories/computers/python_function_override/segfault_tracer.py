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


def trace_this(fn):
    '''Change `fn` to print its arguments and what it's returning.

    Can't handle return statements in the middle of the function.

    Can't handle any jumps -- they have direct bytecode addresses and we move
    them around.
    '''
    orig_code = fn.__code__
    new_names = (orig_code.co_names
                 if 'print' in orig_code.co_names else
                 orig_code.co_names + ('print',))
    num_args = orig_code.co_argcount + orig_code.co_kwonlyargcount
    print_index = new_names.index('print')

    init_instructions = [('LOAD_GLOBAL', print_index)]
    for local_index in range(0, num_args):
        init_instructions.append(('LOAD_FAST', local_index))

    init_instructions.extend([
              ('CALL_FUNCTION', num_args),
              ('POP_TOP', 0),
    ])

    entry_code = assemble(init_instructions)

    exit_code = assemble([
        # Note: The following appears to work instead of calling print().
        # ('DUP_TOP', 0),
        # ('PRINT_EXPR', 0),
        # but this feels like a hack that's not *needed* to implement the hack
        # I want, and seeing as I'm not a Python expert it could have unforseen
        # consequences that would complicate checking my tracers.
        ('DUP_TOP', 0),
        ('LOAD_GLOBAL', print_index),
        ('ROT_TWO', 0),
        ('CALL_FUNCTION', 1),
        ('POP_TOP', 0),
        ('RETURN_VALUE', 0),
    ])

    full_instructions = (entry_code
                         + orig_code.co_code[:-2]
                         + exit_code)

    new_code = types.CodeType(
        fn.__code__.co_argcount,
        fn.__code__.co_kwonlyargcount,
        fn.__code__.co_nlocals,
        # We push num_args onto the stack in the initialisation code, and we
        # push an extra return value and print statement onto the stack in the
        # exit code.
        # Hence the stack can be up to max(2, 1 + num_args) greater than the
        # previous greatest depth.
        # n.b. From those functions I've disassembled it appears that each
        # python function ensures no extra stack variables are left on the
        # stack when it returns, in which case the greatest depth would be
        # max(3, fn.__code__.co_stacksize, 1 + num_args).
        # I don't know for certain that this happens (though the definition of
        # RETURN_VALUE in dis.rst doesn't say anything about clearing the
        # current stack frame, so it looks like it does), so I'm
        # playing it safe.
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
