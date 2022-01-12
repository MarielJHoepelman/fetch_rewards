class PointsController < ApplicationController

  def balance
    render json: Point.calculate_balance
  end

  def add
    transaction = Point.create(add_points_params)

    if transaction.valid?
      render json: transaction
    else
      render json: transaction.errors, status: 400
    end
  end

  def spend
    if Point.calculate_global_balance == 0
      render json: {error: "this account does not have points available to spend"}, status: 400
    else
      render json: Point.spend_points(spend_points_params)
    end
  end

  private

  def add_points_params
    params.permit(:payer, :points, :timestamp)
  end

  def spend_points_params
    params.permit(:points)
  end

end
