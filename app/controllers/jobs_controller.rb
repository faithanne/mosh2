class JobsController < ApplicationController
  # GET /jobs
  # GET /jobs.json
  def index
    @jobs = Job.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @jobs }
    end
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
    @job = Job.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @job }
    end
  end

  # GET /jobs/new
  # GET /jobs/new.json
  def new
    @job = Job.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @job }
    end
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @job = current_user.jobs.new(params[:job])
    @job.set_pending
    @job.due_date = DateTime.strptime(params[:job][:due_date], '%m/%d/%Y').to_date
    @job.finalize = false;

    respond_to do |format|
      if @job.save
        format.html { redirect_to @job, notice: 'Job was successfully created.' }
        format.json { render json: @job, status: :created, location: @job }
      else
        format.html { render action: "new" }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /jobs/1
  # PUT /jobs/1.json
  def update
    @job = Job.find(params[:id])
    @job.due_date = DateTime.strptime(params[:job][:due_date], '%m/%d/%Y').to_date

    respond_to do |format|
      if @job.update_attributes(params[:job])
        format.html { redirect_to @job, notice: 'Job was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  def finalize
    @job = Job.find(params[:job_id])
    @job.set_finalize

    if @job.save

      @poster_overview = PosterOverview.create!(id: @job.id, job_id: @job.id)
      if @poster_overview.save
        @date = @job.format_date
        PosterMailer.new_job(@poster_overview.id, current_user.id, @date).deliver 
      end

      redirect_to @poster_overview, notice: 'Your job was finalized.'
    else
      redirect_to @job, notice: 'Your job could not be finalized.'
    end
  end

  def finish
    @job = Job.find(params[:job_id])
    @job.set_finished

    if @job.save
      redirect_to @job, notice: 'Job was successfully finished.'
    else
      redirect_to @job, notice: 'Job could not be finished.'
    end
  end

  def deny
    @job = Job.find(params[:job_id])
    @job.set_denied

    if @job.save
      redirect_to @job, notice: 'Job was denied.'
    else
      redirect_to @job, notice: 'Job could not be denied.'
    end
  end

  def pend
    @job = Job.find(params[:job_id])
    @job.set_pending

    if @job.save
      redirect_to @job, notice: 'Job is pending.'
    else
      redirect_to @job, notice: 'Job could not be pended.'
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to jobs_url }
      format.json { head :no_content }
    end
  end
end
