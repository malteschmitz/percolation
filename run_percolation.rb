require_relative 'site_percolation'
require_relative 'bond_percolation'

bond_props = [0.4, 0.425, 0.45, 0.46, 0.47, 0.48, 0.49, 0.5, 0.51,
              0.52, 0.53, 0.54, 0.55, 0.575, 0.6, 0.65, 0.7, 0.8]
site_props = [0.4, 0.45, 0.5, 0.525, 0.55, 0.56, 0.57, 0.58, 0.59, 0.6, 0.61,
              0.62, 0.63, 0.64, 0.65, 0.675, 0.7, 0.75, 0.8]

size = 200
n = 100
props = bond_props
klass = BondPercolation

p_cluster = []
p_infty = []
p_infty_all = []
props.each do |p|
  p_c = 0
  p_i = 0
  p_i_a = 0
  n.times do
    per = klass.new(size, p)
    p_c += 1 if per.cluster
    p_i += per.p_infty
    p_i_a += per.p_infty_all
  end
  p_cluster << p_c * 1.0 / n
  p_infty << p_i * 1.0 / n
  p_infty_all << p_i_a * 1.0 / n
end
puts props.join(' ')
puts p_cluster.join(' ')
puts p_infty.join(' ')
puts p_infty_all.join(' ')