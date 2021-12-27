class PointsController < ApplicationController

  def balance
    balance = Point.calculate_balance

    render json: balance
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
    result = Point.spend_points(spend_points_params).map do |entry|
      {
        :payer => entry[:payer],
        :points=> entry[:points] * -1
      }
    end

    render json: result
  end

  private

  def add_points_params
    params.permit(:payer, :points, :timestamp)
  end

  def spend_points_params
    params.permit(:points)
  end
end
