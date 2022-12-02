int count= -1;

ISR(TIMER1_COMPA_vect)
{
  if(++count==0){ digitalWrite(6, HIGH); }
  else if(count==1){ digitalWrite(6,LOW); }
  else if(count==3){ count = -1; }
}

void setup() {
  pinMode(6, OUTPUT);
  noInterrupts();
  TCCR1A = 0;
  TCCR1B = 0;
  OCR1A = 39; // (39.06=15624/400)
  TCCR1B |= (1 << WGM12);
  TCCR1B |= (1 << CS10); // 1,024 prescaler
  TCCR1B |= (1 << CS12);
  TIMSK1 |= (1 << OCIE1A);
  interrupts();
}
void loop() {}
