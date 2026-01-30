constant: PROJECT {
  value: "still-sensor-360721"
  export: override_optional
}

constant: SCHEMA_NAME_1 {
  value: "thelook_ecommerce"
  export: override_optional
}

constant: CONNECTION {
  value: "looker_demo"
  export: override_optional
}

# -------------------------------------------------------------------
# GLOBAL CONSTANTS
# -------------------------------------------------------------------

constant: status_color_formatting {
  value: "
  {% if value == 'Completed' %}
  <span style='color: #007630; background-color: #e6f4ea; border-radius: 4px; padding: 2px 5px; font-weight: bold;'>{{ rendered_value }}</span>
  {% elsif value == 'Stuck' or value == 'Fail' %}
  <span style='color: #a50e0e; background-color: #fce8e6; border-radius: 4px; padding: 2px 5px; font-weight: bold;'>{{ rendered_value }}</span>
  {% elsif value == 'In Progress' or value == 'Doing' %}
  <span style='color: #e37400; background-color: #fef7e0; border-radius: 4px; padding: 2px 5px; font-weight: bold;'>{{ rendered_value }}</span>
  {% elsif value == 'Not Started' %}
  <span style='color: #5f6368; background-color: #f1f3f4; border-radius: 4px; padding: 2px 5px;'>{{ rendered_value }}</span>
  {% else %}
  {{ rendered_value }}
  {% endif %}
  "
}
