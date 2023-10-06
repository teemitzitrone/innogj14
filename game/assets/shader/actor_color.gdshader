shader_type canvas_item;

const float precision = 0.1;

uniform vec4 original_color_0: source_color;
uniform vec4 original_color_1: source_color;
uniform vec4 original_color_2: source_color;
uniform vec4 original_color_3: source_color;
uniform vec4 original_color_4: source_color;
uniform vec4 original_color_5: source_color;
uniform vec4 replacement_color_0: source_color;
uniform vec4 replacement_color_1: source_color;
uniform vec4 replacement_color_2: source_color;
uniform vec4 replacement_color_3: source_color;
uniform vec4 replacement_color_4: source_color;
uniform vec4 replacement_color_5: source_color;

void fragment() {
	COLOR = texture(TEXTURE, UV);

  vec4 original_colors[6] = vec4[6] (original_color_0, original_color_1, original_color_2, original_color_3, original_color_4, original_color_5);
	vec4 replace_colors[6] = vec4[6] (replacement_color_0, replacement_color_1, replacement_color_2, replacement_color_3, replacement_color_4, replacement_color_5);

  for (int i = 0; i < original_colors.length(); i++)
  {
    if (distance(COLOR.rgb, original_colors[i].rgb) <= precision)
    {
      COLOR.rgb = replace_colors[i].rgb;
    }
  }
}
