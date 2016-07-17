class ParseData
  attr_accessor :attributes, :tag, :string
  def initialize(string)
    @string = string
    @attributes = nil
  end

  def parse_tag
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
      @tag = /<(.*)>/.match(string)[1]
    end
  end

end

parsed = ParseData.new("<p class = 'blah', id = 'blahblah', name:'name'>")
parsed.parse_tag
Tag = Struct.new(:tag, :class, :id, :name)
tag = Tag.new(parsed.tag, parsed.class, parsed.id, parsed.name)
p tag.class
