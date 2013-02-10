require_relative 'percolation'

sizes = [10, 50, 100]
props = (40..80).to_a.map{ |x| x/100.0 }
n = 1000

sizes.each do |size|
  p_cluster = []
  p_infty = []
  props.each do |p|
    p_c = 0
    p_i = 0
    n.times do
      per = Percolation.new(size, p)
      p_c += 1 if per.cluster
      p_i += per.p_infty
    end
    p_cluster << p_c * 1.0 / n
    p_infty << p_i * 1.0 / n
  end
  puts size
  puts props.join(' ')
  puts p_cluster.join(' ')
  puts p_infty.join(' ')
  puts ''
end