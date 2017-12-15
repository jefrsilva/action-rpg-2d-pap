-- title:  Fuga das Sombras
-- author: Alura
-- desc:   RPG de acao em 2D
-- script: lua

Constantes = {
  SPRITE_JOGADOR =  256,
  SPRITE_CHAVE = 364,
  SPRITE_PORTA = 366,
  SPRITE_INIMIGO = 292,
  SPRITE_ESPADA = 320,
  SPRITE_TITULO = 352,
  SPRITE_ALURA = 416,
  SPRITE_VIDA = 428,
  SPRITE_CORACAO_CHEIO = 412,
  SPRITE_CORACAO_VAZIO = 396,
  SPRITE_CHAVE_PEQUENA = 398,

  TIPO_JOGADOR = "JOGADOR",
  TIPO_CHAVE = "CHAVE",
  TIPO_PORTA = "PORTA",
  TIPO_INIMIGO = "INIMIGO",
  TIPO_ESPADA = "ESPADA",
  TIPO_VIDA = "VIDA",

  VELOCIDADE_INIMIGO = 0.5,
  VELOCIDADE_EMPURRAO = 2,

  VELOCIDADE_ANIMACAO_JOGADOR = 0.2,
  VELOCIDADE_ANIMACAO_INIMIGO = 0.2,
  VELOCIDADE_ANIMACAO_ESPADA = 0.45,

  ID_SOM_CHAVE = 0,
  ID_SOM_INIMIGO_ATINGIDO = 1,
  ID_SOM_PORTA = 2,
  ID_SOM_ESPADA = 3,
  ID_SOM_JOGADOR_ATINGIDO = 4,
  ID_SOM_INICIO = 5,
  ID_SOM_FINAL = 6,
  ID_SOM_VIDA = 7,

  CIMA = 1,
  BAIXO = 2,
  ESQUERDA = 3,
  DIREITA = 4,

  BLOCOID_CHAVE = 224,
  BLOCOID_PORTA = 225,
  BLOCOID_INIMIGO = 226,

  MAPA_LARGURA_TOTAL = 240,
  MAPA_ALTURA_TOTAL = 136,

  MAPA_LARGURA_TELA = 31,
  MAPA_ALTURA_TELA = 18,

  TITULO_LARGURA = 12,
  TITULO_ALTURA = 4,

  ALURA_LARGURA = 7,
  ALURA_ALTURA = 3,
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

AnimacaoInimigo = {
  { -- andando pra cima
    {sprite = 288},
    {sprite = 290}
  },
  { -- andando pra baixo
    {sprite = 292},
    {sprite = 294}
  },
  { -- andando pra esquerda
    {sprite = 296},
    {sprite = 298}
  },
  { -- andando pra direita
    {sprite = 300},
    {sprite = 302}
  },
}

DadosDaEspada = {
  { -- ataque para cima
    {x = -16, y = 0, sprite = 320},
    {x = -12, y = -12, sprite = 322},
    {x = 0, y = -16, sprite = 324},
    {x = 12, y = -12, sprite = 326},
    {x = 16, y = 0, sprite = 328}
  },
  { -- ataque para baixo
    {x = 16, y = 0, sprite = 328},
    {x = 12, y = 12, sprite = 330},
    {x = 0, y = 16, sprite = 332},
    {x = -12, y = 12, sprite = 334},
    {x = -16, y = 0, sprite = 320}
  },
  { -- ataque para esquerda
    {x = 0, y = 16, sprite = 332},
    {x = -12, y = 12, sprite = 334},
    {x = -16, y = 0, sprite = 320},
    {x = -12, y = -12, sprite = 322},
    {x = 0, y = -16, sprite = 324}
  },
  { -- ataque para direita
    {x = 0, y = -16, sprite = 324},
    {x = 12, y = -12, sprite = 326},
    {x = 16, y = 0, sprite = 328},
    {x = 12, y = 12, sprite = 330},
    {x = 0, y = 16, sprite = 332}
  }
}

Estado = {
  PARADO = "PARADO",
  ANDANDO = "ANDANDO",
  PERSEGUINDO = "PERSEGUINDO",
  ATINGIDO = "ATINGIDO"
}

Tela = {
  TITULO = "TITULO",
  JOGO = "JOGO",
  FINAL = "FINAL"
}

function inicializa()
  quadroDoJogo = 0

  funcaoDeColisao = {
    JOGADOR = {
      JOGADOR = nil,
      CHAVE = fazColisaoJogadorComChave,
      PORTA = fazColisaoJogadorComPorta,
      INIMIGO = fazColisaoJogadorComInimigo,
      ESPADA = nil,
      VIDA = fazColisaoJogadorComVida
    },
    CHAVE = {
      JOGADOR = nil,
      CHAVE = nil,
      PORTA = nil,
      INIMIGO = nil,
      ESPADA = nil,
      VIDA = nil
    },
    PORTA = {
      JOGADOR = nil,
      CHAVE = nil,
      PORTA = nil,
      INIMIGO = nil,
      ESPADA = nil,
      VIDA = nil
    },
    INIMIGO = {
      JOGADOR = nil,
      CHAVE = nil,
      PORTA = nil,
      INIMIGO = nil,
      ESPADA = nil,
      VIDA = nil
    },
    ESPADA = {
      JOGADOR = nil,
      CHAVE = nil,
      PORTA = nil,
      INIMIGO = fazColisaoEspadaComInimigo,
      ESPADA = nil,
      VIDA = nil
    },
    VIDA = {
      JOGADOR = nil,
      CHAVE = nil,
      PORTA = nil,
      INIMIGO = nil,
      ESPADA = nil,
      VIDA = nil
    }
  }

  funcaoDeEstado = {
    PARADO = atualizaEstadoParado,
    ANDANDO = atualizaEstadoAndando,
    PERSEGUINDO = atualizaEstadoPerseguindo,
    ATINGIDO = atualizaEstadoAtingido
  }

  funcoesDaTela = {
    TITULO = {
      funcaoDeAtualizacao = atualizaTelaDeTitulo,
      funcaoDeDesenho = desenhaTelaDeTitulo
    },
    JOGO = {
      funcaoDeAtualizacao = atualizaTelaDeJogo,
      funcaoDeDesenho = desenhaTelaDeJogo
    },
    FINAL = {
      funcaoDeAtualizacao = atualizaTelaDeFinal,
      funcaoDeDesenho = desenhaTelaDeFinal
    }
  }

  telaAtual = Tela.TITULO
  proximaTela = nil
  tempoAteTrocarDeTela = 0

  posicaoDaSaida = {
    x = (55 * 8) + 8,
    y = (6 * 8) + 8
  }

  objetosIniciais = {}
  leObjetosDoMapa()
end

function resetaJogo()
  objetos = {}

  jogador = {
    sprite = Constantes.SPRITE_JOGADOR,
    x = 120,
    y = 68,
    corTransparente = 6,
    direcao = Constantes.BAIXO,
    quadroDeAnimacao = 1,
    tipo = Constantes.TIPO_JOGADOR,
    chaves = 0,
    vida = 5,
    vidaMaxima = 5,
    tempoInvulneravel = 0,
  }

  espada = {
    sprite = Constantes.SPRITE_ESPADA,
    x = 0,
    y = 0,
    corTransparente = 0,
    tipo = Constantes.TIPO_ESPADA,
    visivel = false,
    esperaDoAtaque = 0
  }

  camera = {
    x = 0,
    y = 0
  }

  criaObjetosIniciais()
end

function leObjetosDoMapa()
  for linha = 0, Constantes.MAPA_ALTURA_TOTAL do
    for coluna = 0, Constantes.MAPA_LARGURA_TOTAL do
      local blocoId = mget(coluna, linha)
      -- pra não ter que fazer vários ifs, só verifica se é um marcador
      if blocoEhMarcador(blocoId) then
        mset(coluna, linha, 0)
        local objeto = {
          blocoId = blocoId,
          coluna = coluna,
          linha = linha
        }
        -- coloca em outra tabela de objetos iniciais
        table.insert(objetosIniciais, objeto)
      end
    end
  end
end

function blocoEhMarcador(blocoId)
  if blocoId == Constantes.BLOCOID_CHAVE
    or blocoId == Constantes.BLOCOID_PORTA
    or blocoId == Constantes.BLOCOID_INIMIGO then
    return true
  end
  return false
end

function criaObjetosIniciais()
  objetos = {}
  for indice, objetoACriar in pairs(objetosIniciais) do
    local objeto = criaObjeto(objetoACriar)
    if objeto ~= nil then
      table.insert(objetos, objeto)
    end
  end
end

function criaObjeto(objetoACriar)
  local objeto = nil
  if objetoACriar.blocoId == Constantes.BLOCOID_CHAVE then
    objeto = criaChave(objetoACriar.coluna, objetoACriar.linha)
  elseif objetoACriar.blocoId == Constantes.BLOCOID_PORTA then
    objeto = criaPorta(objetoACriar.coluna, objetoACriar.linha)
  elseif objetoACriar.blocoId == Constantes.BLOCOID_INIMIGO then
    objeto = criaInimigo(objetoACriar.coluna, objetoACriar.linha)
  end
  return objeto
end

function TIC()
  atualiza()
  desenha()
end

function atualiza()
  quadroDoJogo = quadroDoJogo + 1

  local funcaoDeAtualizacao = funcoesDaTela[telaAtual].funcaoDeAtualizacao
  funcaoDeAtualizacao()

  if proximaTela ~= nil then
    if tempoAteTrocarDeTela > 0 then
      tempoAteTrocarDeTela = tempoAteTrocarDeTela - 1
    else
      telaAtual = proximaTela
      proximaTela = nil
    end
  end
end

function atualizaTelaDeTitulo()
  if proximaTela == nil then
    if btn(4) then
      sfx(
        Constantes.ID_SOM_INICIO,
        72, -- número da nota (12 notas por oitava)
        32, -- duracao em quadros
        0,  -- canal
        8,  -- volume
        0   -- velocidade
      )

      resetaJogo()
      proximaTela = Tela.JOGO
      tempoAteTrocarDeTela = 90
    end
  end
end

function atualizaTelaDeJogo()
  if proximaTela == nil then
    atualizaJogador()
    if jogador.x == posicaoDaSaida.x and jogador.y == posicaoDaSaida.y then
      sfx(
        Constantes.ID_SOM_FINAL,
        36, -- número da nota (12 notas por oitava)
        32, -- duracao em quadros
        0,  -- canal
        8,  -- volume
        0   -- velocidade
      )

      proximaTela = Tela.FINAL
      tempoAteTrocarDeTela = 60
    end
  end

  camera.x = jogador.x-120
  camera.y = jogador.y-68

  for indice, objeto in pairs(objetos) do
    if objeto.tipo == Constantes.TIPO_INIMIGO then
      atualizaInimigo(objeto)
    end
  end
end

function atualizaTelaDeFinal()
  if proximaTela == nil then
    if btn(4) then
      proximaTela = Tela.TITULO
      tempoAteTransicao = 15
    end
  end
end

function atualizaInimigo(inimigo)
  local quadroDeAnimacao = math.floor(inimigo.quadroDeAnimacao)
  inimigo.sprite = AnimacaoInimigo[inimigo.direcao][quadroDeAnimacao].sprite

  local atualizaEstado = funcaoDeEstado[inimigo.estado]
  atualizaEstado(inimigo)
end

function atualizaEstadoParado(inimigo)
  if jogadorEstaPerto(inimigo) then
    inimigo.estado = Estado.PERSEGUINDO
    return
  end

  if inimigo.tempoDeEspera > 0 then
    inimigo.tempoDeEspera = inimigo.tempoDeEspera - 1
  else
    local indiceDirecao = math.random(1, 4)
    inimigo.direcao = indiceDirecao
    inimigo.distanciaParaAndar = math.random(16, 64)
    inimigo.estado = Estado.ANDANDO
  end
end

function atualizaEstadoAndando(inimigo)
  if jogadorEstaPerto(inimigo) then
    inimigo.estado = Estado.PERSEGUINDO
    return
  end

  if inimigo.distanciaParaAndar > 0 then
    inimigo.distanciaParaAndar = inimigo.distanciaParaAndar - 1
    if temColisao(inimigo, Direcao[inimigo.direcao].deltaX, Direcao[inimigo.direcao].deltaY) then
      inimigo.distanciaParaAndar = 0
    else
      inimigo.x = inimigo.x + Direcao[inimigo.direcao].deltaX * 0.5
      inimigo.y = inimigo.y + Direcao[inimigo.direcao].deltaY * 0.5
      atualizaAnimacaoInimigo(inimigo)
    end
  else
    inimigo.tempoDeEspera = math.random(30) + 15
    inimigo.estado = Estado.PARADO
  end
end

function atualizaEstadoPerseguindo(inimigo)
  if not jogadorEstaPerto(inimigo) then
    inimigo.estado = Estado.PARADO
    return
  end

  local deltaX = jogador.x - inimigo.x
  local deltaY = jogador.y - inimigo.y

  -- normalizando os deltas para facilitar escolher a velocidade
  if math.abs(deltaX) > 0.0 then
    deltaX = deltaX / math.abs(deltaX)
  end
  if math.abs(deltaY) > 0.0 then
    deltaY = deltaY / math.abs(deltaY)
  end

  if not temColisao(inimigo, deltaX, 0) then
    inimigo.x = inimigo.x + deltaX * Constantes.VELOCIDADE_INIMIGO
    if (deltaX < 0.0) then
      inimigo.direcao = Constantes.ESQUERDA
    else
      inimigo.direcao = Constantes.DIREITA
    end
  end
  if not temColisao(inimigo, 0, deltaY) then
    inimigo.y = inimigo.y + deltaY * Constantes.VELOCIDADE_INIMIGO
    if (deltaY < 0.0) then
      inimigo.direcao = Constantes.CIMA
    else
      inimigo.direcao = Constantes.BAIXO
    end
  end
  atualizaAnimacaoInimigo(inimigo)
end

function atualizaEstadoAtingido(inimigo)
  if not temColisao(inimigo, inimigo.direcaoEmpurrao.deltaX, 0) then
    inimigo.x = inimigo.x + inimigo.direcaoEmpurrao.deltaX
  end
  if not temColisao(inimigo, 0, inimigo.direcaoEmpurrao.deltaY) then
    inimigo.y = inimigo.y + inimigo.direcaoEmpurrao.deltaY
  end

  inimigo.distanciaEmpurrao = inimigo.distanciaEmpurrao - 1
  if inimigo.distanciaEmpurrao <= 0 then
    inimigo.estado = Estado.PARADO
    inimigo.tempoDeEspera = 15
  end
end

function atualizaAnimacaoInimigo(inimigo)
  inimigo.quadroDeAnimacao = inimigo.quadroDeAnimacao + Constantes.VELOCIDADE_ANIMACAO_INIMIGO
  if inimigo.quadroDeAnimacao >= 3 then
    inimigo.quadroDeAnimacao = inimigo.quadroDeAnimacao - 2
  end
end

function jogadorEstaPerto(inimigo)
  local distanciaParaOJogador = calculaDistancia(jogador, inimigo)
  if distanciaParaOJogador > 12 and distanciaParaOJogador < 48 then
    return true
  end
  return false
end

function calculaDistancia(objetoA, objetoB)
  local deltaX = objetoA.x - objetoB.x
  local deltaY = objetoA.y - objetoB.y

  return math.sqrt(deltaX * deltaX + deltaY * deltaY)
end

function atualizaJogador()
  if jogador.tempoInvulneravel > 0 then
    jogador.tempoInvulneravel = jogador.tempoInvulneravel - 1
  end

  temColisao(jogador, 0, 0) -- para verificar se tem colisao com algum inimigo

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

  if btn(4) then
    fazAtaque()
  end

  atualizaEspada()
end

function atualizaEspada()
  if espada.esperaDoAtaque > 0 then
    espada.esperaDoAtaque = espada.esperaDoAtaque - 1
  end

  if espada.visivel then
    espada.quadroAtual = espada.quadroAtual + Constantes.VELOCIDADE_ANIMACAO_ESPADA
    if espada.quadroAtual >= 6 then
      espada.visivel = false
      return
    end

    local quadroAtual = math.floor(espada.quadroAtual)
    local quadroDeAnimacao = espada.quadrosDeAnimacao[quadroAtual]
    espada.x = jogador.x + quadroDeAnimacao.x
    espada.y = jogador.y + quadroDeAnimacao.y
    espada.sprite = quadroDeAnimacao.sprite

    temColisao(espada, 0, 0)
  end
end

function atualizaAnimacaoJogador()
  if jogador.quadroDeAnimacao >= 3 then
    jogador.quadroDeAnimacao = jogador.quadroDeAnimacao - 2
  end
end

function desenha()
  cls() -- limpa a tela, pode passar uma cor como parâmetro

  local funcaoDeDesenho = funcoesDaTela[telaAtual].funcaoDeDesenho
  funcaoDeDesenho()
end

function desenhaTelaDeJogo()
  desenhaMapa()
  for indice, objeto in pairs(objetos) do
    desenhaObjeto(objeto)
  end
  desenhaJogador()
  desenhaInterfaceDoUsuario()
end

function desenhaInterfaceDoUsuario()
  desenhaMostradorDeVida()
  desenhaMostradorDeChaves()
end

function desenhaMostradorDeVida()
  desenhaTexto("Vida", 4, 4, 15)
  for coracao=1, jogador.vidaMaxima do
    local sprite = Constantes.SPRITE_CORACAO_VAZIO
    if coracao <= jogador.vida then
      sprite = Constantes.SPRITE_CORACAO_CHEIO
    end
    spr(
      sprite,
      24 + coracao * 10, -- cada coracao tem 9px de largura
      3,
      1,  -- cor transparente
      1,  -- escala
      0,  -- sem espelhar
      0,  -- sem rotacionar
      2,  -- largura em blocos
      1   -- altura em blocos
    )
  end
end

function desenhaMostradorDeChaves()
  desenhaTexto("Chaves", 148, 4, 15)
  for chave=1, jogador.chaves do
    spr(
      Constantes.SPRITE_CHAVE_PEQUENA,
      180 + chave * 10,
      3,
      1,  -- cor transparente
      1,  -- escala
      0,  -- sem espelhar
      0,  -- sem rotacionar
      2,  -- largura em blocos
      1   -- altura em blocos
    )
  end
end

function desenhaTelaDeTitulo()
  -- Desenha título do jogo
  spr(
    Constantes.SPRITE_TITULO,
    80, -- posicao X
    12, -- posicao Y
    1,  -- cor transparente
    1,  -- escala
    0,  -- sem espelhar
    0,  -- sem rotacionar
    Constantes.TITULO_LARGURA,  -- largura em blocos
    Constantes.TITULO_ALTURA    -- altura em blocos
  )

  desenhaTexto("Pressione Z para iniciar", 56, 64, 15)

  -- Desenha logo da Alura
  spr(
    Constantes.SPRITE_ALURA,
    94,  -- posicao X
    92, -- posicao Y
    1,  -- cor transparente
    1,  -- escala
    0,  -- sem espelhar
    0,  -- sem rotacionar
    Constantes.ALURA_LARGURA,  -- largura em blocos
    Constantes.ALURA_ALTURA    -- altura em blocos
  )

  desenhaTexto("www.alura.com.br", 78, 122, 15)
end

function desenhaTelaDeFinal()
  desenhaTexto("Voce conseguiu escapar!", 56, 40, 15)
  desenhaTexto("Pressione Z para reiniciar", 48, 86, 15 )
end

function desenhaTexto(texto, x, y, cor)
  -- contorno
  print(texto, x-1, y, 0)
  print(texto, x+1, y, 0)
  print(texto, x, y-1, 0)
  print(texto, x, y+1, 0)
  -- texto
  print(texto, x, y, cor)
end

function desenhaJogador()
  if jogador.vida <= 0 then
    return
  end

  local desenha = true

  if jogador.tempoInvulneravel > 0 then
    if ((jogador.tempoInvulneravel // 8) % 2) == 0 then
      desenha = false
    end
  end

  if desenha then
    local quadroDeAnimacao = math.floor(jogador.quadroDeAnimacao)
    jogador.sprite = AnimacaoJogador[jogador.direcao][quadroDeAnimacao].sprite
    desenhaObjeto(jogador)
  end

  if espada.visivel then
    desenhaObjeto(espada)
  end
end

function desenhaObjeto(objeto)
  spr(
    objeto.sprite,
    objeto.x - 8 - camera.x,
    objeto.y - 8 - camera.y,
    objeto.corTransparente,
    1, -- escala 1
    0, -- sem espelhar
    0, -- sem rotacionar
    2, -- largura em blocos 2 (cada bloco eh 8x8)
    2  -- altura em blocos 2
  )
end

function desenhaMapa()
  local blocoX = camera.x // 8
  local blocoY = camera.y // 8

  map(
    blocoX, -- coordenada x do bloco inicial
    blocoY, -- coordenada y do bloco inicial
    Constantes.MAPA_LARGURA_TELA, -- largura do mapa em blocos
    Constantes.MAPA_ALTURA_TELA,  -- altura do mapa em blocos
    -(camera.x % 8), -- posicao x de onde o mapa vai ser desenhado
    -(camera.y % 8)  -- posicao y de onde o mapa vai ser desenhado
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
      local fazColisao = funcaoDeColisao[objeto.tipo][outroObjeto.tipo]
      if fazColisao ~= nil then
        return fazColisao(objeto, outroObjeto, indice)
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

function fazColisaoJogadorComPorta(jogador, porta, indiceDaPorta)
  if jogador.chaves > 0 then
    sfx(
      Constantes.ID_SOM_PORTA,
      36, -- número da nota (12 notas por oitava)
      32, -- duracao em quadros
      0,  -- canal
      15, -- volume
      1   -- velocidade
    )

    table.remove(objetos, indiceDaPorta)
    jogador.chaves = jogador.chaves - 1
    return false
  end
  return true
end

function fazColisaoJogadorComInimigo(jogador, inimigo, indiceDoInimigo)
  if jogador.tempoInvulneravel == 0 then
    sfx(
      Constantes.ID_SOM_JOGADOR_ATINGIDO,
      48, -- número da nota (12 notas por oitava)
      15, -- duracao em quadros
      0,  -- canal
      8,  -- volume
      2   -- velocidade
    )

    jogador.tempoInvulneravel = 60
    jogador.vida = jogador.vida - 1
    if jogador.vida <= 0 then
      proximaTela = Tela.TITULO
      tempoAteTrocarDeTela = 120
    end
  end
  return false
end

function fazColisaoJogadorComVida(jogador, vida, indiceDaVida)
  if jogador.vida < jogador.vidaMaxima then
    sfx(
      Constantes.ID_SOM_VIDA,
      48, -- número da nota (12 notas por oitava)
      15, -- duracao em quadros
      0,  -- canal
      8,  -- volume
      3   -- velocidade
    )

    jogador.vida = jogador.vida + 1
    table.remove(objetos, indiceDaVida)
  end
  return false
end

function fazColisaoEspadaComInimigo(espada, inimigo, indiceDoInimigo)
  if inimigo.estado ~= Estado.ATINGIDO then
    sfx(
      Constantes.ID_SOM_INIMIGO_ATINGIDO,
      24, -- número da nota (12 notas por oitava)
      15, -- duracao em quadros
      0,  -- canal
      8,  -- volume
      0   -- velocidade
    )

    local deltaXEmpurrao = inimigo.x - jogador.x
    local deltaYEmpurrao = inimigo.y - jogador.y
    local distancia = calculaDistancia(jogador, inimigo)

    deltaXEmpurrao = (deltaXEmpurrao / distancia) * Constantes.VELOCIDADE_EMPURRAO
    deltaYEmpurrao = (deltaYEmpurrao / distancia) * Constantes.VELOCIDADE_EMPURRAO

    inimigo.direcaoEmpurrao = {deltaX = deltaXEmpurrao, deltaY = deltaYEmpurrao}
    inimigo.distanciaEmpurrao = 16

    inimigo.estado = Estado.ATINGIDO
    inimigo.vida = inimigo.vida - 1
    if inimigo.vida == 0 then
      table.remove(objetos, indiceDoInimigo)

      local probabilidade = math.random()
      if probabilidade < 0.5 then
        local vida = criaVida(inimigo.x, inimigo.y)
        table.insert(objetos, vida)
      end
    end
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

function criaChave(coluna, linha)
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

function criaInimigo(coluna, linha)
  local inimigo = {
    sprite = Constantes.SPRITE_INIMIGO,
    corTransparente = 14,
    x = (coluna * 8) + 8,
    y = (linha * 8) + 8,
    tipo = Constantes.TIPO_INIMIGO,
    estado = Estado.PARADO,
    tempoDeEspera = 0,
    direcao = Constantes.BAIXO,
    quadroDeAnimacao = 1,
    vida = 3
  }
  return inimigo
end

function criaVida(coordenadaX, coordenadaY)
  local vida = {
    sprite = Constantes.SPRITE_VIDA,
    corTransparente = 14,
    x = coordenadaX,
    y = coordenadaY,
    tipo = Constantes.TIPO_VIDA
  }
  return vida
end

function fazAtaque()
  if not espada.visivel and espada.esperaDoAtaque == 0 then
    sfx(
      Constantes.ID_SOM_ESPADA,
      86, -- número da nota (12 notas por oitava)
      15, -- duracao em quadros
      0,  -- canal
      8,  -- volume
      2   -- velocidade
    )

    espada.esperaDoAtaque = 40
    espada.quadrosDeAnimacao = DadosDaEspada[jogador.direcao]
    espada.quadroAtual = 1
    espada.visivel = true
  end
end

inicializa()
