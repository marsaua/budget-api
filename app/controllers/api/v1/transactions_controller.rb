module Api
  module V1
    class TransactionsController < ApplicationController
      def index
        year  = params[:year]&.to_i  || Date.today.year
        month = params[:month]&.to_i || Date.today.month

        transactions = Transaction.for_month(year, month).by_date

        income  = transactions.where(kind: "income").sum(:amount)
        expense = transactions.where(kind: "expense").sum(:amount)

        render json: {
          transactions: transactions.map { |t| serialize(t) },
          summary: {
            income: income.to_f.round(2),
            expense: expense.to_f.round(2),
            balance: (income - expense).to_f.round(2)
          }
        }
      end

      def create
        transaction = Transaction.new(transaction_params)
        if transaction.save
          render json: serialize(transaction), status: :created
        else
          render json: { errors: transaction.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        transaction = Transaction.find(params[:id])
        if transaction.update(transaction_params)
          render json: serialize(transaction)
        else
          render json: { errors: transaction.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        Transaction.find(params[:id]).destroy
        head :no_content
      end

      private

      def transaction_params
        params.require(:transaction).permit(:description, :amount, :kind, :category, :occurred_on)
      end

      def serialize(t)
        {
          id: t.id,
          description: t.description,
          amount: t.amount.to_f,
          kind: t.kind,
          category: t.category,
          occurred_on: t.occurred_on.iso8601
        }
      end
    end
  end
end
