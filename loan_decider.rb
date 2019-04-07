require 'csv'
require_relative 'loan'
require_relative 'facility'
require_relative 'covenant'

class LoanDecider
  def initialize(loans, facilites, covenants, banks)
    @loans_file = loans
    @facilites= self.facilities_dictionary(facilites)
    @covenants= self.covenants(covenants)
    @loans_yield_dictionary = {}
  end

  def run_decider
    facility_loans = loan_stream_assignment
    write_loan_assignments(facility_loans)
    write_yields(facility_loans)
    puts "Loans assugnments calculated and written to output file!"
  end

  def loan_stream_assignment
    facility_loan = {}
    CSV.foreach(@loans_file, :headers => true) do |loan_line|
      loan = Loan.new(loan_line['interest_rate'], loan_line['amount'], loan_line['id'],
      loan_line['default_likelihood'], loan_line['state'])
      posible_facilities = get_posisble_facilities(loan)
      facility = find_best_facility(loan, posible_facilities)

      if facility
        facility.fund(loan.amount)
        if facility_loan[facility.id]
          facility_loan[facility.id] = facility_loan[facility.id].push(loan.id)
        else
          facility_loan[facility.id] = [loan.id]
        end
        @loans_yield_dictionary[loan.id] = loan.expected_yield(facility.interst_rate)
      end

    end
    return facility_loan
  end

  def write_loan_assignments(facility_loan_dict)
    headers = ["loan_id", "facility_id"]
    CSV.open("output/assignments.csv", "w") do |csv|
      csv << headers #if csv.count.eql?
      facility_loan_dict.each do |fac|
        fac[1].each do |val|
          csv << [val, fac.first]
        end
      end
    end
  end

  def write_yields(facility_loans_dict)
    headers =["facility_id", "expected_yield"]
    CSV.open("output/yields.csv", "w") do |csv|
    facility_loans_dict.each do |fac|
        loan_amount_array = fac[1].map {|loan_id| @loans_yield_dictionary[loan_id]}
        loans_sum = loan_amount_array.inject(0){|sum, x| sum +x }
        csv << [fac[0], loans_sum.round]
      end
    end
  end

  def find_best_facility(loan, facilities)
    max = 0
    facility = nil;
    facilities.each do |fas|
      if fas.can_fund(loan.amount)
        ex_yield = loan.expected_yield(fas.interst_rate)
        if ex_yield > max
           max = ex_yield
           facility = fas
        end
      end
    end
    return facility
  end


  def get_posisble_facilities(loan)
    possible_covenants = @covenants.select {|cov| cov.allow_loan(loan) }
    possible_fac_ids = possible_covenants.map { |cov| cov.facility_id}   #select all covenants that are allowed by banned_state and max
    @facilites.values_at(*possible_fac_ids).uniq
  end

  def covenants(covenants_file)
    covenants = []
    CSV.foreach(covenants_file, :headers => true) do |covenant_line|
      bank_id = covenant_line['bank_id']
      facility_id = covenant_line['facility_id']
      max_default_likelihood = covenant_line['max_default_likelihood']
      banned_state = covenant_line['banned_state']
      covenants << Covenant.new(bank_id, facility_id, max_default_likelihood, banned_state)
    end
    return covenants
  end

  def facilities_dictionary(facilites_file)
    facilities = {}
    CSV.foreach(facilites_file, :headers => true) do |facility_line|
      facility_id = facility_line['id']

      facilities[facility_id] = Facility.new(facility_line['amount'],
        facility_line['interest_rate'],
        facility_id,
        facility_line['bank_id'])
    end
    return facilities
  end
end
