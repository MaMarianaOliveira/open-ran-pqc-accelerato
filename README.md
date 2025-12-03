# FPGA-Based Post-Quantum Cryptography Accelerator for Open RAN

![Status](https://img.shields.io/badge/Status-In%20Development-yellow)
![Tech](https://img.shields.io/badge/FPGA-Intel%20Cyclone%2010-blue)
![Software](https://img.shields.io/badge/C++-Arduino-green)

## 🎯 O Projeto
Prova de conceito (PoC) de aceleração de hardware (offloading) para criptografia pós-quântica (PQC) em cenários de 5G Open RAN. O objetivo é mitigar a latência de algoritmos como **SHA-3 (Keccak)** utilizando arquitetura híbrida.

## ⚙️ Arquitetura
**Hardware:** Arduino MKR Vidor 4000 (ARM Cortex-M0 + FPGA Cyclone 10).

1. **vDU Simulada (Software/C++):** Gera tráfego de dados simulado.
2. **Interface (JTAG/Bridge):** Transfere blocos de dados para o hardware.
3. **Acelerador (Hardware/Verilog):** Núcleo criptográfico rodando em paralelo na FPGA.

## 📂 Estrutura do Repositório
* `/hardware`: Código Verilog do acelerador (Quartus Prime).
* `/firmware`: Código C++ da vDU (Arduino IDE).
* `/results`: Logs de benchmark e gráficos de performance.

## 📚 Referências
Baseado nas especificações da **O-RAN Alliance** e **NIST FIPS 203**.
