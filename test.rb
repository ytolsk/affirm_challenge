require  './main.rb'
small_params = [
  './small/loans.csv',
'./small/facilities.csv',
'./small/covenants.csv',
'./small/banks.csv'
]
bank = LoanDecider.new(*small_params)

loan = Loan.new('0.15', '10552', '1', "0.02", "MO")

bank.write_loan_assignments
