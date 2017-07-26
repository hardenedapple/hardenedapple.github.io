def wrapper_func(fn):
    def return_func(*args, **kwargs):
        print(args)
        print(kwargs)
        return_value = fn(*args, **kwargs)
        print(return_value)
        return return_value
    return return_func


def trace_this(fn):
    fn.__trace_orig_fn = fn
    orig_name = fn.__name__
    globals()[orig_name] = wrapper_func(fn)


if __name__ == "__main__":
    trace_this(test_function)
