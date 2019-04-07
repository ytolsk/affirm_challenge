class Loan

  def initialize(interest_rate,amount,id,default_likelihood,state)
    @interest_rate = interest_rate.to_f
    @amount= amount.to_f
    @id = id
    @default_likelihood = default_likelihood.to_f
    @state = state
  end

  def id
    @id
  end

  def state
    @state
  end

  def amount
    @amount
  end

  def default_likelihood
    @default_likelihood
  end

  def default_max
    @amount * @default_likelihood
  end

 def expected_yield(facility_interest_rate)
   ((1 - @default_likelihood) * @interest_rate * @amount)-(@default_likelihood * @amount)-(facility_interest_rate * @amount)
 end
end
