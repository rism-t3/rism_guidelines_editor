ActiveAdmin::Editor.configure do |config|
  # config.s3_bucket = ''
  # config.aws_access_key_id = ''
  # config.aws_access_secret = ''
  # config.storage_dir = 'uploads'
  config.parser_rules['tags']['del'] = {
        'remove' => 0
  }
  config.parser_rules['tags']['ins'] = {
        'remove' => 0
  }

end
