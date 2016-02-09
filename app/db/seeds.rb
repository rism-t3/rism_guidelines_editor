Language.create(:code =>'en', :name => 'English', :image => "en.png")
Language.create(:code =>'fr', :name => 'French', :image => "fr.png")
Language.create(:code =>'de', :name => 'German', :image => "de.png")
Language.create(:code =>'it', :name => 'Italian', :image => "it.png")
Language.create(:code =>'es', :name => 'Spanish', :image => "es.png")

reference_language = Language.where(:code => App::REFERENCE_LANGUAGE).take

FileSystem.new.sort_by_reference_language.each do |file|
  next if App::EXCLUDED_FILES.include?(file.filename)
  begin
    if file.language == App::REFERENCE_LANGUAGE
      Document.create(:tag => file.tag, :content => file.content, :filename => file, :language => Language.where(:code => 'en').take)
    else
      original = Document.where(:tag => file.tag).where(:language => reference_language).take
      Document.create(:tag => file.tag, :content => file.content, :filename => file, :language => Language.where(:code => file.language).take, :template_id => original.id)
    end
  rescue
    puts file.tag
  end
end
