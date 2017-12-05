-- title:  Fuga das Sombras
-- author: Alura
-- desc:   RPG de acao em 2D
-- script: lua

Constantes = {
  SPRITE_JOGADOR =  256,
  SPRITE_CHAVE = 364,
  SPRITE_PORTA = 366,

  TIPO_JOGADOR = "JOGADOR",
  TIPO_CHAVE = "CHAVE",
  TIPO_PORTA = "PORTA",

  VELOCIDADE_ANIMACAO_JOGADOR = 0.2,

  ID_SOM_CHAVE = 0,

  CIMA = 1,
  BAIXO = 2,
  ESQUERDA = 3,
  DIREITA = 4,

  MAPA_LARGURA_TELA = 30,
  MAPA_ALTURA_TELA = 17
}

Direcao = {
  {deltaX = 0, deltaY = -1},
  {deltaX = 0, deltaY = 1},
  {deltaX = -1, deltaY = 0},
  {deltaX = 1, deltaY = 0}
}

AnimacaoJogador = {
  { -- andando para cima
    {sprite = 256},
    {sprite = 258}
  },
  { -- andando para baixo
    {sprite = 260},
    {sprite = 262}
  },
  { -- andando para esquerda
    {sprite = 264},
    {sprite = 266}
  },
  { -- andando para direita
    {sprite = 268},
    {sprite = 270}
  }
}

jogador = {
  sprite = Constantes.SPRITE_JOGADOR,
  x = 120,
  y = 68,
  corTransparente = 6,
  direcao = Constantes.BAIXO,
  quadroDeAnimacao = 1,
  tipo = Constantes.TIPO_JOGADOR,
  chaves = 0
}

objetos = {}

function inicializa()
  local chave = criaChave(3, 3)
  table.insert(objetos, chave)

  local porta = criaPorta(28, 7)
  table.insert(objetos, porta)
end

function TIC()
  atualiza()
  desenha()
end

function atualiza()
  atualizaJogador()
end

function atualizaJogador()
  local direcao = {
    Constantes.CIMA,
    Constantes.BAIXO,
    Constantes.ESQUERDA,
    Constantes.DIREITA
  }

  for tecla = 0, 3 do
    if btn(tecla) then
      moveJogadorPara(direcao[tecla + 1])
    end
  end

  atualizaAnimacaoJogador()
end

function atualizaAnimacaoJogador()
  if jogador.quadroDeAnimacao >= 3 then
    jogador.quadroDeAnimacao = jogador.quadroDeAnimacao - 2
  end
end

function desenha()
  cls() -- limpa a tela, pode passar uma cor como parâmetro
  desenhaMapa()
  for indice, objeto in pairs(objetos) do
    desenhaObjeto(objeto)
  end
  desenhaJogador()
end

function desenhaJogador()
  local quadroDeAnimacao = math.floor(jogador.quadroDeAnimacao)
  jogador.sprite = AnimacaoJogador[jogador.direcao][quadroDeAnimacao].sprite
  desenhaObjeto(jogador)
end

function desenhaObjeto(objeto)
  spr(
    objeto.sprite,
    objeto.x - 8,
    objeto.y - 8,
    objeto.corTransparente,
    1, -- escala 1
    0, -- sem espelhar
    0, -- sem rotacionar
    2, -- largura em blocos 2 (cada bloco eh 8x8)
    2  -- altura em blocos 2
  )
end

function desenhaMapa()
  map(
    0,  -- coordenada x do bloco inicial
    0,  -- coordenada y do bloco inicial
    Constantes.MAPA_LARGURA_TELA, -- largura do mapa em blocos
    Constantes.MAPA_ALTURA_TELA,  -- altura do mapa em blocos
    0, -- posicao x de onde o mapa vai ser desenhado
    0  -- posicao y de onde o mapa vai ser desenhado
  )
end

function moveJogadorPara(indiceDirecao)
  jogador.direcao = indiceDirecao
  local deltaX = Direcao[indiceDirecao].deltaX
  local deltaY = Direcao[indiceDirecao].deltaY

  if not temColisao(jogador, deltaX, deltaY) then
    jogador.x = jogador.x + deltaX
    jogador.y = jogador.y + deltaY
    jogador.quadroDeAnimacao = jogador.quadroDeAnimacao + Constantes.VELOCIDADE_ANIMACAO_JOGADOR
  end
end

function temColisao(objeto, deltaX, deltaY)
  if (temColisaoComObjeto(objeto, deltaX, deltaY)) then
    return true
  end

  local cantosDoObjeto = {
    superiorEsquerdo = {
      x = objeto.x - 8 + deltaX,
      y = objeto.y - 8 + deltaY
    },
    superiorDireito = {
      x = objeto.x + 7 + deltaX,
      y = objeto.y - 8 + deltaY
    },
    inferiorEsquerdo = {
      x = objeto.x - 8 + deltaX,
      y = objeto.y + 7 + deltaY
    },
    inferiorDireito = {
      x = objeto.x + 7 + deltaX,
      y = objeto.y + 7 + deltaY
    }
  }

  if (temColisaoComMapa(cantosDoObjeto.superiorEsquerdo) or
    temColisaoComMapa(cantosDoObjeto.superiorDireito) or
    temColisaoComMapa(cantosDoObjeto.inferiorEsquerdo) or
    temColisaoComMapa(cantosDoObjeto.inferiorDireito)) then
    return true
  end

  return false
end

function temColisaoComObjeto(objeto, deltaX, deltaY)
  local objetoComDelta = {
    x = objeto.x + deltaX,
    y = objeto.y + deltaY
  }
  for indice, outroObjeto in pairs(objetos) do
    if colide(objetoComDelta, outroObjeto) then
      if objeto.tipo == Constantes.TIPO_JOGADOR then
        if outroObjeto.tipo == Constantes.TIPO_CHAVE then
          return fazColisaoJogadorComChave(objeto, outroObjeto, indice)
        end
      end
    end
  end
  return false
end

function colide(objetoA, objetoB)
  local esquerdaDeA = objetoA.x - 8
  local direitaDeA = objetoA.x + 7
  local cimaDeA = objetoA.y - 8
  local baixoDeA = objetoA.y + 7

  local esquerdaDeB = objetoB.x - 8
  local direitaDeB = objetoB.x + 7
  local cimaDeB = objetoB.y - 8
  local baixoDeB = objetoB.y + 7

  if esquerdaDeA <= direitaDeB and
    direitaDeA >= esquerdaDeB and
    cimaDeA <= baixoDeB and
    baixoDeA >= cimaDeB then
    return true
  end
  return false
end

function fazColisaoJogadorComChave(jogador, chave, indiceDaChave)
  sfx(
    Constantes.ID_SOM_CHAVE,
    60, -- número da nota (12 notas por oitava)
    32, -- duracao em quadros
    0,  -- canal
    8,  -- volume
    1   -- velocidade
  )
  table.remove(objetos, indiceDaChave)
  jogador.chaves = jogador.chaves + 1
  return false
end

function temColisaoComMapa(ponto)
  local blocoX = ponto.x / 8
  local blocoY = ponto.y / 8
  local blocoId = mget(blocoX, blocoY)
  if blocoEhParede(blocoId) then
    return true
  end
  return false
end

function blocoEhParede(blocoId)
  if blocoId >= 128 then
    return true
  end
  return false
end

function criaChave(linha, coluna)
  local chave = {
    sprite = Constantes.SPRITE_CHAVE,
    corTransparente = 6,
    x = (coluna * 8) + 8,
    y = (linha * 8) + 8,
    tipo = Constantes.TIPO_CHAVE
  }
  return chave
end

function criaPorta(coluna, linha)
  local porta = {
    sprite = Constantes.SPRITE_PORTA,
    corTransparente = 6,
    x = (coluna * 8) + 8,
    y = (linha * 8) + 8,
    tipo = Constantes.TIPO_PORTA
  }
  return porta
end

inicializa()
