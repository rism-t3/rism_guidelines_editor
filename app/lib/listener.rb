class Listener

  def self.watch
    listener = Listen.to(App::HELP_FILES, only: /\w+_[a-z]{2}\.html$/) do |modified, added, removed|
      Document.modify(modified.first) unless modified.empty?
      Document.add(added.first) unless added.empty?
      puts "removed absolute path: #{removed}" unless removed.empty?
    end
    listener.start # not blocking
    sleep
  end
end
