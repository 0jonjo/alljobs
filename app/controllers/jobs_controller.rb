  class JobsController < ApplicationController

    before_action :authenticate_headhunter!, except: [:index, :show, :search]
    before_action :find_job, only: [:show, :edit, :update, :destroy, :applies, :drafted, :archived, :published]
    before_action :user_has_profile

    def index
      which_index(:published)
    end

    def index_draft
      which_index(:draft)
      render "jobs/index"
    end

    def index_archived
      which_index(:archived)
      render "jobs/index"
    end

    def new
      @job = Job.new
    end

    def create
      @job = Job.new(job_params)
      return redirect_to @job if @job.save
      render :new
    end

    def edit; end

    def update
      return redirect_to @job if @job.update(job_params)
      render :edit
    end

    def search
      @word = params['query']
      @jobs = Job.where("code LIKE :search OR title LIKE :search OR description LIKE :search", search: "%#{@word}%")
    end

    def destroy
      @job.destroy
      redirect_to root_path
    end

    def show
      @user_applied = Apply.where(job_id: @job.id, user_id: current_user.id) if user_signed_in?
    end

    def drafted
      return redirect_to @job if @job.draft!
      render :new
    end

    def archived
      return redirect_to @job if @job.archived!
      render :new
    end

    def published
      if @job.published!
        #Adjust I18n text flash[:notice] = "You successfully starred this apply."
        return redirect_to @job
      end
      render :new
    end

    def applies; end

    private

    def job_params
      params.require(:job).permit(:title, :code, :description, :skills, :salary, :company_id, :country_id, :city, :level, :date, :job_status)
    end

    def find_job
      @job = Job.find(params[:id])
    end

    def which_index(status)
      @jobs = Job.where(job_status: status).page(params[:page])
    end
  end