ActiveAdmin.register Facility do

  permit_params :name, :marc_field, :language, :entity, :help_text

  scope :english
  scope :german
  scope :italian
  scope :french

  form do |f|
    inputs 'Facility' do
      input :name
      input :marc_field
      input :language, :as => :select, :collection => %w(English German French Italian)
      input :entity, :as => :select, :collection => %w(Source Person Institution Catalogue)
      input 'Reference', :as => :text, :input_html => {:value => resource.read_reference, :readonly => true }# resource.read_helpfile emd
      input :help_text, :as => :html_editor, :input_html => {:value => resource.read_helpfile }# resource.read_helpfile emd
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
