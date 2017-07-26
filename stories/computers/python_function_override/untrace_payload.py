def untrace_this(fn):
    '''Remove tracing on `fn`.'''
    if not hasattr(fn, '__trace_orig_code'):
        return
    fn.__code__ = fn.__trace_orig_code
    delattr(fn, '__trace_orig_code')


if __name__ == "__main__":
    untrace_this(test_function)
