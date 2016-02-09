class Language < ActiveRecord::Base

  def self.codes
    Language.all.map(&:code)
  end
  
  def self.reference
    Language.where(:code => App::REFERENCE_LANGUAGE).take
  end

end
