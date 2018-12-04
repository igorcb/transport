class EdiOccurrences::GenerateFileJob < ApplicationJob
  queue_as :edi_notfis

  def perform(*args)
    # Do something later
  end
end
