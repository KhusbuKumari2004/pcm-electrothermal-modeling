function model = PCM_CRYSTALLINE_TD()

import com.comsol.model.*
import com.comsol.model.util.*

model = mphload('TDmultilayer.mph');

% Keep EXACT values from COMSOL
model.param.set('EC_PCM','5e3[S/m]');
model.param.set('TC_PCM','1.5[W/(m*K)]'); % your table value

model.param.set('Cp_PCM','200[J/(kg*K)]');
model.param.set('RHO_PCM','6150[kg/m^3]');

% Sb2Te3
model.param.set('EC_SB','2e4[S/m]');
model.param.set('TC_SB','1.5[W/(m*K)]');
model.param.set('Cp_SB','200[J/(kg*K)]');
model.param.set('RHO_SB','6500[kg/m^3]');

end