class String
  def html_diff(str2)
    html = HtmlDiff::Compare.new(self, str2)
    html.diff


    #cur = self.gsub(">", ">\n").gsub("\r", "")
    #prev = str2.gsub(">", ">\n").gsub("\r", "")
    #Diffy::Diff.new(prev, cur, :allow_empty_diff => false).to_s#.gsub("\\ No newline at end of file\n", "")
    #res.gsub( />[\+\-]+</, "><")
    #res.gsub( />[\+\-\n]*</, "><")
    #r2 = r.gsub(">+", "><p style=\"color:red;\">+++ ")
    #r2.gsub("<p>-", "<p>--- ")
  end
end
