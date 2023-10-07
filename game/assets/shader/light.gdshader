shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D smoke;
uniform float speed = 0.05;
uniform float size = 0.08;

void fragment() {
  COLOR = texture(TEXTURE, UV);
  vec3 screen = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;

  if (COLOR.a == 0.0) { // outer area
    float avg = (screen.r + screen.g + screen.b) / 20.0;
    COLOR.rgb = vec3(avg);
    COLOR.a = 1.0;

    vec2 smoke_uv = UV + TIME * speed;
   	vec4 smoke_color = texture(smoke, fract(smoke_uv));
   	smoke_color = clamp(smoke_color * size, 0.0, 1.0);
//    float avg_smoke = (smoke_color.g + smoke_color.b);

//   	vec4 img_color = texture(screen_texture, SCREEN_UV + vec2(avg_smoke - size/2.0, 0.0));

   	COLOR += smoke_color;
  }
  else if (COLOR.r == 1.0) { // circle
    COLOR = vec4(0.0, 0.0, 0.0, 0.5); // TODO:
  } else if (COLOR.b == 1.0) { // transparent in light circle
    COLOR = vec4(0.0, 0.0, 0.0, 0.2);
  } else if (COLOR.g == 1.0) { // light area
    COLOR.a = 0.0;
  }
}
