import os
import win32com.client as win32
import numpy as np
import time
from scipy.optimize import fsolve
from scipy.optimize import least_squares

def systemOfEquations(inputs):
  if np.any(inputs < 0.0):
    print('negative values')
    return np.ones(len(inputs)) * 1000.0
  x = list(inputs)
  print(x)
  
  Aspen.Tree.FindNode("/Data/Streams/IN/Input/FLOW/MIXED/ACETO-01").Value = x[0] * weights[0]
  Aspen.Tree.FindNode("/Data/Streams/IN/Input/FLOW/MIXED/N-HEX-01").Value = x[1] * weights[1]
  Aspen.Tree.FindNode("/Data/Streams/IN/Input/FLOW/MIXED/ISOBU-01").Value = x[2] * weights[2]
  Aspen.Tree.FindNode("/Data/Streams/IN/Input/TEMP/MIXED").Value = x[3] * weights[3]
  
  Aspen.Reinit
  Aspen.Engine.Run2(1)
  while Aspen.Engine.IsRunning == 1:
    time.sleep(0.5)
  
  f = np.zeros(len(x))
  f[0] = Aspen.Tree.FindNode("/Data/Streams/OUT/Output/MOLEFLOW/MIXED/ACETO-01").Value - x[0] * weights[0]
  f[1] = Aspen.Tree.FindNode("/Data/Streams/OUT/Output/MOLEFLOW/MIXED/N-HEX-01").Value - x[1] * weights[1]
  f[2] = Aspen.Tree.FindNode("/Data/Streams/OUT/Output/MOLEFLOW/MIXED/ISOBU-01").Value - x[2] * weights[2]
  f[3] = Aspen.Tree.FindNode("/Data/Streams/OUT/Output/TEMP_OUT/MIXED").Value - x[3] * weights[3]
  
  return f

Aspen = win32.Dispatch('Apwn.Document')
Aspen.InitFromArchive2(os.path.abspath('C:/Users/chris/Desktop/ProsDesII/acetoneHexaneAzeotropicDistillation.bkp'))
Aspen.Visible = 1
Aspen.SuppressDialogs = 1

x = [0.1, 0.1, 0.1, 0.25]
weights = [10, 1, 1000, 100]
#f = systemOfEquations(x)
#f = fsolve(systemOfEquations, x, full_output = 1)
f = least_squares(systemOfEquations, x, bounds = (0, 100))
print(f)

Aspen.Quit()
