json.array!(@tasks) do |task|
  json.extract! task, :id, :employees_id, :name, :body, :start_date, :finish_date, :time_first, :allocated, :allocated_observation, :second_time, :status, :observation
  json.url task_url(task, format: :json)
end
