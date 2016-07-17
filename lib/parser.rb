Node = Struct.new(:name, :attributes, :children)
TNode = Struct.new(:contents)


class Tag
  attr_reader :type, :index, :attributes

  def initialize(type, index)
    @type = type
    @index = index
    @attributes = "nil"
  end
end

class HTMLParser
  attr_reader :main_tag, :attributes

  def initialize(html = nil)
    @stack = []
    @html = html
  end

  def fill_stack
    until @html.length < 4
      cur_tag = find_next_tag(@html)
      if @stack.length > 1 && (cur_tag.index > 0)
        contents = @html[0..cur_tag.index - 1]
        @stack << TNode.new(contents)
      end
      @stack << cur_tag
      new_index = cur_tag.index + cur_tag.type.length
      @html = @html[new_index..-1]
    end
  end

  def load_test_html
    file = File.open('../test.html', 'r')
    string = file.read
    file.close
    @html = string
  end

  def print_stack
    @stack.each do |val|
      p val
    end
  end

  def print_stack_values
    @stack.each do |val|
      if val.is_a?(Tag)
        puts "#{val.type}"
      elsif val.is_a?(TNode)
        puts "#{val.contents}"
      end
    end
  end

  def parse(string)
    data = /\s/.match(string)
    if data != nil
      pre = data.pre_match
      post = data.post_match.split(/(.*?)\s*=*'/)
      new_array = []
      new_post = post.map {|attribute| new_array << attribute.strip if !attribute.empty? }
      new_array = [pre[1..-1], new_array[0..-2]]
      @tag = new_array[0]
      @attributes = new_array[1].each_slice(2).to_a
    else
      @main_tag = /<(.*)>/.match(string)[1]
    end
  end

  def find_next_tag(html)
    match = /<.*?>/.match(html)
    loc = html =~ /<.*?>/
    tag = Tag.new(match[0], loc)
    parse(match[0])
    set_tag_attributes(tag)
  end

  def set_tag_attributes(tag)
    @attributes.each do |attribute|
      tag.instance_variable_set("@#{attribute[0]}", attribute[1])
    end
  end

  def matching_tag(tag)
    chars = tag.chars
    chars.delete_at(1)
    chars.join('')
  end

  def contains_html?(html)
    !!find_next_tag_contents(html)
  end

  def open_tag?(html)
    !!(/<[^\/].*?>/.match(html))
  end

  def close_tag?(html)
    !!(/<[\/].*?>/.match(html))
  end

  def find_next_tag_contents(html)
    match = /<.*?>(.*?)<\/.*?>/.match(html)
    match ? match[1] : false
  end

  def test_html
    "<h1>This is my <a>header link</a></h1>"
  end
end
