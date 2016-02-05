# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def get_lang(filename)
  lang=filename.gsub(/^\S+_([a-z]{2})\.html/, '\1')
  lang ? lang : ""
end

def get_marc(filename)
 marc=filename.gsub(/^\S+\/([0-9]{3})\S+$/, '\1')
 marc ? marc : ""
end

def get_abbr(filename)
 marc=filename.gsub(/^\S+\/abbr_(\w+)_\S+$/, '\1')
 marc ? marc : ""
end

def get_aid(filename)
 marc=filename.gsub(/^\S+\/aid_(\w+)_\S+$/, '\1')
 marc ? marc : ""
end

def get_name(filename)
 marc=filename.gsub(/^\S+\/(\w+)_\S+$/, '\1')
 marc ? marc : ""
end

files = Dir["#{App::HELP_FILES}*.html"]

files.each do |file|
  #if file =~ /^\S*\/[0-9]{3}\S+$/
  next if get_name(file)=='header' || get_name(file)=='footer'
    if get_lang(file) == 'en'
      begin 
        Original.create(:tag => get_name(file), :content => File.read(file), :filename => file)
      rescue
        puts file
      end
    end
  #end
end

files.each do |file|
  next if get_name(file)=='header' || get_name(file)=='footer'
  #Marc_Fields
  #if file =~ /^\S*\/[0-9]{3}\S+$/
    if get_lang(file) != 'en'
      original = Original.where(:tag => get_name(file)).take
      if original
        Translation.create(:language => get_lang(file), :content => File.read(file), :original_id => original.id, :filename => file)
      end
    end
    #uts get_marcfield(file)
  #Abbreviations
  #elsif file =~ /^\S*\/abbr_\S+$/
    #uts file
  #elsif file =~ /^\S*\/aid_\S+$/
    #puts get_aid(file)
    #puts file
  #elsif file =~ /^\S*\/cat_\S+$/
    #puts file
  #else
    #puts file
    #puts get_language(file)
    #puts get_name(file)
  #end
end
