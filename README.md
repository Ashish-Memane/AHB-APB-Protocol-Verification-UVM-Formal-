
# AHB-APB Protocol Verification using UVM + Formal Verification

## Overview

This project focuses on the verification of an **AHB to APB Bridge** using **SystemVerilog UVM methodology** along with **Formal Verification techniques**. The verification environment ensures reliable data transfer between the high-performance **AMBA AHB bus** and low-power **APB bus** while validating protocol compliance, timing behavior, and functional correctness.

The project implements a reusable and scalable **UVM-based testbench architecture** integrated with assertions, constrained-random testing, functional coverage, and formal property verification.

---

## Features

* UVM-based reusable verification environment
* Verification of AHB to APB Bridge protocol functionality
* Constrained Random Verification (CRV)
* Functional Coverage collection and analysis
* SystemVerilog Assertions (SVA)
* Formal Verification for protocol/property checking
* Scoreboard and reference model implementation
* Transaction-Level Modeling (TLM) communication
* Error scenario and corner case validation
* Protocol compliance checking for AHB and APB interfaces

---

## Verification Components

### UVM Testbench Architecture

* Sequencer
* Driver
* Monitor
* Agent
* Scoreboard
* Environment
* Testcases

### Verification Techniques

* Directed Testing
* Randomized Test Generation
* Assertion-Based Verification
* Coverage-Driven Verification
* Formal Property Checking

---

## Protocols Verified

### AHB (Advanced High-performance Bus)

* Address phase and data phase handling
* Burst transfer validation
* Read/Write transaction verification
* HREADY and response checking

### APB (Advanced Peripheral Bus)

* Setup and Enable phase verification
* PREADY and PSLVERR handling
* Low-power peripheral communication validation

---

## Tools & Technologies

* SystemVerilog
* UVM (Universal Verification Methodology)
* Formal Verification
* Assertions (SVA)
* QuestaSim / VCS / Xcelium (Simulator Support)

---

## Objectives

* Verify functional correctness of the AHB-APB bridge
* Ensure protocol compliance and timing correctness
* Improve verification reusability and scalability
* Achieve high functional and code coverage
* Detect corner-case and protocol violation scenarios

---

## Repository Structure

```text
├── rtl/               # RTL Design Files
├── tb/                # UVM Testbench
├── sequences/         # UVM Sequences
├── tests/             # Testcases
├── assertions/        # SVA Properties
├── formal/            # Formal Verification Files
├── coverage/          # Coverage Reports
├── sim/               # Simulation Scripts
└── README.md
```

---

## Expected Outcomes

* Robust verification of bridge functionality
* Coverage-driven validation of all major scenarios
* Detection of protocol violations using assertions and formal methods
* Reusable industrial-style UVM verification framework

---

## Author

**Ashish Memane**
Verification Engineer | SystemVerilog | UVM | Formal Verification | VLSI Design & Verification
