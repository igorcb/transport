class TasksController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :task_owner, only: [:edit, :update]
  load_and_authorize_resource
  respond_to :html  

  def index
    #@tasks = Task.all
    #respond_with(@tasks)
    @q = Task.where(status: -1).search(params[:query])
    @tasks = Task.the_day
    respond_with(@tasks)    
  end

  def show
    @internal_comment = @task.internal_comments.build
    respond_with(@task)
  end

  def new
    @task = Task.new
    respond_with(@task)
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    @task.requester = current_user
    respond_to do |format|
      if @task.save
        
        Notification.create(recipient: @task.employee, actor: current_user, action: 'taskd', notifiable: @task)
        @task.send_email_employee
        #@task.send_notification_email
        format.html { redirect_to @task, flash: { success: "TASK was successfully created." } }
        format.json { render action: 'show', status: :created, location: @task }
      else
        format.html { render action: 'new' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end    
  end

  def update
    @task.update(task_params)
    respond_with(@task)
  end

  def destroy
    @task.destroy
    respond_with(@task)
  end

  def search
    @q = Task.search(params[:query])
    @tasks = @q.result
    respond_with(@tasks) do |format|
     format.js
    end
  end    

  def start
    if @task.status == Task::TypeStatus::INICIADO
      flash[:danger] = "Task already started."
      redirect_to task_path(@task)
      return
    end    
    if @task.finished?
      flash[:danger] = "Task already finished."
      redirect_to task_path(@task)
      return
    end    
    if @task.start
      @task.reload
      @task.send_email_requester
      flash[:success] = "Task was successfully start"
    else
      @task.errors.full_messages.each { |msg| flash[:danger] = msg }
    end
    redirect_to task_path(@task)    
  end

  def finish
    if @task.status == Task::TypeStatus::NAO_INICIADO
      flash[:danger] = "Can not end task that was not started."
      redirect_to task_path(@task)  
      return
    end    
    if @task.date_finalization.present?
      flash[:danger] = "Task already finished."
      redirect_to task_path(@task)  
      return
    end    
    if @task.finish
      @task.reload
      @task.send_email_requester
      flash[:success] = "Task was successfully finish"
    else
      @task.errors.full_messages.each { |msg| flash[:danger] = msg }
    end
    redirect_to task_path(@task)    
  end

  private
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:employee_id, :name, :body, :start_date, :finish_date, :time_first, :allocated, 
        :allocated_observation, :second_time, :status, :observation, :second_employee_id,
        assets_attributes: [:asset, :id, :_destroy]
        )
    end

    def task_owner
      @task = Task.find(params[:id])
      if @task.requester != current_user
        flash[:danger] = "You not permission to edit task."
        redirect_to task_path(@task)
      end
    end
end
