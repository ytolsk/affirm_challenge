require_relative 'loan_decider'


small_params = [
  './small/loans.csv',
'./small/facilities.csv',
'./small/covenants.csv',
'./small/banks.csv'
]

large_params = [
  './large/loans.csv',
'./large/facilities.csv',
'./large/covenants.csv',
'./large/banks.csv'
]


loan_decider = LoanDecider.new(*large_params)
loan_decider.run_decider
