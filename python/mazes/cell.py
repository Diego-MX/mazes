
from typing import List

class Cell: 
    directions = {  # IJ-directions, not XY
        'south': (1, 0), # (0,-1)
        'east' : (0, 1), # (1, 0)
        'north': (-1,0), # (0, 1)
        'west' : (0,-1)} # (-1,0)
    
    def __init__(self, row:int, col:int): 
        self.row = row
        self.col = col
        self.links = {}
        for dir in self.directions: 
            setattr(self, dir, None)

    def link(self, other:'Cell', bidir:bool=True): 
        self.links[other] = True
        if bidir: 
            other.link(self, bidir=False)
        return

    def unlink(self, other:'Cell', bidir:bool=True): 
        self.links.pop(other)
        if bidir: 
            other.unlink(self, bidir=False)
        return

    def links(self): 
        return self.links.keys()

    def is_linked(self, other:'Cell') -> bool: 
        return (other in self.links)

    def neighbors(self) -> List['Cell']: 
        them = [link for dir in self.directions 
            if (link := getattr(self, dir))]
        return them


