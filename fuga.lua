-- title:  Fuga das Sombras
-- author: Alura
-- desc:   RPG de acao em 2D
-- script: lua

Constantes = {
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

jogador = {
  sprite = 256,
  x = 120,
  y = 68,
  corTransparente = 6
}

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
end

function desenha()
  cls() -- limpa a tela, pode passar uma cor como parâmetro
  desenhaMapa()
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
  end
end

function temColisao(objeto, deltaX, deltaY)
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
