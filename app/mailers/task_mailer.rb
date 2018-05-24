class TaskMailer < ActionMailer::Base
  
  default from: "from@example.com"

  def notification_employee(task)
    @task = task
    if Rails.env.development?
      email = ENV['RAILS_MAIL_DESTINATION']
    end
    if Rails.env.production?
      email = @task.employee.emails.type_sector(Sector::TypeSector::CONFIRMACAO_ENTREGA).pluck(:email)*","
    end 
    text_subject = "NEW TASK: #{@task.id} - Funcionário: #{@task.employee.nome.upcase} "
    
    attachments.inline['assinatura_paulo.png'] = File.read("#{Rails.root}/app/assets/images/assinatura_paulo.png")

    mail to: email, bcc: nil, subject: "#{text_subject}"
  end  

  def notification_requester(task)
    @task = task
    if Rails.env.development?
      email = ENV['RAILS_MAIL_DESTINATION']
    end
    if Rails.env.production?
      email = @task.requester.emails.type_sector(Sector::TypeSector::CONFIRMACAO_ENTREGA).pluck(:email)*","
    end 
    text_subject = "START/FINISH TASK: #{@task.id} - Funcionário: #{@task.employee.nome.upcase} "
    
    attachments.inline['assinatura_paulo.png'] = File.read("#{Rails.root}/app/assets/images/assinatura_paulo.png")

    mail to: email, bcc: nil, subject: "#{text_subject}"
  end    
end
