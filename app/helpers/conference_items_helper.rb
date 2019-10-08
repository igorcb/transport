module ConferenceItemsHelper
  def location_item_conference(conference_id, product_id)
    conference_items = ConferenceItem.where(conference_id:conference_id, product_id: product_id).first
    #conference_items.id if conference_items.present?
    result = conference_items.present? ? conference_items.id : ""
  end
end
