class SitePercolation
  attr_reader :cluster, :p_infty, :p_infty_all

  # n = size of grid
  # p = propability for one site of being set
  def initialize(n, p, debug = false)
    @n = n
    @matrix = Array.new(n) { Array.new(n) { rand < p ? 1 : 0 } }
    @debug = debug
    find_percolation
    compute_p_infty
  end
  
  def to_s
    @matrix.collect do |row|
      row.join(' ')
    end.join("\n")
  end

  private
  
  # find a global cluster that connects first row with last row
  def find_percolation
    # list of burned sites in last step
    @burned = []
    
    @cluster = nil
    
    puts to_s + "\n\n" if @debug
    
    # start burning every site with y == 0
    0.upto(@n-1) do |x|
      if @matrix[0][x] == 1
        @matrix[0][x] = 2
        @burned << [0,x]
      end
    end
    
    puts to_s + "\n\n" if @debug
    
    # run burning steps
    while @burned.length > 0
      old_burned = @burned
      @burned = []
      old_burned.each do |y,x|
        if y > 0
          if @matrix[y-1][x] == 1
            @matrix[y-1][x] = 2
            @burned << [y-1,x]
          end
        end
        if y + 1 < @n
          if @matrix[y+1][x] == 1
            @matrix[y+1][x] = 2
            @burned << [y+1,x]
            @cluster = [y+1,x] if y == @n-2
          end
        end
        if x >  0
          if @matrix[y][x-1] == 1
            @matrix[y][x-1] = 2
            @burned << [y,x-1]
          end
        end
        if x + 1 < @n
          if @matrix[y][x+1] == 1
            @matrix[y][x+1] = 2
            @burned << [y,x+1]
          end
        end 
      end
      puts to_s + "\n\n" if @debug
    end
    
    if @cluster
      #rerun burning to get cluster connecting first with last row
      @matrix[@cluster[0]][@cluster[1]] = 3
      @burned = [@cluster]
      puts to_s + "\n\n" if @debug
    end 
    while @burned.length > 0
      old_burned = @burned
      @burned = []
      old_burned.each do |y,x|
        if y > 0
          if @matrix[y-1][x] == 2
            @matrix[y-1][x] = 3
            @burned << [y-1,x]
          end
        end
        if y + 1 < @n
          if @matrix[y+1][x] == 2
            @matrix[y+1][x] = 3
            @burned << [y+1,x]
          end
        end
        if x >  0
          if @matrix[y][x-1] == 2
            @matrix[y][x-1] = 3
            @burned << [y,x-1]
          end
        end
        if x + 1 < @n
          if @matrix[y][x+1] == 2
            @matrix[y][x+1] = 3
            @burned << [y,x+1]
          end
        end 
      end
      puts to_s + "\n\n" if @debug
    end
  end
  
  # computes portion of points that belong to the global cluster
  def compute_p_infty
    unless @cluster
      @p_infty = 0
      @p_infty_all = 0
    else 
      point_count = 0
      point_cluster_count = 0
      @matrix.each do |row|
        row.each do |m|
          point_count += 1 if m > 0
          point_cluster_count += 1 if m == 3
        end
      end
      puts point_cluster_count if @debug
      puts point_count if @debug
      @p_infty = point_cluster_count * 1.0 / point_count
      @p_infty_all = point_cluster_count * 1.0 / @n / @n
    end
  end
end
