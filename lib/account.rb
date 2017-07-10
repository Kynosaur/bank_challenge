require_relative 'statement_printer'

# Understands the recording and management of funds
class Account
  attr_reader :balance

  def initialize(statement_printer = StatementPrinter.new)
    @statement_printer = statement_printer
    @transactions = []
    @balance = 0.0
  end

  def deposit(amount)
    @balance = (balance + amount).round(2)
    @transactions << { date: Time.now,
                       credit: amount,
                       debit: nil,
                       balance: @balance }
  end

  def withdraw(amount)
    check_balance(amount)
    @balance = (balance - amount).round(2)
    @transactions << { date: Time.now,
                       credit: nil,
                       debit: amount,
                       balance: @balance }
  end

  def print_statement
    @statement_printer.print_statement(@transactions)
  end

  private

  def check_balance(withdraw_amount)
    fail 'Cannot withdraw - account is empty' if @balance == 0
    return unless @balance < withdraw_amount
    fail "Cannot withdraw that much. Balance: #{format('%.2f', @balance)}"
  end
end
