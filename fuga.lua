-- title:  Fuga das Sombras
-- author: Alura
-- desc:   RPG de ação em 2D
-- script: lua

jogador = {
  sprite = 256,
  x = 120,
  y = 68,
  corTransparente = 0
}

function TIC()
  spr(
    jogador.sprite,
    jogador.x - 8,
    jogador.y - 8,
    jogador.corTransparente,
    1, -- escala 1
    0, -- sem espelhar
    0, -- sem rotacionar
    2, -- largura em blocos 2 (cada bloco eh 8x8)
    2  -- altura em blocos 2
  )
end
