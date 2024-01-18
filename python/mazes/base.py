from .grid import Grid

class Maze(Grid): 
    methods = {}

    @classmethod
    def create(cls, method_key, **kwargs): 
        the_method = cls.methods.get(method_key)
        return the_method(**kwargs)
    
    @classmethod
    def update_methods(cls, methods_dict): 
        cls.methods.update(methods_dict)

    @classmethod
    def add_method(cls, method_key, a_method): 
        cls.methods[method_key] = a_method

    def set_on(self, grid:Grid): 
        return grid
    
