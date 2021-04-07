view: k_means_centroid_profiles {
derived_table: {
  sql: select cf.*
       ,100* (cf.centroid_avg_value / sum(cf.centroid_avg_value * c1.user_pct_total) over (partition by cf.feature_category)) as index_to_avg
       ,(cf.centroid_avg_value / sum(cf.centroid_avg_value * c1.user_pct_total) over (partition by cf.feature_category)) - 1 as pct_diff_from_avg
from

(select  k_means_centroids.centroid_id  AS centroid_id
        ,k_means_centroids.feature as feature
        ,k_means_centroids.numerical_value as feature_value
        ,centroid_categorical_value.category as category
        ,centroid_categorical_value.value as category_value
        ,concat(k_means_centroids.feature,case when centroid_categorical_value.category is not null then concat(': ',centroid_categorical_value.category) else '' end)   AS feature_category

        ,coalesce(k_means_centroids.numerical_value,centroid_categorical_value.value) as centroid_avg_value
from
${k_means_centroids.SQL_TABLE_NAME}  AS k_means_centroids
LEFT JOIN UNNEST(k_means_centroids.categorical_value) as centroid_categorical_value
) cf
join (select centroid_id
         ,user_count
         ,user_count / sum(user_count) over (partition by 1) as user_pct_total
  from (
  select centroid_id
         ,count(distinct user_id) as user_count
  from ${k_means_predict.SQL_TABLE_NAME}
  group by 1 ) c0
  ) c1 on cf.centroid_id = c1.centroid_id

order by 1,2,4
 ;;
}

dimension: pk {
  primary_key: yes
  sql: concat(${centroid_id},${feature_category}) ;;
}
dimension: centroid_id {
  type: number
  sql: ${TABLE}.centroid_id ;;
}

dimension: feature {
  type: string
  sql: ${TABLE}.feature ;;
}

dimension: feature_value {
  type: number
  sql: ${TABLE}.feature_value ;;
}

dimension: category {
  type: string
  sql: ${TABLE}.category ;;
}

dimension: category_value {
  type: number
  sql: ${TABLE}.category_value ;;
}

dimension: feature_category {
  type: string
  sql: ${TABLE}.feature_category ;;
}

dimension: centroid_avg_value {
  type: number
  sql: ${TABLE}.centroid_avg_value ;;
}

dimension: index_to_avg {
  type: number
  sql: ${TABLE}.index_to_avg ;;
}

dimension: pct_diff_from_avg {
  type: number
  sql: ${TABLE}.pct_diff_from_avg ;;
}

measure: centroid_value_compared_to_avg {
  type: average
  sql: ${pct_diff_from_avg} ;;
  value_format_name: percent_1
}

set: detail {
  fields: [
    centroid_id,
    feature,
    feature_value,
    category,
    category_value,
    feature_category,
    centroid_avg_value,
    index_to_avg,
    pct_diff_from_avg
  ]
}
}
