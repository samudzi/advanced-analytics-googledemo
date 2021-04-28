view: automl_test {
  derived_table: {
    persist_for: "1 minute"
    sql_create:  CREATE OR REPLACE MODEL looker_pdts.automl_tables_test_model
                       OPTIONS(model_type='AUTOML_REGRESSOR',
                               input_label_cols=['fare_amount'],
                               budget_hours=1.0)
                AS SELECT
                  (tolls_amount + fare_amount) AS fare_amount,
                  pickup_longitude,
                  pickup_latitude,
                  dropoff_longitude,
                  dropoff_latitude,
                  passenger_count
                FROM `nyc-tlc.yellow.trips`
                WHERE ABS(MOD(FARM_FINGERPRINT(CAST(pickup_datetime AS STRING)), 100000)) = 1
                AND
                  trip_distance > 0
                  AND fare_amount >= 2.5 AND fare_amount <= 100.0
                  AND pickup_longitude > -78
                  AND pickup_longitude < -70
                  AND dropoff_longitude > -78
                  AND dropoff_longitude < -70
                  AND pickup_latitude > 37
                  AND pickup_latitude < 45
                  AND dropoff_latitude > 37
                  AND dropoff_latitude < 45
                  AND passenger_count > 0 ;;
  }

  dimension: train_model {
    sql: 'Complete' ;;
  }
}
