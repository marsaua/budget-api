module Api
  module V1
    class TransactionsController < ApplicationController
      before_action :set_room
      before_action :set_transaction, only: [:update, :destroy]

      PER_PAGE = 20

      def index
        scope = policy_scope(@room.transactions).for_month(year, month).by_date
        categories = Array(params.permit(categories: [])[:categories]).reject { |c| c.blank? || Transaction::CATEGORIES.exclude?(c) }
        scope = scope.where(category: categories) if categories.present?

        income  = scope.where(kind: "income").sum(:amount)
        expense = scope.where(kind: "expense").sum(:amount)

        total       = scope.count
        total_pages = [ (total / PER_PAGE.to_f).ceil, 1 ].max
        page        = [ [ params[:page].to_i, 1 ].max, total_pages ].min
        paged_scope = scope.offset((page - 1) * PER_PAGE).limit(PER_PAGE)

        render json: {
          transactions: paged_scope.map { |t| serialize(t) },
          summary: {
            income:  income.to_f.round(2),
            expense: expense.to_f.round(2),
            balance: (income - expense).to_f.round(2)
          },
          pagination: {
            page:        page,
            per_page:    PER_PAGE,
            total:       total,
            total_pages: total_pages
          }
        }
      end

      def create
        transaction = @room.transactions.new(transaction_params.merge(author: current_user))
        authorize transaction
        if transaction.save
          render json: serialize(transaction), status: :created
        else
          render json: { errors: transaction.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        authorize @transaction
        if @transaction.update(transaction_params)
          render json: serialize(@transaction)
        else
          render json: { errors: @transaction.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @transaction
        @transaction.destroy
        head :no_content
      end

      private

      def set_room
        @room = current_user.rooms.find(params[:room_id])
      end

      def set_transaction
        @transaction = @room.transactions.find(params[:id])
      end

      def year  = params[:year]&.to_i  || Date.today.year
      def month = params[:month]&.to_i || Date.today.month

      def transaction_params
        params.require(:transaction).permit(:description, :amount, :kind, :category, :occurred_on)
      end

      def serialize(t)
        {
          id:          t.id,
          description: t.description,
          amount:      t.amount.to_f,
          kind:        t.kind,
          category:    t.category,
          occurred_on: t.occurred_on.iso8601,
          author:      t.author ? { id: t.author_id, name: t.author.name } : { id: nil, name: nil }
        }
      end
    end
  end
end
