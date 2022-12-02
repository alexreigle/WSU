#define OUTPIN 4
#define INPIN 7

bool d = 0;

void setup() {
  Serial.begin(9600);
  pinMode(OUTPIN, OUTPUT);
  pinMode(INPIN, INPUT);
  digitalWrite(OUTPIN, 0);
  digitalWrite(INPIN, 0);
}

void loop() {
  if(Serial.available() > 0){
    //Read bit from serial monitor
    int data = Serial.read();
    if(data != NULL){
        d = 1;
    }
  
    //Write bit out to FPGA
    digitalWrite(OUTPIN, d);
    Serial.print("Arduino Serial Monitor Input: ");
    Serial.println(d);

    //Read inverted bit from FPGA
    data = digitalRead(INPIN);
    //Display inverted bit in serial monitor
    Serial.print("FPGA PushButton Output: ");
    Serial.println(data);
  }
}
