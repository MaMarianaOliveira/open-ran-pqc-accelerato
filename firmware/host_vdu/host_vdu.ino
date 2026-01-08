/*
 * Project: Open RAN PQC Accelerator
 * Component: vDU Host Simulation (Firmware)
 * Author: Mariana Oliveira
 * Target: Arduino MKR Vidor 4000 (SAMD21 ARM Cortex-M0+)
 */

#include <Arduino.h>

// --- Configurações ---
const int PACKET_SIZE = 256;  
const int NUM_TESTS = 10;     

uint8_t dataBuffer[PACKET_SIZE];

// Função Dummy (Simula a carga de software)
void dummySoftHash(uint8_t *input, int len) {
  volatile uint32_t hash = 0; 
  for (int i = 0; i < len; i++) {
    hash = (hash << 5) + hash + input[i];
    hash ^= 0x5A5A5A5A; 
  }
}

void setup() {
  Serial.begin(9600);
  while (!Serial); 

  Serial.println("=== Open RAN PQC Accelerator Benchmark ===");
  Serial.println("Initializing vDU Host Simulation...");
  
  // Preenche buffer
  for(int i=0; i<PACKET_SIZE; i++) {
    dataBuffer[i] = (uint8_t)random(0, 255);
  }
  
  Serial.println("-> Sistema Pronto (Modo Software Only).");
}

void loop() {
  Serial.println("\n[TEST] Rodando Benchmark de Software...");
  
  long totalTime = 0;

  for(int i=0; i<NUM_TESTS; i++) {
    unsigned long start = micros();
    dummySoftHash(dataBuffer, PACKET_SIZE);
    unsigned long end = micros();
    
    unsigned long duration = end - start;
    totalTime += duration;
    
    Serial.print("   Run "); Serial.print(i+1);
    Serial.print(": "); Serial.print(duration); Serial.println(" us");
    delay(50);
  }

  float avg = totalTime / (float)NUM_TESTS;
  Serial.println("------------------------------------------");
  Serial.print(">> MEDIA Software: ");
  Serial.print(avg);
  Serial.println(" us");
  Serial.println("------------------------------------------");

  while(1);
}