require 'test_helper'

class DocumentTest < ActiveSupport::TestCase
   test "admin user language" do
     assert AdminUser.first.is_admin?
   end
end
