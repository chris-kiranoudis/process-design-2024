%clc;
%clear;

global Aspen;
global iteratorAspen;
global weights;

Aspen= actxserver('Apwn.Document.37.0');
[stat,mess]=fileattrib;
Aspen.invoke('InitFromArchive2',['C:\Users\chris\Desktop\ProsDesII\TF_SS.bkp']);
Aspen.Visible = 1;
Aspen.SuppressDialogs = 1;

%x = [0.8, 0.3];
x = [0.5, 0.2];
weights = [1, 1000];
fun = @objectiveFunction;
iteratorAspen = 1;
x = fminsearch(fun, x);
fprintf('%f\n', objectiveFunction(x));
x = x.*weights;
fprintf('%f %f\n', x(1), x(2));

Aspen.Close;
Aspen.Quit;

function f = objectiveFunction(x)
    global Aspen;
    global iteratorAspen;
    global weights;

    fprintf('%d %f %f ', iteratorAspen, x(1), x(2));
    iteratorAspen = iteratorAspen + 1;

    f = 1000;
    if x(1) < 1
	    Aspen.Tree.FindNode("\Data\Blocks\SPLT\Input\FRAC\RCL").Value = x(1) * weights(1);
	    Aspen.Tree.FindNode("\Data\Blocks\DIST1\Input\BASIS_D").Value = x(2) * weights(2);
	    
	    Aspen.Reinit;
	    Aspen.Engine.Run2(1);
        while Aspen.Engine.IsRunning == 1
            pause(0.5);
        end
	    
        out1 = Aspen.Tree.FindNode("\Data\Streams\TOP1\Output\MOLEFLOW\MIXED\FUR").Value;
        out2 = Aspen.Tree.FindNode("\Data\Streams\PRGE\Output\MOLEFLOW\MIXED\FUR").Value;
    
        if out2 > 0.00001
	      %f = 100 * out2 / out1;
	      f = out2 - out1;
        end
        fprintf('%f %f %f\n', out1, out2, f);
    end
end
