class TaskMailer < ActionMailer::Base
  default from: "sistema@l7logistica.com.br"

  def notification_delivery(task)
    #data_email

    puts ">>>>>>>>>> #{ENV['RAILS_MAIL_HOST']}"
    puts ">>>>>>>>>> #{ENV['RAILS_MAIL_USERNAME']}"
    puts ">>>>>>>>>> #{ENV['RAILS_MAIL_PASSWORD']}"
    puts ">>>>>>>>>> #{ENV['RAILS_MAIL_DOMAIN']}"  
    
    @task = task

    if Rails.env.development?
      email = ENV['RAILS_MAIL_DESTINATION']
    end
    if Rails.env.production?
      email = ENV['RAILS_MAIL_DESTINATION'] #@task.employee.emails.type_sector(Sector::TypeSector::OPERACIONAL).pluck(:email)*","
    end 
    text_subject = "NOTIFICAÇÃO DE TAREFAS - Task: #{@task.id} "
    #attachments.inline['assinatura_paulo.png'] = File.read("#{Rails.root}/app/assets/images/assinatura_paulo.png")

    #send mail
    mail to: email, bcc: nil, subject: "#{text_subject}"
  end

  def notification_employee(task)
    data_email
    @task = task
    if Rails.env.development?
      email = ENV['RAILS_MAIL_DESTINATION']
    end
    if Rails.env.production?
      email = @task.employee.emails.type_sector(Sector::TypeSector::TAREFAS).pluck(:email)*","
    end 
    text_subject = "NEW TASK: #{@task.id} - Funcionário: #{@task.employee.nome.upcase} "
    
    attachments.inline['assinatura_paulo.png'] = File.read("#{Rails.root}/app/assets/images/assinatura_paulo.png")

    mail to: email, bcc: nil, subject: "#{text_subject}"
  end  

  def notification_requester(task)
    data_email
    @task = task
    if Rails.env.development?
      email = ENV['RAILS_MAIL_DESTINATION']
    end
    if Rails.env.production?
      email = @task.requester.emails.type_sector(Sector::TypeSector::TAREFAS).pluck(:email)*","
    end 
    text_subject = "START/FINISH TASK: #{@task.id} - Funcionário: #{@task.employee.nome.upcase} "
    
    attachments.inline['assinatura_paulo.png'] = File.read("#{Rails.root}/app/assets/images/assinatura_paulo.png")

    mail to: email, bcc: nil, subject: "#{text_subject}"
  end    
  
  def notification_employee_requester(task)
    data_email
    @task = task
    if Rails.env.development?
      email = ENV['RAILS_MAIL_DESTINATION']
    end
    if Rails.env.production?
      email_employee = @task.employee.emails.type_sector(Sector::TypeSector::TAREFAS).pluck(:email)*","
      email_requester = @task.requester.emails.type_sector(Sector::TypeSector::TAREFAS).pluck(:email)*","
      email = email_employee + email_requester
    end 
    text_subject = "FeedBack Task #{@task.id} - Funcionário: #{@task.employee.nome.upcase} "
    
    attachments.inline['assinatura_paulo.png'] = File.read("#{Rails.root}/app/assets/images/assinatura_paulo.png")

    mail to: email, bcc: nil, subject: "#{text_subject}"
  end    

  def data_email
    puts ">>>>>>>>>> #{ENV['RAILS_MAIL_HOST']}"
    puts ">>>>>>>>>> #{ENV['RAILS_MAIL_USERNAME']}"
    puts ">>>>>>>>>> #{ENV['RAILS_MAIL_PASSWORD']}"
    puts ">>>>>>>>>> #{ENV['RAILS_MAIL_DOMAIN']}"    
  end

end

