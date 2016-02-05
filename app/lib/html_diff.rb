module HtmlDiff

  class Document
    attr_accessor :content
    def initialize(str)
      @content = Nokogiri::HTML::DocumentFragment.parse str
    end
    def to_s
      return content
    end
  end

  class Compare
    attr_accessor :doc1, :doc2
    def initialize(doc1, doc2)
      @doc1 = Nokogiri::HTML::Document.parse doc1
      @doc2 = Nokogiri::HTML::Document.parse doc2
    end

    def diff
      res = Lorax.diff(doc1, doc2)
      res.deltas.each do |d|
        puts d.inspect
        case d.descriptor.first 
        when :modify
          old = d.descriptor[1][:old]
          new = d.descriptor[1][:new]
          #next if new[:content] =~ /^\s*$/ || old[:content] =~ /^\s*$/
          node = doc1.at_xpath(old[:xpath].gsub("/text()", ""))
          node.content = "--- #{old[:content]}"
          #node.name = "del"
          new_node = Nokogiri::XML::Node.new "p", node
          #node1 = Nokogiri::XML::Node.new "ins", node
          new_node.content = "+++ #{new[:content]}"
          #new_node << node1
          node.add_previous_sibling(new_node)
        when :insert
          old = d.descriptor[1]
          next if ActionView::Base.full_sanitizer.sanitize(old[:content]) =~ /^\s*$/
          node = doc1.at_xpath(old[:xpath])
          new_node = Nokogiri::XML::Node.new "p", node
          new_node.content = ActionView::Base.full_sanitizer.sanitize("--- #{old[:content]}")
          if node.children.empty? || old[:position] >= node.children.length
            node << new_node
          else
            node.children[old[:position]].add_next_sibling(new_node)
          end
          #node.add_next_sibling(new_node)
          #TODO howto deal with inserts?
        when :delete
          next if d.node.content =~ /^\s*$/
          node = doc1.at_xpath(d.node.path)
          #node.name = "del"
          #node['style'] = "color: red;"
          node.content = "--- #{d.node.content}"
        end
      end
    
      print doc1.children[1].children[0].children.to_s
      return doc1.children[1].children[0].children.to_s
    end

  end

end

