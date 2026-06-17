extends Control

onready var g = get_node("/root/Globals")

func _ready():
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()

	var centered_position = (screen_size - window_size) / 2
	OS.set_window_position(centered_position)
	pass
	
func _process(delta):
	$Panel/Coins.text = "Coins: " + str(g.Coins)
	$Panel/Potion.text = "Potions: " + str(g.Potions)
	$Panel/SlashDamage.text = "Damage: " + str(g.slash_damage)
	$Panel/ArrowDamage.text = "Damage: " + str(g.arrow_damage)
	$Panel/PotionHeal.text = "Potion Heal: " + str(g.potion_heal_amount)
	$Panel/PotionCost.text = "Cost: " + str(g.potion_cost)
	$Panel/UpgradeSlashCost.text = "Cost: " + str(g.slash_cost)
	$Panel/UpgradeArrowCost.text = "Cost: " + str(g.arrow_cost)
	$Panel/UpgradePotionCost.text = "Cost: " + str(g.potion_upgrade_cost)

func _on_BuyPotion_pressed():
	var cost = 10 
	if g.Coins >= cost: 
		g.Coins -= cost 
		g.Potions += 1 
		print("Bought potion")
	else:
		print("Not enough coins")


func _on_UpgradeSlash_pressed():
	if g.Coins >= g.slash_cost:
		g.Coins -= g.slash_cost
		g.slash_damage += 1
		
		g.slash_cost = int(g.slash_cost + 20)

		print("Slash upgraded to:", g.slash_damage)
	else:
		print("Not enough coins")


func _on_UpgradeArrow_pressed():
	if g.Coins >= g.arrow_cost:
		g.Coins -= g.arrow_cost
		g.arrow_damage += 1
		
		g.arrow_cost = int(g.arrow_cost + 20)

		print("Arrow upgraded to:", g.arrow_damage)
	else:
		print("Not enough coins")


func _on_UpgradePotion_pressed():
	if g.Coins >= g.potion_upgrade_cost:
		g.Coins -= g.potion_upgrade_cost
		g.potion_heal_amount += 5
		
		g.potion_upgrade_cost = int(g.potion_upgrade_cost * 2)

		print("Potion stronger")
	else:
		print("Not enough coins")


func _on_ExitShop_pressed():
	get_tree().change_scene(g.next_scene)
