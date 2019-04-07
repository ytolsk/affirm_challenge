class Covenant
  def initialize(bank_id, facility_id, max_default_likelihood, banned_state)
    @bank_id = bank_id
    @facility_id = facility_id
    @max_default_likelihood = max_default_likelihood.to_f
    @banned_state = banned_state
  end

  def allow_loan(loan)
    @banned_state != loan.state && @max_default_likelihood >= loan.default_likelihood
  end

  def facility_id
    @facility_id
  end

end
