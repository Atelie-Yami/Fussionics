## Classe que define os elementos.
class_name Element extends RefCounted

## Tempos de ação dos efeitos, quando eles irão ser execultados.
enum ActionTime {
	PRE_INIT, INIT, INSTANTIATED, MOVED, LINKED, UNLINKED, BAKED, DIED, ATTACK, DEFEND, END_TURN
}

## isso é basicamente oque define que tipo de elemento é, seu valor é o custo para instanciar.
var atomic_number: int

## valor de ataque, é variável, ou seja, esse valor pode mudar de acordo com oque acontece durante o jogo.
var eletrons: int

## valor de durabilidade, é o valor defensivo utilizado durante os combates, não é muito normal esse valor mudar.
var protons: int

## Indica quantos links esse elemento pode ter em simultâneo.
var valentia: int

## Dicionario que define os efeitos em seus tempos de ação:[br]
## [codeblock]
## {ActionTime.INIT: Callable(self, "nome_da_func")}
## {ActionTime.INIT: nome_da_func)}
## [/codeblock]
var action_time: Dictionary
