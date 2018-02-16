class TasksController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :destroy]
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
    @task.save
    respond_with(@task)
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
      params.require(:task).permit(:employee_id, :name, :body, :start_date, :finish_date, :time_first, :allocated, :allocated_observation, :second_time, :status, :observation)
    end
end