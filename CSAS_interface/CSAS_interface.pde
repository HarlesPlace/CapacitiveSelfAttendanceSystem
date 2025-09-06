import processing.serial.*;

// ---------------- Variáveis globais ----------------
Serial myPort;
String val; 

String[] itens = {"Salada", "Sanduíche Natural", "Suco Detox"};
int itemHover = 0; // índice do item que o sensor aponta
int tela = 0; // 0=início, 1=menu, 2=resumo
int pedidoID = 1; // número do pedido

boolean[] itensSelecionados = new boolean[3]; // 3 itens de exemplo
boolean avisoSemItens = false;

// ---------------- Setup ----------------
void setup() {
  size(600, 400);
  println(Serial.list()); 
  myPort = new Serial(this, Serial.list()[2], 115200); // pode precisar trocar o [0]
}

// ---------------- Draw (executa em loop) ----------------
void draw() {
  background(240);
  
  // Lê dados do Arduino
  lerSensor();
  
  // Desenha a tela correspondente
  if (tela == 0) {
    telaInicio();
  } else if (tela == 1) {
    telaMenu();
  } else if (tela == 2) {
    telaResumo();
  }
}

// função que escuta o canal serial
void lerSensor() {
  if (myPort.available() > 0) {
    val = myPort.readStringUntil('\n');
    if (val != null) {
      int sensorValue = int(trim(val));
      if (tela == 1) {
        // Voltar (0), Itens (1..N), Comprar (N+1)
        itemHover = int(map(sensorValue, 5200, 5500, 0, itens.length + 1));
        itemHover = constrain(itemHover, 0, itens.length + 1);
      } else if (tela == 2) {
        // Só dois botões: Voltar (0) e Finalizar (1)
        itemHover = int(map(sensorValue, 5200, 5500, 0, 1));
        itemHover = constrain(itemHover, 0, 1);
      }
    }
  }
}


// ---------------- Telas ----------------
void telaInicio() {
  textAlign(CENTER, CENTER);
  textSize(28);
  text("Fast Food Saudável", width/2, 100);
  
  rectMode(CENTER);
  fill(150, 250, 150);
  rect(width/2, 250, 200, 80, 20);
  fill(0);
  text("Iniciar", width/2, 250);
}

void telaMenu() {
  textAlign(LEFT, CENTER);
  textSize(20);
  text("Selecione seus itens (ENTER para escolher):", 50, 50);

  // --- Desenha lista de itens ---
  for (int i = 0; i < itens.length; i++) {
    int idx = i + 1; // deslocado porque 0 é o botão Voltar
    if (idx == itemHover && itensSelecionados[i]) {
      fill(100, 200, 100); // hover + selecionado
    } else if (idx == itemHover && !itensSelecionados[i]) {
      fill(180, 220, 255); // hover + não selecionado
    } else if (itensSelecionados[i]) {
      fill(150, 250, 150); // não hover + selecionado
    } else {
      fill(220); // não hover + não selecionado
    }

    rectMode(CENTER);
    rect(175, 100 + i*80, 250, 60, 15);

    fill(0);
    textAlign(LEFT, CENTER);
    text(itens[i], 70, 100 + i*80);
  }

  // --- Botão Voltar ---
  if (itemHover == 0) {
    fill(255, 150, 150); // hover vermelho mais forte
  } else {
    fill(250, 200, 200); // normal
  }
  rect(width/2 - 150, height-80, 200, 60, 15);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Voltar", width/2 - 150, height-80);

  // --- Botão Comprar ---
  if (itemHover == itens.length + 1) {
    fill(150, 180, 255); // hover azul mais forte
  } else {
    fill(200, 200, 250);
  }
  rect(width-150, height-80, 200, 60, 15);
  fill(0);
  text("Comprar", width-150, height-80);
}

void telaResumo() {
  textSize(22);
  textAlign(LEFT, TOP);
  fill(0);
  text("Resumo do Pedido", 50, 50);
  
  int y = 100;
  for (int i = 0; i < itens.length; i++) {
    if (itensSelecionados[i]) {
      text("- " + itens[i], 70, y);
      y += 40;
    }
  }
  
  // --- Botão Voltar ---
  if (itemHover == 0) {
    fill(255, 150, 150); // hover mais forte
  } else {
    fill(250, 200, 200);
  }
  rect(width/2 - 150, height-80, 200, 60, 15);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Voltar", width/2 - 150, height-80);

  // --- Botão Finalizar ---
  if (itemHover == 1) {
    fill(100, 220, 100); // hover verde mais forte
  } else {
    fill(150, 250, 150);
  }
  rect(width/2 + 150, height-80, 200, 60, 15);
  fill(0);
  text("Finalizar", width/2 + 150, height-80);
}


// Função para usar o mouse enquanto testa
// ---------------- Interações com o mouse ----------------
void mousePressed() {
  if (tela == 0) {
    if (mouseX > 200 && mouseX < 400 && mouseY > 210 && mouseY < 290) {
      tela = 1;
    }
  } else if (tela == 1) {
    // Botão Voltar
    float voltarX = width/2 - 150;
    float voltarY = height - 80;
    float btnW = 200;
    float btnH = 60;
    if (mouseX > voltarX - btnW/2 && mouseX < voltarX + btnW/2 &&
        mouseY > voltarY - btnH/2 && mouseY < voltarY + btnH/2) {
      tela = 0;
     }
      
    for (int i = 0; i < itensSelecionados.length; i++) {
      if (mouseX > 175 - 125 && mouseX < 175 + 125 && mouseY > 100 + i*80 - 30 && mouseY < 100 + i*80 + 30) {
        itensSelecionados[i] = !itensSelecionados[i];
      }
    }
    if (mouseX > width-250 && mouseX < width-50 && mouseY > height-110 && mouseY < height-50) {
      tela = 2;
    }
  } else if (tela == 2) {
    // Botão Voltar
    float voltarX = width/2 - 150;
    float voltarY = height - 80;
    float btnW = 200;
    float btnH = 60;
    if (mouseX > voltarX - btnW/2 && mouseX < voltarX + btnW/2 &&
        mouseY > voltarY - btnH/2 && mouseY < voltarY + btnH/2) {
      tela = 1;
    }

    // Botão Finalizar
    float finalizarX = width/2 + 150;
    float finalizarY = height - 80;
    if (mouseX > finalizarX - btnW/2 && mouseX < finalizarX + btnW/2 &&
        mouseY > finalizarY - btnH/2 && mouseY < finalizarY + btnH/2) {
      println("Pedido nº " + pedidoID + " finalizado!");
      pedidoID++;
      itensSelecionados = new boolean[3]; // reseta seleção
      tela = 0;
    }
  }
}

// ---------------- Interações com o teclado ----------------
void keyPressed() {
  if (tela == 0 && keyCode == ENTER) {
    tela = 1; // iniciar
  } else if (tela == 1 && keyCode == ENTER) {
    if (itemHover == 0) {
      // Voltar
      tela = 0;
    } else if (itemHover == itens.length + 1) {
      // Comprar
      tela = 2;
    } else {
      // Itens (deslocados em +1)
      int itemIndex = itemHover - 1;
      itensSelecionados[itemIndex] = !itensSelecionados[itemIndex];
    }
  }
  else if (tela == 2 && keyCode == ENTER) {
  if (itemHover == 0) {
    tela = 1; // Voltar
  } else if (itemHover == 1) {
    println("Pedido nº " + pedidoID + " finalizado!");
    pedidoID++;
    itensSelecionados = new boolean[itens.length]; // reseta seleção
    tela = 0;
  }
}

}
