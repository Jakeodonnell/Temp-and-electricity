
// Copyright 2015 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

// FirebaseDemo_ESP8266 is a sample that demo the different functions
// of the FirebaseArduino API.

#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>
#include <OneWire.h>
#include <DallasTemperature.h>
#include <NTPClient.h>
#include <EEPROM.h>
#include <NTPtimeESP.h>


#define FIREBASE_HOST ""
#define FIREBASE_AUTH ""
#define WIFI_SSID ""
#define WIFI_PASSWORD ""
// Set these to run example.
// Data wire is plugged into port 2 on the Arduino
#define ONE_WIRE_BUS 5


// Choose server pool as required
// Setup a oneWire instance to communicate with any OneWire devices (not just Maxim/Dallas temperature ICs)
OneWire oneWire(ONE_WIRE_BUS);

// Pass our oneWire reference to Dallas Temperature.
DallasTemperature sensors(&oneWire);

// arrays to hold device address
DeviceAddress insideThermometer;
int mostRecentTemp;
int timer;

NTPtime NTPch("ch.pool.ntp.org");  
strDateTime dateTime;


void setup() {
  Serial.begin(9600);
  //DallasTemp
  Serial.print("Locating devices...");
  sensors.begin();
  Serial.print("Found ");
  Serial.print(sensors.getDeviceCount(), DEC);
  Serial.println(" devices.");

  // report parasite power requirements
  if (sensors.isParasitePowerMode()) Serial.println("ON");
  else Serial.println("OFF");
  if (!sensors.getAddress(insideThermometer, 0)) {
    sensors.setResolution(insideThermometer, 9);
  }
    uint addr = 0;
    uint addr1 = 1;
  EEPROM.begin(512);
   float check;
   float check1;
  EEPROM.get(addr,check); 
  EEPROM.get(addr1,check1); 
  Serial.print("CHECK FOR WAKE UP" + String(check) + "\n");
  /*if(check == getTemp()){ 
     ESP.deepSleep(10e6);
  } else {*/
    float val = getTemp();
    int val1 = timer;
    EEPROM.put(addr,val);
    EEPROM.put(addr1,val1);
    timer =  EEPROM.get(addr1,check1); 
    EEPROM.commit();  
  //}

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("connecting");
    while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.print("connected: ");
  Serial.println(WiFi.localIP());

  //firebase
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
}

int printTemperature(DeviceAddress deviceAddress)
{
  float tempC = sensors.getTempC(deviceAddress);
  Serial.print("Temp C: ");
  Serial.println(tempC);
  int TempC = sensors.getTempC(deviceAddress);
  return TempC;
}

float getTemp() {
  //SensorData
  sensors.requestTemperatures();
  float tempToSend =   printTemperature(insideThermometer);
  return tempToSend;
}


void loop() {

  // check dateTime.valid before using the returned time
  // Use "setSendInterval" or "setRecvTimeout" if required
 

  // check dateTime.valid before using the returned time
  // Use "setSendInterval" or "setRecvTimeout" if required
 /* 
    dateTime = NTPch.getNTPtime(1.0, 1);
    if(dateTime.valid){
    NTPch.printDateTime(dateTime);

    byte actualHour = dateTime.hour;
    byte actualMinute = dateTime.minute;
    byte actualsecond = dateTime.second;
    int actualyear = dateTime.year;
    byte actualMonth = dateTime.month;
    byte actualday =dateTime.day;
    byte actualdayofWeek = dateTime.dayofWeek;
  }
  */
  //Firebase upplload
    timer = (timer + 1) % 2000;
    Firebase.setInt("logs", getTemp());
    Firebase.setInt("timeEsp", timer);

  if (Firebase.failed())
  {
    Serial.println(Firebase.error());
  }
  mostRecentTemp = getTemp();
  delay(200);
  //ESP.deepSleep(10e6);
}
