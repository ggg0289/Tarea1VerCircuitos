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

------------
modulo
------------


module fifo #( parameter bits = 1,
parameter pckg_sz = 32, parameter depth= 32) //la profundidad de debe cambiar a random
(
output reg pndng,
input push,
input pop,
output reg [pckg_sz-1:0] D_pop,
input [pckg_sz-1:0] D_push
    );


bit[pckg_sz-1:0] queue[$:depth];
always @ * begin
   if (push) begin
        queue.push_front( D_push);
        pndng = 1;
   end
   if (pop) begin
        D_pop = queue.pop_back;
   end
end
endmodule
