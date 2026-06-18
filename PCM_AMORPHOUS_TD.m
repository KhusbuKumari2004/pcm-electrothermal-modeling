function model = PCM_AMORPHOUS_TD()

import com.comsol.model.*
import com.comsol.model.util.*

model = mphload('TDmultilayer.mph');

% 🔴 Override ONLY what is amorphous
model.param.set('EC_PCM','500[S/m]');   % amorphous drop
model.param.set('TC_PCM','0.46[W/(m*K)]');

% Keep SAME as COMSOL
model.param.set('Cp_PCM','200[J/(kg*K)]');
model.param.set('RHO_PCM','6150[kg/m^3]');

% Sb2Te3 (unchanged)
model.param.set('EC_SB','2e4[S/m]');
model.param.set('TC_SB','1.5[W/(m*K)]');
model.param.set('Cp_SB','200[J/(kg*K)]');
model.param.set('RHO_SB','6500[kg/m^3]');

end