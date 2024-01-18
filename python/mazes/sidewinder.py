from random import sample, randrange
from .grid import Grid


class Sidewinder: 
    @classmethod
    def set_on(cls, grid:Grid):
        cols = grid.cols 
        for ii, row in enumerate(grid.grid): 
            lk_east  = (sample([False, True], counts=(cols//2, cols), k=cols-1)
                        if 0 < ii else [True]*(cols-1))
            non_lks  = [0] + [ii+1 for ii, bb in enumerate(lk_east) if not bb] + [cols]
            lks_shft = list(zip(non_lks[0:-1], non_lks[1:]))
            north_at = [p0 + randrange(p1-p0) for (p0, p1) in lks_shft]
            _ = {cell.link(cell.east) for (cell, lk) in zip(row[:-1], lk_east) if lk}
            _ = {cell.link(cell.north) for nn in north_at if (cell := row[nn]) and cell.north}
        return  
            

if __name__ == '__main__': 
    sw_grid = Grid(6,6)
    Sidewinder.set_on(sw_grid)
    print(sw_grid)
            

