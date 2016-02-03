ActiveAdmin.register_page "Dashboard" do

  #menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }
  menu false

  content title: proc{ I18n.t("active_admin.dashboard") } do
    #div class: "blank_slate_container", id: "dashboard_default_message" do
    #  span class: "blank_slate" do
    #    span I18n.t("active_admin.dashboard_welcome.welcome")
    #    small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #  end
    #end

    # Here is an example of a simple dashboard with columns and panels.
    #
     columns do
       column do
         panel "Recent Updates" do
           table_for(Translation.order(:updated_at => :desc)[0..5]) do
             column do |o| link_to(o.original.tag, admin_guideline_path(o.original)) end
               column :tag
               column :updated_at
               column :language
           end
         end
       end

       column do
         panel "Info" do
           para "Welcome to ActiveAdmin."
         end
       end
     end
  end # content
end
