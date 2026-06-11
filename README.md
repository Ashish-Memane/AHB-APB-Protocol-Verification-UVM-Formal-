# AMBA AHB-to-APB Bridge Verification IP (UVM)

## Overview

This repository contains a fully parameterized, enterprise-grade Verification IP (VIP) for an **AMBA AHB-to-APB Bridge**, developed from scratch using the **SystemVerilog Universal Verification Methodology (UVM)**. 

The verification environment is architected to ensure highly reliable data transfer between a high-performance, pipelined AHB master bus and a low-power, single-cycle APB peripheral bus. It features advanced verification techniques, including mathematical burst unrolling, dynamic array memory allocation, and constrained-random protocol generation to validate protocol compliance, timing behavior, and functional correctness.

---

## Key Architectural Features

* **v2.0 Burst Capabilities:** Native support for `SINGLE`, `INCR4`, and `WRAP` burst types with dynamic transaction array sizing.
* **Mathematical Burst Unrolling:** Custom UVM Scoreboard logic that fetches complete AHB burst arrays, mathematically calculates expected APB 1KB boundary offsets, and unrolls them to compare against individual sequential APB transfers.
* **Pipelined Protocol Translation:** AHB Driver equipped with mathematical address-calculators to correctly handle AMBA pipelined Address and Data phases (`Htrans` / `Hready` tracking).
* **Reactive Slave Responders:** APB Agent is architected as a fully reactive slave, utilizing a continuously looping dummy sequence to provide randomized Read responses on demand.
* **Configuration-Driven Topology:** Highly scalable environment utilizing `uvm_config_db` and `env_config` objects to dynamically switch agents between `UVM_ACTIVE` and `UVM_PASSIVE` modes.
* **Functional Coverage :** Integrated covergroups tracking AHB burst types, read/write cross-coverage, peripheral slave selection.

---

## Verification Components

### UVM Testbench Architecture
* **`ahb_agent` (Active Master):** Drives pipelined AHB stimulus and monitors bus states.
* **`apb_agent` (Reactive Slave):** Responds to APB Setup/Access phases and drives dummy read data.
* **`ahb_apb_scoreboard`:** Performs TLM FIFO extraction and deep-packet data comparison.
* **`ahb_apb_env`:** Top-level structural container routing Analysis Ports.
* **Sequence Libraries:** Consolidated libraries for `SINGLE` writes, `INCR4` bursts, and APB dummy responses.

### Verification Techniques utilized
* Constrained-Random Verification (CRV)
* Directed Corner-Case Testing (e.g., Mid-burst active-low reset recovery)
* Coverage-Driven Verification (CDV)
* Assertion-Based Verification (ABV)
* Transaction-Level Modeling (TLM)

---

## Protocols Verified

### AHB (Advanced High-performance Bus)
* Pipelined Address phase and Data phase handling.
* Burst transfer array validation and 1KB boundary constraint checking.
* Read/Write transaction verification.
* `HREADY`, `HTRANS`, and `HBURST` protocol compliance.

### APB (Advanced Peripheral Bus)
* Setup and Access phase verification (`PSEL` and `PENABLE` timing).
* Reactive Slave dummy data injection (`PRDATA`).
* Slave selection decoding via `PADDR`.

---

## Tools & Technologies

* **Language:** SystemVerilog (IEEE 1800-2012)
* **Methodology:** UVM 1.2
* **Simulators Supported:** QuestaSim / VCS / Xcelium

---

## Repository Structure

```text
├── rtl/                # AHB-to-APB Bridge Design Files
├── interface/          # Protocol Interfaces (ahb_if.sv, apb_if.sv)
├── ahb_agent/          # AHB Master Components (Driver, Monitor, Sequencer, XTN)
├── apb_agent/          # APB Slave Components (Driver, Monitor, Sequencer, XTN)
├── tb/                # Scoreboard, Env Configuration, Env Top and Static Top Module (top.sv)
├── test/               # Sequence Libraries, Test Library, and tb_pkg
├── sim/                # Makefile and Simulation execution scripts
└── README.md

## Author

**Ashish Memane**
Verification Engineer | SystemVerilog | UVM | Formal Verification | VLSI Design & Verification
