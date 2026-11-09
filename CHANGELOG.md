# Changelog

## v0.3
- Speed reference ramp (1500 rad/s^2) and acceleration feedforward using the nominal inertia.
- Current limit applied after the feedforward sum.
- Back-EMF feedforward evaluated and not adopted (no metric changed by more than 0.1 %).
- Tests: 10 checks x 4 scenarios. New checks: settling from end of ramp, ramp tracking error,
  time at the voltage limit, steady-state voltage headroom. Load-capability table added to the report.
- Fix: setpoint step moved from t = 0 to t = 10 ms. A Rate Limiter outputs its input unchanged at
  the first time step, so the ramp and feedforward were bypassed. Detected by the ramp-tracking check
  while every v0.2-style check still passed.
- Result: 40/40 PASS. Overshoot <= 2.9 %, peak current 3.0-4.8 A, voltage limit reached only at 450 rad/s (22 ms).

## v0.2
- Cascade control: speed PI (1 kHz) -> current PI (10 kHz) with a 5 A current limit.
- Clamping anti-windup on both loops.
- Four test scenarios: nominal, 450 rad/s step, inertia x1.5, inertia x0.5. Peak-current check added.
- Fix: voltage and current-reference signals from discrete blocks are logged on their own time base;
  plots now use each signal's own time vector.
- Result: 28/28 PASS. Peak current 4.8-4.9 A (v0.1: 15.9 A).

## v0.1
- DC motor model from first principles, continuous PI speed loop with 24 V limit and clamping anti-windup.
- Load torque step at t = 1 s. Six automated checks.
- Result: 6/6 PASS. Overshoot 0 %, settling 0.08 s, load dip 3.0 %, peak current 15.9 A.
