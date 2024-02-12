%clc;
%clear;

global Aspen;
global iteratorAspen;
global weights;

Aspen= actxserver('Apwn.Document.37.0');
[stat,mess]=fileattrib;
Aspen.invoke('InitFromArchive2',['C:\Users\chris\Desktop\ProsDesII\CO2EthanolFlash.bkp']);
Aspen.Visible = 1;
Aspen.SuppressDialogs = 1;

x = [0.1];
weights = [10];
fun = @objectiveFunction;
iteratorAspen = 1;
x = fminsearch(fun, x);
fprintf('%f\n', objectiveFunction(x));
x = x.*weights;
fprintf('%f\n', x(1));

Aspen.Close;
Aspen.Quit;

function f = objectiveFunction(x)
    global Aspen;
    global iteratorAspen;
    global weights;

    fprintf('%d %f\n', iteratorAspen, x(1));
    iteratorAspen = iteratorAspen + 1;

	Aspen.Tree.FindNode("\Data\Blocks\B1\Input\PRES").Value = x(1) * weights(1);
	
	Aspen.Reinit;
	Aspen.Engine.Run2(1);
    while Aspen.Engine.IsRunning == 1
        pause(0.5);
    end
	
    out1 = Aspen.Tree.FindNode("\Data\Streams\S2\Output\MASSFLOW\MIXED\CO2").Value;
    out2 = Aspen.Tree.FindNode("\Data\Streams\S3\Output\MASSFLOW\MIXED\ETHAN-01").Value;

	f = -(5 * out1 + 30.0 * out2);
end
