class HomeController < ApplicationController
  def index
  end

  def graphs
  	category = Category.where(user_id: current_user.id)
    curr_expenses = current_user.expenses
  	last_week_expenses = curr_expenses.where(:created_at => 1.week.ago.beginning_of_week..1.week.ago.end_of_week)
  	this_week_expenses = curr_expenses.where(:created_at => Time.now.beginning_of_week..Time.now.end_of_week)
    @category_data = category.map{|c| [c.name,c.expenses.where(gains:false).sum("amount")]}.to_h
    @last_week_expenses = curr_expenses.where(gains:false).where(:created_at => Time.now.last_week.beginning_of_week..Time.now.end_of_week)
    @this_week_expenses = curr_expenses.where(gains:false).where(:created_at => Time.now.beginning_of_week..Time.now.end_of_week)

    @last_week_category_data = category.map{|c| [c.name,c.expenses.
    	where(gains:false).where(:created_at => Time.now.last_week.beginning_of_week..Time.now.last_week.end_of_week).
    	sum("amount")]}.to_h
    @this_week_category_data = category.map{|c| [c.name,c.expenses.
    	where(gains:false).where(:created_at => Time.now.beginning_of_week..Time.now.end_of_week).
    	sum("amount")]}.to_h

    @daily_expense_data = curr_expenses.where(gains:false).group_by_day(:created_at).sum("amount")
    @weekly_expense_data = curr_expenses.where(gains:false).group_by_week(:created_at).sum("amount")
    @monthly_expense_data = curr_expenses.where(gains:false).group_by_month(:created_at).sum("amount")



  end
end
