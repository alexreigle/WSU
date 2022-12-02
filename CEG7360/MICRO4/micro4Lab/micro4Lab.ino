#include <avr/sleep.h>

int num = 0;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(2, INPUT);
   attachInterrupt(0,printN, LOW);
}

void loop() {
  // put your main code here, to run repeatedly:
  delay(150);
  Go_to_sleep();
 
}

void Go_to_sleep()
{
  sleep_enable();
  attachInterrupt(0,printN, LOW);
  set_sleep_mode(SLEEP_MODE_PWR_DOWN);
  sleep_mode();
  sleep_disable();
  detachInterrupt(0); 
}

void printN()
{
  num = num+1;
  Serial.println(num);
}
