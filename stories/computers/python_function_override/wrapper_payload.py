import itertools as itt
import opcode
import dis
import types

def wrapper_func(fn):
    def return_func(*args, **kwargs):
        print('Calling with args', args)
        print('Calling with kwargs', kwargs)
        return_value = fn(*args, **kwargs)
        print('Returned:', return_value)
        return return_value
    return return_func


def trace_this(fn):
    '''Modify `fn` to print arguments and return value on execution.'''
    # Implementation is done by modifying the function *in-place*.
    # This is necessary to ensure that all local references to the function
    # (e.g. in closures, different namespaces, or collections) are traced too.

    # TODO
    #   Known problems:
    #       sys._getframe(1) now returns the frame from inside the closure.

    # Create a wrapper function to print arguments and return value.
    wrap_function = wrapper_func(fn)
    orig_wrap_code = wrap_function.__code__

    # Happen to know the current bytecode of my wrapper function.
    # Probably should parse it programmatically, but for demonstration purposes
    # this is fine.
    # Change the bytecode instruction that loads a freevar into an instruction
    # to load a constant.
    # Happen to know I'll want the 5'th constant in co_consts (because I know
    # how many constants the wrapper function uses.
    #
    # Bytecode is version specific.
    # Am *very* apprehensive about this, I can easily imagine the LOAD_CONST
    # bytecode implementation assuming it's loading something that's constant.
    # It appears to work ...
    alt = bytes([opcode.opmap['LOAD_CONST'], 4])
    alternate_code = orig_wrap_code.co_code[:20] + alt + orig_wrap_code.co_code[22:]

    # Create a copy of the original function.
    # This has the same functionality as the original one, but is a different
    # object.
    # We need a different object so that the modification done below doesn't
    # change the behaviour of our wrapper function.
    copy_fn = types.FunctionType(fn.__code__, fn.__globals__, fn.__name__,
                                 fn.__defaults__, fn.__closure__)

    new_codeobj = types.CodeType(
        orig_wrap_code.co_argcount,
        orig_wrap_code.co_kwonlyargcount,
        orig_wrap_code.co_nlocals,
        orig_wrap_code.co_stacksize,
        orig_wrap_code.co_flags,
        alternate_code,
        orig_wrap_code.co_consts + (copy_fn,),
        orig_wrap_code.co_names,
        orig_wrap_code.co_varnames,
        orig_wrap_code.co_filename,
        orig_wrap_code.co_name,
        orig_wrap_code.co_firstlineno,
        orig_wrap_code.co_lnotab,
        # Take freevars from the original function.
        # This is so the code object matches the __closure__ object from the
        # original function.
        # If they don't match, python raises an exception upon assignment at
        # the end of this function.
        # We can't change the __closure__ member, as this is a read-only
        # attribute enforced in the C core.
        # This shouldn't matter either way, the closed over variables aren't
        # used in the wrapper code.
        fn.__code__.co_freevars,
        orig_wrap_code.co_cellvars
    )

    if getattr(fn, '__trace_orig_code', None) is None:
        fn.__trace_orig_code = fn.__code__
    else:
        raise ValueError('Tracing function with __trace_orig_code attribute.\n'
                         'Probably an already traced function.')

    fn.__code__ = new_codeobj
    return


if __name__ == "__main__":
    trace_this(test_function)
