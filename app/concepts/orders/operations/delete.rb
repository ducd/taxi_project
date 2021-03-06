class Order::Delete < Trailblazer::Operation
  step Model(Order, :find_by)
  step Policy::Pundit(OrdersPolicy, :access_granted?)
  step Wrap ->(*, &block) { Order.transaction(&block) } {
    step :unassign_car!
    step :delete!
  }

  private

  def unassign_car!(_options, model:, **)
    model.car.update(car_status: 0) unless model.car.nil?
    true
  end

  def delete!(_options, model:, **)
    model.destroy
  end
end
