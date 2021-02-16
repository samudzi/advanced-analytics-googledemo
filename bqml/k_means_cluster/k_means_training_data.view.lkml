view: k_means_training_data {
  derived_table: {
    sql:  SELECT
            users.id  AS users_id,
            COUNT(DISTINCT order_items.order_id ) AS order_items_order_count,
            COALESCE(SUM(order_items.sale_price ), 0) AS order_items_total_sale_price,
            AVG(order_items.sale_price ) AS order_items_average_sale_price
          FROM `looker-private-demo.ecomm.order_items`  AS order_items
          LEFT JOIN `looker-private-demo.ecomm.users`  AS users ON order_items.user_id = users.id
          GROUP BY 1
    ;;
  }
}
