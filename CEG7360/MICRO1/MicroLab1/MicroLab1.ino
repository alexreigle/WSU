#define LEDPIN 13
#define PUSHBUTTON 7
#define PRINTTIME 1000

int ledState = HIGH;
int pbState;
int lastPBState = LOW;

//time vars
unsigned long lastPrint = millis();
unsigned long lastDB = 0;
unsigned long dbDelay = 50;

void setup() {
  Serial.begin(9600);
  pinMode(PUSHBUTTON, INPUT);
  pinMode(LEDPIN, OUTPUT);
  digitalWrite(LEDPIN, ledState);
}

void loop() {
  //Print logic
  unsigned long curr = millis();
  //Print if lastPrint was 1 second ago
  if(curr - lastPrint > PRINTTIME){
    Serial.println("Hello World");
    lastPrint = curr;
  }

  //LED logic
  int readPB = digitalRead(PUSHBUTTON);
  //Check if pin state has changed, if it has reset the last debounce time
  if(readPB != lastPBState){
    lastDB = millis();
    //Serial.println(lastDB);
  }

  //Wait 50ms (debounce delay) before executing
  if((millis() - lastDB) > dbDelay){
    if(readPB != pbState){
      pbState = readPB;
      //Toggle LED when PB is high
      if(pbState == HIGH){
        ledState = !ledState;
      }
    }
  }

  //Write to LED
  digitalWrite(LEDPIN, ledState);

  //Store last PB state for next loop
  lastPBState = readPB;
}
