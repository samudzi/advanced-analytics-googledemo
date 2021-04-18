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
