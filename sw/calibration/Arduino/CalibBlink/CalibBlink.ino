/*
 * 
  Calib Blink - based on Blink example

  Used to configure Arduino to show a blinking pattern
  to calibrate a DVS camera

  Connect LED (or transistor) to pin 13
  Flashes with a frequency of 500Hz
  
*/

void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  pinMode(LED_BUILTIN, OUTPUT);
}

// the loop function runs over and over again forever
void loop() {
  digitalWrite(LED_BUILTIN, HIGH);   // turn the LED on (HIGH is the voltage level)
  delay(1);                       // wait for a milisecond
  digitalWrite(LED_BUILTIN, LOW);    // turn the LED off by making the voltage LOW
  delay(1);                       // wait for a milisecond
}
