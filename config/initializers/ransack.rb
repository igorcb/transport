Ransack.configure do |config|

  # Change default search parameter key name.
  # Default key name is :q
  config.search_key = :query

  # Raise errors if a query contains an unknown predicate or attribute.
  # Default is true (do not raise error on unknown conditions).
  config.ignore_unknown_conditions = false

  # config.add_predicate 'date_equals',
  #     arel_predicate: 'eq',
  #     formatter: proc { |v| process_user_date_search_string(v).to_date },
  #     validator: proc { |v| v.present? },
  #     type: :string

  config.add_predicate 'date_equals',
      arel_predicate: 'eq',
      formatter: proc { |v| v.to_date },
      validator: proc { |v| v.present? },
      type: :string
  
end
