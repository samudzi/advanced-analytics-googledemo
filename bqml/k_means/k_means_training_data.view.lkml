view: k_means_training_data {
  label: "1. BQML K-Means: Create or Replace Model"

  derived_table: {
    sql:  SELECT
            {% assign item_id = _filters['item_id'] | sql_quote | replace: '"','' | remove: "'" %}
            {{ item_id }},
            {% assign feature_list = _filters['features'] | sql_quote | replace: '"','' | remove: "'" %}
            {{ feature_list }}

        FROM ${users_dataset.SQL_TABLE_NAME}
    ;;
  }

  filter: item_id {
    type: string
    suggest_explore: users_dataset_field_suggestions
    suggest_dimension: users_dataset_field_suggestions.column_name
  }

  filter: features {
    type: string
    suggest_explore: users_dataset_field_suggestions
    suggest_dimension: users_dataset_field_suggestions.column_name
  }
}
