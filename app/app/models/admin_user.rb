class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
  def can_edit?(trans)
    return true if !self.language || self.language.empty?
    if trans.class.to_s == 'String'
      return trans == self.language ? true : false
    end
    trans.language == self.language ? true : false
  end

end
