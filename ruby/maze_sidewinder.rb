class Sidewinder
    
    def self.on(grid)
        grid.each_row do |row|
            run = []
            
            row.each do |cell|
                run << cell
                
                at_east_bdry = (cell.east  == nil)
                at_nrth_bdry = (cell.north == nil)
                
                close_path = at_east_bdry || (!at_nrth_bdry && rand(2) == 0)
                
                if close_path
                    member = run.sample
                    member.link(member.north) if member.north
                    run.clear
                else
                    cell.link(cell.east)
                end
            end
        end
        
        grid
    end
    
end
