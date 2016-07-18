require './parser'
require './tree_builder'

class Render
  attr_reader :total, :tree, :hash
  def initialize(tree)
    @tree = tree
    @total_nodes = 1
    @type_count = {}
  end


  def total_sub_nodes(node)
    return if node.children == []
    node.children.each do |child|
      total_sub_nodes(child)
      @total_nodes += 1
    end
    return @total_nodes
  end

  def reset_counter
    @total = 0
  end


  def node_type(node)
    return if node.children == []
    node.children.each do |child| 
      if @type_count[child.tag]
        @type_count[child.tag] +=1 
      else
        @type_count[child.tag] = 1
      end
      node_type(child)
    end
    @type_count
  end

  def reset_hash
    @hash = {}
  end

  def data_attributes(node)
    puts "The #{node.tag}'s class is: #{node.class_attribute}" if node.class != nil  
    puts "The #{node.tag}'s id is: #{node.id}" if node.id != nil
  end

end


hp = HTMLParser.new
hp.load_test_html
hp.fill_stack
hp.print_stack
tree = TreeBuilder.new(hp.stack)
actual_tree = tree.make_tree
r = Render.new(actual_tree)
#r.total
r.total_sub_nodes(tree.root)
#r.reset_counter
r.total_sub_nodes(tree.root)
#puts r.node_type(tree.root)
#r.reset_hash
r.data_attributes(tree.root.children[1].children[0])

