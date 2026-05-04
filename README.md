# Cores_VeeR_EH1 — RTL-to-GDSII ASIC Implementation (Reference Project)

This repository documents a complete ASIC implementation flow for VeeR EH1, from RTL synthesis to final routed outputs.

> **Reference-only scope:** This project is shared for learning/documentation. Proprietary technology files (PDK/libs/LEF/script collateral) must not be uploaded publicly.

---

## 1) Environment & Technologies

- **Top design:** `veer_wrapper`
- **RTL language:** SystemVerilog
- **Technology node:** IHP SG13G2 (130nm)
- **Supply:** 1.2V core, 3.3V I/O
- **Target clocks:**
  - `clk_sys`: 10 ns (100 MHz)
  - `clk_jtg` (`jtag_tck`): 20 ns (50 MHz)
- **Clock uncertainty:** 0.1 ns (setup/hold)
- **Synthesis tool:** Cadence Genus 22.16
- **P&R tool:** Cadence Innovus 22.16

This README is self-contained for GitHub publishing and includes all key implementation details directly.

---

## 2) Detailed Project Specifications

### 2.1 Design Composition

- **Total instances:** 158,570
- **Standard cells:** 158,542
- **Hard macros:** 28
- **Total signal nets:** 136,219 (+2 special nets)

Cell mix highlights (from Innovus summary):

- Flip-flops (`dfrbp` + `sdfbbp`): ~14,081
- Buffers (all strengths): ~20,316
- Inverters (all strengths): ~12,479
- MUX2: ~4,589
- Tie cells: 1,136
- Well tap + endcap: 41,143

### 2.2 Macro Breakdown

| Macro | Instances | Area (um²) | Core Share |
|---|---:|---:|---:|
| `RM_IHPSG13_1P_2048x64_c2_bm_bist` | 8 | 3,933,068.928 | 34.028% |
| `RM_IHPSG13_1P_256x48_c2_bm_bist` | 16 | 1,133,598.310 | 9.808% |
| `RM_IHPSG13_1P_64x64_c2_bm_bist` | 4 | 201,956.531 | 1.747% |

**Total macro area:** ~5,268,623 um² (~45.58% of core area)

---

## 3) Design Constraints & Target PPA

### 3.1 SDC Constraint Model

Implemented in [`constraints.sdc`](myproject/Cores_VeeR_EH1/sdc/constraints.sdc:1):

- Units: ns / pF / V / mA
- Output load model: `set_load 0.01 [all_outputs]`
- Input driving cell model: `sg13g2_buf_16`
- Clock definitions:
  - `create_clock -name clk_sys -period 10.0 [get_ports clk]`
  - `create_clock -name clk_jtg -period 20.0 [get_ports jtag_tck]`
- Asynchronous grouping:
  - `set_clock_groups -asynchronous ... -group {clk_sys} -group {clk_jtg}`
- Uncertainty/transition:
  - `set_clock_uncertainty 0.1 -setup/-hold [all_clocks]`
  - `set_clock_transition 0.20 [all_clocks]`
- Reset/JTAG/system IO delays explicitly modeled with min/max constraints.

### 3.2 Target PPA Intent

- Close setup timing at 100 MHz system target
- Maintain hold-safe behavior across clocked paths
- Keep routability clean (no final DRC)
- Manage macro-heavy floorplan congestion while preserving utilization

---

## 4) The Process & Challenges

### 4.1 Flow Stages

1. **Synthesis (Genus):** RTL read/elaboration + mapping/optimization
   - Netlist handoff is used as input for physical implementation.

2. **Floorplan / Initialization (`00_init_design`):** die/core setup, power planning context, macro-aware layout initialization.

   ![01_floorplan](images/01_floorplan.png)

   - The floorplan shows macro-dominant organization (SRAM-heavy), which directly influences congestion and timing topology.

3. **Placement (`02_place_opt`):** standard-cell placement and early optimization.

   ![02_placement_density](images/02_placement_density.png)

   - Density view confirms concentrated logic channels between macros and identifies hotspot regions.

4. **Power Grid / Early Route Visibility:** power distribution and routing accessibility across the core.

   ![03_power_grid](images/03_power_grid.png)

   - This view helps validate macro/channel routing accessibility before late-stage optimization.

5. **Clock Tree Synthesis (`03_cts`, `04_cts_opt`):** clock distribution construction and balancing.

   ![04_clock_tree](images/04_clock_tree.png)

   - Clock structure spans macro-separated regions and supports system/JTAG timing domains.

6. **Detailed Routing / Post-route (`05_route`, `06_route_opt`):** full signal routing and cleanup.

   ![05_routing_all_layers](images/05_routing_all_layers.png)

   - All routed layers are visible in the final implementation snapshot.

7. **Routing Quality Deep-Dive:** inspect local detail and via-rich areas.

   ![06_routing_zoom](images/06_routing_zoom.png)

   - Zoomed view demonstrates dense signal/via usage in critical regions.

8. **Congestion and Critical Region Review:** hotspot and path context analysis.

   ![07_congestion_map](images/07_congestion_map.png)

   - Congestion concentration near macro boundaries is consistent with macro placement topology.

9. **Timing Summary / Signoff Snapshot:** review setup/hold and DRV status.

   ![08_timing_path](images/08_timing_path.png)

   ![10_timing_summary_report](images/10_timing_summary_report.png)

   - Final snapshot indicates setup closure and clean DRC context in the provided reports.

10. **Final export:** DEF/LEF/netlist + summary artifacts for documentation/reference.

### 4.2 Key Challenges

- Congestion pressure near SRAM macro boundaries
- Interpreting near-zero hold behavior in asynchronous/multi-clock context
- Large output footprint (database/netlist/report scale) for publish-safe curation

---

## 5) Quantitative Results

### 5.1 Floorplan & Initialization

- Die area: ~3721.9 x 2017.1 um
- Core area: ~3252.4 x 1895.2 um (estimated)
- Core utilization: **65.18%**
- Alloc area: 3,160,567 sites (5,734,533 um²)
- Std-cell area: 909,563 sites (1,650,311 um²)
- Hard macros: 28
- Pin density: 0.06255 (398,436 pins / 6,370,314 area)
- Average pins/net: 3.191
- Total nets: 136,219 signal + 2 special

### 5.2 Placement (Pre-CTS)

Timing summary:

- Setup WNS: **+0.001 ns**
- Setup TNS: **0.000 ns**
- Hold WNS: **-0.000 ns**
- Hold TNS: **-0.000 ns**
- Hold violating paths: 1
- Setup violating paths: 0

Congestion:

- Normalized max hotspot: **0.52**
- Normalized total hotspot: **2.08**
- Top hotspot #1 bbox: (1332.60, 1635.06) – (1453.56, 1756.02)

Density/placement:

- Placed instances: 143,662
- Pure std-cell density: 0.287785
- Effective utilization: 65.178116%

### 5.3 CTS / Post-CTS

- Clock domains: 2 (`clk`, `jtag_tck`)
- Setup WNS/TNS: +0.001 / 0.000
- Hold WNS/TNS: -0.000 / -0.000
- Hold violating paths: 1 (in2reg)

Path groups:

- reg2reg: 33,842
- in2reg: 15,593
- reg2out: 616
- mem2reg: 1,390
- reg2mem: 1,236

Post-CTS DRVs:

- max_cap: 940 nets (worst -0.138)
- max_tran: 4 nets (worst -0.015)
- max_fanout: 3 nets (worst -2)
- max_length: 0

Reported density: 30.711%

### 5.4 Routing / Final

- Final DRC violations: **0**
  - Shorts: 0
  - Spacing: 0
- Routing layers used: 7
  - Metal1–Metal5, TopMetal1, TopMetal2

Final timing snapshot:

- Setup WNS/TNS: +0.001 / 0.000 (0 setup violating paths)
- Hold WNS/TNS: -0.000 / -0.000 (1 hold violating path, in2reg context)

### 5.5 Final Signoff Summary

- Final setup WNS: +0.001 ✅
- Final setup TNS: 0.000 ✅
- Final hold WNS: -0.000 ✅ (marginal single-path context)
- Final hold TNS: -0.000 ✅
- Final DRC: 0 ✅
- Final LVS: not reported in shared snapshot

Final outputs:

- `output/06_postRoute/veer_wrapper.def.gz`
- `output/06_postRoute/veer_wrapper.v`
- `output/06_postRoute/veer_wrapper.lef`

---

## 6) Implementation Highlights

- End-to-end RTL-to-GDSII completion for a realistic macro-heavy SoC block
- Setup timing closure achieved at target 100 MHz system clock
- Clean final DRC snapshot (0 violations)
- Comprehensive flow evidence captured in implementation summaries

---

## 7) What I Learned

- Constraint quality directly drives timing interpretation quality.
- Macro placement topology strongly shapes congestion and route quality.
- Timing signoff must be read together with clock-domain intent and path-group context.
- Public technical documentation requires strict filtering of proprietary collateral.

---

## 8) Future Improvements

- Add sanitized automation to parse reports into a compact PPA dashboard
- Add checkpoint-to-checkpoint trend plots (timing/congestion/DRV)
- Expand CDC/path-exception documentation for multi-clock transparency
- Add a publish-safe reproducibility note for educational reruns

---

## 9) Security & Publishing Policy

This repository is **reference-only**. Do not upload proprietary files, including:

- Foundry/PDK collateral
- `.lib` timing libraries
- Proprietary `.lef`/tech LEF collateral
- Internal licensed scripts/tool setup data
- Full implementation databases containing restricted IP context

Keep only sanitized docs/reports/images that are safe for public reference.

---

## 10) Disclaimer

All results are tied to the captured environment/constraints/tool versions in this snapshot and are shared for educational reference.
