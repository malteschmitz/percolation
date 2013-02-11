class BondPercolation
  attr_reader :cluster, :p_infty, :p_infty_all

  # n = size of grid
  # p = propability for one site of being set
  def initialize(n,p,debug = false)
    @n = n
    @matrix = Array.new(n) { Array.new(2*n-1) { rand < p ? 1 : 0 } }
    @debug = debug
    find_percolation
    compute_p_infty
  end
  
  def to_s
    yy = 0
    @matrix.collect do |row|
      first = (0..@n-1).to_a.map{|i| 2*i}.map{|i| row[i]}.join('   ')
      second = (0..@n-2).to_a.map{|i| 2*i+1}.map{|i| row[i]}.join('   ')
      second = "  #{second}  "
      @burned.each do |y,x|
        second[4*x] = 'x' if y == yy
      end
      yy += 1
      first + "\n" + second
    end.join("\n")
  end

  private
  
  # find a global cluster that connects first row with last row
  def find_percolation
    # list of burned sites in last step
    @burned = []
    
    @cluster = nil
    
    puts to_s + "\n\n" if @debug
    
    # start burning every down edge with y == 0
    0.upto(@n-1) do |x|
      if @matrix[0][2*x] == 1
        @matrix[0][2*x] = 2
        @burned << [0,x]
      end
    end
    
    puts to_s + "\n\n" if @debug
    
    # run burning steps
    while @burned.length > 0
      old_burned = @burned
      @burned = []
      old_burned.each do |y,x|
        # up
        if @matrix[y][2*x] == 1
          @matrix[y][2*x] = 2
          @burned << [y-1,x]
        end
        # left
        if x > 0
          if @matrix[y][2*x-1] == 1
            @matrix[y][2*x-1] = 2
            @burned << [y,x-1]
          end
        end
        # right
        if x + 1 < @n
          if @matrix[y][2*x+1] == 1
            @matrix[y][2*x+1] = 2
            @burned << [y,x+1]
          end
        end
        # down
        if y + 1 < @n
          if @matrix[y+1][2*x] == 1
            @matrix[y+1][2*x] = 2
            @burned << [y+1,x]
            @cluster = [y+1,x] if y == @n-2
          end
        end 
      end
      puts to_s + "\n\n" if @debug
    end
    
    if @cluster
      # rerun burning to get cluster connecting first with last row
      @burned = [@cluster]
    end 
    while @burned.length > 0
      old_burned = @burned
      @burned = []
      puts to_s + "\n\n" if @debug
      old_burned.each do |y,x|
        # up
        if @matrix[y][2*x] == 2
          @matrix[y][2*x] = 3
          @burned << [y-1,x]
        end
        # left
        if x > 0
          if @matrix[y][2*x-1] == 2
            @matrix[y][2*x-1] = 3
            @burned << [y,x-1]
          end
        end
        # right
        if x + 1 < @n
          if @matrix[y][2*x+1] == 2
            @matrix[y][2*x+1] = 3
            @burned << [y,x+1]
          end
        end
        # down
        if y + 1 < @n
          if @matrix[y+1][2*x] == 2
            @matrix[y+1][2*x] = 3
            @burned << [y+1,x]
          end
        end 
      end
      puts to_s + "\n\n" if @debug
    end
  end
  
  # computes portion of bonds that belong to the global cluster
  def compute_p_infty
    unless @cluster
      @p_infty = 0
      @p_infty_all = 0
    else 
      bond_count = 0
      bond_cluster_count = 0
      @matrix.each do |row|
        row.each do |m|
          bond_count += 1 if m > 0
          bond_cluster_count += 1 if m == 3
        end
      end
      puts bond_cluster_count if @debug
      puts bond_count if @debug
      @p_infty = bond_cluster_count * 1.0 / bond_count
      @p_infty_all = bond_cluster_count * 1.0 / @n / (2*@n-1)
    end
  end
end
