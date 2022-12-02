void setup() {
  Serial.begin(9600);
}

void loop() {
  if(Serial.available() > 0){
    char data = Serial.read();
    data = data+1;
    Serial.write(data);
  }
}
