class StretchRoute < ActiveRecord::Base

	validates :stretch_source_id, presence: true
	#validates :stretch_target_id, presence: true
	validates :stretch_target_id, presence: true, uniqueness: {scope: :stretch_source_id, message: ": Trechos de origem e destino já estão em uso."}
	#validates :size, inclusion: { in: %w(small medium large),	message: "%{value} is not a valid size" }, allow_nil: true

	belongs_to :stretch_source, class_name: "Stretch", foreign_key: 'stretch_source_id', required: false
	belongs_to :stretch_target, class_name: "Stretch", foreign_key: 'stretch_target_id', required: false

	#scope :order_stretch, -> { joins(:stretch_source).order('stretch.estado desc') }
	scope :state_source, -> (state) { StretchRoute.includes(:stretch_source).where(stretches: {estado: state}).order(:id) }
	scope :state_target, -> (state) { StretchRoute.includes(:stretch_target).where(stretches: {estado: state}).order(:id) }
	scope :state_source_and_target, -> (state_source, state_target) { StretchRoute.joins(:stretch_source, :stretch_target).where(stretches: {estado: state_source}, stretch_targets_stretch_routes: {estado: state_target}).order("stretch_targets_stretch_routes.destino asc") }


	def stretch_source_and_target_long
		"#{stretch_source.destino}/#{stretch_source.estado}/#{stretch_source.cidade} para #{stretch_target.destino}/#{stretch_target.estado}/#{stretch_target.cidade}"
	end

	def stretch_source_and_target_short
		"#{stretch_source.destino}/#{stretch_target.destino}"
	end

	#StretchRoute.joins(:stretch_source, :stretch_target)


end
