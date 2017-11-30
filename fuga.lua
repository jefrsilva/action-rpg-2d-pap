-- title:  Fuga das Sombras
-- author: Alura
-- desc:   RPG de acao em 2D
-- script: lua

Constantes = {
  MAPA_LARGURA_TELA = 30,
  MAPA_ALTURA_TELA = 17
}

jogador = {
  sprite = 256,
  x = 120,
  y = 68,
  corTransparente = 0
}

function TIC()
  atualiza()
  desenha()
end

function atualiza()
    -- botão 0 -> seta para cima
    if btn(0) then
      jogador.y = jogador.y - 1
    end

    -- botão 1 -> seta para baixo
    if btn(1) then
      jogador.y = jogador.y + 1
    end

    -- botão 2 -> seta para esquerda
    if btn(2) then
      jogador.x = jogador.x - 1
    end

    -- botão 3 -> seta para direita
    if btn(3) then
      jogador.x = jogador.x + 1
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
