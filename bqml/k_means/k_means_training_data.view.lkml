view: k_means_training_data {
  label: "BQML 1 - Create or Replace Model"

  derived_table: {
    sql:  SELECT
            {% assign item_id = _filters['select_item_id'] | sql_quote | replace: '"','' | remove: "'" %}
              {{ item_id }},
            {% assign features = _filters['select_features'] | sql_quote | replace: '"','' | remove: "'" %}
              {{ features }}

        FROM ${users_dataset.SQL_TABLE_NAME}
    ;;
  }

  filter: select_item_id {
    type: string
    suggest_explore: field_suggestions
    suggest_dimension: field_suggestions.column_name
  }

  filter: select_features {
    type: string
    suggest_explore: field_suggestions
    suggest_dimension: field_suggestions.column_name
  }
}
