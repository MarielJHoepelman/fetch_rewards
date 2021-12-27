class Point < ApplicationRecord
  def self.calculate_balance
    balance = {}

    self.all.each do |entry|
      if balance[entry[:payer]]
        balance[entry[:payer]] += entry[:points]
      else
        balance[entry[:payer]] = entry[:points]
      end
    end

    balance
  end

  def self.spend_points(params)
    result = []
    points_to_spend = params[:points].to_i
    points_balances = self.calculate_balance

    self.order(:timestamp).each do |transaction_record|
      if points_to_spend > 0 && points_balances[transaction_record[:payer]] > 0
        points_to_discount = points_to_spend > transaction_record[:points] ? transaction_record[:points] : points_to_spend
        current_entry = result.find { |e| e[:payer] == transaction_record[:payer] }

        if current_entry
          current_entry[:points] += points_to_discount
        else
          result << {
            :payer => transaction_record[:payer],
            :points => points_to_discount
          }
        end

        points_to_spend -= transaction_record[:points]
      end
    end

    result.each do |transaction_record|
      self.create(
        :payer => transaction_record[:payer],
        :points => transaction_record[:points] * -1,
        :timestamp => Time.now)
    end

    result
  end
end
