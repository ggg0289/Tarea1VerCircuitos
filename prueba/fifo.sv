------------
bit dyn[] data_in,
bit dyn[] data_out,
  q[$]={};
  q.push_front(data_in);
  data_out = q.pop_back;
--------------
bit[bits-1:0] data_out; #señal de salida
bit[bits-1:0] queue[$:ancho]; #cola con ancho varible y profundidad variable
queue.push_front(data_in); #inserta el dato mediante push
data_out= queue.pop_back;  #asigna el valor al data out cuando hay un pop_back
