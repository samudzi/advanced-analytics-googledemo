view: k_means_training_data {
  label: "1. BQML K-Means: Select Training Data"
  derived_table: {
    sql:  SELECT
            {% parameter item_id %},
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
        FROM ${dataset_1.SQL_TABLE_NAME}
    ;;
  }

  parameter: item_id {
    label: "Select Identifier Field"
    description: "Choose a field that uniquely identifies the items you want to cluster"
    type: unquoted
    suggest_explore: dataset_columns
    suggest_dimension: dataset_columns.column_name
  }

  parameter: features {
    label: "Select attributes of items you want to cluster"
    type: unquoted
    suggest_explore: dataset_columns
    suggest_dimension: dataset_columns.column_name
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
      value: "age"
    }
    allowed_value: {
      label: "City"
      value: "city"
    }
    allowed_value: {
      label: "Country"
      value: "country"
    }
    allowed_value: {
      label: "Created Date"
      value: "created"
    }
    allowed_value: {
      label: "Days as Customer"
      value: "days_as_customer"
    }
    allowed_value: {
      label: "Days as Customer"
      value: "days_as_customer"
    }
    allowed_value: {
      label: "Distinct Months as Orders"
      value: "distinct_months_with_orders"
    }
    allowed_value: {
      label: "First Order Date"
      value: "first_order"
    }
    allowed_value: {
      label: "Gender"
      value: "gender"
    }
    allowed_value: {
      label: "Is Active Customer"
      value: "is_active_customer"
    }
    allowed_value: {
      label: "Latest Order Date"
      value: "latest_order"
    }
    allowed_value: {
      label: "Lifetime Orders"
      value: "lifetime_orders"
    }
    allowed_value: {
      label: "Lifetime Revenue"
      value: "lifetime_revenue"
    }
    allowed_value: {
      label: "Over 21"
      value: "over_21"
    }
    allowed_value: {
      label: "Repeat Customer"
      value: "repeat_customer"
    }
    allowed_value: {
      label: "State"
      value: "state"
    }
    allowed_value: {
      label: "Traffic Source"
      value: "traffic_source"
    }
    allowed_value: {
      label: "UK Postcode"
      value: "uk_postcode"
    }
    allowed_value: {
      label: "US Zip Code"
      value: "zip"
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
      value: "age"
    }
    allowed_value: {
      label: "City"
      value: "city"
    }
    allowed_value: {
      label: "Country"
      value: "country"
    }
    allowed_value: {
      label: "Created Date"
      value: "created"
    }
    allowed_value: {
      label: "Days as Customer"
      value: "days_as_customer"
    }
    allowed_value: {
      label: "Days as Customer"
      value: "days_as_customer"
    }
    allowed_value: {
      label: "Distinct Months as Orders"
      value: "distinct_months_with_orders"
    }
    allowed_value: {
      label: "First Order Date"
      value: "first_order"
    }
    allowed_value: {
      label: "Gender"
      value: "gender"
    }
    allowed_value: {
      label: "Is Active Customer"
      value: "is_active_customer"
    }
    allowed_value: {
      label: "Latest Order Date"
      value: "latest_order"
    }
    allowed_value: {
      label: "Lifetime Orders"
      value: "lifetime_orders"
    }
    allowed_value: {
      label: "Lifetime Revenue"
      value: "lifetime_revenue"
    }
    allowed_value: {
      label: "Over 21"
      value: "over_21"
    }
    allowed_value: {
      label: "Repeat Customer"
      value: "repeat_customer"
    }
    allowed_value: {
      label: "State"
      value: "state"
    }
    allowed_value: {
      label: "Traffic Source"
      value: "traffic_source"
    }
    allowed_value: {
      label: "UK Postcode"
      value: "uk_postcode"
    }
    allowed_value: {
      label: "US Zip Code"
      value: "zip"
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
      value: "age"
    }
    allowed_value: {
      label: "City"
      value: "city"
    }
    allowed_value: {
      label: "Country"
      value: "country"
    }
    allowed_value: {
      label: "Created Date"
      value: "created"
    }
    allowed_value: {
      label: "Days as Customer"
      value: "days_as_customer"
    }
    allowed_value: {
      label: "Days as Customer"
      value: "days_as_customer"
    }
    allowed_value: {
      label: "Distinct Months as Orders"
      value: "distinct_months_with_orders"
    }
    allowed_value: {
      label: "First Order Date"
      value: "first_order"
    }
    allowed_value: {
      label: "Gender"
      value: "gender"
    }
    allowed_value: {
      label: "Is Active Customer"
      value: "is_active_customer"
    }
    allowed_value: {
      label: "Latest Order Date"
      value: "latest_order"
    }
    allowed_value: {
      label: "Lifetime Orders"
      value: "lifetime_orders"
    }
    allowed_value: {
      label: "Lifetime Revenue"
      value: "lifetime_revenue"
    }
    allowed_value: {
      label: "Over 21"
      value: "over_21"
    }
    allowed_value: {
      label: "Repeat Customer"
      value: "repeat_customer"
    }
    allowed_value: {
      label: "State"
      value: "state"
    }
    allowed_value: {
      label: "Traffic Source"
      value: "traffic_source"
    }
    allowed_value: {
      label: "UK Postcode"
      value: "uk_postcode"
    }
    allowed_value: {
      label: "US Zip Code"
      value: "zip"
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
      value: "age"
    }
    allowed_value: {
      label: "City"
      value: "city"
    }
    allowed_value: {
      label: "Country"
      value: "country"
    }
    allowed_value: {
      label: "Created Date"
      value: "created"
    }
    allowed_value: {
      label: "Days as Customer"
      value: "days_as_customer"
    }
    allowed_value: {
      label: "Days as Customer"
      value: "days_as_customer"
    }
    allowed_value: {
      label: "Distinct Months as Orders"
      value: "distinct_months_with_orders"
    }
    allowed_value: {
      label: "First Order Date"
      value: "first_order"
    }
    allowed_value: {
      label: "Gender"
      value: "gender"
    }
    allowed_value: {
      label: "Is Active Customer"
      value: "is_active_customer"
    }
    allowed_value: {
      label: "Latest Order Date"
      value: "latest_order"
    }
    allowed_value: {
      label: "Lifetime Orders"
      value: "lifetime_orders"
    }
    allowed_value: {
      label: "Lifetime Revenue"
      value: "lifetime_revenue"
    }
    allowed_value: {
      label: "Over 21"
      value: "over_21"
    }
    allowed_value: {
      label: "Repeat Customer"
      value: "repeat_customer"
    }
    allowed_value: {
      label: "State"
      value: "state"
    }
    allowed_value: {
      label: "Traffic Source"
      value: "traffic_source"
    }
    allowed_value: {
      label: "UK Postcode"
      value: "uk_postcode"
    }
    allowed_value: {
      label: "US Zip Code"
      value: "zip"
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
      value: "age"
    }
    allowed_value: {
      label: "City"
      value: "city"
    }
    allowed_value: {
      label: "Country"
      value: "country"
    }
    allowed_value: {
      label: "Created Date"
      value: "created"
    }
    allowed_value: {
      label: "Days as Customer"
      value: "days_as_customer"
    }
    allowed_value: {
      label: "Days as Customer"
      value: "days_as_customer"
    }
    allowed_value: {
      label: "Distinct Months as Orders"
      value: "distinct_months_with_orders"
    }
    allowed_value: {
      label: "First Order Date"
      value: "first_order"
    }
    allowed_value: {
      label: "Gender"
      value: "gender"
    }
    allowed_value: {
      label: "Is Active Customer"
      value: "is_active_customer"
    }
    allowed_value: {
      label: "Latest Order Date"
      value: "latest_order"
    }
    allowed_value: {
      label: "Lifetime Orders"
      value: "lifetime_orders"
    }
    allowed_value: {
      label: "Lifetime Revenue"
      value: "lifetime_revenue"
    }
    allowed_value: {
      label: "Over 21"
      value: "over_21"
    }
    allowed_value: {
      label: "Repeat Customer"
      value: "repeat_customer"
    }
    allowed_value: {
      label: "State"
      value: "state"
    }
    allowed_value: {
      label: "Traffic Source"
      value: "traffic_source"
    }
    allowed_value: {
      label: "UK Postcode"
      value: "uk_postcode"
    }
    allowed_value: {
      label: "US Zip Code"
      value: "zip"
    }
  }

}
