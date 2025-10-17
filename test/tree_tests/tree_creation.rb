require_relative "../../app/services/compiler/tree"
include COMPILER
tree = Tree.new(:assignment, "=")
if tree.root.is_a?(Node)
tree.root.add_child(:variable, "num")
tree.root.add_child(:number, "5")
end
puts(tree)
