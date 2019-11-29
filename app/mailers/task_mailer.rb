class TaskMailer < ActionMailer::Base
  default from: "sistema@yohanmws.com.br"

  def notification_employee(task)

    @task = task

    # if Rails.env.development?
    #   email = ENV['RAILS_MAIL_DESTINATION']
    # end
    # if Rails.env.production?
    #   #primary_employee = @task.employee.emails.type_sector(Sector::TypeSector::TAREFAS).pluck(:email)
    #   primary_employee = @task.employee.email
    #   email = primary_employee
    #   if @task.second_employee.present?
    #     #second_employee  = @task.second_employee.emails.type_sector(Sector::TypeSector::TAREFAS).pluck(:email)
    #     second_employee  = @task.second_employee.email
    #     email = primary_employee + ', ' + second_employee
    #   end
    #   email
    # end
    #   #primary_employee = @task.employee.emails.type_sector(Sector::TypeSector::TAREFAS).pluck(:email)


    # primary_employee = @task.employee.email
    # email = primary_employee
    # if @task.second_employee.present?
    #   #second_employee  = @task.second_employee.emails.type_sector(Sector::TypeSector::TAREFAS).pluck(:email)
    #   second_employee  = @task.second_employee.email
    #   email = primary_employee + ', ' + second_employee
    # end

    email = @task.users.pluck(:email)

    text_subject = "NEW TASK: #{@task.id} - Funcionário: #{@task.employee.name.upcase} "

    attachments.inline['assinatura_paulo.png'] = File.read("#{Rails.root}/app/assets/images/assinatura_paulo.png")

    mail to: email, bcc: nil, subject: "#{text_subject}"
  end

  def notification_requester(task)
    @task = task
    if Rails.env.development?
      email = ENV['RAILS_MAIL_DESTINATION']
    end
    if Rails.env.production?
      # email_employee = @task.employee.emails.type_sector(Sector::TypeSector::TAREFAS).pluck(:email)
      # email_requester = @task.requester.emails.type_sector(Sector::TypeSector::TAREFAS).pluck(:email)
      email_employee = @task.employee.email
      email_requester = @task.requester.email
      email = email_employee + ', ' + email_requester
      if @task.second_employee.present?
        #second_employee  = @task.second_employee.emails.type_sector(Sector::TypeSector::TAREFAS).pluck(:email)
        second_employee  = @task.second_employee.email
        email = email_employee + ', ' + email_requester + ', ' + second_employee
      end
      email
    end

    text_subject = "START/FINISH TASK: #{@task.id} - Funcionário: #{@task.employee.name.upcase} "

    attachments.inline['assinatura_paulo.png'] = File.read("#{Rails.root}/app/assets/images/assinatura_paulo.png")

    mail to: email, bcc: nil, subject: "#{text_subject}"
  end

  def notification_employee_requester(task)
    @task = task
    if Rails.env.development?
      email = ENV['RAILS_MAIL_DESTINATION']
    end
    if Rails.env.production?
      # email_employee = @task.employee.emails.type_sector(Sector::TypeSector::TAREFAS).pluck(:email)
      # email_requester = @task.requester.emails.type_sector(Sector::TypeSector::TAREFAS).pluck(:email)
      email_employee = @task.employee.email
      email_requester = @task.requester.email
      email = email_employee + ', ' + email_requester
      if @task.second_employee.present?
        #second_employee  = @task.second_employee.emails.type_sector(Sector::TypeSector::TAREFAS).pluck(:email)
        second_employee  = @task.second_employee.email
        email = email_employee + ', ' + email_requester + ', ' + second_employee
      end
      email
    end
    text_subject = "FeedBack Task #{@task.id} - Funcionário: #{@task.employee.name.upcase} "
    attachments.inline['assinatura_paulo.png'] = File.read("#{Rails.root}/app/assets/images/assinatura_paulo.png")


    mail to: email, bcc: nil, subject: "#{text_subject}"
  end

end
