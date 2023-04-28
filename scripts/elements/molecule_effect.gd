class_name MoleculeEffect extends BaseEffect

## Tipo de efeito que o elemento altera na molecula
enum MoleculeEffectType {
	TRIGGER,    ## cria e controla o uso de efeito da molecula
	MECHANICAL, ## muda alguma mecanica ou forma q algo funciona
	UPGRADE,    ## altera as propriedades já existentes na molecula
	MULTI,      ## possui alguma combinação dos tipos anteriores
}

var molecule_effect_type: MoleculeEffectType
var cluster: EffectCluster

# {token : [ BindToken, valor ]}
var tokens: Dictionary
var tags: Array


func get_targets(target: ElementBase):
	pass


