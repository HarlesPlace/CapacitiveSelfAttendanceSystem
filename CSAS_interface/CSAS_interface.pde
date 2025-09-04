import processing.serial.*;

// ---------------- Variáveis globais ----------------
Serial myPort;
String val; 

String[] itens = {"Salada", "Sanduíche Natural", "Suco Detox"};
int itemHover = 0; // índice do item que o sensor aponta
int tela = 0; // 0=início, 1=menu, 2=resumo
int pedidoID = 1; // número do pedido

boolean[] itensSelecionados = new boolean[3]; // 3 itens de exemplo

// ---------------- Setup ----------------
void setup() {
  size(600, 400);
  println(Serial.list()); 
  myPort = new Serial(this, Serial.list()[0], 115200); // pode precisar trocar o [0]
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
    }
  }
}

void telaInicio() {
  textAlign(CENTER, CENTER);
  textSize(28);
  text("Fast Food Saudável", width/2, 100);
  
  rectMode(CENTER);
  fill(200, 250, 200);
  rect(width/2, 250, 200, 80, 20);
  fill(0);
  text("Iniciar", width/2, 250);
}

void telaMenu() {
  textAlign(LEFT, CENTER);
  textSize(20);
  text("Selecione seus itens (Enter para escolher):", 50, 50);

  for (int i = 0; i < itens.length; i++) {
    // hover destacado pelo sensor
    if (i == itemHover) {
      fill(180, 220, 255); // azul claro pro hover
    } else if (itensSelecionados[i]) {
      fill(150, 250, 150); // verde se já selecionado
    } else {
      fill(220);
    }
    rect(50, 100 + i*80, 250, 60, 15);
    fill(0);
    text(itens[i], 70, 130 + i*80);
  }

  // Botão avançar
  fill(200, 200, 250);
  rect(width-150, height-80, 200, 60, 15);
  fill(0);
  text("Resumo", width-150, height-80);
}

void telaResumo() {
  textSize(22);
  text("Resumo do Pedido", 50, 50);
  
  int y = 100;
  
  for (int i = 0; i < itens.length; i++) {
    if (itensSelecionados[i]) {
      text("- " + itens[i], 70, y);
      y += 40;
    }
  }
  
  rect(width/2, height-80, 200, 60, 15);
  fill(0);
  text("Finalizar", width/2, height-80);
}

// Função para usar o mouse enquanto testa
void mousePressed() {
  if (tela == 0) {
    if (mouseX > 200 && mouseX < 400 && mouseY > 210 && mouseY < 290) {
      tela = 1;
    }
  } else if (tela == 1) {
    for (int i = 0; i < itensSelecionados.length; i++) {
      if (mouseX > 50 && mouseX < 300 && mouseY > 100+i*80-30 && mouseY < 100+i*80+30) {
        itensSelecionados[i] = !itensSelecionados[i];
      }
    }
    if (mouseX > width-250 && mouseX < width-50 && mouseY > height-110 && mouseY < height-50) {
      tela = 2;
    }
  } else if (tela == 2) {
    if (mouseX > width/2-100 && mouseX < width/2+100 && mouseY > height-110 && mouseY < height-50) {
      println("Pedido nº " + pedidoID + " finalizado!");
      pedidoID++;
      itensSelecionados = new boolean[3]; // reseta
      tela = 0;
    }
  }
}
