class GeneralAnalyticsService
    def most_ordered_restaurant
        Order.joins(:restaurant)
        .group("restaurants.id, restaurants.name")
        .order("COUNT(orders.id) DESC")
        .select("restaurants.name, COUNT(orders.id) as order_count")
        .limit(2)
    end

    def most_ordered_user
        Order.joins(:user)
        .group("users.id,users.name")
        .order("COUNT(orders.id) DESC")
        .select("users.name, count(orders.id) as order_count")
    end
end


