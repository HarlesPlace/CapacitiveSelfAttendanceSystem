//
// Adapted from Kyle McDonald
// From the instructables project at:
// http://www.instructables.com/id/DIY-3D-Controller/

#define resolution 8
#define mains 60 // frequência da rede elétrica 60 Hz no Brasil

#define refresh 2 * 1000000 / mains

// parâmetros da média móvel
const int windowSize = 10;        // tamanho da janela da média (10 leituras)
long buffer[10];                  // buffer circular
int bufferIndex = 0;              
long soma = 0;                    
bool bufferCheio = false;

void setup() {
  Serial.begin(115200);

  // unused pins are fairly insignificant,
  // but pulled low to reduce unknown variables
  for(int i = 2; i < 14; i++) {
    pinMode(i, OUTPUT);
    digitalWrite(i, LOW);
  }

  pinMode(10, INPUT);

  startTimer();
}

void loop() {
  long leitura = time(10, B00000100);

  // atualiza soma e buffer (média móvel)
  soma -= buffer[bufferIndex];   // remove o valor antigo
  buffer[bufferIndex] = leitura; // coloca a nova leitura
  soma += leitura;               

  bufferIndex++;
  if (bufferIndex >= windowSize) {
    bufferIndex = 0;
    bufferCheio = true;
  }

  long media;
  if (bufferCheio) {
    media = soma / windowSize;
  } else {
    media = soma / bufferIndex; // até encher, divide pelo que já tem
  }

  Serial.println(media);
}

long time(int pin, byte mask) {
  unsigned long count = 0, total = 0;
  while(checkTimer() < refresh) {
    // pinMode is about 6 times slower than assigning
    // DDRB directly, but that pause is important
    pinMode(pin, OUTPUT);
    PORTB = 0;
    pinMode(pin, INPUT);
    while((PINB & mask) == 0)
      count++;
    total++;
  }
  startTimer();
  return (count << resolution) / total;
}

extern volatile unsigned long timer0_overflow_count;

void startTimer() {
  timer0_overflow_count = 0;
  TCNT0 = 0;
}

unsigned long checkTimer() {
  return ((timer0_overflow_count << 8) + TCNT0) << 2;
}
