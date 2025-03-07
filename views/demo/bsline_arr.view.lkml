view: bsline_arr {
  sql_table_name: `ben-sandbox-env.internal.bsline_arr` ;;

  dimension: arr {
    type: number
    sql: ${TABLE}.ARR ;;
  }
  dimension: business_line {
    primary_key: yes
    type: string
    sql: ${TABLE}.business_line ;;
  }
  dimension: gross_margin {
    type: number
    sql: ${TABLE}.gross_margin ;;
  }
  dimension: net_margin {
    type: number
    sql: ${TABLE}.net_margin ;;
  }
  dimension_group: period {
    type: time
    description: "%E4Y-%m-%d"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Period ;;
  }
  measure: sum_arr {
    type: sum
    sql: ${arr} ;;
  }
  # measure: percent_net_margin {
  #   label: "%net_margin"
  #   type:number
  #   sql: ${net_margin} ;;
  #   value_format_name: percent_2
  # }
  # measure: percent_gross_margin {
  #   label: "%gross_margin"
  #   type:average_distinct
  #   sql: ${gross_margin} ;;
  #   value_format_name: percent_2
  # }

}
