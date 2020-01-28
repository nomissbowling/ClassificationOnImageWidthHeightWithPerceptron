require_relative "./Perceptron"

a = Perceptron.new(3)
b = Perceptron.new(5)
puts a.eta
puts b.eta

a = [1, 2, 3, 4, 5]
b = a.slice(1..3)
p b[-1]