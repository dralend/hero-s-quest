#class_name DecisionEngineName
extends DecisionEngine

# meta-name: DecisionEngine
# meta-description: Boilerplate decision engine script
# meta-default: true

# Included in DecisionEngine:
# var enemy: Enemy
# var current_state: EnemyState
# var blackboard: Blackboard


#func _ready() -> void:
	#await super() # maintains important setup code & timing
	# implement your own scripts here
	#pass


# all the conditions for making decisions go in this function
#func decide() -> EnemyState:
	# Example decisions
	#if blackboard.damage_source:
		#if blackbord.health <= 0:
			#return es_death
		#else:
			#return es_stun
	
	#if current_state is ESDeath or not blackboard.can_decide:
		#return null
	
	#if black
