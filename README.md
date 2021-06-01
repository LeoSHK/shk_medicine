# shk_medicine

Sistema compativel com vRPex

# Descrição </br>
Sistema que gerencia as partes do corpo do personagem dando mais imersão no RP de Emergência.</br></br>

-- Sistema de Recepção com anuncio por voz <br/>
-- Sistema de Raio-X que informa todas as partes feridas via NUI. <br/>
-- Sistema de Projeteis alojados, tem uma chance de ficar alojado nas partes do corpo e é possivel fazer uma cirurgia com transfusão de sangue. <br/>
-- Sistema de tratamentos com gesso ou medicamentos, aplicando reações ao personagem conforme o tipo de Ferimento/Fratura. <br/>
-- Sistema de macas está incluso no sistema, caso você utiliza um, melhor desabilita-lo caso usar esse sistema. <br/>
-- Sistema de AUDIO (vRPex) nos equipamentos de Exames, trazendo mais realismo.

# Instalação

Adicione em seu server.cfg ensure nas pastas do projeto:

ensure shk_medicine </br>
ensure shk_audio </br>

# Itens para criar.
Criar itens em sua base: <br/></br>
bolsasanguevazia - Bolsa de Sangue vazia <br/>
bolsasangue - Bolsa com Sangue <br/>
morfina - Morfina <br/>

# Configurações <br/>
-- Configurações no cfg/config.lua <br/>
-- Adicionar props de macas estão no arquivo client.lua <br/>

# Permissões <br/>
Adicionar ou mudar a permissão conforme sua base: paramedico.permissao <br/>


# Tipos de Tratamentos e comandos: <br/> <br/>

/tratamento [iniciar/cancelar] <br/>
Tratamento normal, cura a vida do personagem <br/> <br/>

/tratamento morfina <br/>
É um medicamento onde intensifica a cura de todas as partes, intensifica com o gesso. <br/>
Necessário item morfina <br/> <br/>

# Gesso Ortopédico <br/>
O Gesso ajuda na recuperação da parte do corpo aonde for aplicada, porem tem menos eficacia que a morfina, mas aplicados juntos ficam POWER. <br/> <br/>

/orto [partedocorpo] [adicionar/remover] <br/> <br/>

Partes do corpo: <br/> <br/>

superior - Cabeça,pescoço,coluna vertebral, tronco <br/>
inferior - Pernas <br/>
bota - Pés <br/>
tala - Mãos <br/> <br/>

exemplo: /orto bota adicionar <br/> <br/>

# Retirar Sangue <br/>
/doarsangue <br/> <br/>

Ao usar esse comando, vai ser executado um procedimento de retirada de sangue (no jogador mais proximo), no final do processo, vai receber uma Bolsa de Sangue  <br/> <br/>

Necessário ter o item: bolsasanguevazia | Bolsa de sangue vazia <br/> <br/>

/transfusao [iniciar/cancelar] <br/>
Procedimento necessário para iniciar durante uma cirurgia, é obrigatorio ter a bolsa de sangue cheia: bolsadesangue <br/> <br/>

# Cirurgias <br/>

A cirurgia remove o projetil alojado na parte que deseja. Para verificar no diagnostico, faça um exame de Raio-X. <br/> <br/>

/cirurgia [partesdocorpo] <br/> <br/>

partesdocorpo: <br/> <br/>

cabeca - remove projetil na cabeça <br/>
bracoesq - remove projetil no braco esquerdo <br/>
bracodir - remove projetil braço direito <br/>
pernaesq -  remove projetil perna esquerda <br/>
tronco - remove projetil no tronco <br/>
quadril - remove projetil no quadril <br/> <br/>

# Reações do personagem <br/> <br/>
Quando o personagem começar a cair, é porque ele está com um indice de ferimento alto nas pernas, so verificar no raiox. <br/>
Ao usar a bota, essas quedas param instantaneamentes, mas a cura completa só é possivel analisar via raio-x. <br/>
Ao braços machucados, impossibilita de equipar armas.

