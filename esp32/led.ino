#include <WiFi.h>

#include <WebServer.h>

const char *ssid = "Malcolm";
const char *password = "Komodo3000";

const byte DNS_PORT = 53;
const int red_pin = 19;
const int green_pin = 23;
const int blue_pin = 22;

// Setting PWM frequency, channels and bit resolution
const int frequency = 1000;
const int redChannel = 0;
const int greenChannel = 1;
const int blueChannel = 2;
const int resolution = 10;

WebServer webServer(80);

String webpage = "<!DOCTYPE html><html><head><title>RGB control</title><meta name=\"mobile-web-app-capable\" content=\"yes\" /><meta name=\"viewport\" content=\"width=device-width\" /></head><body style=\"margin: 0px; padding: 0px\"><canvas id=\"colorspace\"></canvas><input type=\"color\" /><script type=\"text/javascript\">var colorPicker = document.querySelector('input[type=\"color\"]');colorPicker.addEventListener(\"input\", function () {var color = colorPicker.value;var r = parseInt(color.substring(1, 3), 16);var g = parseInt(color.substring(3, 5), 16);var b = parseInt(color.substring(5, 7), 16);var params = [\"r=\" + r,\"g=\" + g,\"b=\" + b,].join(\"&\");var req = new XMLHttpRequest();req.open(\"POST\", \"?\" + params, true);req.send();});</script></body></html>";

void handleRoot() {
  String red_pin = webServer.arg(0);
  String green_pin = webServer.arg(1);
  String blue_pin = webServer.arg(2);

  if ((red_pin != "") && (green_pin != "") && (blue_pin != "")) {
    analogWrite(19, 1024 - round((red_pin.toInt() * 1024) / 255));
    analogWrite(22, 1024 - round((green_pin.toInt() * 1024) / 255));
    analogWrite(23, 1024 - round((blue_pin.toInt() * 1024) / 255));
  }
  Serial.print("Red: ");
  Serial.println(red_pin.toInt());
  Serial.print("Green: ");
  Serial.println(green_pin.toInt());
  Serial.print("Blue: ");
  Serial.println(blue_pin.toInt());
  Serial.println();

  webServer.send(200, "text/html", webpage);
}

void setup() {
  pinMode(19, OUTPUT);
  pinMode(22, OUTPUT);
  pinMode(23, OUTPUT);

  delay(1000);
  Serial.begin(115200);
  Serial.println();

  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  Serial.print("Connecting to WiFi ..");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print('.');
    delay(1000);
  }
  Serial.println(WiFi.localIP());

  webServer.on("/", handleRoot);
  webServer.begin();
}

void loop() {
  webServer.handleClient();
}