ActiveAdmin.register MarcField do
  permit_params :tag, :helptext, :facility

  action_item :translate, only: :index do
      link_to 'translate', new_admin_translation_path
  end

  index do
    column :tag
    column :translations do |r|
      r.facilities.map(&:language).sort.join(", ")
    end
     actions defaults: true do |r|
        link_to "Translate", new_admin_translation_path(:facility => { :marc_field_id => r.id })
       end
    #ctions
  end

  form do |f|
    inputs 'MarcField' do
      input :tag
      input :helptext, :as => :html_editor, :input_html => {:value => resource.read_helpfile }# resource.read_helpfile emd
      actions
    end
  end






  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end


end
