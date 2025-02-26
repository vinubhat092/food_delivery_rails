class RestaurantAnalyticsService
    def initialize(restaurant)
        @restaurant = restaurant
    end

    def most_ordered_items
        @restaurant.menuitems
        .joins(:orderitems)
        .group("menuitems.id, menuitems.name")
        .order("COUNT(orderitems.id) DESC")
        .limit(5)
        .pluck("menuitems.name, COUNT(orderitems.id)")
    end
    
    def most_ordered_category
        @restaurant.menuitems
        .joins(:orderitems)
        .group("menuitems.category")
        .select("menuitems.category, COUNT(orderitems.id) as order_count")
        .limit(5)
    end
end

