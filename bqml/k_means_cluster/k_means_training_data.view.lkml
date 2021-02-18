view: k_means_training_data {
  derived_table: {

    sql:  SELECT
            users.id  AS user_id,
            {% if user_attribute_1._parameter_value == 'select_attribute' %}
            {% else %}
              {% parameter user_attribute_1 %},
            {% endif %}
            {% if user_attribute_2._parameter_value == 'select_attribute' %}
            {% else %}
              {% parameter user_attribute_2 %},
            {% endif %}
            {% if user_attribute_3._parameter_value == 'select_attribute' %}
            {% else %}
              {% parameter user_attribute_3 %},
            {% endif %}
            {% if user_attribute_4._parameter_value == 'select_attribute' %}
            {% else %}
              {% parameter user_attribute_4 %},
            {% endif %}
            {% if user_attribute_4._parameter_value == 'select_attribute' %}
            {% else %}
              {% parameter user_attribute_5 %}
            {% endif %}
        FROM ${users.SQL_TABLE_NAME}  AS users
        LEFT JOIN ${user_order_facts.SQL_TABLE_NAME} AS user_order_facts
        ON users.id = user_order_facts.user_id
    ;;
  }

  dimension: user_id {
    primary_key: yes
    hidden: yes
  }

  parameter: model_name {
    label: "Name your Segmentation model"
    description: "Enter a unique name for your BQML model"
    type: unquoted
  }

  parameter: number_of_clusters {
    label: "Select Number of Segments"
    description: "Enter the number of segments you want to create"
    type: unquoted
  }

  parameter: user_attribute_1 {
    description: "Select an attribute to define your segments"
    type: unquoted
    default_value: "select_attribute"
    allowed_value: {
      label: "Select Attribute"
      value: "select_attribute"
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
      value: "users.created"
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
      value: "user_order_facts.first_order"
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
      value: "user_order_facts.latest_order"
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
    description: "Select an attribute to define your segments"
    type: unquoted
    default_value: "select_attribute"
    allowed_value: {
      label: "Select Attribute"
      value: "select_attribute"
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
      value: "users.created"
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
      value: "user_order_facts.first_order"
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
      value: "user_order_facts.latest_order"
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
    description: "Select an attribute to define your segments"
    type: unquoted
    default_value: "select_attribute"
    allowed_value: {
      label: "Select Attribute"
      value: "select_attribute"
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
      value: "users.created"
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
      value: "user_order_facts.first_order"
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
      value: "user_order_facts.latest_order"
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
    description: "Select an attribute to define your segments"
    type: unquoted
    default_value: "select_attribute"
    allowed_value: {
      label: "Select Attribute"
      value: "select_attribute"
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
      value: "users.created"
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
      value: "user_order_facts.first_order"
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
      value: "user_order_facts.latest_order"
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
    description: "Select an attribute to define your segments"
    type: unquoted
    default_value: "select_attribute"
    allowed_value: {
      label: "Select Attribute"
      value: "select_attribute"
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
      value: "users.created"
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
      value: "user_order_facts.first_order"
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
      value: "user_order_facts.latest_order"
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
