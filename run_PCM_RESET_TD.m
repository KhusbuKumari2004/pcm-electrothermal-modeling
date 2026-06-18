function run_PCM_RESET_TD()

clc; clear; close all;

import com.comsol.model.*
import com.comsol.model.util.*

%% SETTINGS
V_list = 0:0.2:4.2;
T_melt = 900;

domain_id = [3 5 7 9 11 13];

t_sb = 6 * 5e-9;
r_gst = 50e-9;
A = pi*r_gst^2;

rho_am = 1/500;
rho_cr = 1/5e3;   % 🔴 match your COMSOL EC_PCM

%% STORAGE
Tmax = zeros(size(V_list));
z_cap = zeros(size(V_list));
R_total = zeros(size(V_list));

%% LOOP
for i = 1:length(V_list)

    V = V_list(i);
    fprintf('Running TD V = %.2f V\n', V);

    model = PCM_AMORPHOUS_TD();

    % 🔥 Match COMSOL variables exactly
    model.param.set('V_amp', sprintf('%g[V]',V));
    model.param.set('t_w','100e-9[s]');   % match your table

    model.study('std1').run;

Tmax(i) = max(mphmax(model,'T','volume','selection',domain_id));
    %% Phase growth
    if Tmax(i) <= T_melt
        z_cap(i) = 0;
    else
        deltaT = Tmax(i) - T_melt;
        z_cap(i) = t_sb * (1 - exp(-deltaT/150));
        z_cap(i) = min(z_cap(i), t_sb);
    end

    %% Resistance
    z_am = z_cap(i);
    z_cr = t_sb - z_am;

    R_am = rho_am * (z_am/A);
    R_cr = rho_cr * (z_cr/A);

    R_total(i) = R_am + R_cr;

end

%% PLOTS
figure;
plot(V_list, Tmax,'LineWidth',2);
xlabel('Voltage (V)');
ylabel('T_{max} (K)');
title('Temperature vs Voltage (Matched Model)');
grid on;

figure;
plot(V_list, z_cap*1e9,'LineWidth',2);
xlabel('Voltage (V)');
ylabel('Amorphous Thickness (nm)');
title('Cap Growth');
grid on;

figure;
plot(V_list, R_total,'LineWidth',2);
xlabel('Voltage (V)');
ylabel('Resistance (\Omega)');
title('Resistance vs Voltage');
grid on;

disp(table(V_list', Tmax', z_cap'*1e9, R_total', ...
'VariableNames',{'Voltage_V','Tmax_K','Cap_nm','R_ohm'}));

end