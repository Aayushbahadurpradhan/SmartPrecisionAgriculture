#include <SoftwareSerial.h>
#include <ArduinoJson.h>
#include <FirebaseESP8266.h>
#include <ESP8266WiFi.h>
#include <DHT.h>
#include <OneWire.h>
#include <DallasTemperature.h>

SoftwareSerial nodemcu(D6, D5);

#define WIFI_SSID "one"
#define WIFI_PASSWORD "@@98131y"
#define FIREBASE_HOST "my-smart-agriculture-c9a33-default-rtdb.firebaseio.com/"
#define FIREBASE_AUTH "AIzaSyBXaBGI0c1BbTpl09LQvLOhwKYXQytrFUc"


FirebaseData fbdo;

void setup() {
  Serial.begin(9600);
  nodemcu.begin(9600);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(3000);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
}

void loop() {
  if (nodemcu.available()) {
    // Read the incoming data from Arduino
    String jsonString = nodemcu.readStringUntil('\n');

    // Create a JSON document
    DynamicJsonDocument jsonDoc(1000);

    // Deserialize the JSON data
    DeserializationError error = deserializeJson(jsonDoc, jsonString);

    if (error) {
      Serial.println("Invalid JSON Object");
      return;
    }

    Serial.println("JSON Object Received");

    // Retrieve the sensor data from the JSON document
    float temperature = jsonDoc["temperature"];
    float humidity = jsonDoc["humidity"];
    float temperature2 = jsonDoc["temperature2"];
    float humidity2 = jsonDoc["humidity2"];
    int soilMoisture = jsonDoc["soilMoisture"];
    int soilMoisture2 = jsonDoc["soilMoisture2"];
    float pH = jsonDoc["pH"];
    float waterproofTemperature = jsonDoc["waterproofTemperature"];
    int raindropValue = jsonDoc["raindropValue"];
    int raindropValue2 = jsonDoc["raindropValue2"];   
    int distance = jsonDoc["ultrasonicDistance"];
    bool motor1State = jsonDoc["motor1State"];
    bool motor2State = jsonDoc["motor2State"];

    // Write temperature to the database path test/temperature
    if (Firebase.setFloat(fbdo, "test/temperature", temperature)) {
      Serial.println("Temperature - PASSED");
      Serial.println("PATH: " + fbdo.dataPath());
      Serial.println("TYPE: " + fbdo.dataType());
    } else {
      Serial.println("Temperature - FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }

    // Write humidity to the database path test/humidity
    if (Firebase.setFloat(fbdo, "test/humidity", humidity)) {
      Serial.println("Humidity - PASSED");
      Serial.println("PATH: " + fbdo.dataPath());
      Serial.println("TYPE: " + fbdo.dataType());
    } else {
      Serial.println("Humidity - FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }

    // Write temperature to the database path test/temperature2
    if (Firebase.setFloat(fbdo, "test/temperature2", temperature2)) {
      Serial.println("Temperature2 - PASSED");
      Serial.println("PATH: " + fbdo.dataPath());
      Serial.println("TYPE: " + fbdo.dataType());
    } else {
      Serial.println("Temperature2 - FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }

    // Write humidity to the database path test/humidity
    if (Firebase.setFloat(fbdo, "test/humidity2", humidity2)) {
      Serial.println("Humidity2 - PASSED");
      Serial.println("PATH: " + fbdo.dataPath());
      Serial.println("TYPE: " + fbdo.dataType());
    } else {
      Serial.println("Humidity2 - FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }
    
    // Write soil moisture to the database path test/soil_moisture
    if (Firebase.setInt(fbdo, "test/soil_moisture", soilMoisture)) {
      Serial.println("Soil Moisture - PASSED");
      Serial.println("PATH: " + fbdo.dataPath());
      Serial.println("TYPE: " + fbdo.dataType());
    } else {
      Serial.println("Soil Moisture - FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }

        // Write soil moisture to the database path test/soil_moisture
    if (Firebase.setInt(fbdo, "test/soil_moisture2", soilMoisture2)) {
      Serial.println("Soil Moisture2 - PASSED");
      Serial.println("PATH: " + fbdo.dataPath());
      Serial.println("TYPE: " + fbdo.dataType());
    } else {
      Serial.println("Soil Moisture2 - FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }

    // Write pH value to the database path test/pH
    if (Firebase.setFloat(fbdo, "test/pH", pH)) {
      Serial.println("pH Value - PASSED");
      Serial.println("PATH: " + fbdo.dataPath());
      Serial.println("TYPE: " + fbdo.dataType());
    } else {
      Serial.println("pH Value - FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }

    // Write waterproof temperature to the database path test/waterproof_temperature
    if (Firebase.setFloat(fbdo, "test/waterproof_temperature", waterproofTemperature)) {
      Serial.println("Waterproof Temperature - PASSED");
      Serial.println("PATH: " + fbdo.dataPath());
      Serial.println("TYPE: " + fbdo.dataType());
    } else {
      Serial.println("Waterproof Temperature - FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }

    // Write raindrop sensor value to the database path test/raindrop
    if (Firebase.setInt(fbdo, "test/raindrop", raindropValue)) {
      Serial.println("Raindrop - PASSED");
      Serial.println("PATH: " + fbdo.dataPath());
      Serial.println("TYPE: " + fbdo.dataType());
    } else {
      Serial.println("Raindrop - FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }

        if (Firebase.setInt(fbdo, "test/raindrop2", raindropValue2)) {
      Serial.println("Raindrop2 - PASSED");
      Serial.println("PATH: " + fbdo.dataPath());
      Serial.println("TYPE: " + fbdo.dataType());
    } else {
      Serial.println("Raindrop2 - FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }

    
    // Write distance to the database path test/distance
    if (Firebase.setFloat(fbdo, "test/distance", distance)) {
      Serial.println("Distance - PASSED");
      Serial.println("PATH: " + fbdo.dataPath());
      Serial.println("TYPE: " + fbdo.dataType());
    } else {
      Serial.println("Distance - FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }
    
    // Write motor states to the database path test/motor1 and test/motor2
    if (Firebase.setBool(fbdo, "test/motor1", motor1State) && Firebase.setBool(fbdo, "test/motor2", motor2State)) {
      Serial.println("Motor1 and Motor2 State - PASSED");
      Serial.println("PATH: " + fbdo.dataPath());
      Serial.println("TYPE: " + fbdo.dataType());
    } else {
      Serial.println("Motor1 and Motor2 State - FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }

    Serial.println("-----------------------------------------");
  }
}
