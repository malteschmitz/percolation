require_relative 'percolation'

size = 10
props = (40..80).to_a.map{ |x| x/100.0 }
n = 1000

start = Time.now
props.each do |p|
  n.times do
    Percolation.new(10, p)
  end
end
puts Time.now - start