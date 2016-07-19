require './parser'
require './tree_builder'

class RebuildDom
  def initialize(tree)
    @tree = tree
  end

  def rebuild_dom
    queue = []
    File.open("rebuilt_dom.html", "w") do |file|
      @tree
      @tree.children.each do |child|
        queue << child
        queue << child.contents if child.children.empty?
      end
    end
  end


end



hp = HTMLParser.new
hp.load_test_html
hp.fill_stack
tree = TreeBuilder.new(hp.stack)
tree.make_tree
rebuild = RebuildDom.new(tree.root)
rebuild.rebuild_dom