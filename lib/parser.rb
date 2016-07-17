require 'ostruct'
Tag = Struct.new(:type, :index, :children)

#Node = Struct.new(:name, :attributes, :children)
TNode = Struct.new(:contents)


class HTMLParser
  attr_reader :main_tag
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
   matched =  /<.*?\s(.*?)\s*="(.*?)">/.match(string)
   @attributes = [matched[1], matched[2]] if matched != nil
  end

  def find_next_tag(html)
    match = /<.*?>/.match(html)
    @attributes = parse(match[0])
    p @attributes
    loc = html =~ /<.*?>/
    tag = set_tag_attributes(match[0], loc, @attributes) if @attributes != nil
    tag = OpenStruct.new(type: match[0], index: loc) if @attributes == nil
    tag
  end

  def set_tag_attributes(tag, loc, attributes)
      tag = OpenStruct.new(type: tag, index: loc, attributes[0] => attributes[1])
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
