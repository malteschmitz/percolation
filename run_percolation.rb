require_relative 'percolation'

size = 200
props = [0.4, 0.45, 0.5, 0.525, 0.55, 0.56, 0.57, 0.58, 0.59, 0.6, 0.61, 0.62,
         0.63, 0.64, 0.65, 0.675, 0.7, 0.75, 0.8]
n = 200

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
puts props.join(' ')
puts p_cluster.join(' ')
puts p_infty.join(' ')