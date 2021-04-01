view: arima_users_dataset {
  derived_table: {
    sql:  SELECT * EXCEPT(user_id), users.id as user_id
          FROM ${users.SQL_TABLE_NAME}  AS users
          LEFT JOIN ${user_order_facts.SQL_TABLE_NAME} AS user_order_facts
            ON users.id = user_order_facts.user_id ;;
  }
}
