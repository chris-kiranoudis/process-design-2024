%clc;
%clear;

global Aspen;
global iteratorAspen;
global weights;

Aspen= actxserver('Apwn.Document.37.0');
[stat,mess]=fileattrib;
Aspen.invoke('InitFromArchive2',['C:\Users\chris\Desktop\ProsDesII\acroleineDMB.bkp']);
Aspen.Visible = 1;
Aspen.SuppressDialogs = 1;

x = [0.001, 0.001, 0, 0.25];
weights = [1, 1, 1, 100];
fun = @systemOfEquations;
iteratorAspen = 1;
x = lsqnonlin(fun, x, zeros(size(x)));
f = systemOfEquations(x);
x = x.*weights;
fprintf('Variables: %f %f %f %f\n', x(1), x(2), x(3), x(4));
fprintf('Equations: %f %f %f %f\n', f(1), f(2), f(3), f(4));

Aspen.Close;
Aspen.Quit;

function f = systemOfEquations(x)
    global Aspen;
    global iteratorAspen;
    global weights;

    fprintf('%d %f %f %f %f\n', iteratorAspen, x(1), x(2), x(3), x(4));
    iteratorAspen = iteratorAspen + 1;

	Aspen.Tree.FindNode("\Data\Streams\IN\Input\FLOW\MIXED\2:3-D-01").Value = x(1) * weights(1);
	Aspen.Tree.FindNode("\Data\Streams\IN\Input\FLOW\MIXED\ACROL-01").Value = x(2) * weights(2);
	Aspen.Tree.FindNode("\Data\Streams\IN\Input\FLOW\MIXED\ISOPH-01").Value = x(3) * weights(3);
	Aspen.Tree.FindNode("\Data\Streams\IN\Input\TEMP\MIXED").Value = x(4) * weights(4);
	
	Aspen.Reinit;
	Aspen.Engine.Run2(1);
    while Aspen.Engine.IsRunning == 1
        pause(0.5);
    end
	
	f(1) = Aspen.Tree.FindNode("\Data\Streams\OUT\Output\MOLEFLOW\MIXED\2:3-D-01").Value - x(1) * weights(1);
	f(2) = Aspen.Tree.FindNode("\Data\Streams\OUT\Output\MOLEFLOW\MIXED\ACROL-01").Value - x(2) * weights(2);
	f(3) = Aspen.Tree.FindNode("\Data\Streams\OUT\Output\MOLEFLOW\MIXED\ISOPH-01").Value - x(3) * weights(3);
	f(4) = Aspen.Tree.FindNode("\Data\Streams\OUT\Output\TEMP_OUT\MIXED").Value - x(4) * weights(4);
end
