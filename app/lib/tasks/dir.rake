namespace :dir do
    desc "Watch Directory with helpfiles"
      task watch: :environment do
            Listener.watch
              end

end
