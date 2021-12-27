class Point < ApplicationRecord
  validates :payer, :points, :timestamp, presence: true
  validates :points, numericality: true

  # Calculates the available points to spend group by payer.
  # Returns:
  # => {
  #     "DANNON": 1000,
  #     "UNILEVER": 0,
  #     "MILLER COORS": 5300
  #   }
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

# Receives a request to spend points e.g. { "points": 5000 }
# Returns the points that has been spent by payer from available transactions.
# => [
#     { "payer": "DANNON", "points": -100 },
#     { "payer": "UNILEVER", "points": -200 },
#     { "payer": "MILLER COORS", "points": -4,700 }
#   ]

  def self.spend_points(params)
    result = []
    points_to_spend = params[:points].to_i

    # Iterates through list of records ordered from oldes to newest.
    self.order(:timestamp).each do |transaction_record|
      # Keeps track that there is more points to spend from request.
      if points_to_spend > 0
        # Determines if amount to be deducted is the total amount of points available
        # or a portion of points in record.
        points_to_deduct = points_to_spend > transaction_record[:points] ? transaction_record[:points] : points_to_spend
        # Searches if an entry has been already entered into result histogram.
        current_entry = result.find { |e| e[:payer] == transaction_record[:payer] }
        if current_entry
        # If entry already exists in histogram, adds points to deduct to previous amount.
          current_entry[:points] += points_to_deduct
        else
        # If entry is not in result array, adds it as a new entry.
          result << {
            :payer => transaction_record[:payer],
            :points => points_to_deduct
          }
        end
        # Substracts deducted points to total points to spend.
        points_to_spend -= transaction_record[:points]
        # Mutates the record from where the points have been deducted.
        transaction_record.update(:points => transaction_record[:points] - points_to_deduct)
      end
    end
    # Returns object with all points spent by payer.
    result
  end
end
