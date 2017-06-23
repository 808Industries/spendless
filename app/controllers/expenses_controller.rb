class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  # GET /expenses
  # GET /expenses.json
  def index
    @user = current_user
    if current_user != nil and current_user.current_balance == nil
      current_user.current_balance = 0.0
      current_user.save
    end
    if current_user != nil
      @expense_this_week = current_user.expenses.where(:created_at => Time.now.beginning_of_week..Time.now, :gains => false).sum("amount")
      @expense = Expense.new
      @category = Category.new
      category = Category.where(user_id: current_user.id)
      @category_data = category.map{|c| [c.name,c.expenses.where(user_id: current_user.id).sum("amount")]}.to_h
      @daily_expense_data = current_user.expenses.group_by_day(:created_at).sum("amount")
      @expenses = current_user.expenses.paginate(:page => params[:page], :per_page => 5).where(:created_at => 30.days.ago..Time.now).order("created_at DESC")
    end
  end

  # GET /expenses/1
  # GET /expenses/1.json
  def show
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
  end

  # GET /expenses/1/edit
  def edit
  end

  # POST /expenses
  # POST /expenses.json
  def create
    @expense = Expense.new(expense_params)
    @user = current_user
    @expense.user_id = current_user.id    
    if @expense.gains
      @user.current_balance = @user.current_balance + @expense.amount
    else
      @user.current_balance = @user.current_balance - @expense.amount
    end
    @user.save

    respond_to do |format|
      if @expense.save
        format.html { redirect_to '/expenses', notice: 'Expense was successfully created.' }
        format.json { render :show, status: :created, location: @expense }
      else
        format.html { render :new }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1
  # PATCH/PUT /expenses/1.json
  def update
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to '/expenses', notice: 'Expense was successfully updated.' }
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
    @user = current_user
    if @expense.gains
      @user.current_balance = @user.current_balance - @expense.amount
    else
      @user.current_balance = @user.current_balance + @expense.amount
    end
    @user.save
    @expense.destroy
    respond_to do |format|
      format.html { redirect_to expenses_url, notice: 'Expense was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expense_params
      params.fetch(:expense, {}).permit(:expense, :cost, :date, :category_id, :amount, :gains)
    end
end
