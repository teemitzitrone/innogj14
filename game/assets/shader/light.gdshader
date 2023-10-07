shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	// Place fragment code here.
  COLOR = texture(TEXTURE, UV);
  vec3 screen = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;

  if (COLOR.a == 0.0) { // outer area
    float avg = (screen.r + screen.g + screen.b) / 20.0;
    COLOR.rgb = vec3(avg);
    COLOR.a = 1.0;
  }
  else if (COLOR.r == 1.0) { // circle
    COLOR = vec4(0.0, 0.0, 0.0, 0.5); // TODO:
  } else if (COLOR.b == 1.0) { // transparent in light circle
    COLOR = vec4(0.0, 0.0, 0.0, 0.2);
  } else if (COLOR.g == 1.0) { // light area
    COLOR.a = 0.0;
  }
}
