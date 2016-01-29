ActiveAdmin.register Facility ,as: "Translation" do

  permit_params :marc_field_id, :language, :entity, :help_text

  scope :german
  scope :italian
  scope :french

  form do |f|
    f.inputs 'Facility' do
      f.input :marc_field, :as => :select, :include_blank => false
      f.input :language, :as => :select, :collection => %w(German French Italian)
      #input :entity, :as => :select, :collection => %w(Source Person Institution Catalogue)
      f.input 'Reference', :as => :text, :input_html => {:value => resource.marc_field.read_helpfile, :readonly => true } if resource.marc_field
      f.input :help_text, :as => :html_editor, :input_html => {:value => resource.read_helpfile } if resource.marc_field# resource.read_helpfile emd
      f.actions
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
