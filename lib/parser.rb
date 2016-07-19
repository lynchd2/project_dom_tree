require 'ostruct'
#Tag = Struct.new(:tag, :content, :index, :children, :parent)

#Node = Struct.new(:name, :attributes, :children)
TNode = Struct.new(:tag, :contents, :children, :parent)


class HTMLParser
  attr_reader :main_tag, :stack
  attr_accessor :attributes

  def initialize(html = nil)
    @stack = []
    @html = html
    @attributes = ""
  end

  def fill_stack
    until @html.length < 4
      cur_tag = find_next_tag(@html)
      if @stack.length > 1 && (cur_tag.index > 0)
        contents = @html[0..cur_tag.index - 1].strip
        @stack << TNode.new("text", contents, []) unless contents.length <= 1
      end
      @stack << cur_tag
      new_index = cur_tag.index + cur_tag.contents.length
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
      if val.is_a?(TNode)
        puts "#{val.contents}"
      elsif val.is_a?(OpenStruct)
        puts "#{val.contents}"
      else
        puts "#{val.contents}"
      end
    end
  end

  def parse(string)
   matched =  /<.*?\s(.*?)\s*="(.*?)">/.match(string)
   @attributes = [matched[1], matched[2]] if matched != nil
  end

  def find_next_tag(html)
    match = /<.*?>/.match(html)
    @attributes = parse(match[0])
    type = /<(.*?)\s/.match(match[0])
    type = type[1] if type
    loc = html =~ /<.*?>/
    tag = set_tag_attributes(type, match[0], loc, @attributes, nil) if @attributes != nil
    tag = OpenStruct.new(tag: match[0], contents: match[0], index: loc, children: [], parent: nil) if @attributes == nil
    tag
  end

  def set_tag_attributes(type, tag, loc, attributes, parent)
      if attributes[0] == "class"
        attributes[0] = attributes[0] << "_attribute"
      end
      tag = OpenStruct.new(tag: "<" + type + ">", contents: tag, index: loc, attributes[0] => attributes[1], children: [], parent: nil)
      tag
  end

###############################3
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
