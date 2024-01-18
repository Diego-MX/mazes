from random import choice
from .base import Maze
from .grid import Grid


class BinaryTree(Maze):
    dir_targets = ['north', 'east'] 

    @classmethod
    def set_on(cls, grid:Grid): 
        for cell in grid:
            available = [target for dir in cls.dir_targets 
                    if (target := getattr(cell, dir, None))]
            if available: 
                chosen = choice(available) if available else None
                cell.link(chosen)
        return


if __name__ == '__main__': 
    bt_grid = Grid(4,4)
    BinaryTree.set_on(bt_grid)
    print(bt_grid)
    
