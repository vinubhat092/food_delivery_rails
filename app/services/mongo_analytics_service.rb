class MongoAnalyticsService
  def initialize(restaurant_id)
    @restaurant_id = restaurant_id
  end

  def most_ordered_items(limit = 10)
    Analytics::OrderStat.collection
      .aggregate([
        { 
          '$match' => { 
            'restaurant_id' => @restaurant_id 
          }
        },
        {
          '$group' => {
            '_id' => {
              'menuitem_id' => '$menuitem_id',
              'name' => '$menuitem_name'
            },
            'total_orders' => { '$sum' => '$quantity' }
          }
        },
        { '$sort' => { 'total_orders' => -1 } },
        { '$limit' => limit }
      ]).to_a
  end

  def category_analytics
    Analytics::OrderStat.collection
      .aggregate([
        { 
          '$match' => { 
            'restaurant_id' => @restaurant_id 
          }
        },
        {
          '$group' => {
            '_id' => '$category',
            'total_orders' => { '$sum' => '$quantity' }
          }
        },
        { '$sort' => { 'total_orders' => -1 } }
      ]).to_a
  end
end 