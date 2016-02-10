namespace :db do
  desc "Backup database"
  task :backup do
    RAILS_ENV = "development" if !defined?(RAILS_ENV)
    app_root = File.join(File.dirname(__FILE__), "..", "..")

    settings = YAML.load(File.read(File.join(app_root, "config", "database.yml")))[RAILS_ENV]
    output_file = File.join(app_root, "backup", "#{settings['database']}-#{Time.now.strftime('%Y%m%d')}.sql.gz")

    system("/usr/bin/env mysqldump -h #{settings['host']} -u #{settings['username']} -p#{settings['password']} #{settings['database']} | gzip > #{output_file}")
  end
end
