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
      #FIXME needs much improvement; maybe with document builder
      #Maybe showing selected version in editor and diffs in sidebar would be cleaner 
      if doc1.children.size == 1 && doc2.children.size == 1
        return " "
      elsif doc1.children.size == 1
        return doc2.children[1].children[0].children.to_s
      elsif doc2.children.size == 1
        return doc1.children[1].children[0].children.to_s
      end
      res = Lorax.diff(doc1, doc2)
      res.deltas.each do |d|
        puts d.inspect
        case d.descriptor.first 
        when :modify
          old = d.descriptor[1][:old]
          new = d.descriptor[1][:new]
          node = doc1.at_xpath(new[:xpath])
          node.content = "+++ #{old[:content]}"
          new_node = Nokogiri::XML::Node.new "p", node
          new_node.content = "--- #{new[:content]}"
          node.add_next_sibling(new_node)
        when :insert
          old = d.descriptor[1]
          next if ActionView::Base.full_sanitizer.sanitize(old[:content]) =~ /^\s*$/
          node = doc1.at_xpath(old[:xpath])
          new_node = Nokogiri::XML::Node.new "p", node
          new_node.content = ActionView::Base.full_sanitizer.sanitize("--- #{old[:content]}")
          if old[:position] == 1 && node.children.length == 2
            node.children[1].children[0] << new_node
          elsif node.children.empty? || old[:position] >= node.children.length
            puts "---"
            puts node.children
            node << new_node
          else
            node.children[old[:position]].add_previous_sibling(new_node)
          end
        when :delete
          next if d.node.content =~ /^\s*$/
          node = doc1.at_xpath(d.node.path)
          if d.node.path == "/html"
            next
          else
            node.content = "+++ #{d.node.content}"
          end
        end
      end
      print doc1.children[1].children[0].children.to_s
      return doc1.children[1].children[0].children.to_s
    end

  end

end

