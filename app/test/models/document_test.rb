require 'test_helper'

class DocumentTest < ActiveSupport::TestCase
   test "admin user language" do
     assert AdminUser.where(:language => "").take.is_admin?
   end   
   
   test "template is outdated" do
     documents(:english).updated_at = Time.now + 1.day
     assert documents(:german).updated_at < documents(:english).updated_at
   end

   test "translator can edit" do
     assert_not admin_users(:translator).can_edit?(documents(:english))
   end

   test "is ref document" do
     assert documents(:english).is_reference_document?
   end


end
