import os
import win32com.client as win32
import numpy as np
import time
from scipy.optimize import fsolve, least_squares, fmin

def objectiveFunction(inputs):
  f = 1000.0
  if np.any(inputs < 0.0):
    print('negative values')
    return f
  x = list(inputs)
  print(x)
  
  if x[0] < 1:
    Aspen.Tree.FindNode("\Data\Blocks\SPLT\Input\FRAC\RCL").Value = x[0] * weights[0]
    Aspen.Tree.FindNode("\Data\Blocks\DIST1\Input\BASIS_D").Value = x[1] * weights[1]
  
    Aspen.Reinit
    Aspen.Engine.Run2(1)
    while Aspen.Engine.IsRunning == 1:
      time.sleep(0.5)
  
    out1 = Aspen.Tree.FindNode("\Data\Streams\TOP1\Output\MOLEFLOW\MIXED\FUR").Value
    out2 = Aspen.Tree.FindNode("\Data\Streams\PRGE\Output\MOLEFLOW\MIXED\FUR").Value
    
    if out2 > 0.00001:
      #f = 100 * out2 / out1
      f = out2 - out1
    print(f)
      
  return f

Aspen = win32.Dispatch('Apwn.Document')
Aspen.InitFromArchive2(os.path.abspath('C:/Users/chris/Desktop/ProsDesII/TF_SS.bkp'))
Aspen.Visible = 1
Aspen.SuppressDialogs = 1

#x = [0.8, 0.3]
x = [0.5, 0.2]
weights = [1, 1000]
#f = objectiveFunction(x)
f = fmin(objectiveFunction, x)
print(f)

Aspen.Quit()
