class Identifier:
    def __init__(self, meta, var_name, arr_size=None):
        assert(isinstance(var_name, str) and
               isinstance(arr_size, (type(None), int)))

        self.meta = meta
        self.var_name = var_name
        self.arr_size = arr_size

    def __str__(self):
        arr_str = '' if self.arr_size is None else '[%s]' % self.arr_size
        return '%s%s' % (self.var_name, arr_str)
