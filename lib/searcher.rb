require './parser'
require './tree_builder'

class Searcher
  attr_reader :tree

  def initialize(tree)
    @tree = tree
    @total_descendents_attributes = []
    @total_ancestors_attributes = []
  end

  #This searches both direct ancestors and all nodes of a particular tree.(1 and 2 from the Searcher exercises)
  #Just switch the node parameter with any node you want to search from.
  def search_descendents(node, attribute)
    return if node.children == []
    node.children.select do |child|
      @total_descendents_attributes << child if child.respond_to?(attribute)
      search_descendents(child, attribute)
    end
    return @total_descendents_attributes
  end

  def reset_node_with_descendents
    @total_descendents_attributes = []
  end

  def search_ancestors(node, attribute)
    if node.parent == nil
      return
    end
    @total_ancestors_attributes << node.parent if node.parent.respond_to?(attribute)
    search_ancestors(node.parent, attribute)
    return @total_ancestors_attributes
  end

  def reset_node_with_ancestors
    @total_ancestors_attributes = 0
  end

end


hp = HTMLParser.new
hp.load_test_html
hp.fill_stack
#hp.print_stack
t = TreeBuilder.new(hp.stack)
tree = t.make_tree

s = Searcher.new(tree)
#s.search_descendents(t.root, "class_attribute")
s.reset_node_with_descendents
p s.search_ancestors(t.root.children[1].children[0].children[1].children[2], "class_attribute").length