
from .base import Maze
from .binary_tree import BinaryTree
from .sidewinder import Sidewinder

methods = {
   'binary_tree': BinaryTree, 
   'sidewinder' : Sidewinder
}

Maze.update_methods(methods)


if __name__ == '__main__': 
    pass
    # argparser type of maze, size.  
    