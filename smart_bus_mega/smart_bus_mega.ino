#include <DHT.h>
#include <ArduinoJson.h>
#include <NewPing.h>

#define soilMoisturePin A0
#define soilMoisturePin2 A1
#define DHTPIN 6
#define DHTPIN2 7
#define DHTTYPE DHT22
#define phSensorPin A2
#define waterproofTempPin A3
#define raindropPin A4
#define raindropPin2 A5
#define motor1Pin 8
#define motor2Pin 9
#define triggerPin1 5
#define echoPin1 4
#define triggerPin2 3   // Define trigger and echo pins for the new ultrasonic sensor
#define echoPin2 2

DHT dht(DHTPIN, DHTTYPE);
DHT dht2(DHTPIN2, DHTTYPE);
NewPing sonar1(triggerPin1, echoPin1);
NewPing son  ar2(triggerPin2, echoPin2); // Create a new NewPing object for the second ultrasonic sensor

// Define soil moisture mapping values
const int soilMoistureMin = 0;
const int soilMoistureMax = 1023;
const int soilMoisture2Min = 0;
const int soilMoisture2Max = 1023;

// Define raindrop sensor mapping values
const int raindropMin = 0;
const int raindropMax = 1023;
const int raindrop2Min = 0;
const int raindrop2Max = 1023;

// Calibrated waterproof temperature mapping values
const int waterproofTempMin = 0;    // Replace with the calibrated value for 0°C
const int waterproofTempMax = 1023; // Replace with the calibrated value for 100°C

void setup() {
  Serial.begin(9600);
  dht.begin();
  dht2.begin();

  pinMode(motor1Pin, OUTPUT);
  pinMode(motor2Pin, OUTPUT);
}

void loop() {
  // Allow DHT sensors to stabilize
  delay(2000);

  // Read soil moisture level
  int soilMoisture = analogRead(soilMoisturePin);
  int soilMoisture2 = analogRead(soilMoisturePin2);

  // Map soil moisture readings to a percentage (0-100)
  int soilMoisturePercentage = map(soilMoisture, soilMoistureMin, soilMoistureMax, 0, 100);
  int soilMoisture2Percentage = map(soilMoisture2, soilMoisture2Min, soilMoisture2Max, 0, 100);

  // Read temperature and humidity from DHT22 sensor 1
  float temperature = dht.readTemperature();
  float humidity = dht.readHumidity();

  // Read temperature and humidity from DHT22 sensor 2
  float temperature2 = dht2.readTemperature();
  float humidity2 = dht2.readHumidity();

  // Read pH value from pH sensor
  int pHValue = analogRead(phSensorPin);
  float voltage = pHValue * (5.0 / 1023.0); // Assuming 5V reference voltage
  float pH = 0.0;

  if (voltage < 2.5) {
    pH = map(voltage, 0.0, 2.5, 0.0, 7.0); // Mapping voltage to pH scale (0-7)
  } else {
    pH = map(voltage, 2.5, 5.0, 7.0, 14.0); // Mapping voltage to pH scale (7-14)
  }

  // Read waterproof temperature
  int waterproofTempValue = analogRead(waterproofTempPin);
  float waterproofTemperature = map(waterproofTempValue, waterproofTempMin, waterproofTempMax, -50, 100); // Mapping ADC value to temperature range (-50°C to 100°C)

  // Read raindrop sensor value
  int raindropValue = analogRead(raindropPin);
  int raindropValue2 = analogRead(raindropPin2);

  // Map raindrop sensor readings to a percentage (0-100)
  int raindropPercentage = map(raindropValue, raindropMin, raindropMax, 0, 100);
  int raindrop2Percentage = map(raindropValue2, raindrop2Min, raindrop2Max, 0, 100);
 
  // Read ultrasonic sensor distances
  int distance = sonar1.ping_cm();
  int distance2 = sonar2.ping_cm();

  // Read motor control state
  bool motor1State = digitalRead(motor1Pin);
  bool motor2State = digitalRead(motor2Pin);

  // Create a JSON document
  StaticJsonDocument<500> jsonDoc;

  // Fill the JSON document with sensor data
  jsonDoc["soilMoisture"] = soilMoisturePercentage;
  jsonDoc["soilMoisture2"] = soilMoisture2Percentage;
  jsonDoc["temperature"] = temperature;
  jsonDoc["humidity"] = humidity;
  jsonDoc["temperature2"] = temperature2;
  jsonDoc["humidity2"] = humidity2;
  jsonDoc["pH"] = pH;
  jsonDoc["waterproofTemperature"] = waterproofTemperature;
  jsonDoc["raindropValue"] = raindropPercentage;
  jsonDoc["raindropValue2"] = raindrop2Percentage;
  jsonDoc["ultrasonicDistance"] = distance;
  jsonDoc["ultrasonicDistance2"] = distance2;
  jsonDoc["motor1State"] = motor1State;
  jsonDoc["motor2State"] = motor2State;

  // Serialize the JSON document into a string
  String jsonString;
  serializeJson(jsonDoc, jsonString);

  // Send the JSON data to NodeMCU via serial communication
  Serial.println(jsonString);

  delay(3000);
}
