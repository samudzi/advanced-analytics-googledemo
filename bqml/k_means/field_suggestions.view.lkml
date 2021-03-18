explore: field_suggestions { hidden: yes }

view: field_suggestions {
  derived_table: {
    sql:  SELECT table_name, column_name
          FROM looker-private-demo.ecomm.INFORMATION_SCHEMA.COLUMNS
          WHERE table_name = 'users' AND column_name != 'id'

          UNION ALL

          SELECT 'user_order_facts' AS table_name, column_name
          FROM advanced-analytics-accelerator.looker_pdts.INFORMATION_SCHEMA.COLUMNS
          WHERE table_name = 'LR_7L4VZ1613530346128_user_order_facts'
    ;;
  }

  dimension: table_name {}
  dimension: column_name {}
}
