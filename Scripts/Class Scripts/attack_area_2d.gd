extends Area2D

## This class activates/deactviates it's [member monitoring] state and detects if a body in the [member target] group entered it and damages it.
class_name AttackArea2D

## The [CollisionShape2D] that the [AttackArea2D] needs to detect if a body entered or not.
@export var hitbox: CollisionShape2D

@export_category("Stats")
## The [member damage] that will be dealt to the [Damageable2D].
@export var damage:=10
## The duration that the [Damageable2D] will be in a hitstun state after this attack.
@export var hitstun_f:=0.1: set = set_hitstun_f
## The [method normalized] direction that the [Damageable2D] will be hit towards after this attack.
@export var knockback_dir:=Vector2(100, 0).normalized()
## The knockback multiplier for the [member knockback_dir]. This is needed because [member knockback_dir] is [method normalized].
@export var knockback_str:=500

@export_category("Targets")
## The target that this [AttackArea2D] can hit.
@export_enum("Player", "Enemy", "Damageable") var target:="Damageable"
## Decides whether the attack should be able to hit the attacker or not.
@export var include_self:=false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

## Activates [member monitoring].
func activate():
	monitoring=true
	

## Deactivates [member monitoring].
func deactivate():
	monitoring=false
	

## Ensures that [member hitstun_f] does not go below [code]0.0[/code].
func set_hitstun_f(time: float):
	if time<=0.0:
		hitstun_f=0.0
	else:
		hitstun_f=time
	

## Checks if the [member body] should be damaged, and calls [member body].[method take_damage] if so.
func _on_body_entered(body: Node2D):
	if body==self.get_parent() and not include_self:
		return
	if body.is_in_group(target):
		var knockback: Vector2 = knockback_dir*knockback_str
		body.take_damage(damage, knockback, hitstun_f)
	

## Sets the hitboxes [member size], [member position] and [member rotation] to the given parameters.
func set_hitbox(size: Vector2, pos: Vector2, rot:=0.0):
	if not hitbox:
		return
	hitbox.size=size
	hitbox.position=pos
	hitbox.rotation=rot
	
