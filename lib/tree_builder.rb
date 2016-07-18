#Tnode
#OpenStruct

require './parser'

class TreeBuilder
  attr_reader :root, :stack, :new_stack

  def initialize(stack)
    @stack = stack
    @root = stack[0]
    @new_stack = [stack[0]]
  end

  def make_tree
    new_stack = [@stack[0]]  
    current_child = nil
    current_parent = new_stack[0]
    @stack[1..-1].each do |node|
      if node.is_a?(OpenStruct)
        if node.tag[0..1] == "<\/"
          current_parent = current_parent.parent
          current_child = current_parent
        else
          current_parent.children << node
          node.parent = current_parent
          current_parent = node
          current_child = nil
        end
      elsif node.is_a?(TNode)
        current_parent.children << node 
        node.parent = current_parent
        current_child = nil
      end
    end
    @new_stack
  end
end

hp = HTMLParser.new
hp.load_test_html
hp.fill_stack
tree = TreeBuilder.new(hp.stack)
tree.make_tree