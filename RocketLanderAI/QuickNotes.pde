/**

width = 3.7 m
height = 48.2
max angle = ~10 degrees or pi/20 radians
max anglular speed = 5 degrees/s
max hor vel = 5.4 m/s
max ver vel = 5 m/s (guess)
mass 26,000 kg (scott manley)
moment of inertia = 5*10^6 kg*m^2 about CoM
moment of inertia = 1*10^8 kg*m^2 about leg
center of gravity = 14 m above bottom of engines (approximate)
mass flow rate = 5 - 10 kg/s (guess)
F_thrusters = gravity * ISP * mass flow rate = 9.8 * 60 * 10 = 5880 N
F_merlin = 845 kN

overturn stability criteria = m * v_x^2 / 2 + I * ω^2 / 2 < m * g * delta_h
                            = 0.5 * mass * vel.x^2 + 0.5 * I_leg * omega^2 < mass * 9.8 * 1.5

*/
