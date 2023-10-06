extends RefCounted
## ActorBuilder


# signals
# enums
# inner classes
# constants
const Actor = preload("res://scripts/actor/actor.gd")

const ActorComponent = preload("res://scripts/actor/actor_component.gd")
const ActorInputMoveComponent = preload("res://scripts/actor/components/actor_input_move_component.gd")
const ActorPhysicsMoveAndCollideComponent = preload("res://scripts/actor/components/actor_physics_moveandcollide_component.gd")
const ActorSpritesheet2DComponent = preload("res://scripts/actor/components/actor_spritesheet2d_component.gd")
const ActorUpdateSpritesheetComponent = preload("res://scripts/actor/components/actor_update_spritesheet_component.gd")



static func _create_character_animation_sprite(tex: String, replacement_colors := {}) -> ActorSpritesheet2DComponent:
  var anim_sprite = ActorSpritesheet2DComponent.new()
  anim_sprite.texture = tex
  anim_sprite.frame_size = Vector2i(3, 4)
  anim_sprite.frame_time_distance = 0.2
  anim_sprite.region_rect = Rect2(Vector2.ZERO, Vector2(96, 256))
  anim_sprite.animations = {
    "idle_down": [1],
    "idle_up": [4],
    "idle_right": [7],
    "idle_left": [10],
    "run_down": [1, 0, 1, 2],
    "run_up": [4, 3, 4, 5],
    "run_right": [7, 6, 7, 8],
    "run_left": [10, 9, 10, 11],
  }
  anim_sprite.animation_nodes = {
    "idle": ["idle_down", "idle_left", "idle_right", "idle_up"],
    "run": ["run_down", "run_left", "run_right", "run_up"],
  }
  anim_sprite.animation_transitions = {"idle": ["run"], "run": ["idle"]}
  anim_sprite.animation_default = "run"
  anim_sprite.shader = ShaderMaterial.new()
  anim_sprite.shader.shader = load("res://assets/shader/actor_color.gdshader")
  anim_sprite.shader_parameters = {
    "original_color_0": Color8(50, 50, 50),
    "original_color_1": Color8(100, 100, 100),
    "original_color_2": Color8(150, 150, 150),
    "original_color_3": Color8(200, 200, 200),
    "original_color_4": Color8(255, 255, 255),
    "original_color_5": Color8(0, 255, 234),
  }
  for c in replacement_colors:
    anim_sprite.shader_parameters[c] = replacement_colors[c]

  return anim_sprite
