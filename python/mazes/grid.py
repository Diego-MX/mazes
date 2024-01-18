from random import randrange
from .cell import Cell 


class Grid: 
    def __init__(self, rows:int, cols:int): 
        self.rows = rows
        self.cols = cols
        self.grid = self._prepare_grid()
        self._configure_cells()

    def __getitem__(self, row_col):
        row, col = row_col
        in_range = (0 <= row < self.rows) and (0 <= col < self.cols)
        return self.grid[row][col] if in_range else None
    
    def __iter__(self): 
        for row in self.grid:
            for cell in row: 
                yield cell

    def __len__(self): 
        return self.rows*self.cols


    def __str__(self):
        vrt_0, vrt_1 =  ' ' ,  '|'
        hrz_0, hrz_1 = '   ', '---'
        corn, cent, n_rr = '+', '   ', '\n'  
        
        dummy = Cell(-1,-1)
        all_str = f"{corn}{(hrz_1+corn)*self.cols}{n_rr}"

        for row in self.grid: 
            m_links = [cell.is_linked(cell.east or dummy) for cell in [dummy]+row]
            d_links = [cell.is_linked(cell.south or dummy) for cell in row]
            m_str = cent.join(vrt_0 if link else vrt_1 for link in m_links)
            d_str = corn+corn.join(hrz_0 if link else hrz_1 for link in d_links)+corn

            add_str = f"{m_str}{n_rr}{d_str}{n_rr}"
            all_str += add_str
        return all_str

    
    def random_cell(self): 
        row = randrange(self.rows)
        col = randrange(self.cols)
        return self[row, col]


    def _prepare_grid(self): 
        that = [[Cell(ii, jj) for jj in range(self.cols)] 
                for ii in range(self.rows)]
        return that


    def _configure_cells(self):
        for cell in self: 
            for dir, add in cell.directions.items():
                rpp, cpp = add
                neighbor = self[cell.row + rpp, cell.col + cpp]
                setattr(cell, dir, neighbor)
    


