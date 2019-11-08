module Conferences
  class DeleteConferenceAllService
    #Service usado apenas para apagar os items na conferencia automatico
    #Usar apenas para testes
    def initialize(input_control)
      @input_control = input_control
    end

    def call
      @input_control.conferences.destroy_all
      @input_control.breakdowns.destroy_all
      @input_control.update(status:5, avaria: nil, date_start_avaria: nil, date_finish_avaria: nil, time_start_avaria: nil, time_finish_avaria: nil)
    end

    private
  end
end
