class_name Health
extends Node

signal lives_increased
signal lives_decreased

var health = 0
export(int) var max_health = 3

var status = null

func _ready():
	health = max_health
	$InvincibleTimer.connect("timeout", self, "_on_InvincibleTimer_timeout")
			 
func take_damage(amount, effect=null):
	if status == PlayerStatus.INVINCIBLE:
		return
	status = PlayerStatus.INVINCIBLE
	health -= amount
	owner.get_node("AnimationPlayer2").play("hurt")
	$InvincibleTimer.start()
	health = max(0, health)
	emit_signal("lives_decreased", health)
	
func heal(amount):
	health += amount
	health = min(health, max_health)
	emit_signal("lives_increased", health)

func _on_InvincibleTimer_timeout():
	$InvincibleTimer.stop()
	owner.get_node("AnimationPlayer2").play("normal")
	status = PlayerStatus.NONE
	
