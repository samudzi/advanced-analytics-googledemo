# view: users_dataset {
#   derived_table: {
#     sql:  SELECT * EXCEPT(user_id), users.id as user_id
#           FROM ${users.SQL_TABLE_NAME}  AS users
#           LEFT JOIN `looker_pdts.7L_advanced_analytics_accelerator_user_order_facts` AS user_order_facts
#             ON users.id = user_order_facts.user_id ;;
#   }
# }
