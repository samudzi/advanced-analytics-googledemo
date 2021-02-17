view: k_means_training_data {
  derived_table: {
    # sql:  SELECT
    #         users.id  AS users_id,
    #         COUNT(DISTINCT order_items.order_id ) AS order_items_order_count,
    #         COALESCE(SUM(order_items.sale_price ), 0) AS order_items_total_sale_price,
    #         AVG(order_items.sale_price ) AS order_items_average_sale_price
    #       FROM `looker-private-demo.ecomm.order_items`  AS order_items
    #       LEFT JOIN `looker-private-demo.ecomm.users`  AS users ON order_items.user_id = users.id
    #       GROUP BY 1
    # ;;
    sql:  SELECT
            users.id  AS users_id,
            {% parameter user_attribute_1 %},
            {% parameter user_attribute_2 %},
            {% parameter user_attribute_3 %},
            {% parameter user_attribute_4 %},
            {% parameter user_attribute_5 %}

          FROM ${users.SQL_TABLE_NAME}  AS users
          LEFT JOIN ${user_order_facts.SQL_TABLE_NAME} AS user_order_facts
            ON users.id = user_order_facts.user_id
    ;;
  }

  dimension: user_id {
    primary_key: yes
    hidden: yes
  }

  parameter: user_attribute_1 {
    type: unquoted
    default_value: "NULL"
    allowed_value: {
      label: "Select Attribute"
      value: "NULL"
    }
    allowed_value: {
      label: "Age"
      value: "users.age"
    }
    allowed_value: {
      label: "City"
      value: "users.city"
    }
    allowed_value: {
      label: "Country"
      value: "users.country"
    }
    allowed_value: {
      label: "Created Date"
      value: "users.created_date"
    }
    allowed_value: {
      label: "Days as Customer"
      value: "user_order_facts.days_as_customer"
    }
    allowed_value: {
      label: "Days as Customer"
      value: "user_order_facts.days_as_customer"
    }
    allowed_value: {
      label: "Distinct Months as Orders"
      value: "user_order_facts.distinct_months_with_orders"
    }
    allowed_value: {
      label: "First Order Date"
      value: "user_order_facts.first_order_date"
    }
    allowed_value: {
      label: "Gender"
      value: "users.gender"
    }
    allowed_value: {
      label: "Is Active Customer"
      value: "user_order_facts.is_active_customer"
    }
    allowed_value: {
      label: "Latest Order Date"
      value: "user_order_facts.latest_order_date"
    }
    allowed_value: {
      label: "Lifetime Orders"
      value: "user_order_facts.lifetime_orders"
    }
    allowed_value: {
      label: "Lifetime Revenue"
      value: "user_order_facts.lifetime_revenue"
    }
    allowed_value: {
      label: "Over 21"
      value: "users.over_21"
    }
    allowed_value: {
      label: "Repeat Customer"
      value: "user_order_facts.repeat_customer"
    }
    allowed_value: {
      label: "State"
      value: "users.state"
    }
    allowed_value: {
      label: "Traffic Source"
      value: "users.traffic_source"
    }
    allowed_value: {
      label: "UK Postcode"
      value: "users.uk_postcode"
    }
    allowed_value: {
      label: "US Zip Code"
      value: "users.zip"
    }
  }

  parameter: user_attribute_2 {
    type: unquoted
    default_value: "NULL"
    allowed_value: {
      label: "Select Attribute"
      value: "NULL"
    }
    allowed_value: {
      label: "Age"
      value: "users.age"
    }
    allowed_value: {
      label: "City"
      value: "users.city"
    }
    allowed_value: {
      label: "Country"
      value: "users.country"
    }
    allowed_value: {
      label: "Created Date"
      value: "users.created_date"
    }
    allowed_value: {
      label: "Days as Customer"
      value: "user_order_facts.days_as_customer"
    }
    allowed_value: {
      label: "Days as Customer"
      value: "user_order_facts.days_as_customer"
    }
    allowed_value: {
      label: "Distinct Months as Orders"
      value: "user_order_facts.distinct_months_with_orders"
    }
    allowed_value: {
      label: "First Order Date"
      value: "user_order_facts.first_order_date"
    }
    allowed_value: {
      label: "Gender"
      value: "users.gender"
    }
    allowed_value: {
      label: "Is Active Customer"
      value: "user_order_facts.is_active_customer"
    }
    allowed_value: {
      label: "Latest Order Date"
      value: "user_order_facts.latest_order_date"
    }
    allowed_value: {
      label: "Lifetime Orders"
      value: "user_order_facts.lifetime_orders"
    }
    allowed_value: {
      label: "Lifetime Revenue"
      value: "user_order_facts.lifetime_revenue"
    }
    allowed_value: {
      label: "Over 21"
      value: "users.over_21"
    }
    allowed_value: {
      label: "Repeat Customer"
      value: "user_order_facts.repeat_customer"
    }
    allowed_value: {
      label: "State"
      value: "users.state"
    }
    allowed_value: {
      label: "Traffic Source"
      value: "users.traffic_source"
    }
    allowed_value: {
      label: "UK Postcode"
      value: "users.uk_postcode"
    }
    allowed_value: {
      label: "US Zip Code"
      value: "users.zip"
    }
  }

  parameter: user_attribute_3 {
    type: unquoted
    default_value: "NULL"
    allowed_value: {
      label: "Select Attribute"
      value: "NULL"
    }
    allowed_value: {
      label: "Age"
      value: "users.age"
    }
    allowed_value: {
      label: "City"
      value: "users.city"
    }
    allowed_value: {
      label: "Country"
      value: "users.country"
    }
    allowed_value: {
      label: "Created Date"
      value: "users.created_date"
    }
    allowed_value: {
      label: "Days as Customer"
      value: "user_order_facts.days_as_customer"
    }
    allowed_value: {
      label: "Days as Customer"
      value: "user_order_facts.days_as_customer"
    }
    allowed_value: {
      label: "Distinct Months as Orders"
      value: "user_order_facts.distinct_months_with_orders"
    }
    allowed_value: {
      label: "First Order Date"
      value: "user_order_facts.first_order_date"
    }
    allowed_value: {
      label: "Gender"
      value: "users.gender"
    }
    allowed_value: {
      label: "Is Active Customer"
      value: "user_order_facts.is_active_customer"
    }
    allowed_value: {
      label: "Latest Order Date"
      value: "user_order_facts.latest_order_date"
    }
    allowed_value: {
      label: "Lifetime Orders"
      value: "user_order_facts.lifetime_orders"
    }
    allowed_value: {
      label: "Lifetime Revenue"
      value: "user_order_facts.lifetime_revenue"
    }
    allowed_value: {
      label: "Over 21"
      value: "users.over_21"
    }
    allowed_value: {
      label: "Repeat Customer"
      value: "user_order_facts.repeat_customer"
    }
    allowed_value: {
      label: "State"
      value: "users.state"
    }
    allowed_value: {
      label: "Traffic Source"
      value: "users.traffic_source"
    }
    allowed_value: {
      label: "UK Postcode"
      value: "users.uk_postcode"
    }
    allowed_value: {
      label: "US Zip Code"
      value: "users.zip"
    }
  }

  parameter: user_attribute_4 {
    type: unquoted
    default_value: "NULL"
    allowed_value: {
      label: "Select Attribute"
      value: "NULL"
    }
    allowed_value: {
      label: "Age"
      value: "users.age"
    }
    allowed_value: {
      label: "City"
      value: "users.city"
    }
    allowed_value: {
      label: "Country"
      value: "users.country"
    }
    allowed_value: {
      label: "Created Date"
      value: "users.created_date"
    }
    allowed_value: {
      label: "Days as Customer"
      value: "user_order_facts.days_as_customer"
    }
    allowed_value: {
      label: "Days as Customer"
      value: "user_order_facts.days_as_customer"
    }
    allowed_value: {
      label: "Distinct Months as Orders"
      value: "user_order_facts.distinct_months_with_orders"
    }
    allowed_value: {
      label: "First Order Date"
      value: "user_order_facts.first_order_date"
    }
    allowed_value: {
      label: "Gender"
      value: "users.gender"
    }
    allowed_value: {
      label: "Is Active Customer"
      value: "user_order_facts.is_active_customer"
    }
    allowed_value: {
      label: "Latest Order Date"
      value: "user_order_facts.latest_order_date"
    }
    allowed_value: {
      label: "Lifetime Orders"
      value: "user_order_facts.lifetime_orders"
    }
    allowed_value: {
      label: "Lifetime Revenue"
      value: "user_order_facts.lifetime_revenue"
    }
    allowed_value: {
      label: "Over 21"
      value: "users.over_21"
    }
    allowed_value: {
      label: "Repeat Customer"
      value: "user_order_facts.repeat_customer"
    }
    allowed_value: {
      label: "State"
      value: "users.state"
    }
    allowed_value: {
      label: "Traffic Source"
      value: "users.traffic_source"
    }
    allowed_value: {
      label: "UK Postcode"
      value: "users.uk_postcode"
    }
    allowed_value: {
      label: "US Zip Code"
      value: "users.zip"
    }
  }

  parameter: user_attribute_5 {
    type: unquoted
    default_value: "NULL"
    allowed_value: {
      label: "Select Attribute"
      value: "NULL"
    }
    allowed_value: {
      label: "Age"
      value: "users.age"
    }
    allowed_value: {
      label: "City"
      value: "users.city"
    }
    allowed_value: {
      label: "Country"
      value: "users.country"
    }
    allowed_value: {
      label: "Created Date"
      value: "users.created_date"
    }
    allowed_value: {
      label: "Days as Customer"
      value: "user_order_facts.days_as_customer"
    }
    allowed_value: {
      label: "Days as Customer"
      value: "user_order_facts.days_as_customer"
    }
    allowed_value: {
      label: "Distinct Months as Orders"
      value: "user_order_facts.distinct_months_with_orders"
    }
    allowed_value: {
      label: "First Order Date"
      value: "user_order_facts.first_order_date"
    }
    allowed_value: {
      label: "Gender"
      value: "users.gender"
    }
    allowed_value: {
      label: "Is Active Customer"
      value: "user_order_facts.is_active_customer"
    }
    allowed_value: {
      label: "Latest Order Date"
      value: "user_order_facts.latest_order_date"
    }
    allowed_value: {
      label: "Lifetime Orders"
      value: "user_order_facts.lifetime_orders"
    }
    allowed_value: {
      label: "Lifetime Revenue"
      value: "user_order_facts.lifetime_revenue"
    }
    allowed_value: {
      label: "Over 21"
      value: "users.over_21"
    }
    allowed_value: {
      label: "Repeat Customer"
      value: "user_order_facts.repeat_customer"
    }
    allowed_value: {
      label: "State"
      value: "users.state"
    }
    allowed_value: {
      label: "Traffic Source"
      value: "users.traffic_source"
    }
    allowed_value: {
      label: "UK Postcode"
      value: "users.uk_postcode"
    }
    allowed_value: {
      label: "US Zip Code"
      value: "users.zip"
    }
  }

}