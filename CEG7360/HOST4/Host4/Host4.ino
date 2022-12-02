#define datapin 4
#define readypin 5

int which_bit  = 0;
int wbn = 1;
unsigned char str[20] = { 0, 1, 1, 1, 1,
                          1, 0, 1, 0, 0,
                          1, 0, 0, 1, 0,
                          0, 1, 0, 1, 1};

void setup() {
  Serial.begin(9600);

  pinMode(datapin, OUTPUT);
  pinMode(readypin, OUTPUT);
  digitalWrite(datapin, LOW);
  digitalWrite(readypin, LOW);
}

void send_one_bit(){
  //store bit on datapin, signal if ready on readypin
  digitalWrite(readypin, LOW);
  digitalWrite(datapin, str[which_bit]);
  digitalWrite(readypin, HIGH);

  //delay for noise-tolerance
  delay(1);

  //Print statements
  wbn = which_bit + 1;
  Serial.print(str[which_bit]);
  if(which_bit != 0 && wbn%5 == 0){
    Serial.println();
  };
  which_bit = which_bit+1;
  if(which_bit >= 20){
    Serial.println("done");
  }
}

void loop() {
  //Wait for input
  if(Serial.available()){
    //Don't care whats read, just using it as a signal to start sending bits
    Serial.read();

    //send bits one word at a time
    for(int i = 0; i < 20; i++){
      send_one_bit();
    }
  }
}
