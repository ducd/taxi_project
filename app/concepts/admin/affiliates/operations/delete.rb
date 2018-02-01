module Admin::Affiliate
  class Delete < Trailblazer::Operation
    step Model(Affiliate, :find_by)
    step Policy::Pundit(Admin::AffiliatesPolicy, :user_admin?)
    step Wrap ->(*, &block) { Affiliate.transaction { block.call } } {
      step :remove_from_cars!
      step :delete!
    }

    private

    def remove_from_cars!(options, *)
      options['model'].cars.update_all(affiliate_id: nil)
    end

    def delete!(_options, model:, **)
      model.destroy
    end
  end
end
