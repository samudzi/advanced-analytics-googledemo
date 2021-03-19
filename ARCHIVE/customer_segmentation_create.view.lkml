# view: customer_segmentation_create {
#   label: "BQML K-Means: Create Model"
#   derived_table: {
#     datagroup_trigger: bqml_model_creation
#     create_process: {

#       sql_step: CREATE OR REPLACE MODEL looker_pdts.{% parameter model_name %}
#                   OPTIONS(MODEL_TYPE = 'KMEANS'
#                           , NUM_CLUSTERS = {% parameter number_of_clusters %}
#                           , KMEANS_INIT_METHOD = 'KMEANS++'
#                           , STANDARDIZE_FEATURES = TRUE)
#                   AS (
#                       SELECT
#                         {% if user_attribute_1._parameter_value == 'select_attribute' %}
#                         {% else %}
#                           {% parameter user_attribute_1 %},
#                         {% endif %}
#                         {% if user_attribute_2._parameter_value == 'select_attribute' %}
#                         {% else %}
#                           {% parameter user_attribute_2 %},
#                         {% endif %}
#                         {% if user_attribute_3._parameter_value == 'select_attribute' %}
#                         {% else %}
#                           {% parameter user_attribute_3 %},
#                         {% endif %}
#                         {% if user_attribute_4._parameter_value == 'select_attribute' %}
#                         {% else %}
#                           {% parameter user_attribute_4 %},
#                         {% endif %}
#                         {% if user_attribute_4._parameter_value == 'select_attribute' %}
#                         {% else %}
#                           {% parameter user_attribute_5 %}
#                         {% endif %}

#                       FROM ${users.SQL_TABLE_NAME}  AS users
#                       LEFT JOIN ${user_order_facts.SQL_TABLE_NAME} AS user_order_facts
#                       ON users.id = user_order_facts.user_id
#                       )
#       ;;

#       sql_step: CREATE OR REPLACE TABLE looker_pdts.{% parameter model_name %}_predict AS
#                 SELECT *
#                 FROM ml.PREDICT(MODEL looker_pdts.{% parameter model_name %},
#                     (SELECT
#                       users.id  AS user_id,
#                       {% if user_attribute_1._parameter_value == 'select_attribute' %}
#                       {% else %}
#                         {% parameter user_attribute_1 %},
#                       {% endif %}
#                       {% if user_attribute_2._parameter_value == 'select_attribute' %}
#                       {% else %}
#                         {% parameter user_attribute_2 %},
#                       {% endif %}
#                       {% if user_attribute_3._parameter_value == 'select_attribute' %}
#                       {% else %}
#                         {% parameter user_attribute_3 %},
#                       {% endif %}
#                       {% if user_attribute_4._parameter_value == 'select_attribute' %}
#                       {% else %}
#                         {% parameter user_attribute_4 %},
#                       {% endif %}
#                       {% if user_attribute_4._parameter_value == 'select_attribute' %}
#                       {% else %}
#                         {% parameter user_attribute_5 %}
#                       {% endif %}

#                     FROM ${users.SQL_TABLE_NAME}  AS users
#                     LEFT JOIN ${user_order_facts.SQL_TABLE_NAME} AS user_order_facts
#                     ON users.id = user_order_facts.user_id
#                     )
#                   )
#       ;;

#       sql_step: CREATE TABLE IF NOT EXISTS ${SQL_TABLE_NAME} AS
#                 SELECT TRUE AS complete
#       ;;
#     }
#   }

#   parameter: model_name {
#     label: "Name your Segmentation Model"
#     description: "Enter a unique name for your BQML k-means clustering model"
#     type: unquoted
#   }

#   parameter: number_of_clusters {
#     label: "Select Number of Segments"
#     description: "Enter the number of clusters you want the BQML k-means model to create"
#     type: unquoted
#   }

#   parameter: user_attribute_1 {
#     description: "Select a field to include in your BQML k-means model training data"
#     type: unquoted
#     default_value: "select_attribute"
#     allowed_value: {
#       label: "Select Attribute"
#       value: "select_attribute"
#     }
#     allowed_value: {
#       label: "Age"
#       value: "users.age"
#     }
#     allowed_value: {
#       label: "City"
#       value: "users.city"
#     }
#     allowed_value: {
#       label: "Country"
#       value: "users.country"
#     }
#     allowed_value: {
#       label: "Created Date"
#       value: "users.created"
#     }
#     allowed_value: {
#       label: "First Order Date"
#       value: "user_order_facts.first_order"
#     }
#     allowed_value: {
#       label: "Gender"
#       value: "users.gender"
#     }
#     allowed_value: {
#       label: "Latest Order Date"
#       value: "user_order_facts.latest_order"
#     }
#     allowed_value: {
#       label: "Lifetime Orders"
#       value: "user_order_facts.lifetime_orders"
#     }
#     allowed_value: {
#       label: "Lifetime Revenue"
#       value: "user_order_facts.lifetime_revenue"
#     }
#     allowed_value: {
#       label: "State"
#       value: "users.state"
#     }
#     allowed_value: {
#       label: "Traffic Source"
#       value: "users.traffic_source"
#     }
#     allowed_value: {
#       label: "UK Postcode"
#       value: "users.uk_postcode"
#     }
#     allowed_value: {
#       label: "US Zip Code"
#       value: "users.zip"
#     }
#   }

#   parameter: user_attribute_2 {
#     description: "Select a field to include in your BQML k-means model training data"
#     type: unquoted
#     default_value: "select_attribute"
#     allowed_value: {
#       label: "Select Attribute"
#       value: "select_attribute"
#     }
#     allowed_value: {
#       label: "Age"
#       value: "users.age"
#     }
#     allowed_value: {
#       label: "City"
#       value: "users.city"
#     }
#     allowed_value: {
#       label: "Country"
#       value: "users.country"
#     }
#     allowed_value: {
#       label: "Created Date"
#       value: "users.created"
#     }
#     allowed_value: {
#       label: "First Order Date"
#       value: "user_order_facts.first_order"
#     }
#     allowed_value: {
#       label: "Gender"
#       value: "users.gender"
#     }
#     allowed_value: {
#       label: "Latest Order Date"
#       value: "user_order_facts.latest_order"
#     }
#     allowed_value: {
#       label: "Lifetime Orders"
#       value: "user_order_facts.lifetime_orders"
#     }
#     allowed_value: {
#       label: "Lifetime Revenue"
#       value: "user_order_facts.lifetime_revenue"
#     }
#     allowed_value: {
#       label: "State"
#       value: "users.state"
#     }
#     allowed_value: {
#       label: "Traffic Source"
#       value: "users.traffic_source"
#     }
#     allowed_value: {
#       label: "UK Postcode"
#       value: "users.uk_postcode"
#     }
#     allowed_value: {
#       label: "US Zip Code"
#       value: "users.zip"
#     }
#   }

#   parameter: user_attribute_3 {
#     description: "Select a field to include in your BQML k-means model training data"
#     type: unquoted
#     default_value: "select_attribute"
#     allowed_value: {
#       label: "Select Attribute"
#       value: "select_attribute"
#     }
#     allowed_value: {
#       label: "Age"
#       value: "users.age"
#     }
#     allowed_value: {
#       label: "City"
#       value: "users.city"
#     }
#     allowed_value: {
#       label: "Country"
#       value: "users.country"
#     }
#     allowed_value: {
#       label: "Created Date"
#       value: "users.created"
#     }
#     allowed_value: {
#       label: "First Order Date"
#       value: "user_order_facts.first_order"
#     }
#     allowed_value: {
#       label: "Gender"
#       value: "users.gender"
#     }
#     allowed_value: {
#       label: "Latest Order Date"
#       value: "user_order_facts.latest_order"
#     }
#     allowed_value: {
#       label: "Lifetime Orders"
#       value: "user_order_facts.lifetime_orders"
#     }
#     allowed_value: {
#       label: "Lifetime Revenue"
#       value: "user_order_facts.lifetime_revenue"
#     }
#     allowed_value: {
#       label: "State"
#       value: "users.state"
#     }
#     allowed_value: {
#       label: "Traffic Source"
#       value: "users.traffic_source"
#     }
#     allowed_value: {
#       label: "UK Postcode"
#       value: "users.uk_postcode"
#     }
#     allowed_value: {
#       label: "US Zip Code"
#       value: "users.zip"
#     }
#   }

#   parameter: user_attribute_4 {
#     description: "Select a field to include in your BQML k-means model training data"
#     type: unquoted
#     default_value: "select_attribute"
#     allowed_value: {
#       label: "Select Attribute"
#       value: "select_attribute"
#     }
#     allowed_value: {
#       label: "Age"
#       value: "users.age"
#     }
#     allowed_value: {
#       label: "City"
#       value: "users.city"
#     }
#     allowed_value: {
#       label: "Country"
#       value: "users.country"
#     }
#     allowed_value: {
#       label: "Created Date"
#       value: "users.created"
#     }
#     allowed_value: {
#       label: "First Order Date"
#       value: "user_order_facts.first_order"
#     }
#     allowed_value: {
#       label: "Gender"
#       value: "users.gender"
#     }
#     allowed_value: {
#       label: "Latest Order Date"
#       value: "user_order_facts.latest_order"
#     }
#     allowed_value: {
#       label: "Lifetime Orders"
#       value: "user_order_facts.lifetime_orders"
#     }
#     allowed_value: {
#       label: "Lifetime Revenue"
#       value: "user_order_facts.lifetime_revenue"
#     }
#     allowed_value: {
#       label: "State"
#       value: "users.state"
#     }
#     allowed_value: {
#       label: "Traffic Source"
#       value: "users.traffic_source"
#     }
#     allowed_value: {
#       label: "UK Postcode"
#       value: "users.uk_postcode"
#     }
#     allowed_value: {
#       label: "US Zip Code"
#       value: "users.zip"
#     }
#   }

#   parameter: user_attribute_5 {
#     description: "Select a field to include in your BQML k-means model training data"
#     type: unquoted
#     default_value: "select_attribute"
#     allowed_value: {
#       label: "Select Attribute"
#       value: "select_attribute"
#     }
#     allowed_value: {
#       label: "Age"
#       value: "users.age"
#     }
#     allowed_value: {
#       label: "City"
#       value: "users.city"
#     }
#     allowed_value: {
#       label: "Country"
#       value: "users.country"
#     }
#     allowed_value: {
#       label: "Created Date"
#       value: "users.created"
#     }
#     allowed_value: {
#       label: "First Order Date"
#       value: "user_order_facts.first_order"
#     }
#     allowed_value: {
#       label: "Gender"
#       value: "users.gender"
#     }
#     allowed_value: {
#       label: "Latest Order Date"
#       value: "user_order_facts.latest_order"
#     }
#     allowed_value: {
#       label: "Lifetime Orders"
#       value: "user_order_facts.lifetime_orders"
#     }
#     allowed_value: {
#       label: "Lifetime Revenue"
#       value: "user_order_facts.lifetime_revenue"
#     }
#     allowed_value: {
#       label: "State"
#       value: "users.state"
#     }
#     allowed_value: {
#       label: "Traffic Source"
#       value: "users.traffic_source"
#     }
#     allowed_value: {
#       label: "UK Postcode"
#       value: "users.uk_postcode"
#     }
#     allowed_value: {
#       label: "US Zip Code"
#       value: "users.zip"
#     }
#   }


# }
