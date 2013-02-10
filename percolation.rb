require 'matrix'

require_relative 'disjoint_set_node'

# extend matrix class and make it writeable
class PercolMatrix < Matrix
  def []=(i, j, x)
    @rows[i][j] = x
  end
  
  def to_s
    keys = {}
    max = 2
    @rows.collect do |row|
      row.collect do |e|
        if e.respond_to?(:find)
          unless keys.has_key?(e.find)
            keys[e.find] = max
            max += 1
          end
          keys[e.find]
        elsif e
          1
        else
          0
        end
      end.join(' ')
    end.join("\n")
  end
end

# site percolation
class Percolation
  attr_reader :cluster, :p_infty

  # n = size of grid
  # p = propability for one site of being set
  def initialize(n,p)
    @n = n
    @matrix = PercolMatrix.build(n) do
      rand < p
    end
    find_percolation
    compute_p_infty
  end

  private
  
  # find a global cluster that connects first row with last row
  def find_percolation
    # list of burned sites in last step
    @burned = []
    
    # keep track if global cluster
    @cluster = nil
    
    # puts @matrix.to_s + "\n\n"
    
    # start burning every site with y == 0
    0.upto(@n-1) do |x|
      if @matrix[0,x]
        @matrix[0,x] = DisjointSetNode.new
        @burned << [0,x]
      end
    end
    
    # puts @matrix.to_s + "\n\n"
    
    # run burning steps
    while @burned.length > 0
      old_burned = @burned
      @burned = []
      old_burned.each do |y,x|
        burn([y, x], [y-1, x]) if y > 0
        burn([y, x], [y+1, x]) if y + 1 < @n
        burn([y, x], [y, x-1]) if x >  0
        burn([y, x], [y, x+1]) if x + 1 < @n
      end
      # puts @matrix.to_s + "\n\n"
    end
  end
  
  def burn(c1, c2)
    if m = @matrix[c2[0], c2[1]]
      if m.respond_to?(:union)
        m.union(@matrix[c1[0], c1[1]])
      else
        @matrix[c2[0], c2[1]] = @matrix[c1[0], c1[1]]
        @cluster = @matrix[c2[0], c2[1]] if c2[0] == @n - 1
        @burned << c2
      end
    end
  end
  
  # computes portion of points that belong to the global cluster
  def compute_p_infty
    unless @cluster
      @p_infty = 0
    else 
      c = @cluster.find
      point_count = 0
      point_cluster_count = 0
      @matrix.each do |m|
        point_count += 1 if m
        if m.respond_to?(:find)
          point_cluster_count += 1 if m.find == c
        end
      end
      # puts point_cluster_count
      # puts point_count
      @p_infty = point_cluster_count * 1.0 / point_count
    end
  end
end
