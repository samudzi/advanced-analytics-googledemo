view: k_means_training_data {
  label: "BQML 1 - Create or Replace Model"

  derived_table: {
    persist_for: "1 second"
    sql_create: CREATE OR REPLACE VIEW looker_pdts.{% parameter workflow_parameters.select_model_name %}_training_data
                  AS  SELECT
                        {% assign item_id = _filters['select_item_id'] | sql_quote | replace: '"','' | remove: "'" %}
                          {{ item_id }},
                        {% assign features = _filters['select_features'] | sql_quote | replace: '"','' | remove: "'" %}
                          {{ features }}
                      FROM ${users_dataset.SQL_TABLE_NAME}
    ;;
  }

  filter: select_item_id {
    label: "Select an ID Field (REQUIRED)"
    description: "Choose the field that identifies the items you want to cluster"
    type: string
    suggest_explore: field_suggestions
    suggest_dimension: field_suggestions.column_name
    suggest_persist_for: "0 minutes"
  }

  filter: select_features {
    label: "Select Features (REQUIRED)"
    description: "Choose the attribute fields that you want to use to cluster your data"
    type: string
    suggest_explore: field_suggestions
    suggest_dimension: field_suggestions.column_name
    suggest_persist_for: "0 minutes"
  }
}
