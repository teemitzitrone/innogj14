shader_type canvas_item;

void fragment() {
	// Place fragment code here.
  COLOR = texture(TEXTURE, UV);

  if (COLOR.a == 0.0) {
    COLOR.rgba = vec4(0.0, 0.0, 0.0, 1.0);
  }
  else if (COLOR.r == 1.0) {
    COLOR = vec4(0.0, 0.0, 0.0, 0.5); // TODO:
  } else if (COLOR.b == 1.0) {
    COLOR = vec4(0.0, 0.0, 0.0, 0.2);
  } else if (COLOR.g == 1.0) {
    COLOR.a = 0.0;
  }
}
