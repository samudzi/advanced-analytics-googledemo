view: order_items {
  sql_table_name: looker-private-demo.ecomm.order_items ;;

  ########## IDs, Foreign Keys, Counts ###########

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: number
    hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: user_id {
    type: number
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_last_28d {
    label: "Count Sold in Trailing 28 Days"
    type: count_distinct
    sql: ${id} ;;
    hidden: yes
    filters:
    {field:created_date
      value: "28 days"
    }}

  measure: order_count {
    view_label: "Orders"
    type: count_distinct
    drill_fields: [detail*]
    sql: ${order_id} ;;
  }

  # measure: first_purchase_count {
  #   view_label: "Orders"
  #   type: count_distinct
  #   sql: ${order_id} ;;
  #   filters: {
  #     field: order_facts.is_first_purchase
  #     value: "Yes"
  #   }
  #   drill_fields: [user_id, users.name, users.email, order_id, created_date, users.traffic_source]
  # }

  dimension: order_id_no_actions {
    type: number
    hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
    action: {
      label: "Send this to slack channel"
      url: "https://hooks.zapier.com/hooks/catch/1662138/tvc3zj/"
      param: {
        name: "user_dash_link"
        value: "/dashboards/ayalascustomerlookupdb?Email={{ users.email._value}}"
      }
      form_param: {
        name: "Message"
        type: textarea
        default: "Hey,
        Could you check out order #{{value}}. It's saying its {{status._value}},
        but the customer is reaching out to us about it.
        ~{{ _user_attributes.first_name}}"
      }
      form_param: {
        name: "Recipient"
        type: select
        default: "zevl"
        option: {
          name: "zevl"
          label: "Zev"
        }
        option: {
          name: "slackdemo"
          label: "Slack Demo User"
        }
      }
      form_param: {
        name: "Channel"
        type: select
        default: "cs"
        option: {
          name: "cs"
          label: "Customer Support"
        }
        option: {
          name: "general"
          label: "General"
        }
      }
    }
    action: {
      label: "Create Order Form"
      url: "https://hooks.zapier.com/hooks/catch/2813548/oosxkej/"
      form_param: {
        name: "Order ID"
        type: string
        default: "{{ order_id._value }}"
      }

      form_param: {
        name: "Name"
        type: string
        default: "{{ users.name._value }}"
      }

      form_param: {
        name: "Email"
        type: string
        default: "{{ _user_attributes.email }}"
      }

      form_param: {
        name: "Item"
        type: string
        default: "{{ products.item_name._value }}"
      }

      form_param: {
        name: "Price"
        type: string
        default: "{{ order_items.sale_price._rendered_value }}"
      }

      form_param: {
        name: "Comments"
        type: string
        default: " Hi {{ users.first_name._value }}, thanks for your business!"
      }
    }
  }

  ########## Time Dimensions ##########

  dimension_group: returned {
    type: time
    timeframes: [time, date, week, month, raw]
    sql: ${TABLE}.returned_at ;;

  }

  dimension_group: shipped {
    type: time
    timeframes: [date, week, month, raw]
    sql: CAST(${TABLE}.shipped_at AS TIMESTAMP) ;;

  }

  dimension_group: delivered {
    type: time
    timeframes: [date, week, month, raw]
    sql: CAST(${TABLE}.delivered_at AS TIMESTAMP) ;;

  }

  dimension_group: created {
    type: time
    timeframes: [time, hour, date, week, month, year, hour_of_day, day_of_week, month_num, raw, week_of_year,month_name]
    sql: ${TABLE}.created_at ;;

  }

  dimension: reporting_period {
    group_label: "Order Date"
    sql: CASE
        WHEN EXTRACT(YEAR from ${created_raw}) = EXTRACT(YEAR from CURRENT_TIMESTAMP())
        AND ${created_raw} < CURRENT_TIMESTAMP()
        THEN 'This Year to Date'

        WHEN EXTRACT(YEAR from ${created_raw}) + 1 = EXTRACT(YEAR from CURRENT_TIMESTAMP())
        AND CAST(FORMAT_TIMESTAMP('%j', ${created_raw}) AS INT64) <= CAST(FORMAT_TIMESTAMP('%j', CURRENT_TIMESTAMP()) AS INT64)
        THEN 'Last Year to Date'

      END
       ;;
  }

  dimension: days_since_sold {
    hidden: yes
    sql: TIMESTAMP_DIFF(${created_raw},CURRENT_TIMESTAMP(), DAY) ;;
  }

  # dimension: months_since_signup {
  #   view_label: "Orders"
  #   type: number
  #   sql: CAST(FLOOR(TIMESTAMP_DIFF(${created_raw}, ${users.created_raw}, DAY)/30) AS INT64) ;;
  # }

########## Logistics ##########

  dimension: status {
    sql: ${TABLE}.status ;;
  }

  dimension: days_to_process {
    type: number
    sql: CASE
        WHEN ${status} = 'Processing' THEN TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), ${created_raw}, DAY)*1.0
        WHEN ${status} IN ('Shipped', 'Complete', 'Returned') THEN TIMESTAMP_DIFF(${shipped_raw}, ${created_raw}, DAY)*1.0
        WHEN ${status} = 'Cancelled' THEN NULL
      END
       ;;
  }


  dimension: shipping_time {
    type: number
    sql: TIMESTAMP_DIFF(${delivered_raw}, ${shipped_raw}, DAY)*1.0 ;;
  }

  measure: average_days_to_process {
    type: average
    value_format_name: decimal_2
    sql: ${days_to_process} ;;
  }

  measure: average_shipping_time {
    type: average
    value_format_name: decimal_2
    sql: ${shipping_time} ;;
  }

########## Financial Information ##########

  dimension: sale_price {
    type: number
    value_format_name: usd
    sql: ${TABLE}.sale_price ;;
  }

  dimension: gross_margin {
    type: number
    value_format_name: usd
    sql: ${sale_price} - ${inventory_items.cost} ;;
  }

  dimension: item_gross_margin_percentage {
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${gross_margin}/nullif(0,${sale_price}) ;;
  }

  dimension: item_gross_margin_percentage_tier {
    type: tier
    sql: 100*${item_gross_margin_percentage} ;;
    tiers: [0, 10, 20, 30, 40, 50, 60, 70, 80, 90]
    style: interval
  }

  measure: total_sale_price {
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [detail*]
  }

  measure: total_gross_margin {
    type: sum
    value_format_name: usd
    sql: ${gross_margin} ;;
    drill_fields: [detail*]
  }

  measure: average_sale_price {
    type: average
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [detail*]
  }

  measure: median_sale_price {
    type: median
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [detail*]
  }

  measure: average_gross_margin {
    type: average
    value_format_name: usd
    sql: ${gross_margin} ;;
    drill_fields: [detail*]
  }

  measure: total_gross_margin_percentage {
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${total_gross_margin}/ nullif(${total_sale_price},0) ;;
  }

  # measure: average_spend_per_user {
  #   type: number
  #   value_format_name: usd
  #   sql: 1.0 * ${total_sale_price} / nullif(${users.count},0) ;;
  #   drill_fields: [detail*]
  # }

########## Return Information ##########

  dimension: is_returned {
    type: yesno
    sql: ${returned_raw} IS NOT NULL ;;
  }

  measure: returned_count {
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: is_returned
      value: "yes"
    }
    drill_fields: [detail*]
  }

  measure: returned_total_sale_price {
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    filters: {
      field: is_returned
      value: "yes"
    }
  }

  measure: return_rate {
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${returned_count} / nullif(${count},0) ;;
  }


########## Repeat Purchase Facts ##########

  dimension: days_until_next_order {
    type: number
    view_label: "Repeat Purchase Facts"
    sql: TIMESTAMP_DIFF(${created_raw},${repeat_purchase_facts.next_order_raw}, DAY) ;;
  }

  dimension: repeat_orders_within_30d {
    type: yesno
    view_label: "Repeat Purchase Facts"
    sql: ${days_until_next_order} <= 30 ;;
  }

  dimension: repeat_orders_within_15d{
    type: yesno
    sql:  ${days_until_next_order} <= 15;;
  }

  measure: count_with_repeat_purchase_within_30d {
    type: count_distinct
    sql: ${id} ;;
    view_label: "Repeat Purchase Facts"

    filters: {
      field: repeat_orders_within_30d
      value: "Yes"
    }
  }

  measure: 30_day_repeat_purchase_rate {
    description: "The percentage of customers who purchase again within 30 days"
    view_label: "Repeat Purchase Facts"
    type: number
    value_format_name: percent_1
    sql: 1.0 * ${count_with_repeat_purchase_within_30d} / (CASE WHEN ${count} = 0 THEN NULL ELSE ${count} END) ;;
    drill_fields: [products.brand, order_count, count_with_repeat_purchase_within_30d]
  }

########## Dynamic Sales Cohort App ##########

#   filter: cohort_by {
#     type: string
#     hidden: yes
#     suggestions: ["Week", "Month", "Quarter", "Year"]
#   }
#
#   filter: metric {
#     type: string
#     hidden: yes
#     suggestions: ["Order Count", "Gross Margin", "Total Sales", "Unique Users"]
#   }
#
#   dimension_group: first_order_period {
#     type: time
#     timeframes: [date]
#     hidden: yes
#     sql: CAST(DATE_TRUNC({% parameter cohort_by %}, ${user_order_facts.first_order_date}) AS TIMESTAMP)
#       ;;
#   }
#
#   dimension: periods_as_customer {
#     type: number
#     hidden: yes
#     sql: TIMESTAMP_DIFF(${user_order_facts.first_order_date}, ${user_order_facts.latest_order_date}, {% parameter cohort_by %})
#       ;;
#   }
#
#   measure: cohort_values_0 {
#     type: count_distinct
#     hidden: yes
#     sql: CASE WHEN {% parameter metric %} = 'Order Count' THEN ${id}
#         WHEN {% parameter metric %} = 'Unique Users' THEN ${users.id}
#         ELSE null
#       END
#        ;;
#   }
#
#   measure: cohort_values_1 {
#     type: sum
#     hidden: yes
#     sql: CASE WHEN {% parameter metric %} = 'Gross Margin' THEN ${gross_margin}
#         WHEN {% parameter metric %} = 'Total Sales' THEN ${sale_price}
#         ELSE 0
#       END
#        ;;
#   }
#
#   measure: values {
#     type: number
#     hidden: yes
#     sql: ${cohort_values_0} + ${cohort_values_1} ;;
#   }

########## Sets ##########

  set: detail {
    fields: [id, order_id, status, created_date, sale_price, products.brand, products.item_name, users.portrait, users.name, users.email]
  }
  set: return_detail {
    fields: [id, order_id, status, created_date, returned_date, sale_price, products.brand, products.item_name, users.portrait, users.name, users.email]
  }
}


  view: users {
    sql_table_name: `looker-private-demo.ecomm.users` ;;

    ## Demographics ##

    dimension: id {
      primary_key: yes
      type: number
      sql: ${TABLE}.id ;;
      tags: ["user_id"]
    }

    dimension: first_name {
      hidden: yes
      sql: CONCAT(UPPER(SUBSTR(${TABLE}.first_name,1,1)), LOWER(SUBSTR(${TABLE}.first_name,2))) ;;

    }

    dimension: last_name {
      hidden: yes
      sql: CONCAT(UPPER(SUBSTR(${TABLE}.last_name,1,1)), LOWER(SUBSTR(${TABLE}.last_name,2))) ;;
    }

    dimension: name {
      sql: concat(${first_name}, ' ', ${last_name}) ;;
    }

    dimension: age {
      type: number
      sql: ${TABLE}.age ;;
    }

    dimension: over_21 {
      type: yesno
      sql:  ${age} > 21;;
    }

    dimension: age_tier {
      type: tier
      tiers: [0, 10, 20, 30, 40, 50, 60, 70]
      style: integer
      sql: ${age} ;;
    }

    dimension: gender {
      sql: ${TABLE}.gender ;;
    }

    dimension: gender_short {
      sql: LOWER(SUBSTR(${gender},1,1)) ;;
    }

    dimension: user_image {
      sql: ${image_file} ;;
      html: <img src="{{ value }}" width="220" height="220"/>;;
    }

    dimension: email {
      sql: ${TABLE}.email ;;
      tags: ["email"]

      link: {
        label: "User Lookup Dashboard"
        url: "/dashboards/ayalascustomerlookupdb?Email={{ value | encode_uri }}"
        icon_url: "http://www.looker.com/favicon.ico"
      }
      action: {
        label: "Email Promotion to Customer"
        url: "https://desolate-refuge-53336.herokuapp.com/posts"
        icon_url: "https://sendgrid.com/favicon.ico"
        param: {
          name: "some_auth_code"
          value: "abc123456"
        }
        form_param: {
          name: "Subject"
          required: yes
          default: "Thank you {{ users.name._value }}"
        }
        form_param: {
          name: "Body"
          type: textarea
          required: yes
          default:
          "Dear {{ users.first_name._value }},

          Thanks for your loyalty to the Look.  We'd like to offer you a 10% discount
          on your next purchase!  Just use the code LOYAL when checking out!

          Your friends at the Look"
        }
      }
      required_fields: [name, first_name]
    }

    dimension: image_file {
      hidden: yes
      sql: concat('https://docs.looker.com/assets/images/',${gender_short},'.jpg') ;;
    }

    ## Demographics ##

    dimension: city {
      sql: ${TABLE}.city ;;
      drill_fields: [zip]
    }

    dimension: state {
      sql: ${TABLE}.state ;;
      map_layer_name: us_states
      drill_fields: [zip, city]
    }

    dimension: zip {
      type: zipcode
      sql: ${TABLE}.zip ;;
    }

    dimension: uk_postcode {
      label: "UK Postcode"
      sql: case when ${TABLE}.country = 'UK' then regexp_replace(${zip}, '[0-9]', '') else null end;;
      map_layer_name: uk_postcode_areas
      drill_fields: [city, zip]
    }

    dimension: country {
      map_layer_name: countries
      drill_fields: [state, city]
      sql: CASE WHEN ${TABLE}.country = 'UK' THEN 'United Kingdom'
           ELSE ${TABLE}.country
           END
       ;;
    }

    dimension: location {
      type: location
      sql_latitude: ${TABLE}.latitude ;;
      sql_longitude: ${TABLE}.longitude ;;
    }

    dimension: approx_latitude {
      type: number
      sql: round(${TABLE}.latitude,1) ;;
    }

    dimension: approx_longitude {
      type: number
      sql:round(${TABLE}.longitude,1) ;;
    }

    dimension: approx_location {
      type: location
      drill_fields: [location]
      sql_latitude: ${approx_latitude} ;;
      sql_longitude: ${approx_longitude} ;;
      link: {
        label: "Google Directions from {{ distribution_centers.name._value }}"
        url: "{% if distribution_centers.location._in_query %}https://www.google.com/maps/dir/'{{ distribution_centers.latitude._value }},{{ distribution_centers.longitude._value }}'/'{{ approx_latitude._value }},{{ approx_longitude._value }}'{% endif %}"
        icon_url: "http://www.google.com/s2/favicons?domain=www.google.com"
      }

    }

    ## Other User Information ##

    dimension_group: created {
      type: time
#     timeframes: [time, date, week, month, raw]
      sql: ${TABLE}.created_at ;;
    }

    dimension: history {
      sql: ${TABLE}.id ;;
      html: <a href="/explore/thelook_event/order_items?fields=order_items.detail*&f[users.id]={{ value }}">Order History</a>
        ;;
    }

    dimension: traffic_source {
      sql: ${TABLE}.traffic_source ;;
    }

    dimension: ssn {
      # dummy field used in next dim, generate 4 random numbers to be the last 4 digits
      hidden: yes
      type: string
      sql: CONCAT(CAST(FLOOR(10*RAND()) AS INT64),CAST(FLOOR(10*RAND()) AS INT64),
        CAST(FLOOR(10*RAND()) AS INT64),CAST(FLOOR(10*RAND()) AS INT64));;
    }

    dimension: ssn_last_4 {
      label: "SSN Last 4"
      description: "Only users with sufficient permissions will see this data"
      type: string
      sql: CASE WHEN '{{_user_attributes["can_see_sensitive_data"]}}' = 'Yes'
                THEN ${ssn}
                ELSE '####' END;;
    }

    ## MEASURES ##

    measure: count {
      type: count
      drill_fields: [detail*]
    }

    measure: count_percent_of_total {
      label: "Count (Percent of Total)"
      type: percent_of_total
      sql: ${count} ;;
      drill_fields: [detail*]
    }

    measure: average_age {
      type: average
      value_format_name: decimal_2
      sql: ${age} ;;
      drill_fields: [detail*]
    }

    set: detail {
      fields: [id, name, email, age, created_date, orders.count, order_items.count]
    }
  }


  view: inventory_items {
    sql_table_name: looker-private-demo.ecomm.inventory_items ;;

    ## DIMENSIONS ##

    dimension: id {
      primary_key: yes
      type: number
      sql: ${TABLE}.id ;;
    }

    dimension: cost {
      type: number
      value_format_name: usd
      sql: ${TABLE}.cost ;;
    }

    dimension_group: created {
      type: time
      timeframes: [time, date, week, month, raw]
      #sql: cast(CASE WHEN ${TABLE}.created_at = "\\N" THEN NULL ELSE ${TABLE}.created_at END as timestamp) ;;
      sql: CAST(${TABLE}.created_at AS TIMESTAMP) ;;
    }

    dimension: product_id {
      type: number
      hidden: yes
      sql: ${TABLE}.product_id ;;
    }

    dimension_group: sold {
      type: time
      timeframes: [time, date, week, month, raw]
#    sql: cast(CASE WHEN ${TABLE}.sold_at = "\\N" THEN NULL ELSE ${TABLE}.sold_at END as timestamp) ;;
      sql: ${TABLE}.sold_at ;;
    }

    dimension: is_sold {
      type: yesno
      sql: ${sold_raw} is not null ;;
    }

    dimension: days_in_inventory {
      description: "days between created and sold date"
      type: number
      sql: TIMESTAMP_DIFF(coalesce(${sold_raw}, CURRENT_TIMESTAMP()), ${created_raw}, DAY) ;;
    }

    dimension: days_in_inventory_tier {
      type: tier
      sql: ${days_in_inventory} ;;
      style: integer
      tiers: [0, 5, 10, 20, 40, 80, 160, 360]
    }

    dimension: days_since_arrival {
      description: "days since created - useful when filtering on sold yesno for items still in inventory"
      type: number
      sql: TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), ${created_raw}, DAY) ;;
    }

    dimension: days_since_arrival_tier {
      type: tier
      sql: ${days_since_arrival} ;;
      style: integer
      tiers: [0, 5, 10, 20, 40, 80, 160, 360]
    }

    dimension: product_distribution_center_id {
      hidden: yes
      sql: ${TABLE}.product_distribution_center_id ;;
    }

    ## MEASURES ##

    measure: sold_count {
      type: count
      drill_fields: [detail*]

      filters: {
        field: is_sold
        value: "Yes"
      }
    }

    measure: sold_percent {
      type: number
      value_format_name: percent_2
      sql: 1.0 * ${sold_count}/(CASE WHEN ${count} = 0 THEN NULL ELSE ${count} END) ;;
    }

    measure: total_cost {
      type: sum
      value_format_name: usd
      sql: ${cost} ;;
    }

    measure: average_cost {
      type: average
      value_format_name: usd
      sql: ${cost} ;;
    }

    measure: count {
      type: count
      drill_fields: [detail*]
    }

    measure: number_on_hand {
      type: count
      drill_fields: [detail*]

      filters: {
        field: is_sold
        value: "No"
      }
    }

    measure: stock_coverage_ratio {
      type:  number
      description: "Stock on Hand vs Trailing 28d Sales Ratio"
      sql:  1.0 * ${number_on_hand} / nullif(${order_items.count_last_28d}*20.0,0) ;;
      value_format_name: decimal_2
      html: <p style="color: black; background-color: rgba({{ value | times: -100.0 | round | plus: 250 }},{{value | times: 100.0 | round | plus: 100}},100,80); font-size:100%; text-align:center">{{ rendered_value }}</p> ;;
    }

    set: detail {
      fields: [id, products.item_name, products.category, products.brand, products.department, cost, created_time, sold_time]
    }
  }


  view: products {
    sql_table_name: looker-private-demo.ecomm.products ;;

    ### DIMENSIONS ###

    dimension: id {
      primary_key: yes
      type: number
      sql: ${TABLE}.id ;;
    }

    dimension: category {
      sql: TRIM(${TABLE}.category) ;;
      drill_fields: [item_name]
    }

    dimension: item_name {
      sql: TRIM(${TABLE}.name) ;;
    }

    dimension: brand {
      sql: TRIM(${TABLE}.brand) ;;
      link: {
        label: "Website"
        url: "http://www.google.com/search?q={{ value | encode_uri }}+clothes&btnI"
        icon_url: "http://www.google.com/s2/favicons?domain=www.{{ value | encode_uri }}.com"
      }
      link: {
        label: "Facebook"
        url: "http://www.google.com/search?q=site:facebook.com+{{ value | encode_uri }}+clothes&btnI"
        icon_url: "https://upload.wikimedia.org/wikipedia/commons/c/c2/F_icon.svg"
      }
      link: {
        label: "{{value}} Analytics Dashboard"
        url: "/dashboards/CRMxoGiGJUv4eGALMHiAb0?Brand%20Name={{ value | encode_uri }}"
        icon_url: "http://www.looker.com/favicon.ico"
      }
      drill_fields: [category, item_name]
    }

    dimension: retail_price {
      type: number
      sql: ${TABLE}.retail_price ;;
    }

    dimension: department {
      sql: TRIM(${TABLE}.department) ;;
    }

    dimension: sku {
      sql: ${TABLE}.sku ;;
    }

    dimension: distribution_center_id {
      type: number
      sql: CAST(${TABLE}.distribution_center_id AS INT64) ;;
    }

    ## MEASURES ##

    measure: count {
      type: count
      drill_fields: [detail*]
    }

    measure: brand_count {
      type: count_distinct
      sql: ${brand} ;;
      drill_fields: [brand, detail2*, -brand_count] # show the brand, a bunch of counts (see the set below), don't show the brand count, because it will always be 1
    }

    measure: category_count {
      alias: [category.count]
      type: count_distinct
      sql: ${category} ;;
      drill_fields: [category, detail2*, -category_count] # don't show because it will always be 1
    }

    measure: department_count {
      alias: [department.count]
      type: count_distinct
      sql: ${department} ;;
      drill_fields: [department, detail2*, -department_count] # don't show because it will always be 1
    }

    set: detail {
      fields: [id, item_name, brand, category, department, retail_price, customers.count, orders.count, order_items.count, inventory_items.count]
    }

    set: detail2 {
      fields: [category_count, brand_count, department_count, count, customers.count, orders.count, order_items.count, inventory_items.count, products.count]
    }
  }


  view: distribution_centers {
    sql_table_name: looker-private-demo.ecomm.distribution_centers ;;
    dimension: location {
      type: location
      sql_latitude: ${TABLE}.latitude ;;
      sql_longitude: ${TABLE}.longitude ;;
    }

    dimension: latitude {
      sql: ${TABLE}.latitude ;;
      hidden: yes
    }

    dimension: longitude {
      sql: ${TABLE}.longitude ;;
      hidden: yes
    }

    dimension: id {
      type: number
      primary_key: yes
      sql: ${TABLE}.id ;;
    }

    dimension: name {
      sql: ${TABLE}.name ;;
    }
  }


  include: "/models/advanced_analytics_accelerator.model"
  view: order_facts {
    derived_table: {
      explore_source: order_items {
        column: order_id {field: order_items.order_id_no_actions }
        column: items_in_order { field: order_items.count }
        column: order_amount { field: order_items.total_sale_price }
        column: order_cost { field: inventory_items.total_cost }
        column: user_id {field: order_items.user_id }
        column: created_at {field: order_items.created_raw}
        column: order_gross_margin {field: order_items.total_gross_margin}
        derived_column: order_sequence_number {
          sql: RANK() OVER (PARTITION BY user_id ORDER BY created_at) ;;
        }
      }
      datagroup_trigger: ecommerce_etl
    }

    dimension: order_id {
      type: number
      hidden: yes
      primary_key: yes
      sql: ${TABLE}.order_id ;;
    }

    dimension: items_in_order {
      type: number
      sql: ${TABLE}.items_in_order ;;
    }

    dimension: order_amount {
      type: number
      value_format_name: usd
      sql: ${TABLE}.order_amount ;;
    }

    dimension: order_cost {
      type: number
      value_format_name: usd
      sql: ${TABLE}.order_cost ;;
    }

    dimension: order_gross_margin {
      type: number
      value_format_name: usd
    }

    dimension: order_sequence_number {
      type: number
      sql: ${TABLE}.order_sequence_number ;;
    }

    dimension: is_first_purchase {
      type: yesno
      sql: ${order_sequence_number} = 1 ;;
    }
  }

  view: user_order_facts {
    derived_table: {
      sql:
          SELECT
              user_id
              , COUNT(DISTINCT order_id) AS lifetime_orders
              , SUM(sale_price) AS lifetime_revenue
              , CAST(MIN(created_at)  AS TIMESTAMP) AS first_order
              , CAST(MAX(created_at)  AS TIMESTAMP)  AS latest_order
              , COUNT(DISTINCT FORMAT_TIMESTAMP('%Y%m', created_at))  AS number_of_distinct_months_with_orders
              --, FIRST_VALUE(CONCAT(uniform(2, 9, random(1)),uniform(0, 9, random(2)),uniform(0, 9, random(3)),'-',uniform(0, 9, random(4)),uniform(0, 9, random(5)),uniform(0, 9, random(6)),'-',uniform(0, 9, random(7)),uniform(0, 9, random(8)),uniform(0, 9, random(9)),uniform(0, 9, random(10)))) OVER (PARTITION BY user_id ORDER BY user_id) AS phone_number
            FROM `looker-private-demo.ecomm.order_items`
            GROUP BY user_id
          ;;
      datagroup_trigger: ecommerce_etl
      publish_as_db_view: yes
    }

    dimension: user_id {
      primary_key: yes
      hidden: yes
      sql: ${TABLE}.user_id ;;
    }

#   dimension: phone_number {
#     type: string
#     tags: ["phone"]
#     sql: ${TABLE}.phone_number ;;
#   }


    ##### Time and Cohort Fields ######

    dimension_group: first_order {
      type: time
      timeframes: [date, week, month, year]
      sql: ${TABLE}.first_order ;;
    }

    dimension_group: latest_order {
      type: time
      timeframes: [raw, date, week, month, year]
      sql: ${TABLE}.latest_order ;;
    }


    dimension: days_as_customer {
      description: "Days between first and latest order"
      type: number
      sql: TIMESTAMP_DIFF(${TABLE}.latest_order, ${TABLE}.first_order, DAY)+1 ;;
    }

    dimension: days_as_customer_tiered {
      type: tier
      tiers: [0, 1, 7, 14, 21, 28, 30, 60, 90, 120]
      sql: ${days_as_customer} ;;
      style: integer
    }

    ##### Lifetime Behavior - Order Counts ######

    dimension: lifetime_orders {
      type: number
      sql: ${TABLE}.lifetime_orders ;;
    }

    dimension: repeat_customer {
      description: "Lifetime Count of Orders > 1"
      type: yesno
      sql: ${lifetime_orders} > 1 ;;
    }

    dimension: lifetime_orders_tier {
      type: tier
      tiers: [0, 1, 2, 3, 5, 10]
      sql: ${lifetime_orders} ;;
      style: integer
    }

    measure: average_lifetime_orders {
      type: average
      value_format_name: decimal_2
      sql: ${lifetime_orders} ;;
    }

    dimension: distinct_months_with_orders {
      type: number
      sql: ${TABLE}.number_of_distinct_months_with_orders ;;
    }

    ##### Lifetime Behavior - Revenue ######

    dimension: lifetime_revenue {
      type: number
      value_format_name: usd
      sql: ${TABLE}.lifetime_revenue ;;
    }

    dimension: lifetime_revenue_tier {
      type: tier
      tiers: [0, 25, 50, 100, 200, 500, 1000]
      sql: ${lifetime_revenue} ;;
      style: integer
    }

    measure: average_lifetime_revenue {
      type: average
      value_format_name: usd
      sql: ${lifetime_revenue} ;;
    }

    measure: average_latest_order_date {
      type: date
      sql: timestamp_seconds(CAST(avg(unix_seconds(${latest_order_raw})) AS INT64)) ;;
    }
  }


  view: repeat_purchase_facts {
    derived_table: {
      datagroup_trigger: ecommerce_etl
      sql: SELECT
              order_items.order_id as order_id
              , order_items.created_at
              , COUNT(DISTINCT repeat_order_items.id) AS number_subsequent_orders
              , MIN(repeat_order_items.created_at) AS next_order_date
              , MIN(repeat_order_items.order_id) AS next_order_id
            FROM looker-private-demo.ecomm.order_items as order_items
            LEFT JOIN looker-private-demo.ecomm.order_items repeat_order_items
              ON order_items.user_id = repeat_order_items.user_id
              AND order_items.created_at < repeat_order_items.created_at
            GROUP BY 1, 2
             ;;
    }

    dimension: order_id {
      type: number
      hidden: yes
      primary_key: yes
      sql: ${TABLE}.order_id ;;
    }

    dimension: next_order_id {
      type: number
      hidden: yes
      sql: ${TABLE}.next_order_id ;;
    }

    dimension: has_subsequent_order {
      type: yesno
      sql: ${next_order_id} > 0 ;;
    }

    dimension: number_subsequent_orders {
      type: number
      sql: ${TABLE}.number_subsequent_orders ;;
    }

    dimension_group: next_order {
      type: time
      timeframes: [raw, date]
      hidden: yes
      sql: CAST(${TABLE}.next_order_date AS TIMESTAMP) ;;
    }
  }

  view: affinity {
    derived_table: {
      datagroup_trigger: ecommerce_etl
      sql: SELECT
          product_a_id
          , product_b_id
          , joint_user_freq
          , joint_order_freq
          , top1.prod_freq AS product_a_freq
          , top2.prod_freq AS product_b_freq
        FROM
        (
        SELECT
          up1.prod_id AS product_a_id
          , up2.prod_id AS product_b_id
          , COUNT(*) AS joint_user_freq
        FROM ${user_order_product.SQL_TABLE_NAME} AS up1
          LEFT JOIN ${user_order_product.SQL_TABLE_NAME} AS up2
            ON up1.user_id = up2.user_id
            AND up1.prod_id <> up2.prod_id
          GROUP BY product_a_id, product_b_id
        ) AS juf
    LEFT JOIN
      (
      SELECT
        op1.prod_id AS oproduct_a_id
        , op2.prod_id AS oproduct_b_id
        , COUNT(*) AS joint_order_freq
      FROM ${user_order_product.SQL_TABLE_NAME} op1
        LEFT JOIN ${user_order_product.SQL_TABLE_NAME} op2
          ON op1.order_id = op2.order_id
          AND op1.prod_id <> op2.prod_id
        GROUP BY oproduct_a_id, oproduct_b_id
      ) AS jof
      ON jof.oproduct_a_id = juf.product_a_id
      AND jof.oproduct_b_id = juf.product_b_id
    LEFT JOIN ${total_order_product.SQL_TABLE_NAME} top1
      ON top1.prod_id = juf.product_a_id
    LEFT JOIN ${total_order_product.SQL_TABLE_NAME} top2
      ON top2.prod_id = juf.product_b_id
    ;;
    }

    measure: count {
      type: count
      drill_fields: [detail*]
    }

    dimension: product_a_id {
      sql: ${TABLE}.product_a_id ;;
    }

    dimension: product_b_id {
      sql: ${TABLE}.product_b_id ;;
    }

    dimension: joint_user_freq {
      description: "The number of users who have purchased both product a and product b"
      type: number
      sql: ${TABLE}.joint_user_freq ;;
    }

    dimension: joint_order_freq {
      description: "The number of orders that include both product a and product b"
      type: number
      sql: ${TABLE}.joint_order_freq ;;
    }

    dimension: product_a_freq {
      description: "The total number of times product a has been purchased"
      type: number
      sql: ${TABLE}.product_a_freq ;;
    }

    dimension: product_b_freq {
      description: "The total number of times product b has been purchased"
      type: number
      sql: ${TABLE}.product_b_freq ;;
    }

    dimension: user_affinity {
      hidden: yes
      type: number
      sql: 1.0*${joint_user_freq}/NULLIF((${product_a_freq}+${product_b_freq})-(${joint_user_freq}),0) ;;
      value_format_name: percent_2
    }

    dimension: order_affinity {
      hidden: yes
      type: number
      sql: 1.0*${joint_order_freq}/NULLIF((${product_a_freq}+${product_b_freq})-(${joint_order_freq}),0) ;;
      value_format_name: percent_2
    }

    measure: avg_user_affinity {
      label: "Affinity Score (by User History)"
      description: "Percentage of users that bought both products weighted by how many times each product sold individually"
      type: average
      sql: 100.0 * ${user_affinity} ;;
      value_format_name: decimal_2
    }

    measure: avg_order_affinity {
      label: "Affinity Score (by Order Basket)"
      description: "Percentage of orders that contained both products weighted by how many times each product sold individually"
      type: average
      sql: 100.0 * ${order_affinity} ;;
      value_format_name: decimal_2
    }

    measure: combined_affinity {
      type: number
      sql: ${avg_user_affinity} + ${avg_order_affinity} ;;
    }

    set: detail {
      fields: [product_a_id,product_b_id,user_affinity,order_affinity]
    }
  }



#############################################
#Table that aggregates the products purchased by user and order id
  view: user_order_product {
    derived_table: {
      datagroup_trigger: ecommerce_etl
      sql: SELECT
        oi.user_id AS user_id
        , p.id AS prod_id
        , oi.order_id AS order_id
      FROM looker-private-demo.ecomm.order_items oi
      LEFT JOIN looker-private-demo.ecomm.inventory_items ii
        ON oi.inventory_item_id = ii.id
      LEFT JOIN looker-private-demo.ecomm. products p
        ON ii.product_id = p.id
      GROUP BY 1,2,3
       ;;
    }

#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }

    dimension: user_id {
      type: number
      sql: ${TABLE}.user_id ;;
    }

    dimension: prod_id {
      type: number
      sql: ${TABLE}.prod_id ;;
    }

    dimension: order_id {
      type: number
      sql: ${TABLE}.order_id ;;
    }
  }

#################################################
#Table to count the total times a product id has been purchased
  view: total_order_product {
    derived_table: {
      datagroup_trigger: ecommerce_etl
      sql: SELECT
        p.id AS prod_id
        , COUNT(*) AS prod_freq
      FROM looker-private-demo.ecomm.order_items oi
      LEFT JOIN looker-private-demo.ecomm.inventory_items
        ON oi.inventory_item_id = inventory_items.id
      LEFT JOIN looker-private-demo.ecomm.products p
        ON inventory_items.product_id = p.id
      GROUP BY p.id
       ;;
    }

#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }

    dimension: prod_id {
      sql: ${TABLE}.prod_id ;;
    }

    dimension: prod_freq {
      type: number
      sql: ${TABLE}.prod_freq ;;
    }
  }

  view: order_items_share_of_wallet {
    view_label: "Share of Wallet"
    #
    #   - measure: total_sale_price
    #     type: sum
    #     value_format: '$#,###'
    #     sql: ${sale_price}
    #


    ########## Comparison for Share of Wallet ##########

    filter: item_name {
      view_label: "Share of Wallet (Item Level)"
      suggest_dimension: products.item_name
      suggest_explore: orders_with_share_of_wallet_application
    }

    filter: brand {
      view_label: "Share of Wallet (Brand Level)"
      suggest_dimension: products.brand
      suggest_explore: orders_with_share_of_wallet_application
    }

    dimension: primary_key {
      sql: ${order_items.id} ;;
      primary_key: yes
      hidden: yes
    }

    dimension: item_comparison {
      view_label: "Share of Wallet (Item Level)"
      description: "Compare a selected item vs. other items in the brand vs. all other brands"
      sql: CASE
              WHEN {% condition item_name %} rtrim(ltrim(products.item_name)) {% endcondition %}
              THEN concat('(1) ',${products.item_name})
              WHEN  {% condition brand %} rtrim(ltrim(products.brand)) {% endcondition %}
              THEN concat('(2) Rest of ', ${products.brand})
              ELSE '(3) Rest of Population'
              END
               ;;
    }

    dimension: brand_comparison {
      view_label: "Share of Wallet (Brand Level)"
      description: "Compare a selected brand vs. all other brands"
      sql: CASE
              WHEN  {% condition brand %} rtrim(ltrim(products.brand)) {% endcondition %}
              THEN concat('(1) ',${products.brand})
              ELSE '(2) Rest of Population'
              END
               ;;
    }

    measure: total_sale_price_this_item {
      view_label: "Share of Wallet (Item Level)"
      type: sum
      hidden: yes
      sql: ${order_items.sale_price} ;;
      value_format_name: usd

      filters: {
        field: order_items_share_of_wallet.item_comparison
        value: "(1)%"
      }
    }

    measure: total_sale_price_this_brand {
      view_label: "Share of Wallet (Item Level)"
      type: sum
      hidden: yes
      value_format_name: usd
      sql: ${order_items.sale_price} ;;

      filters: {
        field: order_items_share_of_wallet.item_comparison
        value: "(2)%,(1)%"
      }
    }

    measure: total_sale_price_brand_v2 {
      view_label: "Share of Wallet (Brand Level)"
      label: "Total Sales - This Brand"
      type: sum
      value_format_name: usd
      sql: ${order_items.sale_price} ;;

      filters: {
        field: order_items_share_of_wallet.brand_comparison
        value: "(1)%"
      }
    }

    measure: item_share_of_wallet_within_brand {
      view_label: "Share of Wallet (Item Level)"
      type: number
      description: "This item sales over all sales for same brand"
      #     view_label: 'Share of Wallet'
      value_format_name: percent_2
      sql: ${total_sale_price_this_item}*1.0 / nullif(${total_sale_price_this_brand},0) ;;
    }

    measure: item_share_of_wallet_within_company {
      view_label: "Share of Wallet (Item Level)"
      description: "This item sales over all sales across website"
      value_format_name: percent_2
      #     view_label: 'Share of Wallet'
      type: number
      sql: ${total_sale_price_this_item}*1.0 / nullif(${order_items.total_sale_price},0) ;;
    }

    measure: brand_share_of_wallet_within_company {
      view_label: "Share of Wallet (Brand Level)"
      description: "This brand's sales over all sales across website"
      value_format_name: percent_2
      #     view_label: 'Share of Wallet'
      type: number
      sql: ${total_sale_price_brand_v2}*1.0 / nullif(${order_items.total_sale_price},0) ;;
    }
  }


  view: inventory_snapshot {
    derived_table: {
      datagroup_trigger: ecommerce_etl
      sql: with calendar as
              (
              select distinct created_at as snapshot_date
                from looker-private-demo.ecomm.inventory_items
              )

              select
                inventory_items.product_id
                ,calendar.snapshot_date
                ,count(*) as number_in_stock
              from looker-private-demo.ecomm.inventory_items
                 join calendar
                  on inventory_items.created_at <= calendar.snapshot_date
                  and (date(inventory_items.sold_at) >= calendar.snapshot_date OR inventory_items.sold_at is null)
                group by 1,2;;
    }

    dimension: product_id {
      type: number
      sql: ${TABLE}.product_id ;;
    }

    dimension: snapshot_date {
      type: date
      sql:  cast(${TABLE}.snapshot_date as timestamp) ;;
    }

    dimension: number_in_stock {
      type: number
      hidden: yes
      sql: ${TABLE}.number_in_stock ;;
    }

    measure: total_in_stock {
      type: sum
      sql: ${number_in_stock} ;;
    }

    measure: stock_coverage_ratio {
      type: number
      sql: 1.0 * ${total_in_stock} / (11.0*nullif(${trailing_sales_snapshot.sum_trailing_28d_sales},0)) ;;
      value_format_name: decimal_2
    }

    measure: sum_stock_yesterday {
      type: sum
      hidden: yes
      sql: ${number_in_stock} ;;
      filters: {
        field: snapshot_date
        value: "yesterday"
      }
    }

    measure: sum_stock_last_wk {
      type: sum
      hidden: yes
      sql: ${number_in_stock} ;;
      filters: {
        field: snapshot_date
        value: "8 days ago for 1 day"
      }
    }

    measure: stock_coverage_ratio_yday {
      type: number
      view_label: "Stock Ratio Changes"
      sql: 1.0 * ${sum_stock_yesterday} / (11*nullif(${trailing_sales_snapshot.sum_trailing_28d_sales_yesterday},0)) ;;
      value_format_name: decimal_2
    }

    measure: stock_coverage_ratio_last_wk {
      type: number
      view_label: "Stock Ratio Changes"
      sql: 1.0 * ${sum_stock_last_wk} / nullif(${trailing_sales_snapshot.sum_trailing_28d_sales_last_wk},0) ;;
      value_format_name: decimal_2
    }

    measure: wk_to_wk_change_coverage {
      label: "WoW Change - Coverage Ratio"
      view_label: "Stock Ratio Changes"
      sql: round(100*(${stock_coverage_ratio_yday}-${stock_coverage_ratio_last_wk}),1) ;;
      value_format_name: decimal_1
#     value_format: "# 'bp'"
    }

    set: detail {
      fields: [product_id, snapshot_date, number_in_stock]
    }
  }


  view: trailing_sales_snapshot {
    derived_table: {
      datagroup_trigger: ecommerce_etl
      sql: with calendar as
              (select distinct created_at as snapshot_date
              from looker-private-demo.ecomm.inventory_items
              -- where dateadd('day',90,created_at)>=current_date
              )

              select
                inventory_items.product_id
                ,date(order_items.created_at) as snapshot_date
                ,count(*) as trailing_28d_sales
              from looker-private-demo.ecomm.order_items
              join looker-private-demo.ecomm.inventory_items
                on order_items.inventory_item_id = inventory_items.id
              join calendar
                on date(order_items.created_at) <= date_add(calendar.snapshot_date, interval 28 day)
                and date(order_items.created_at) >= calendar.snapshot_date
              -- where dateadd('day',90,calendar.snapshot_date)>=current_date
              group by 1,2
            ;;
    }

#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }

    dimension: product_id {
      type: number
      sql: ${TABLE}.product_id ;;
    }

    dimension: snapshot_date {
      type: date
      sql: cast(${TABLE}.snapshot_date as timestamp) ;;
    }

    dimension: trailing_28d_sales {
      type: number
      hidden: yes
      sql: ${TABLE}.trailing_28d_sales ;;
    }

    measure: sum_trailing_28d_sales {
      type: sum
      sql: ${trailing_28d_sales} ;;
    }

    measure: sum_trailing_28d_sales_yesterday {
      type: sum
      hidden: yes
      sql: ${trailing_28d_sales} ;;
      filters: {
        field: snapshot_date
        value: "yesterday"
      }
    }

    measure: sum_trailing_28d_sales_last_wk {
      type: sum
      hidden: yes
      sql: ${trailing_28d_sales} ;;
      filters: {
        field: snapshot_date
        value: "8 days ago for 1 day"
      }
    }

    set: detail {
      fields: [product_id, snapshot_date, trailing_28d_sales]
    }
  }


  view: events {
    sql_table_name: looker-private-demo.ecomm.events ;;

    dimension: event_id {
      type: number
      primary_key: yes
      tags: ["mp_event_id"]
      sql: ${TABLE}.id ;;
    }

    dimension: session_id {
      type: number
      hidden: yes
      sql: ${TABLE}.session_id ;;
    }

    dimension: ip {
      label: "IP Address"
      view_label: "Visitors"
      sql: ${TABLE}.ip_address ;;
    }

    dimension: user_id {
      sql: ${TABLE}.user_id ;;
    }

    dimension_group: event {
      type: time
#     timeframes: [time, date, hour, time_of_day, hour_of_day, week, day_of_week_index, day_of_week]
      sql: ${TABLE}.created_at ;;
    }

    dimension: sequence_number {
      type: number
      description: "Within a given session, what order did the events take place in? 1=First, 2=Second, etc"
      sql: ${TABLE}.sequence_number ;;
    }

    dimension: is_entry_event {
      type: yesno
      description: "Yes indicates this was the entry point / landing page of the session"
      sql: ${sequence_number} = 1 ;;
    }

    dimension: is_exit_event {
      type: yesno
      label: "UTM Source"
      sql: ${sequence_number} = ${sessions.number_of_events_in_session} ;;
      description: "Yes indicates this was the exit point / bounce page of the session"
    }

    measure: count_bounces {
      type: count
      description: "Count of events where those events were the bounce page for the session"

      filters: {
        field: is_exit_event
        value: "Yes"
      }
    }

    measure: bounce_rate {
      type: number
      value_format_name: percent_2
      description: "Percent of events where those events were the bounce page for the session, out of all events"
      sql: ${count_bounces}*1.0 / nullif(${count}*1.0,0) ;;
    }

    dimension: full_page_url {
      sql: ${TABLE}.uri ;;
    }

    dimension: viewed_product_id {
      type: number
      sql: CASE WHEN ${event_type} = 'Product' THEN
          CAST(SPLIT(${full_page_url}, '/')[OFFSET(ARRAY_LENGTH(SPLIT(${full_page_url}, '/'))-1)] AS INT64)
      END
       ;;
    }

    dimension: event_type {
      sql: ${TABLE}.event_type ;;
      tags: ["mp_event_name"]
    }

    dimension: funnel_step {
      description: "Login -> Browse -> Add to Cart -> Checkout"
      sql: CASE
        WHEN ${event_type} IN ('Login', 'Home') THEN '(1) Land'
        WHEN ${event_type} IN ('Category', 'Brand') THEN '(2) Browse Inventory'
        WHEN ${event_type} = 'Product' THEN '(3) View Product'
        WHEN ${event_type} = 'Cart' THEN '(4) Add Item to Cart'
        WHEN ${event_type} = 'Purchase' THEN '(5) Purchase'
      END
       ;;
    }

    measure: unique_visitors {
      type: count_distinct
      description: "Uniqueness determined by IP Address and User Login"
      view_label: "Visitors"
      sql: ${ip} ;;
      drill_fields: [visitors*]
    }

    dimension: location {
      type: location
      view_label: "Visitors"
      sql_latitude: ${TABLE}.latitude ;;
      sql_longitude: ${TABLE}.longitude ;;
    }

    dimension: approx_location {
      type: location
      view_label: "Visitors"
      sql_latitude: round(${TABLE}.latitude,1) ;;
      sql_longitude: round(${TABLE}.longitude,1) ;;
    }

    dimension: has_user_id {
      type: yesno
      view_label: "Visitors"
      description: "Did the visitor sign in as a website user?"
      sql: ${users.id} > 0 ;;
    }

    dimension: browser {
      view_label: "Visitors"
      sql: ${TABLE}.browser ;;
    }

    dimension: os {
      label: "Operating System"
      view_label: "Visitors"
      sql: ${TABLE}.os ;;
    }

    measure: count {
      type: count
      drill_fields: [simple_page_info*]
    }

    measure: sessions_count {
      type: count_distinct
      sql: ${session_id} ;;
    }

    measure: count_m {
      label: "Count (MM)"
      type: number
      hidden: yes
      sql: ${count}/1000000.0 ;;
      drill_fields: [simple_page_info*]
      value_format: "#.### \"M\""
    }

    measure: unique_visitors_m {
      label: "Unique Visitors (MM)"
      view_label: "Visitors"
      type: number
      sql: count (distinct ${ip}) / 1000000.0 ;;
      description: "Uniqueness determined by IP Address and User Login"
      value_format: "#.### \"M\""
      hidden: yes
      drill_fields: [visitors*]
    }

    measure: unique_visitors_k {
      label: "Unique Visitors (k)"
      view_label: "Visitors"
      type: number
      hidden: yes
      description: "Uniqueness determined by IP Address and User Login"
      sql: count (distinct ${ip}) / 1000.0 ;;
      value_format: "#.### \"k\""
      drill_fields: [visitors*]
    }

    set: simple_page_info {
      fields: [event_id, event_time, event_type, full_page_url, user_id, funnel_step]
    }

    set: visitors {
      fields: [ip, os, browser, user_id, count]
    }
  }


  view: sessions {
    derived_table: {
      datagroup_trigger: ecommerce_etl
      sql: SELECT
        session_id
        , CAST(MIN(created_at) AS TIMESTAMP) AS session_start
        , CAST(MAX(created_at) AS TIMESTAMP) AS session_end
        , COUNT(*) AS number_of_events_in_session
        , SUM(CASE WHEN event_type IN ('Category','Brand') THEN 1 ELSE NULL END) AS browse_events
        , SUM(CASE WHEN event_type = 'Product' THEN 1 ELSE NULL END) AS product_events
        , SUM(CASE WHEN event_type = 'Cart' THEN 1 ELSE NULL END) AS cart_events
        , SUM(CASE WHEN event_type = 'Purchase' THEN 1 ELSE NULL end) AS purchase_events
        , CAST(MAX(user_id) AS INT64)  AS session_user_id
        , MIN(id) AS landing_event_id
        , MAX(id) AS bounce_event_id
      FROM looker-private-demo.ecomm.events
      GROUP BY session_id
       ;;
    }


    #####  Basic Web Info  ########

    measure: count {
      type: count
      drill_fields: [detail*]
    }

    dimension: session_id {
      type: string
      primary_key: yes
      tags: ["mp_session_id"]
      sql: ${TABLE}.session_id ;;
    }

    dimension: session_user_id {
      tags: ["mp_session_uuid"]
      sql: ${TABLE}.session_user_id ;;
    }

    dimension: landing_event_id {
      sql: ${TABLE}.landing_event_id ;;
    }

    dimension: bounce_event_id {
      sql: ${TABLE}.bounce_event_id ;;
    }

    dimension_group: session_start {
      type: time
#     timeframes: [time, date, week, month, hour_of_day, day_of_week]
      sql: ${TABLE}.session_start ;;
    }

    dimension_group: session_end {
      type: time
      timeframes: [raw, time, date, week, month]
      sql: ${TABLE}.session_end ;;
    }

    dimension: duration {
      label: "Duration (sec)"
      type: number
      sql: (UNIX_MICROS(${TABLE}.session_end) - UNIX_MICROS(${TABLE}.session_start))/1000000 ;;
    }

    measure: average_duration {
      label: "Average Duration (sec)"
      type: average
      value_format_name: decimal_2
      sql: ${duration} ;;
    }

    dimension: duration_seconds_tier {
      label: "Duration Tier (sec)"
      type: tier
      tiers: [10, 30, 60, 120, 300]
      style: integer
      sql: ${duration} ;;
    }

    #####  Bounce Information  ########

    dimension: is_bounce_session {
      type: yesno
      sql: ${number_of_events_in_session} = 1 ;;
    }

    measure: count_bounce_sessions {
      type: count
      filters: {
        field: is_bounce_session
        value: "Yes"
      }
      drill_fields: [detail*]
    }

    measure: percent_bounce_sessions {
      type: number
      value_format_name: percent_2
      sql: 1.0 * ${count_bounce_sessions} / nullif(${count},0) ;;
    }

    ####### Session by event types included  ########

    dimension: number_of_browse_events_in_session {
      type: number
      hidden: yes
      sql: ${TABLE}.browse_events ;;
    }

    dimension: number_of_product_events_in_session {
      type: number
      hidden: yes
      sql: ${TABLE}.product_events ;;
    }

    dimension: number_of_cart_events_in_session {
      type: number
      hidden: yes
      sql: ${TABLE}.cart_events ;;
    }

    dimension: number_of_purchase_events_in_session {
      type: number
      hidden: yes
      sql: ${TABLE}.purchase_events ;;
    }

    dimension: includes_browse {
      type: yesno
      sql: ${number_of_browse_events_in_session} > 0 ;;
    }

    dimension: includes_product {
      type: yesno
      sql: ${number_of_product_events_in_session} > 0 ;;
    }

    dimension: includes_cart {
      type: yesno
      sql: ${number_of_cart_events_in_session} > 0 ;;
    }

    dimension: includes_purchase {
      type: yesno
      sql: ${number_of_purchase_events_in_session} > 0 ;;
    }

    measure: count_with_cart {
      type: count
      filters: {
        field: includes_cart
        value: "Yes"
      }
      drill_fields: [detail*]
    }

    measure: count_with_purchase {
      type: count
      filters: {
        field: includes_purchase
        value: "Yes"
      }
      drill_fields: [detail*]
    }

    dimension: number_of_events_in_session {
      type: number
      sql: ${TABLE}.number_of_events_in_session ;;
    }

    ####### Linear Funnel   ########

    dimension: furthest_funnel_step {
      sql: CASE
              WHEN ${number_of_purchase_events_in_session} > 0 THEN '(5) Purchase'
              WHEN ${number_of_cart_events_in_session} > 0 THEN '(4) Add to Cart'
              WHEN ${number_of_product_events_in_session} > 0 THEN '(3) View Product'
              WHEN ${number_of_browse_events_in_session} > 0 THEN '(2) Browse'
              ELSE '(1) Land'
              END
               ;;
    }

    measure: all_sessions {
      view_label: "Funnel View"
      label: "(1) All Sessions"
      type: count
      drill_fields: [detail*]
    }

    measure: count_browse_or_later {
      view_label: "Funnel View"
      label: "(2) Browse or later"
      type: count
      filters: {
        field: furthest_funnel_step
        value: "(2) Browse,(3) View Product,(4) Add to Cart,(5) Purchase"
      }
      drill_fields: [detail*]
    }

    measure: count_product_or_later {
      view_label: "Funnel View"
      label: "(3) View Product or later"
      type: count
      filters: {
        field: furthest_funnel_step
        value: "(3) View Product,(4) Add to Cart,(5) Purchase"
      }
      drill_fields: [detail*]
    }

    measure: count_cart_or_later {
      view_label: "Funnel View"
      label: "(4) Add to Cart or later"
      type: count
      filters: {
        field: furthest_funnel_step
        value: "(4) Add to Cart,(5) Purchase"
      }
      drill_fields: [detail*]
    }

    measure: count_purchase {
      view_label: "Funnel View"
      label: "(5) Purchase"
      type: count
      filters: {
        field: furthest_funnel_step
        value: "(5) Purchase"
      }
      drill_fields: [detail*]
    }

    measure: cart_to_checkout_conversion {
      view_label: "Funnel View"
      type: number
      value_format_name: percent_2
      sql: 1.0 * ${count_purchase} / nullif(${count_cart_or_later},0) ;;
    }

    measure: overall_conversion {
      view_label: "Funnel View"
      type: number
      value_format_name: percent_2
      sql: 1.0 * ${count_purchase} / nullif(${count},0) ;;
    }

    set: detail {
      fields: [session_id, session_start_time, session_end_time, number_of_events_in_session, duration, number_of_purchase_events_in_session, number_of_cart_events_in_session]
    }
  }
