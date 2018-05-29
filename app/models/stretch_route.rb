class StretchRoute < ActiveRecord::Base

	validates :stretch_source_id, presence: true
	#validates :stretch_target_id, presence: true
	validates :stretch_target_id, presence: true, uniqueness: {scope: :stretch_source_id, message: ": Trechos de origem e destino já estão em uso."}
	#validates :size, inclusion: { in: %w(small medium large),	message: "%{value} is not a valid size" }, allow_nil: true	

	belongs_to :stretch_source, class_name: "Stretch", foreign_key: 'stretch_source_id'
	belongs_to :stretch_target, class_name: "Stretch", foreign_key: 'stretch_target_id'

	#scope :order_stretch, -> { joins(:stretch_source).order('stretch.estado desc') }


	def stretch_source_and_target_long
		"#{stretch_source.destino}/#{stretch_source.estado}/#{stretch_source.cidade} para #{stretch_target.destino}/#{stretch_target.estado}/#{stretch_target.cidade}"
	end

	def stretch_source_and_target_short
		"#{stretch_source.destino}/#{stretch_target.destino}"
	end

	#StretchRoute.joins(:stretch_source, :stretch_target)


end
