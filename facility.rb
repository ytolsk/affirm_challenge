class Facility
  def initialize(amount,  interest_rate, id,  bank_id)
    @bank_id = bank_id;
    @interest_rate = interest_rate.to_f;
    @facility_id = id;
    @amount = amount.to_f;
  end

  def id
    @facility_id
  end

  def interst_rate
    @interest_rate
  end

  def amount
    @amount
  end

  def set_amount(new_amount)
    @amount= new_amount
  end

  def fund(amount_fund)
    set_amount(@amount - amount_fund)
  end

  def can_fund(loan_amount)
    loan_amount < self.amount
  end
end
