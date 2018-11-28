class ActionInspector < ActiveRecord::Base
  belongs_to :input_control, required: false
  belongs_to :created_user, class_name: "User", foreign_key: :created_user_id, required: false

  #has_attached_file :asset, styles: { small: "64x64", med: "100x100", large: "200x200" }

  has_attached_file :asset, styles: lambda { |a| a.instance.asset_content_type =~ %r(image) ? { medium: "300x300>", thumb: "120x90>", mini: "64x64>"} : {} }

	def is_image?
	  return false unless asset.content_type
	  ['image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png', 'image/jpg'].include?(asset.content_type)
	end
end
